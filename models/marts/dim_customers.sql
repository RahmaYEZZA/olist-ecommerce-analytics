-- One row per real customer (customer_unique_id), with their purchase history.
select
    customer_unique_id,
    any_value(customer_state)          as state,
    min(purchased_at)                  as first_order_at,
    max(purchased_at)                  as last_order_at,
    count(*)                           as orders_count,
    sum(order_value)                   as total_spent,
    count(*) > 1                       as is_repeat_customer
from {{ ref('fct_orders') }}
where is_valid_sale
group by customer_unique_id
