{{
  config(
    materialized='table'
  )
}}

SELECT  
          product_id, 
          product_name

FROM {{ref('stg_products')}} 
WHERE is_latest