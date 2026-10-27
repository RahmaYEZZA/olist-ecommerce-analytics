-- One row per order: what was bought, how it was paid, how delivery went, and the review.
select
    o.order_id,
    c.customer_unique_id,
    c.state                                        as customer_state,
    o.order_status,
    o.purchased_at,
    cast(date_trunc('month', o.purchased_at) as date) as order_month,
    t.items_count,
    t.sellers_count,
    t.items_value,
    t.freight_value,
    t.items_value + t.freight_value                as order_value,
    t.payment_value,
    t.payment_type,
    t.installments,
    o.delivered_at,
    o.estimated_delivery_at,
    date_diff('day', o.purchased_at, o.delivered_at)          as delivery_days,
    date_diff('day', o.purchased_at, o.estimated_delivery_at) as promised_days,
    case
        when o.delivered_at is null then null
        when o.delivered_at > o.estimated_delivery_at then true
        else false
    end                                            as is_late,
    r.review_score,
    o.order_status not in ('canceled', 'unavailable') as is_valid_sale
from {{ ref('stg_orders') }}            as o
join {{ ref('stg_customers') }}         as c using (customer_id)
join {{ ref('int_order_totals') }}      as t using (order_id)
left join {{ ref('stg_reviews') }}      as r using (order_id)
