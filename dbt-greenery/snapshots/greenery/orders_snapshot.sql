{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='order_id',
      check_cols=['order_cost', 'shipping_cost','order_total', 'shipping_service', 'status', 'estimated_delivery_at'],
    )
  }}

  SELECT * 
  FROM {{ source('greenery_db', 'orders') }}

{% endsnapshot %}