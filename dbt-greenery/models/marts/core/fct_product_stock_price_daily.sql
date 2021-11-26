{{
  config(
    materialized='table'
  )
}}

SELECT    calendar_date,
          product_id,
          product_price,
          stock,
          CASE WHEN stock - LAG(stock) OVER (PARTITION BY product_id ORDER BY calendar_date) > 0 
                THEN 'increased' 
               WHEN stock - LAG(stock) OVER (PARTITION BY product_id ORDER BY calendar_date) < 0 
                    THEN 'descreased' 
               ELSE 'no_change' 
               END as stock_change,

          CASE WHEN product_price - LAG(product_price) OVER (PARTITION BY product_id ORDER BY calendar_date) > 0 
                    THEN 'increased' 
               WHEN product_price - LAG(product_price) OVER (PARTITION BY product_id ORDER BY calendar_date) < 0 
                    THEN 'descreased' 
               ELSE 'no_change' 
               END as price_change

FROM {{ref('int_product_snapshot_date_spine')}} 