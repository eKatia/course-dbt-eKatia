{{
  config(
    materialized='table'
  )
}}

WITH all_events AS (

SELECT  *
FROM {{ref('stg_events')}}  )


, sessions AS(

SELECT DISTINCT 
       session_id
     , FIRST_VALUE(user_id) OVER(PARTITION BY session_id ORDER BY created_at ROWS between unbounded preceding and unbounded following) as user_id
     , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) OVER(PARTITION BY session_id) AS page_views_in_session
     , EXTRACT(EPOCH FROM (MAX(created_at) OVER(PARTITION BY session_id) - MIN(created_at) OVER(PARTITION BY session_id))) as session_length_seconds
     , FIRST_VALUE(event_type) OVER(PARTITION BY session_id ORDER BY created_at ROWS between unbounded preceding and unbounded following) as first_event
     , LAST_VALUE(event_type) OVER(PARTITION BY session_id ORDER BY created_at ROWS between unbounded preceding and unbounded following) as last_event
     , COALESCE(FIRST_VALUE(split_part(page_url, '/',4)) OVER(PARTITION BY session_id ORDER BY created_at ROWS between unbounded preceding and unbounded following), 'homepage') as first_page_visited
     , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) OVER(PARTITION BY session_id) as has_conversion
     


FROM all_events AS ev 
)
 

SELECT s.*
     , CASE WHEN page_views_in_session = 1 
             AND first_page_visited = 'homepage' OR session_length_seconds <30 THEN TRUE ELSE FALSE END AS is_bounce

FROM sessions s
