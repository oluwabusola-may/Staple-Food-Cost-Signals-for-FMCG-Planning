[README (5).md](https://github.com/user-attachments/files/30234901/README.5.md)
# Staple Food Cost Signals for FMCG Planning

**An Excel dashboard analyzing Nigerian staple food price inflation (Nov 2024–May 2026) — and why national inflation benchmarks can mask what's actually happening to specific commodities.**

!<img width="1039" height="589" alt="dashboard_screenshot" src="https://github.com/user-attachments/assets/1c844c50-dd56-4ec7-98e7-7a9c89654113" />
(dashboard/dashboard_screenshot.png)

## The Finding

CBN's national food inflation sits at **+16.96% YoY**. The core staple basket (rice, beans, garri, yam) analyzed here shows **-24.7% YoY** over the same period and that deflation is concentrated almost entirely in Beans and Garri, while Rice and Yam hold firm or rise.

This divergence matters for FMCG cost planning: relying on broad national inflation figures alone would miss a real margin opportunity sitting in two specific commodities.

## Data Sources

| Source | Contents |
|---|---|
| **NBS** (National Bureau of Statistics) | Monthly price exports — item prices, MoM/YoY, highest/lowest state prices, six geopolitical zone breakdowns |
| **CBN** (Central Bank of Nigeria) | Food inflation table (Food YoY, Food Average, All Items YoY) + exchange rate table |

Both datasets were sourced from the publicly available NBS and CBN websites.

**World Bank data was evaluated and excluded** — found to be skewed toward two states, not nationally representative. Full rationale in `/documentation/world_bank_exclusion_rationale.md`.

## Methodology

1. **Clean** — Handled schema drift across monthly NBS files using Power Query's Transform File function applied from a folder; dates extracted from filenames for reliability
2. **Model** — Built a star schema (Dim_Date, Dim_Item) in Power Query / Data Model
3. **Validate** — Independently recalculated MoM and YoY figures, checked against NBS's own published values
4. **Analyze** — PivotTables/PivotCharts for exploratory analysis, refined into final dashboard panels
5. **Document** — Every cleaning decision and exclusion logged for transparency

## Key Learnings

- `Text.From()` wrapping required for numeric fields in M code concatenation, a recurring fix across pipeline steps
- Relationship direction in the Data Model must be checked against data type alignment before building, a type mismatch on Dim_Date silently reversed a relationship
- NBS data is national-level aggregate, not state-by-state — regional analysis uses six geopolitical zones, not states
- Caught and corrected a YoY calculation error mid-build that briefly produced a nonsensical -182% — the mistake was comparing two already-calculated percentages instead of raw prices. Full writeup in `/documentation/cleaning_summary.md`

## Repo Contents

- `/power-query/` — Full M code for each transformation step, in the order applied
- `/documentation/` — Cleaning summary, exclusion rationale, data dictionary
- `/dashboard/` — Final dashboard screenshot

## Connect

Built by Oluwabusola Oyenuga — [LinkedIn link] | [dashboard write-up link]
