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
        DATE_PART('day', delivered_at - estimated_delivery_at) * 24 + DATE_PART('hour', delivered_at - estimated_delivery_at) as delivery_estimation_accuracy_in_hours,
        DATE_PART('day', delivered_at - created_at) * 24 + DATE_PART('hour', delivered_at - created_at ) as delivery_time_in_hours,
        order_cost,
        shipping_cost,
        order_total

FROM {{ref('int_fct_order')}} 
WHERE is_latest