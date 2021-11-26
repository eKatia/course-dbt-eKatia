{{
  config(
    materialized='view'
  )
}}

SELECT 
    id AS order_item_id,
    order_id,
    product_id,
    quantity,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to,
    dbt_valid_to is null as is_latest

FROM {{ ref('order_items_snapshot') }}