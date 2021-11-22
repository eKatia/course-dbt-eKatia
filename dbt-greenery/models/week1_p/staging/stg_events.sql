{{
  config(
    materialized='view'
  )
}}

SELECT 
    event_id,
    event_type,
    session_id,
    user_id,
    page_url,
    created_at
FROM {{ source('greenery_db', 'events') }}