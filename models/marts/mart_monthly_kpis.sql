select
    order_month,
    count(*)                                         as orders,
    count(distinct customer_unique_id)               as customers,
    round(sum(order_value), 2)                       as revenue,
    round(avg(order_value), 2)                       as avg_order_value,
    round(avg(case when is_late then 1.0 else 0 end) * 100, 1) as late_delivery_pct,
    round(avg(review_score), 2)                      as avg_review_score
from {{ ref('fct_orders') }}
-- 2016 and Sept-Oct 2018 only contain a handful of orders (start and end of the extract),
-- so they are left out to avoid misleading monthly figures.
where is_valid_sale
  and order_month between date '2017-01-01' and date '2018-08-01'
group by order_month
order by order_month
