{{
  config(
    materialized='table'
  )
}}

WITH calendar AS ({{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2010-01-01' as date)",
    end_date="cast('2050-01-01' as date)"
   )
}}
)
, orders AS (SELECT * FROM {{ref('int_fct_order')}})
, discount AS (SELECT * FROM {{ref('stg_promos')}})

SELECT    date_day::date as calendar_date
        , shipping_service
        , SUM(order_cost) as order_cost
        , SUM(shipping_cost) as shipping_cost
        , SUM(order_total) as total_order_cost
        , COUNT(distinct user_id) as total_users
        , COUNT(CASE WHEN o.status = 'delivered' THEN order_id END) as delivered_orders
        , COUNT(o.order_id) as total_orders
        , AVG(discount) as average_discount

FROM calendar c
JOIN orders o ON c.date_day >= o.created_at::date AND c.date_day <  current_date 
LEFT JOIN discount d ON o.promo_id = d.promo_id
GROUP BY 1,2