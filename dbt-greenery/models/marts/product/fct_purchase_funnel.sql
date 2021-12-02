
{{
  config(
    materialized='table'
  )
}}

WITH 

events AS (SELECT * FROM {{ref('stg_events')}})

, order_item_products AS (SELECT * FROM {{ref('int_order_item')}})

, users as ( {{ distinct_users_by_event('page_view') }} )

, accounts_created AS ( {{ distinct_users_by_event('account_created') }} )

, added_to_cart AS ( {{ distinct_users_by_event('add_to_cart') }} )

, checkouted AS ({{ distinct_users_by_event('checkout') }} )

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