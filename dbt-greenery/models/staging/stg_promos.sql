{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS primary_key,
    promo_id,
    discout

FROM {{ source('greenery_db', 'promos') }}