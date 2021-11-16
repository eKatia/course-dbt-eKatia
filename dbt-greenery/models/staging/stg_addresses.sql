{{
  config(
    materialized='table'
  )
}}

SELECT 

    address_id,
    address,
    zipcode,
    state,
    country,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to

FROM {{ ref('addresses_snapshot') }}