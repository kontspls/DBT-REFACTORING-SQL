-- created_at: 2026-10-20T13:30:38.583018700+00:00
-- finished_at: 2026-10-20T13:30:39.125183200+00:00
-- elapsed: 542ms
-- outcome: success
-- dialect: databricks
-- node_id: not available
-- query_id: 01f1cc8a-701e-14bb-bd06-1e0aeab0034a
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "invocation_id": "01a15981-bac3-78e2-9d64-a1e387f78e13", "profile_name": "dbt-refactoring", "target_name": "dev"} */
SHOW SCHEMAS IN `dbt-refactoring`;

-- created_at: 2026-10-20T13:30:39.174031800+00:00
-- finished_at: 2026-10-20T13:30:39.692380400+00:00
-- elapsed: 518ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.customer_orders_legacy
-- query_id: 01f1cc8a-7074-11da-a3a9-9dcc2c96daa8
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

-- created_at: 2026-10-20T13:30:39.693119600+00:00
-- finished_at: 2026-10-20T13:30:40.221843500+00:00
-- elapsed: 528ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.customer_orders_legacy
-- query_id: 01f1cc8a-70c6-1468-8c4c-6a212cccefe8
-- desc: get_relation adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a15981-bac3-78e2-9d64-a1e387f78e13", "node_id": "model.dbt-refactoring.customer_orders_legacy", "profile_name": "dbt-refactoring", "target_name": "dev"} */
DESCRIBE TABLE EXTENDED `dbt-refactoring`.`ktspls_refactoring`.`customer_orders_legacy` AS JSON;

-- created_at: 2026-10-20T13:30:40.224953200+00:00
-- finished_at: 2026-10-20T13:30:40.727774600+00:00
-- elapsed: 502ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.customer_orders_legacy
-- query_id: 01f1cc8a-7114-1f27-9b05-200d5a8ef596
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a15981-bac3-78e2-9d64-a1e387f78e13", "node_id": "model.dbt-refactoring.customer_orders_legacy", "profile_name": "dbt-refactoring", "target_name": "dev"} */
SELECT
    table_catalog,
    table_schema,
    table_name,
    filter_name,
    target_columns
  FROM `dbt-refactoring`.`information_schema`.`row_filters`
  WHERE table_catalog = 'dbt-refactoring'
    AND table_schema = 'ktspls_refactoring'
    AND table_name = 'customer_orders_legacy';

-- created_at: 2026-10-20T13:30:40.734870900+00:00
-- finished_at: 2026-10-20T13:30:45.957613800+00:00
-- elapsed: 5.2s
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.customer_orders_legacy
-- query_id: 01f1cc8a-7162-159c-ac01-f678d3fba67e
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a15981-bac3-78e2-9d64-a1e387f78e13", "node_id": "model.dbt-refactoring.customer_orders_legacy", "profile_name": "dbt-refactoring", "target_name": "dev"} */
create or replace table `dbt-refactoring`.`ktspls_refactoring`.`customer_orders_legacy`
      
      
    
      using delta
    
  
      
      
      
      
      
      
      
      
      as
      WITH paid_orders as (select Orders.ID as order_id,
        Orders.USER_ID    as customer_id,
        Orders.ORDER_DATE AS order_placed_at,
            Orders.STATUS AS order_status,
        p.total_amount_paid,
        p.payment_finalized_date,
        C.FIRST_NAME    as customer_first_name,
            C.LAST_NAME as customer_last_name
    FROM raw.jaffle_shop.orders as Orders
    left join (select ORDERID as order_id, max(CREATED) as payment_finalized_date, sum(AMOUNT) / 100.0 as total_amount_paid
from raw.stripe.payments
where STATUS <> 'fail'
group by 1) p ON orders.ID = p.order_id
left join raw.jaffle_shop.customers C on orders.USER_ID = C.ID ),

customer_orders 
    as (select C.ID as customer_id
        , min(ORDER_DATE) as first_order_date
        , max(ORDER_DATE) as most_recent_order_date
        , count(ORDERS.ID) AS number_of_orders
    from raw.jaffle_shop.customers C 
    left join raw.jaffle_shop.orders as Orders
    on orders.USER_ID = C.ID 
    group by 1)

select
    p.*,
    ROW_NUMBER() OVER (ORDER BY p.order_id) as transaction_seq,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY p.order_id) as customer_sales_seq,
    CASE WHEN c.first_order_date = p.order_placed_at
    THEN 'new'
    ELSE 'return' END as nvsr,
    x.clv_bad as customer_lifetime_value,
    c.first_order_date as fdos
    FROM paid_orders p
    left join customer_orders as c USING (customer_id)
    LEFT OUTER JOIN 
    (
            select
            p.order_id,
            sum(t2.total_amount_paid) as clv_bad
        from paid_orders p
        left join paid_orders t2 on p.customer_id = t2.customer_id and p.order_id >= t2.order_id
        group by 1
        order by p.order_id
    ) x on x.order_id = p.order_id
    ORDER BY order_id;

