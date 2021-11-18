{{
  config(
    materialized='incremental',
    unique_key='dbt_scd_id'
  )
}}

SELECT 
    order_id,
    user_id,
    promo_id,
    address_id,
    tracking_id,
    shipping_service,
    status,
    estimated_delivery_at,
    created_at,
    delivered_at,
    order_cost,
    shipping_cost,
    order_total,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to

FROM {{ ref('orders_snapshot') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where dbt_scd_id >= (select max(dbt_scd_id) from {{ this }})

{% endif %}
