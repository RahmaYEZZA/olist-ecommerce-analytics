{{ config(severity = 'warn') }}
-- Orders marked as delivered should have a delivery date.
select order_id
from {{ ref('stg_orders') }}
where order_status = 'delivered' and delivered_at is null
