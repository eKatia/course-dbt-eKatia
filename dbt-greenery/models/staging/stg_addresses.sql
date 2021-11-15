{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS primary_key,
    address_id,
    address,
    zipcode,
    state,
    country
FROM {{ source('greenery_db', 'addresses') }}