{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS primary_key,
    user_id,
    address_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at,
    updated_at

FROM {{ source('greenery_db', 'users') }}