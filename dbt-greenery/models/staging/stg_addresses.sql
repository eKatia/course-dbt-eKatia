{{
  config(
    materialized='view'
  )
}}
WITH sources AS ( SELECT * FROM {{ source('greenery_db', 'addresses') }})

SELECT 

    address_id,
    address,
    zipcode,
    state,
    country

FROM sources
