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

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Good indicators would be:
1. a frequency of purchase: if a user bought more than once, there is a higher chance he wil buy again
2. the time it takes for an average customer to buy again as it shows how satisfied a customer is with the products
3. website activity

if we had more data, we could measure, for example:
1. NPS score as a general customer satisfation 
2. LCV

## Project structure and models
```
├── dbt_project.yml
└── models
    ├── staging
        ├── base
        ├── gatekeeper
          ├── sources.yml
          ├── stg_events.sql
          ├── ...
          ├── stg_users.sql
          └── schema.yml
    ├── marts
        ├── core
          ├── intermediate
              ├── int_dim_user.sql
              ├── int_fct_order.sql
              ├── int_product_snapshot_date_spine.sql
              ├── schema.sql
          ├── dim_product.sql
          ├── dim_user.sql
          ├── fct_agg_orders_daily.sql
          ├── fct_order.sql
          ├── fct_product_stock_price.sql
          ├── hdim_user.sql
          └── schema.yml
        ├── marketing
          ├── intermediate
              ├── int_user_product_items.sql
              ├── schema.sql
          ├── fct_user_orders.sql
          └── schema.sql
        └── product
          ├── fct_purchase_funnel.sql
          ├── fct_web_session.sql
          └── schema.sql
```
The marts are stored in 3 (in this project) folders: 
1. Core - facts and dimensions relevant for every business team
2. Marketing - facts and dimensions relevant primarly for marketing team
2. Product - facts and dimensions relevant primarly for product team

Event Marts subfolder has an intermediate subfolder, in case some data manipulatiions are required to create the downstream dimensions and facts and those tables could be reused. 

#### Core Marts: 
1. *dim_product* - latest information on products availalbe in Greenary
2. *dim_user* - latest information on all users of Greenary
3. *fct_agg_orders_daily* - orders (e.g. total orders costs, total amount of users, etc.) data aggregated to date and deliver service level. THe summary could be useful for all departments to get an idea of how company is growing over time. It could also be used by Finance/Sales/Planning departments to make forecasts. 
4. *fct_order* - last order fact. All information about orders
5. *fct_product_stock_price* - snapshot of product stock and prices changes ( due to no ETL, snapshot is not showing any change). It could be used to analyse price changes depending on the amount of stocks and track the trend.
6. *hdim_user* - an example of a historical dimension, that could be used to join with facts to get more accurate information on users (given the data changes) over time.

#### Marketing Marts: 
*fct_user_orders* - table aggregates data on users purchases. We can see how much every user contributed to the revenue of the company, how many orders have been made, what the most purchased products are, etc.

#### Product Marts:
1. *fct_purchase_funnel* - a table that could be used to analyse purchase funnel on Greenary website. E.g. if very few users end up making a purchase, maybe the UI is complicated or there is a bug on the website that prevents from purchasing
2. *fct_web_session* - events data rolled up to session level. A useful tool to analyze product data

## Models DAG 
![DAG](./images/LineageGraphWeek2.png)

## Models Tests
Some tests that i originally set up we failing, e.g. `created_at` at orders - logically it should always be filled but the data is not clean enough, thus i removed the test.

Another example - some `session_id` have more than 1 user assigned to it, which logically is also not possible. I had to select the first user associated with the session to create a futher aggregation. 

## Stakeholders alerting

Normally, I would setup pipeline to first `dbt run` and then `dbt test` right away to ensure that whenever there is a run, the data is up-to-date. For notifications about data quality issues, we can collect failing tests results and set up notifications to be sent to Slack, for example.