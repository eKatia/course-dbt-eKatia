
{{
  config(
    materialized='view'
  )
}}

{% set event_types = [ 
    'delete_from_cart'
    ,'checkout'
    ,'page_view'
    ,'add_to_cart'
    ,'package_shipped'
    ,'account_created'
]
%}

WITH all_events AS (

                SELECT  *
                FROM {{ref('stg_events')}} 
                WHERE created_at IS NOT NULL )

, products AS ( SELECT  *
                FROM {{ref('stg_products')}}  )

, first_user AS (SELECT 
                      DISTINCT session_id
                      , FIRST_VALUE(user_id) OVER (PARTITION BY session_id ORDER BY created_at ROWS between unbounded preceding and unbounded following ) as user_id -- sessions have multiple users ( data qyality issue)
                FROM all_events AS ev)
SELECT 
       ev.session_id
     , created_at::date as event_date
     , u.user_id 
       {%for event_type in event_types %}
     , SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) as {{event_type}}_events
      {%endfor%}

FROM all_events AS ev
JOIN first_user u ON ev.session_id = u.session_id
{{dbt_utils.group_by(3)}}