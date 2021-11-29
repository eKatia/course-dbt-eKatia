{{
  config(
    materialized='table'
  )
}}

WITH 

  users AS (SELECT * FROM {{ref('int_dim_user')}} WHERE is_latest)
, orders AS (SELECT * FROM {{ref('int_fct_order')}} WHERE is_latest)
, user_and_products AS (SELECT * FROM {{ref('int_user_product_items')}})
, products AS (SELECT * FROM {{ref('stg_products')}} WHERE is_latest)

, most_times_purchased_ranked AS (

    SELECT    user_id
           , product_name
           , rank() OVER (PARTITION BY user_id ORDER BY times_purchased DESC) as rank_most_times_purchased
           , rank() OVER (PARTITION BY user_id ORDER BY total_amount_purchased DESC) as rank_most_quantity_purchased
    FROM user_and_products
)
, most_times_purchased AS (
    SELECT      user_id
            , STRING_AGG(product_name,',') as most_times_purchased_products

    FROM most_times_purchased_ranked
    WHERE rank_most_times_purchased = 1
    GROUP BY 1

)

, most_quantity_purchased AS (
    SELECT      user_id
            , STRING_AGG(product_name,',') as most_quantity_purchased_products

    FROM most_times_purchased_ranked
    WHERE rank_most_quantity_purchased = 1
    GROUP BY 1

)
, user_orders AS (
SELECT      u.user_id
        ,COALESCE(SUM(order_total),0) as total_spend
        ,COALESCE(COUNT(o.order_id),0) as total_orders
        ,MIN(o.created_at) as first_order_date
        ,MAX(o.created_at) as last_order_date

FROM users u 
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY 1)

, days_between_purchase AS (
SELECT  order_id
      , user_id 
      , DATE_PART('day', LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) - created_at) * 24 + DATE_PART('hour', LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) - created_at) as days_between_purchase 
FROM orders)

, days_between_purchase_total AS (
  SELECT user_id
        , SUM(days_between_purchase) as total_days_between_purchases 
  FROM days_between_purchase
  GROUP BY 1
)

SELECT   u.user_id
        , total_spend
        , total_orders
        , first_order_date
        , last_order_date
        , first_order_date = last_order_date as one_time_customer
        , total_days_between_purchases
        , total_days_between_purchases/total_orders as avg_purchase_rate
        , most_times_purchased_products
        , most_quantity_purchased_products
        

FROM user_orders u
LEFT JOIN most_times_purchased mtp ON mtp.user_id = u.user_id
LEFT JOIN most_quantity_purchased mqp ON mqp.user_id = u.user_id
LEFT JOIN days_between_purchase_total dp ON u.user_id = dp.user_id
