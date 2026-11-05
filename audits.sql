-------------------- Row Count Audit --------------------

{% set old_relation = ref('customer_orders_legacy') -%}


{% set dbt_relation = ref('fct_customer_orders') %}

{{ audit_helper.compare_row_counts(
    a_relation = old_relation,
    b_relation = dbt_relation,
    primary_key="order_id"
) }}

-------------------- Compare All columns Audit --------------------



{% set old_relation =  ref('customer_orders_legacy') -%}

{% set dbt_relation = ref('fct_customer_orders') %}

{{ audit_helper.compare_all_columns(
    a_relation = old_relation,
    b_relation = dbt_relation,
    primary_key = "order_id"
) }}

-- All audits passed successfully. No discrepancies found between the legacy and dbt models.