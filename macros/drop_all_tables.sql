{% macro drop_databricks_schemata() %}
    {% set catalog = "dbt-refactoring" %}
    {% set schemas = ["dbt_ktspls", "dbt_ktspls_raw"] %}

    {% for schema in schemas %}
        {# Notice the backticks `` ` `` wrapping the catalog variable below #}
        {% set drop_query = "DROP SCHEMA IF EXISTS `" ~ catalog ~ "`." ~ schema ~ " CASCADE;" %}
        
        {% do log("Dropping Databricks schema: " ~ catalog ~ "." ~ schema, info=True) %}
        {% do run_query(drop_query) %}
    {% endfor %}
    
    {% do log("All specified schemas have been dropped.", info=True) %}
{% endmacro %}