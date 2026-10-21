-- created_at: 2026-10-21T13:00:56.998048300+00:00
-- finished_at: 2026-10-21T13:00:57.510407600+00:00
-- elapsed: 512ms
-- outcome: success
-- dialect: databricks
-- node_id: not available
-- query_id: 01f1cd4f-74b8-1e87-9925-5300fbba0242
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "invocation_id": "01a15e8c-e6d7-7ab2-9b86-74008b9f0ec8", "profile_name": "dbt-refactoring", "target_name": "dev"} */
SHOW SCHEMAS IN `dbt-refactoring`;

-- created_at: 2026-10-21T13:00:57.578378+00:00
-- finished_at: 2026-10-21T13:00:58.227643600+00:00
-- elapsed: 649ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.fct_customer_orders
-- query_id: 01f1cd4f-7511-114a-bd97-5a4d640640ec
-- desc: get_relation > list_relations call

SELECT
    table_name,
    if(table_type IN ('EXTERNAL', 'MANAGED', 'MANAGED_SHALLOW_CLONE', 'EXTERNAL_SHALLOW_CLONE'), 'table', lower(table_type)) AS table_type,
    lower(data_source_format) AS file_format,
    table_schema,
    table_owner,
    table_catalog,
    if(
    table_type IN (
        'EXTERNAL',
        'MANAGED',
        'MANAGED_SHALLOW_CLONE',
        'EXTERNAL_SHALLOW_CLONE'
    ),
    lower(table_type),
    NULL
    ) AS databricks_table_type
FROM `system`.`information_schema`.`tables`
WHERE table_catalog = 'dbt-refactoring'
    AND table_schema = 'ktspls_refactoring';

-- created_at: 2026-10-21T13:00:58.229691800+00:00
-- finished_at: 2026-10-21T13:00:58.941531600+00:00
-- elapsed: 711ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.fct_customer_orders
-- query_id: 01f1cd4f-7575-1728-a760-50a4fccbe839
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a15e8c-e6d7-7ab2-9b86-74008b9f0ec8", "node_id": "model.dbt-refactoring.fct_customer_orders", "profile_name": "dbt-refactoring", "target_name": "dev"} */
SELECT
    table_catalog,
    table_schema,
    table_name,
    filter_name,
    target_columns
  FROM `dbt-refactoring`.`information_schema`.`row_filters`
  WHERE table_catalog = 'dbt-refactoring'
    AND table_schema = 'ktspls_refactoring'
    AND table_name = 'fct_customer_orders';

-- created_at: 2026-10-21T13:00:58.949251500+00:00
-- finished_at: 2026-10-21T13:01:15.528512500+00:00
-- elapsed: 16.6s
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.fct_customer_orders
-- query_id: 01f1cd4f-75e0-17a9-8ff6-ff05c8ba3147
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a15e8c-e6d7-7ab2-9b86-74008b9f0ec8", "node_id": "model.dbt-refactoring.fct_customer_orders", "profile_name": "dbt-refactoring", "target_name": "dev"} */
create or replace table `dbt-refactoring`.`ktspls_refactoring`.`fct_customer_orders`
      
      
    
      using delta
    
  
      
      
      
      
      
      
      
      
      as
      with
    paid_orders as (
        select
            orders.id as order_id,
            orders.user_id as customer_id,
            orders.order_date as order_placed_at,
            orders.status as order_status,
            p.total_amount_paid,
            p.payment_finalized_date,
            c.first_name as customer_first_name,
            c.last_name as customer_last_name
        from
            raw.jaffle_shop.orders as orders
            left join (
                select
                    orderid as order_id,
                    max(created) as payment_finalized_date,
                    sum(amount) / 100.0 as total_amount_paid
                from
                    raw.stripe.payments
                where
                    status <> 'fail'
                group by
                    1
            ) p on orders.id = p.order_id
            left join raw.jaffle_shop.customers c on orders.user_id = c.id
    ),
    customer_orders as (
        select
            c.id as customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(orders.id) as number_of_orders
        from
            raw.jaffle_shop.customers c
            left join raw.jaffle_shop.orders as orders on orders.user_id = c.id
        group by
            1
    )
select
    p.*,
    row_number() over (
        order by
            p.order_id
    ) as transaction_seq,
    row_number() over (
        partition by
            customer_id
        order by
            p.order_id
    ) as customer_sales_seq,
    case
        when c.first_order_date = p.order_placed_at then 'new'
        else 'return'
    end as nvsr,
    x.clv_bad as customer_lifetime_value,
    c.first_order_date as fdos
from
    paid_orders p
    left join customer_orders as c using (customer_id)
    left outer join (
        select
            p.order_id,
            sum(t2.total_amount_paid) as clv_bad
        from
            paid_orders p
            left join paid_orders t2 on p.customer_id = t2.customer_id
            and p.order_id >= t2.order_id
        group by
            1
        order by
            p.order_id
    ) x on x.order_id = p.order_id
order by
    order_id;

