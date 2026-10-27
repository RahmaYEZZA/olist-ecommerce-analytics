{{ config(severity = 'warn') }}
-- Known issue in the source: some orders are handed to the carrier before the purchase timestamp.
select order_id, purchased_at, shipped_at
from {{ ref('stg_orders') }}
where shipped_at < purchased_at
