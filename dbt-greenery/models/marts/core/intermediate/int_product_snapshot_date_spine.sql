{{
  config(
    materialized='view'
  )
}}
WITH calendar AS ({{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2010-01-01' as date)",
    end_date="cast('2050-01-01' as date)"
   )
}}
)


SELECT    c.date_day as calendar_date,
          product_id,
          product_name,
          product_price,
          stock,
          is_latest

FROM {{ref('stg_products')}} p
JOIN calendar c ON c.date_day >= p.dbt_valid_from::date AND c.date_day <= COALESCE(p.dbt_valid_to::date, current_date)
