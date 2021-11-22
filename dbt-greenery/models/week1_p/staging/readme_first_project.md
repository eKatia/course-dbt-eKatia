# Questions
## How many users do we have?
``` sql
select count(distinct user_id)  from users;
```
Result:
`130`

## On average, how many orders do we receive per hour?
``` sql
WITH orders_per_hour AS (select date_part('hour',created_at) as hour_of_order, count(distinct order_id) as orders_per_hour 
                         from orders group by 1)
      
select ROUND(avg(orders_per_hour),2) as avg_orders_per_hour
from orders_per_hour;
```
Result:
`16`
## On average, how long does an order take from being placed to being delivered?
``` sql
WITH diff AS (select date_part('day',  delivered_at - created_at) * 24 + date_part('hour', delivered_at - created_at) as hours_to_deliver from public.orders)  

select ROUND(avg(hours_to_deliver)) as avg_time_to_deliver_in_hours
from diff;
```
Result:
`94 hours`
## How many users have only made one purchase? Two purchases? Three+ purchases?
``` sql
WITH amount_of_orders AS (select user_id, count(distinct order_id) as amount_of_orders from orders group by 1)
select SUM(CASE WHEN amount_of_orders = 1 THEN 1 ELSE 0 END) as customers_with_1_purchase,
       SUM(CASE WHEN amount_of_orders = 2 THEN 1 ELSE 0 END) as customers_with_2_purchases,
       SUM(CASE WHEN amount_of_orders >= 3 THEN 1 ELSE 0 END) as customers_with_more_than_3_purchases
from amount_of_orders;
```
Result:

| First customers_with_1_purchase  | customers_with_2_purchases  | customers_with_more_than_3_purchases  |
| -------------------------------- | --------------------------- | ------------------------------------- | 
| 25                               | 22                          | 81                                    |
## On average, how many unique sessions do we have per hour?
``` sql
WITH sessions_per_hour AS (select  date_part('hour',created_at) as hour_of_event, count(distinct session_id) as amount_of_sessions from events group by 1)

select ROUND(avg(amount_of_sessions),2) as avg_sessions_per_hour
from sessions_per_hour;
```
Result:

| avg_sessions_per_hour|
| -------------------- |
|                120.56|
