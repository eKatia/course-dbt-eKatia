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
, daily_agg AS (
SELECT event_date
      , COUNT(DISTINCT session_id) as total_sessions
      , COUNT(DISTINCT CASE WHEN page_view_events > 0 THEN session_id END ) as sessions_with_pv
      , COUNT(DISTINCT CASE WHEN add_to_cart_events > 0 THEN session_id END ) as sessions_with_add_to_cart
      , COUNT(DISTINCT CASE WHEN checkout_events > 0 THEN session_id END ) as sessions_with_checkout
FROM {{ref('int_session_events')}} 
GROUP BY 1)

, date_spine AS (

SELECT   c.date_day::date as calendar_date
      , COALESCE(SUM(total_sessions),0) as total_sessions
      , COALESCE(SUM(sessions_with_pv),0) as sessions_with_pv
      , COALESCE(SUM(sessions_with_add_to_cart),0) as sessions_with_add_to_cart
      , COALESCE(SUM(sessions_with_checkout),0) as sessions_with_checkout

FROM calendar c
LEFT JOIN daily_agg da ON c.date_day::date = da.event_date::date
WHERE c.date_day::date >= (SELECT MIN(event_date) FROM daily_agg)
AND c.date_day::date <= CURRENT_DATE
GROUP BY 1)

SELECT calendar_date
      , total_sessions
      , sessions_with_pv
      , sessions_with_add_to_cart
      , sessions_with_checkout
      , sessions_with_pv/NULLIF(total_sessions,0)*100 as sessions_with_pv_percentage
      , sessions_with_add_to_cart/NULLIF(sessions_with_pv,0)*100 as sessions_with_add_to_cart_percentage
      , sessions_with_checkout/NULLIF(sessions_with_add_to_cart,0)*100 as sessions_with_checkout_percentage
FROM date_spine