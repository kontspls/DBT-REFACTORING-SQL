with 

raw_payments as (
  select * from {{ source ('stripe', 'payments')}}
),

transformed as (
    select
        orderid as order_id,
        paymentmethod as payment_method,
        status,
        amount,
        created as date_created
    from
        raw_payments
)

select * from transformed