{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS order_item_id,
    order_id,
    product_id,
    quantity
FROM {{ source('greenery_db', 'order_items') }}