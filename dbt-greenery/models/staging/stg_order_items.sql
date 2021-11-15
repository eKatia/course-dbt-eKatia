{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS primary_key,
    order_id,
    product_id,
    quantity
FROM {{ source('greenery_db', 'order_items') }}