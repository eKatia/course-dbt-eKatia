{{
  config(
    materialized='view'
  )
}}

SELECT 
    order_id,
    user_id,
    promo_id,
    address_id,
    tracking_id,
    shipping_service,
    status,
    estimated_delivery_at,
    created_at,
    delivered_at,
    order_cost,
    shipping_cost,
    order_total,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to,
    dbt_valid_to is null as is_latest

FROM {{ ref('orders_snapshot') }}