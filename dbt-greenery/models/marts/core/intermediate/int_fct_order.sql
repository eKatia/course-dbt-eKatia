{{
  config(
    materialized='view'
  )
}}

WITH orders AS (SELECT * FROM {{ref('stg_orders')}})
, addresses AS (SELECT * FROM {{ref('stg_addresses')}})


SELECT 
    
    order_id,
    user_id,
    promo_id,
    a.address as delivery_address,
    shipping_service,
    status,
    estimated_delivery_at,
    created_at,
    delivered_at,
    order_cost,
    shipping_cost,
    order_total,
    dbt_valid_from,
    dbt_valid_to,
    is_latest
FROM orders o
LEFT JOIN addresses a ON o.address_id = a.address_id