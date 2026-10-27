"""Draws the README chart from the marts."""
from pathlib import Path
import duckdb
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
con = duckdb.connect(str(ROOT / "data" / "olist.duckdb"), read_only=True)
df = con.execute("select * from mart_review_vs_delivery").df()
df["label"] = df["delivery_vs_promise"].str[3:]

GRID, MUTED = "#e6e5e0", "#898781"
plt.rcParams.update({"figure.facecolor": "#fcfcfb", "axes.facecolor": "#fcfcfb", "axes.edgecolor": GRID,
                     "xtick.color": MUTED, "ytick.color": MUTED, "axes.spines.top": False,
                     "axes.spines.right": False, "axes.grid": True, "grid.color": GRID,
                     "axes.axisbelow": True, "font.size": 11})
fig, ax = plt.subplots(figsize=(8, 4))
bars = ax.bar(df["label"], df["bad_review_pct"], color="#2a78d6", width=0.6)
ax.bar_label(bars, labels=[f"{v:.0f}%" for v in df["bad_review_pct"]], padding=3, color="#52514e")
ax.set_title("Share of 1–2 star reviews, by delivery compared with the promised date",
             loc="left", fontweight="bold", fontsize=12)
ax.set_ylim(0, 90); ax.grid(axis="x", visible=False)
ax.set_ylabel("% of reviews with 1 or 2 stars", color="#52514e")
fig.tight_layout()
(ROOT / "images").mkdir(exist_ok=True)
fig.savefig(ROOT / "images" / "bad_reviews_vs_delivery.png", dpi=150)
