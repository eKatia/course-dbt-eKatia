{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS primary_key,
    event_id,
    event_type,
    session_id,
    user_id,
    page_url,
    created_at
FROM {{ source('greenery_db', 'events') }}