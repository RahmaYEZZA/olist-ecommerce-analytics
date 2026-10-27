{{ config(severity = 'warn') }}
-- What the customer paid should equal items + freight (1 BRL tolerance).
-- Differences usually come from vouchers or interest on instalments.
select order_id, items_value + freight_value as order_value, payment_value
from {{ ref('int_order_totals') }}
where payment_value is not null
  and abs(items_value + freight_value - payment_value) > 1
