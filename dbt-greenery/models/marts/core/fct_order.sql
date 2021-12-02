{{
  config(
    materialized='table'
  )
}}

SELECT  order_id,
        user_id,
        promo_id,
        delivery_address,
        shipping_service,
        status,
        estimated_delivery_at,
        created_at,
        delivered_at,
        {{ dbt_utils.datediff("estimated_delivery_at", "delivered_at", 'hour') }} as delivery_estimation_accuracy_in_hours,
        {{ dbt_utils.datediff("created_at", "delivered_at", 'hour') }} as delivery_time_in_hours,
        order_cost,
        shipping_cost,
        order_total

FROM {{ref('int_fct_order')}} 
WHERE is_latest