{{
  config(
    materialized='view'
  )
}}

SELECT    product_id,
          product_name,
          product_price,
          stock,
          dbt_scd_id,
          dbt_updated_at,
          dbt_valid_from,
          dbt_valid_to

FROM {{ref('stg_products')}} p
WHERE is_latest