"""Exports the marts as CSV files, ready to be opened in Tableau Public."""
from pathlib import Path
import duckdb

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "exports"
TABLES = {
    "orders": """
        select o.order_id, o.customer_unique_id, o.customer_state, s.state_name, s.region,
               'Brazil' as country, o.order_status, o.order_month,
               cast(o.purchased_at as date) as purchase_date, o.items_count, o.items_value,
               o.freight_value, o.order_value, o.payment_type, o.installments, o.delivery_days,
               o.promised_days, o.is_late, o.review_score
        from fct_orders as o
        left join brazil_states as s on s.state_code = o.customer_state
        where o.is_valid_sale
          and o.order_month between date '2017-01-01' and date '2018-08-01'
        order by o.purchased_at, o.order_id""",
    "monthly_kpis": "select * from mart_monthly_kpis",
    "delivery_by_state": "select * from mart_delivery_by_state",
    "category_sales": "select * from mart_category_sales",
    "review_vs_delivery": "select * from mart_review_vs_delivery",
}

if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    con = duckdb.connect(str(ROOT / "data" / "olist.duckdb"), read_only=True)
    for name, query in TABLES.items():
        path = OUT / f"{name}.csv"
        con.execute(f"COPY ({query}) TO '{path}' (HEADER, DELIMITER ',')")
        rows = con.execute(f"select count(*) from ({query})").fetchone()[0]
        print(f"{path.name}: {rows} rows")
