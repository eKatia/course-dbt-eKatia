{{
  config(
    materialized='incremental',
    unique_key='dbt_scd_id'
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
    dbt_valid_to

FROM {{ ref('order_items_snapshot') }}