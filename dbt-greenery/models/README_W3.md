# Questions
## What is our conversion rate?
``` sql
WITH agg AS (SELECT   

COUNT(DISTINCT session_id) as total_sessions,
COUNT(DISTINCT case when session_converted = 1 then session_id END)::numeric as converted_sessions

FROM dbt_katya_khr_marts.int_session_products)

SELECT ROUND(converted_sessions/total_sessions*100,2) as conversion_rate
FROM agg
```
Result:

| total_sessions    | converted_sessions          | repeat_rate_percentage  |
| ----------------- | --------------------------- | ----------------------- | 
| 1108              | 400                         | 36.10                   |

## What is our conversion rate per product?

``` sql
WITH agg AS (SELECT   
product_name,
COUNT(DISTINCT session_id) as total_sessions,
COUNT(DISTINCT case when session_converted = 1 then session_id END)::numeric as converted_sessions

FROM dbt_katya_khr_marts.int_session_products
WHERE product_name is not null
GROUP BY 1)

SELECT product_name, total_sessions, converted_sessions, ROUND(converted_sessions/total_sessions*100,2) as conversion_rate
FROM agg
ORDER BY 3 desc;
```
Result:

    product_name     | total_sessions | converted_sessions | conversion_rate 
---------------------+----------------+--------------------+-----------------
 String of pearls    |             46 |                 25 |           54.35
 Orchid              |             37 |                 23 |           62.16
 ZZ Plant            |             43 |                 23 |           53.49
 Majesty Palm        |             38 |                 22 |           57.89
 Bamboo              |             39 |                 21 |           53.85
 Dragon Tree         |             38 |                 20 |           52.63
 Birds Nest Fern     |             37 |                 20 |           54.05
 Arrow Head          |             43 |                 20 |           46.51
 Bird of Paradise    |             37 |                 19 |           51.35
 Pink Anthurium      |             38 |                 19 |           50.00
 Monstera            |             30 |                 18 |           60.00
 Cactus              |             37 |                 17 |           45.95
 Peace Lily          |             29 |                 17 |           58.62
 Spider Plant        |             33 |                 17 |           51.52
 Snake Plant         |             37 |                 16 |           43.24
 Pilea Peperomioides |             36 |                 16 |           44.44
 Philodendron        |             37 |                 16 |           43.24
 Calathea Makoyana   |             32 |                 16 |           50.00
 Aloe Vera           |             35 |                 15 |           42.86
 Fiddle Leaf Fig     |             30 |                 15 |           50.00
 Boston Fern         |             32 |                 15 |           46.88
 Ficus               |             37 |                 14 |           37.84
 Money Tree          |             33 |                 14 |           42.42
 Angel Wings Begonia |             32 |                 14 |           43.75
 Rubber Plant        |             37 |                 13 |           35.14
 Pothos              |             26 |                 12 |           46.15
 Ponytail Palm       |             34 |                 11 |           32.35
 Alocasia Polly      |             33 |                 10 |           30.30
 Jade Plant          |             26 |                 10 |           38.46
 Devil's Ivy         |             35 |                 10 |           28.57