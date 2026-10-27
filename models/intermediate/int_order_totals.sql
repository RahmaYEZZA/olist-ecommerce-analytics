-- One row per order with the value of its items and of its payments.
with items as (
    select order_id,
           count(*)           as items_count,
           count(distinct seller_id) as sellers_count,
           sum(price)         as items_value,
           sum(freight_value) as freight_value
    from {{ ref('stg_order_items') }}
    group by order_id
),
payments as (
    select order_id,
           sum(payment_value)        as payment_value,
           max(payment_installments) as installments,
           -- main payment method = the one with the highest amount
           arg_max(payment_type, payment_value) as payment_type
    from {{ ref('stg_payments') }}
    group by order_id
)
select
    o.order_id,
    coalesce(i.items_count, 0)   as items_count,
    coalesce(i.sellers_count, 0) as sellers_count,
    coalesce(i.items_value, 0)   as items_value,
    coalesce(i.freight_value, 0) as freight_value,
    p.payment_value,
    p.installments,
    p.payment_type
from {{ ref('stg_orders') }} as o
left join items    as i using (order_id)
left join payments as p using (order_id)
