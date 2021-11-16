{{
  config(
    materialized='incremental',
    unique_key='dbt_scd_id'
  )
}}

SELECT 
    user_id,
    address_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at,
    updated_at,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to

FROM {{ ref('users_snapshot') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where dbt_scd_id >= (select max(dbt_scd_id) from {{ this }})

{% endif %}
