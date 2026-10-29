-- created_at: 2026-10-29T11:24:23.834101300+00:00
-- finished_at: 2026-10-29T11:24:24.232498600+00:00
-- elapsed: 398ms
-- outcome: success
-- dialect: databricks
-- node_id: not available
-- query_id: 01f1d38b-4bae-1b7c-a195-b9df4c2555ff
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "profile_name": "dbt-refactoring", "target_name": "dev"} */
SHOW SCHEMAS IN `dbt-refactoring`;

-- created_at: 2026-10-29T11:24:24.250792300+00:00
-- finished_at: 2026-10-29T11:24:24.722816900+00:00
-- elapsed: 472ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__orders
-- query_id: 01f1d38b-4bed-164d-8806-7245b6446943
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

-- created_at: 2026-10-29T11:24:24.462980100+00:00
-- finished_at: 2026-10-29T11:24:24.971130900+00:00
-- elapsed: 508ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__payments
-- query_id: 01f1d38b-4c0e-1dd8-9e90-e17eaff7b924
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

-- created_at: 2026-10-29T11:24:24.723556700+00:00
-- finished_at: 2026-10-29T11:24:25.119570200+00:00
-- elapsed: 396ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__orders
-- query_id: 01f1d38b-4c34-1a26-94c4-29c50ccc2fbd
-- desc: get_relation adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "node_id": "model.dbt-refactoring.stg__orders", "profile_name": "dbt-refactoring", "target_name": "dev"} */
DESCRIBE TABLE EXTENDED `dbt-refactoring`.`ktspls_refactoring`.`stg__orders` AS JSON;

-- created_at: 2026-10-29T11:24:24.661256900+00:00
-- finished_at: 2026-10-29T11:24:25.230325100+00:00
-- elapsed: 569ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__customers
-- query_id: 01f1d38b-4c2c-114d-a224-ebe425b0813e
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

-- created_at: 2026-10-29T11:24:24.971843500+00:00
-- finished_at: 2026-10-29T11:24:25.307445700+00:00
-- elapsed: 335ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__payments
-- query_id: 01f1d38b-4c5a-1d54-aa58-3889487130aa
-- desc: get_relation adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "node_id": "model.dbt-refactoring.stg__payments", "profile_name": "dbt-refactoring", "target_name": "dev"} */
DESCRIBE TABLE EXTENDED `dbt-refactoring`.`ktspls_refactoring`.`stg__payments` AS JSON;

-- created_at: 2026-10-29T11:24:25.231058100+00:00
-- finished_at: 2026-10-29T11:24:25.547011600+00:00
-- elapsed: 315ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__customers
-- query_id: 01f1d38b-4c82-18a9-b95b-e29fe239cdb8
-- desc: get_relation adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "node_id": "model.dbt-refactoring.stg__customers", "profile_name": "dbt-refactoring", "target_name": "dev"} */
DESCRIBE TABLE EXTENDED `dbt-refactoring`.`ktspls_refactoring`.`stg__customers` AS JSON;

-- created_at: 2026-10-29T11:24:25.126156300+00:00
-- finished_at: 2026-10-29T11:24:26.204353700+00:00
-- elapsed: 1.1s
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__orders
-- query_id: 01f1d38b-4c74-11f7-b998-4882266a640c
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "node_id": "model.dbt-refactoring.stg__orders", "profile_name": "dbt-refactoring", "target_name": "dev"} */
create or replace view `dbt-refactoring`.`ktspls_refactoring`.`stg__orders`
  
  as (
    with 

raw_orders as (
  select * from `raw`.`jaffle_shop`.`orders`
),

transformed as (
    select
        id as order_id,
        user_id as customer_id,
        order_date as order_placed_at,
        status as order_status
        from
        raw_orders
)

select * from transformed
  );

-- created_at: 2026-10-29T11:24:25.314577900+00:00
-- finished_at: 2026-10-29T11:24:26.212202800+00:00
-- elapsed: 897ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__payments
-- query_id: 01f1d38b-4c8d-1eaf-9f69-84821b8882ed
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "node_id": "model.dbt-refactoring.stg__payments", "profile_name": "dbt-refactoring", "target_name": "dev"} */
create or replace view `dbt-refactoring`.`ktspls_refactoring`.`stg__payments`
  
  as (
    with 

raw_payments as (
  select * from `raw`.`stripe`.`payments`
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
  );

-- created_at: 2026-10-29T11:24:25.552897400+00:00
-- finished_at: 2026-10-29T11:24:26.396213800+00:00
-- elapsed: 843ms
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.stg__customers
-- query_id: 01f1d38b-4cb4-13d2-82de-18e2265b72ae
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "node_id": "model.dbt-refactoring.stg__customers", "profile_name": "dbt-refactoring", "target_name": "dev"} */
create or replace view `dbt-refactoring`.`ktspls_refactoring`.`stg__customers`
  
  as (
    with 
raw_customers as (
  select * from `raw`.`jaffle_shop`.`customers`
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
  );

-- created_at: 2026-10-29T11:24:26.431331300+00:00
-- finished_at: 2026-10-29T11:24:30.371460900+00:00
-- elapsed: 3.9s
-- outcome: success
-- dialect: databricks
-- node_id: model.dbt-refactoring.fct_customer_orders
-- query_id: 01f1d38b-4d38-12ca-ac9d-6660f4c64090
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "invocation_id": "01a18767-62e1-7950-a0c1-37bda186c649", "node_id": "model.dbt-refactoring.fct_customer_orders", "profile_name": "dbt-refactoring", "target_name": "dev"} */
create or replace view `dbt-refactoring`.`ktspls_refactoring`.`fct_customer_orders`
  
  as (
    with 

--Staging CTEs
payments as (

  select * from `dbt-refactoring`.`ktspls_refactoring`.`stg__payments`

),

orders as (
    
    select * from `dbt-refactoring`.`ktspls_refactoring`.`stg__orders`

),

customers as (
    
    select * from `dbt-refactoring`.`ktspls_refactoring`.`stg__customers`

),
 
-- logical CTEs
completed_payments as (
    select
        order_id,
        max(date_created) as payment_finalized_date,
        sum(amount) / 100.0 as total_amount_paid
        from
        payments
    where
        status <> 'fail'
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

        customers.customer_first_name,
        customers.customer_last_name
    from
        orders
        left join completed_payments on orders.order_id = completed_payments.order_id
        left join customers on orders.customer_id = customers.customer_id
),

--final CTE
final as (
    
    select
        order_id,
        customer_id,
        order_placed_at,
        order_status,
        total_amount_paid,
        payment_finalized_date,
        customer_first_name,
        customer_last_name,

        -- sales transaction sequence
        row_number() over (order by order_id) as transaction_seq,

        -- customers sales sequence
        row_number() over (partition by customer_id order by order_id) as customer_sales_seq,
        
        
        -- new vs returning customer
        case
            when (
            rank() over (
            partition by customer_id
            order by order_placed_at, order_id
            ) = 1
        ) then 'new'
        else 'return'
        end as nvsr,

        -- customer lifetime value
        sum(paid_orders.total_amount_paid) over (
            partition by customer_id
            order by order_placed_at
        ) as customer_lifetime_value,

        -- first day of sale
        first_value(order_placed_at) over (
        partition by customer_id
        order by order_placed_at
        ) as fdos
    from
        paid_orders
)
-- Simple Select Statement

select * from final
  );

