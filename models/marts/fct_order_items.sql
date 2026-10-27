select
    i.order_id,
    i.order_item_id,
    i.product_id,
    p.category,
    i.seller_id,
    s.state as seller_state,
    o.customer_state,
    o.order_month,
    o.is_valid_sale,
    i.price,
    i.freight_value
from {{ ref('stg_order_items') }} as i
join {{ ref('fct_orders') }}       as o using (order_id)
join {{ ref('stg_products') }}     as p using (product_id)
join {{ ref('stg_sellers') }}      as s using (seller_id)
