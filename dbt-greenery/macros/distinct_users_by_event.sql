{% macro distinct_users_by_event(event_type) %}

   SELECT distinct e.user_id 
    FROM users u
    JOIN events e on e.user_id = u.user_id
    WHERE event_type =  '{{ event_type }}'

{% endmacro %}