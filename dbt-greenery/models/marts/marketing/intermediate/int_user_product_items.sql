{{
  config(
    materialized='table'
  )
}}

WITH 
    users AS (SELECT * FROM {{ref('stg_users')}} WHERE is_latest)
, orders AS (SELECT * FROM {{ref('stg_orders')}} WHERE is_latest)
, order_items AS (SELECT * FROM {{ref('stg_order_items')}} WHERE is_latest)
, products AS (SELECT * FROM {{ref('stg_products')}} WHERE is_latest)

, users_and_products AS (

    SELECT oi.order_item_id,
        oi.product_id,
        p.product_name,
        oi.order_id,
        oi.quantity,
        o.user_id
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id)
 

SELECT            up.user_id
           , up.product_name
           , COUNT(DISTINCT up.order_id) as times_purchased
           , SUM(up.quantity) as total_amount_purchased

FROM users_and_products up
GROUP BY 1,2