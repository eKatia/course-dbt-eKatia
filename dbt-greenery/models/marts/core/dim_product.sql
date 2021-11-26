{{
  config(
    materialized='table'
  )
}}

SELECT    DISTINCT
          product_id, 
          product_name,
          product_price

FROM {{ref('stg_products')}} 
WHERE is_latest