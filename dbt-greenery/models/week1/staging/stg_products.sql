{{
  config(
    materialized='incremental',
    unique_key='dbt_scd_id'
  )
}}

SELECT 
    product_id,
    name as product_name,
    price as product_price,
    quantity as stock,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to,
    dbt_valid_to is null as is_latest

FROM {{ ref('products_snapshot') }}
