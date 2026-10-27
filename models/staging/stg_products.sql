select
    p.product_id,
    coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category,
    p.product_weight_g as weight_g,
    p.product_photos_qty as photos_qty
from {{ source('olist', 'olist_products_dataset') }} as p
left join {{ source('olist', 'product_category_name_translation') }} as t
    using (product_category_name)
