with 

-- Intermediate CTEs

customer_orders as (
    
    select * from {{ ref('int__customers') }}

),

-- Final CTE
final as (
    
    select
        customer_orders.order_id,
        customer_orders.customer_id,
        customer_orders.order_placed_at,
        customer_orders.order_status,
        customer_orders.total_amount_paid,
        customer_orders.customer_first_name,
        customer_orders.customer_last_name,
        customer_orders.nvsr,
        customer_orders.customer_lifetime_value,
        customer_orders.fdos,
        customer_orders.payment_finalized_date,
        customer_orders.transaction_seq,
        customer_orders.customer_sales_seq
        
    from 
        customer_orders
    order by order_id
)

-- Simple Select Statement

select * from final
