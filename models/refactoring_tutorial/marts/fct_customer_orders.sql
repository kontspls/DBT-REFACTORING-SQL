with

--import CTEs

raw_customers as (
  select * from {{ source ('jaffle_shop', 'customers')}}
),

raw_orders as (
  select * from {{ source ('jaffle_shop', 'orders')}}
),

raw_payments as (
  select * from {{ source ('stripe', 'payments')}}
),

--logical CTEs

paid_orders as (
    select
            orders.id as order_id,
            orders.user_id as customer_id,
            orders.order_date as order_placed_at,
            orders.status as order_status,
            payments.total_amount_paid,
            payments.payment_finalized_date,
            customers.first_name as customer_first_name,
            customers.last_name as customer_last_name
        from raw_orders as orders
            left join (
                select
                    orderid as order_id,
                    max(created) as payment_finalized_date,
                    sum(amount) / 100.0 as total_amount_paid
                from raw_payments
                where
                    status <> 'fail'
                group by
                    1
            ) payments on orders.id = payments.order_id
            left join raw_customers customers on orders.user_id = customers.id
),

customer_orders as (
        select
            customers.id as customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(orders.id) as number_of_orders
        from
         raw_customers customers
            left join raw_orders as orders on orders.user_id = customers.id
        group by
            1
),
 --final CTE

final as (select
    payments.*,
    row_number() over (
        order by
            payments.order_id
    ) as transaction_seq,
    row_number() over (
        partition by
            customer_id
        order by
            payments.order_id
    ) as customer_sales_seq,
    case
        when customers.first_order_date = payments.order_placed_at then 'new'
        else 'return'
    end as nvsr,
    x.clv_bad as customer_lifetime_value,
    customers.first_order_date as fdos
from
    paid_orders payments
    left join customer_orders as customers using (customer_id)
    left outer join (
        select
            payments.order_id,
            sum(t2.total_amount_paid) as clv_bad
        from
            paid_orders payments
            left join paid_orders t2 on payments.customer_id = t2.customer_id
            and payments.order_id >= t2.order_id
        group by
            1
        order by
            payments.order_id
    ) x on x.order_id = payments.order_id
order by
    order_id   
)
-- Simple Select Statement

select * from final

