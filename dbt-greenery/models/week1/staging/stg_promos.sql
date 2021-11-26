{{
  config(
    materialized='view'
  )
}}

SELECT 

    promo_id,
    discout as discount,
    status,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to,
    dbt_valid_to is null as is_latest

FROM {{ref('promos_snapshot')}}
