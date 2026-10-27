-- Delivery experience by customer state (delivered orders only).
select
    o.customer_state,
    s.state_name,
    s.region,
    'Brazil'                                         as country,
    count(*)                                         as delivered_orders,
    round(avg(o.delivery_days), 1)                   as avg_delivery_days,
    round(avg(o.promised_days), 1)                   as avg_promised_days,
    round(avg(case when o.is_late then 1.0 else 0 end) * 100, 1) as late_delivery_pct,
    round(avg(o.freight_value / nullif(o.order_value, 0)) * 100, 1) as freight_share_pct,
    round(avg(o.review_score), 2)                    as avg_review_score
from {{ ref('fct_orders') }} as o
left join {{ ref('brazil_states') }} as s on s.state_code = o.customer_state
where o.order_status = 'delivered' and o.delivered_at is not null
group by all
order by delivered_orders desc
