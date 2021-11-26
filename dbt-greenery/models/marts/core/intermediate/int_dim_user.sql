{{
  config(
    materialized='view'
  )
}}

SELECT    user_id,
        first_name,
        last_name,
        address,
        email,
        phone_number,
        created_at,
        u.dbt_valid_from as scd_valid_from,
        u.dbt_valid_to as scd_valid_to,
        dbt_valid_to is null as is_latest
FROM {{ref('stg_users')}} u
LEFT JOIN {{ref('stg_addresses')}} a ON u.address_id = a.address_id
