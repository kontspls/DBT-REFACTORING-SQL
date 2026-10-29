with 
raw_customers as (
  select * from {{ source ('jaffle_shop', 'customers')}}
),

customers as (
    select
        id as customer_id,
        first_name as customer_first_name,
        last_name as customer_last_name,
        customer_first_name || ' ' || customer_last_name as full_name
    from
        raw_customers
)

select * from customers

