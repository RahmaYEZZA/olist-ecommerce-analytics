"""Downloads the public Olist dataset (raw CSV files) into data/raw/."""
from pathlib import Path
import urllib.request

BASE_URL = "https://raw.githubusercontent.com/olist/work-at-olist-data/master/datasets/"
FILES = [
    "olist_customers_dataset", "olist_orders_dataset", "olist_order_items_dataset",
    "olist_order_payments_dataset", "olist_order_reviews_dataset", "olist_products_dataset",
    "olist_sellers_dataset", "product_category_name_translation",
]
RAW = Path(__file__).resolve().parents[1] / "data" / "raw"

if __name__ == "__main__":
    RAW.mkdir(parents=True, exist_ok=True)
    for name in FILES:
        target = RAW / f"{name}.csv"
        if target.exists():
            print(f"already there: {target.name}")
            continue
        print(f"downloading {name}.csv")
        urllib.request.urlretrieve(f"{BASE_URL}{name}.csv", target)
