with 

-- Intermediate CTEs

customers as (
    
    select * from {{ ref('stg__customers') }}

),
 

paid_orders as (

    select * from {{ ref('int__orders') }}

),

--Final CTE
final as (
    
    select
        paid_orders.order_id,
        paid_orders.customer_id,
        paid_orders.order_placed_at,
        paid_orders.order_status,
        paid_orders.total_amount_paid,
        paid_orders.nvsr,
        paid_orders.customer_lifetime_value,
        paid_orders.fdos,
        paid_orders.payment_finalized_date,
        paid_orders.transaction_seq,
        paid_orders.customer_sales_seq,
        

        customers.customer_first_name,
        customers.customer_last_name

        
    from
        paid_orders
    left join customers on paid_orders.customer_id = customers.customer_id
    order by customer_id
    
)
-- Simple Select Statement

select * from final
