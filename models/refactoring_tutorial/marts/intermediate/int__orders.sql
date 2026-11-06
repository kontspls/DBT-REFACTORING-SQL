{{ config(
    materialized='view'
)}}


with 

orders as (

  select * from {{ ref('stg__orders') }}

),

payments as (

  select * from {{ ref('stg__payments') }}

),

completed_payments as (
    select
        order_id,
        max(date_created) as payment_finalized_date,
        sum(amount) / 100.0 as total_amount_paid
        from
        payments
    where is_completed_payment(status)
    group by 
    1
),

paid_orders as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        orders.order_status,

        completed_payments.total_amount_paid,
        completed_payments.payment_finalized_date,

        -- sales transaction sequence
        row_number() over (order by orders.order_placed_at, orders.order_id) as transaction_seq,
        -- customers sales sequence
        row_number() over (partition by orders.customer_id 
        order by orders.order_placed_at, orders.order_id) as customer_sales_seq,

        -- new vs returning customer
        case
            when (
            rank() over (
            partition by orders.customer_id
            order by orders.order_placed_at, orders.order_id
            ) = 1
        ) then 'new'
        else 'return'
        end as nvsr,

        -- customer lifetime value
        sum( completed_payments.total_amount_paid) over (
            partition by orders.customer_id
            order by orders.order_placed_at, orders.order_id
        ) as customer_lifetime_value,

        -- first day of sale
        first_value(orders.order_placed_at) over (
        partition by orders.customer_id
        order by orders.order_placed_at, orders.order_id
        ) as fdos


    from orders
    left join completed_payments on orders.order_id = completed_payments.order_id
)

select * from paid_orders

