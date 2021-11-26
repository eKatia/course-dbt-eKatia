{{
  config(
    materialized='table'
  )
}}

SELECT  user_id,
        first_name,
        last_name,
        address,
        email,
        phone_number,
        created_at

FROM {{ref('int_dim_user')}} 
WHERE is_latest