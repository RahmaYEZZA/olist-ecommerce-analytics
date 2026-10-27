-- Some orders have more than one review (and some review_ids appear twice).
-- We keep the most recent review per order so that each order has one score.
with ranked as (
    select
        review_id,
        order_id,
        review_score,
        cast(review_creation_date as timestamp) as reviewed_at,
        row_number() over (
            partition by order_id
            order by review_answer_timestamp desc, review_id
        ) as rn
    from {{ source('olist', 'olist_order_reviews_dataset') }}
)
select review_id, order_id, review_score, reviewed_at
from ranked
where rn = 1
