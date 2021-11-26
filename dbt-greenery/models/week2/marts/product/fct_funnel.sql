
{{
  config(
    materialized='table'
  )
}}

WITH 
users as (
  select
    user_id, 
    min(created_at) as min_visit_ts 
  from {{ref('stg_events')}}
  where event_type = 'page_view'
  group by 1
),
accounts_created AS ( 
    SELECT distinct e.user_id 
    FROM users u
    JOIN {{ref('stg_events')}} e on e.user_id = u.user_id
    WHERE event_type = 'account_created')

, added_to_cart AS (
    SELECT distinct e.user_id 
    FROM users u
    JOIN {{ref('stg_events')}} e on e.user_id = u.user_id
    WHERE event_type = 'add_to_cart')

, checkouted AS (
    SELECT distinct e.user_id 
    FROM users u
    JOIN {{ref('stg_events')}} e on e.user_id = u.user_id
    WHERE event_type = 'checkout')

, stages AS (
SELECT 'Visit' as stage, COUNT(*) as amount_of_users FROM users
  UNION
SELECT 'Sign Up' as stage, COUNT(*) as amount_of_users  FROM accounts_created
  UNION
SELECT 'Added to Cart' as stage, COUNT(*) as amount_of_users  FROM added_to_cart
  UNION
SELECT 'Purchase' as stage, COUNT(*) as amount_of_users  FROM checkouted
order by amount_of_users desc)

SELECT
  stage,
  amount_of_users,
  lag(amount_of_users, 1) over () as amount_of_users_at_prev_step,
  round((1.0 - amount_of_users::numeric/lag(amount_of_users, 1) over ()),2) as drop_off
FROM stages