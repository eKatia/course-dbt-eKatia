
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
                FROM {{ref('stg_events')}}  )

, products AS ( SELECT  *
                FROM {{ref('stg_products')}}  )


SELECT 
       session_id
     , created_at
     , CASE WHEN split_part(page_url, '/',4) = 'product' THEN split_part(page_url, '/',5) END as product_id
       {%for event_type in event_types %}
     , SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) as {{event_type}}s
      {%endfor%}


FROM all_events AS ev
{{dbt_utils.group_by(3)}}