{{
  config(
    materialized='view'
  )
}}
WITH sources AS ( SELECT * FROM {{ source('greenery_db', 'events') }})

SELECT 
    event_id,
    event_type,
    session_id,
    user_id,
    page_url,
    created_at
    
FROM sources