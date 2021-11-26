{{
  config(
    materialized='table'
  )
}}

SELECT    user_id,
        first_name,
        last_name,
        address,
        email,
        phone_number,
        created_at,
        scd_valid_from,
        scd_valid_to

FROM {{ref('int_dim_user')}} 