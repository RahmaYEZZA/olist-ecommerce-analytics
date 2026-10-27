select
    category,
    count(distinct order_id)          as orders,
    count(*)                          as items_sold,
    round(sum(price), 2)              as revenue,
    round(avg(price), 2)              as avg_price,
    round(sum(freight_value) / nullif(sum(price), 0) * 100, 1) as freight_to_price_pct
from {{ ref('fct_order_items') }}
where is_valid_sale
group by category
order by revenue desc
