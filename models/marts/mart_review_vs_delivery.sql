-- How does the delay compared to the promised date affect the review score?
with delivered as (
    select
        review_score,
        date_diff('day', estimated_delivery_at, delivered_at) as days_vs_promise
    from {{ ref('fct_orders') }}
    where order_status = 'delivered' and delivered_at is not null and review_score is not null
)
select
    case
        when days_vs_promise <= -7 then '1. 7+ days early'
        when days_vs_promise <= 0  then '2. 0-6 days early'
        when days_vs_promise <= 7  then '3. 1-7 days late'
        else '4. 8+ days late'
    end                                                as delivery_vs_promise,
    count(*)                                           as orders,
    round(avg(review_score), 2)                        as avg_review_score,
    round(avg(case when review_score <= 2 then 1.0 else 0 end) * 100, 1) as bad_review_pct
from delivered
group by 1
order by 1
