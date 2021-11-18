# Questions
## What is our user repeat rate?
``` sql
WITH orders_per_user AS (select user_id, count(distinct order_id) as amount_of_orders from orders group by 1)
, groups AS (
select COUNT(user_id) users_who_purchased,
       SUM(CASE WHEN amount_of_orders >= 2 THEN 1 ELSE 0 END) as multiple_purchases_users
from orders_per_user) 

select multiple_purchases_users, users_who_purchased, multiple_purchases_users/users_who_purchased::float*100 as repeat_rate_percentage
from groups;
```
Result:

| multiple_purchases_users         | users_who_purchased         | repeat_rate_percentage                |
| -------------------------------- | --------------------------- | ------------------------------------- | 
| 103                              | 128                         | 80.46875                              |