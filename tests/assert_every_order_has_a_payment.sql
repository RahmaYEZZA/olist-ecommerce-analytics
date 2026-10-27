{{ config(severity = 'warn') }}
select order_id
from {{ ref('int_order_totals') }}
where payment_value is null
