{{
  config(
    materialized='incremental',
    unique_key='dbt_scd_id'
  )
}}

SELECT 
    product_id,
    name,
    price,
    quantity as stock,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to

FROM {{ ref('products_snapshot') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where dbt_scd_id >= (select max(dbt_scd_id) from {{ this }})

{% endif %}
