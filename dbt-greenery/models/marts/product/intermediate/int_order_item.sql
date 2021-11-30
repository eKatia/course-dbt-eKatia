
{{
  config(
    materialized='view'
  )
}}

WITH 

orders AS (SELECT * FROM {{ref('stg_orders')}} WHERE is_latest)
, order_items AS (SELECT {{ dbt_utils.star(from=ref('stg_order_items'), except=["dbt_valid_from", "dbt_valid_to", "dbt_scd_id", "dbt_updated_at", "is_latest"]) }}
                  FROM {{ref('stg_order_items')}} WHERE is_latest)
, products AS (SELECT * FROM {{ref('stg_products')}} WHERE is_latest)

SELECT oi.*
, o.created_at as order_created_at
, p.product_name
FROM orders  o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p on oi.product_id = p.product_id