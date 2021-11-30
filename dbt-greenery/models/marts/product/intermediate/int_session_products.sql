
{{
  config(
    materialized='view'
  )
}}

WITH all_events AS (

                SELECT  *
                FROM {{ref('stg_events')}}  )

, products AS ( SELECT  *
                FROM {{ref('stg_products')}}  )

, sessions AS (

SELECT DISTINCT 
       session_id
     , event_type
     , created_at as event_ts
     , CASE WHEN event_type IN ('delete_from_cart' , 'add_to_cart') AND split_part(page_url, '/',4) = 'product' THEN split_part(page_url, '/',5) END as product_id
     , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) OVER(PARTITION BY session_id) as has_conversion


FROM all_events AS ev)

SELECT session_id
     , s.product_id
     , p.product_name
     , MAX(has_conversion) as session_converted
     , MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) as has_added_to_cart
     , MAX(CASE WHEN event_type = 'delete_from_cart' THEN 1 ELSE 0 END) as has_deleted_from_cart

FROM sessions s 
LEFT JOIN products p ON p.product_id = s.product_id
GROUP BY 1,2,3