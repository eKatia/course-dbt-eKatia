# Questions
## How many users do we have?
``` sql
select count(distinct user_id)  from users;
```
Result:
`130`

## On average, how many orders do we receive per hour?
``` sql
select ROUND(avg(orders_per_hour),2) as avg_orders_per_hour
from (select date_trunc('hour',created_at) as hour_of_order, count(distinct order_id) as orders_per_hour 
      from orders group by 1) as t1;
```
Result:
`8.16`
## On average, how long does an order take from being placed to being delivered?
``` sql
select avg(days_to_deliver) as avg_time_to_deliver_in_days
from (select delivered_at - created_at as days_to_deliver from orders) as t1;
```
Result:
`3 days 22:13:10.504451`
## How many users have only made one purchase? Two purchases? Three+ purchases?
``` sql
select SUM(CASE WHEN amount_of_orders = 1 THEN 1 ELSE 0 END) as customers_with_1_purchase,
       SUM(CASE WHEN amount_of_orders = 2 THEN 1 ELSE 0 END) as customers_with_2_purchases,
       SUM(CASE WHEN amount_of_orders >= 3 THEN 1 ELSE 0 END) as customers_with_more_than_3_purchases
from (select user_id, count(distinct order_id) as amount_of_orders from orders group by 1) as t1;
```
Result:
 customers_with_1_purchase | customers_with_2_purchases | customers_with_more_than_3_purchases 
---------------------------+----------------------------+--------------------------------------
                        25 |                         22 |                                   81
## On average, how many unique sessions do we have per hour?
``` sql
select ROUND(avg(amount_of_sessions),2) as avg_sessions_per_hour
from (select date_trunc('hour',created_at) as hour_of_event, count(distinct session_id) as amount_of_sessions from events group by 1) as t1;
```
Result:
avg_sessions_per_hour 
-----------------------
                  7.39