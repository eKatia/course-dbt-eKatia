{{
  config(
    materialized='view'
  )
}}

SELECT     u.user_id,
        first_name,
        last_name,
        address,
        email,
        phone_number,
        u.created_at,
        MIN(o.created_at::date ) OVER (PARTITION BY u.user_id) as first_purchase_date,
        MAX(o.created_at::date ) OVER (PARTITION BY u.user_id) as last_purchase_date,
        u.dbt_valid_from as scd_valid_from,
        u.dbt_valid_to as scd_valid_to,
        MAX(u.dbt_scd_id) OVER (PARTITION BY u.user_id) = u.dbt_scd_id as is_latest
FROM {{ref('stg_products')}} u
LEFT JOIN {{ref('stg_addresses')}} a ON u.address_id = a.address_id
LEFT JOIN {{ref('stg_orders')}} o ON o.user_id = u.user_id
