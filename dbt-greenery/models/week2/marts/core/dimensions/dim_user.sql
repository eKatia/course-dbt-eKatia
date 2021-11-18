{{
  config(
    materialized='table'
  )
}}

SELECT * 
FROM {{ref('int_dim_user')}} 
WHERE is_latest