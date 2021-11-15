{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS primary_key,
    product_id,
    name,
    price,
    quantity

FROM {{ source('greenery_db', 'products') }}