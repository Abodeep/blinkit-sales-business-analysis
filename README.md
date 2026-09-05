# Blinkit Sales & Business Analysis

An end-to-end sales and business analysis project based on Blinkit grocery data, implemented using **SQL, Python, and Power BI**.

The project focuses on understanding overall sales performance, product performance, outlet performance, customer ratings, and item visibility through data cleaning, KPI analysis, exploratory analysis, and interactive business reporting.

---

## Project Overview

This project analyzes Blinkit's grocery sales data to identify key patterns and performance differences across products and outlet characteristics.

The same business problem was analyzed independently using three different tools:

- **SQL** for data cleaning, validation, KPI calculation, and business analysis
- **Python** for data cleaning, exploratory data analysis, and visualization
- **Power BI** for interactive dashboard development and business reporting

---

## Business Objectives

The analysis aims to:

- Evaluate overall sales performance
- Analyze sales by item fat content and item type
- Compare outlet performance across location, size, establishment year, and outlet type
- Monitor key business KPIs
- Analyze item visibility across outlet types
- Identify key business insights and potential areas for optimization

---

## Key Performance Indicators

The project tracks the following core KPIs:

| KPI | Description |
|---|---|
| Total Sales | Overall sales generated across the dataset |
| Average Sales | Average sales per item record |
| Number of Items | Total number of item records analyzed |
| Average Rating | Average customer rating across items |

---

## Data Cleaning & Quality

The data preparation process included:

- Data quality and missing-value validation
- Standardization of `Item Fat Content` categories
- Missing `Item Weight` treatment using a hierarchical imputation approach
- Duplicate and grain validation
- Categorical value validation
- Numerical field validation

### Item Weight Imputation

Missing `Item Weight` values were handled using a two-level strategy:

1. Recover the weight from the same `Item Identifier` when a known value was available.
2. For the remaining cases, use the median `Item Weight` within the corresponding `Item Type` and `Item Fat Content` group.

This approach was designed to preserve as much original information as possible while avoiding a blanket mean-based replacement.

---

## Analysis Covered

### Product Analysis

- Sales by Item Fat Content
- Sales by Item Type
- Top-performing item categories
- Average sales and ratings by product group

### Outlet Analysis

- Sales by Outlet Location Type
- Sales by Outlet Size
- Sales by Outlet Establishment Year
- Sales by Outlet Type
- Average sales and ratings across outlet segments
- Average Item Visibility by Outlet Type

### Cross Analysis

- Sales by Item Fat Content across Outlet Location Types

---

## Power BI Dashboard

The Power BI dashboard provides an interactive view of the key business metrics and sales performance.

### Dashboard Features

- KPI Cards
- Interactive slicers
- Sales analysis by fat content
- Item type performance
- Outlet establishment analysis
- Outlet size analysis
- Outlet location analysis
- Outlet type performance matrix
- Item visibility analysis

![Blinkit Power BI Dashboard](powerbi/screenshots/blinkit_dashboard.png)

---

## Key Business Insights

- Low Fat products generated the largest share of total sales, representing approximately 64.6% of overall sales.
- Fruits and Vegetables recorded the highest total sales among item categories, followed closely by Snack Foods.
- Tier 3 outlets contributed the largest share of sales among outlet location tiers at approximately 39.3%.
- Medium-sized outlets generated the highest share of sales among outlet sizes at approximately 42.3%.
- Supermarket Type1 was the strongest contributor to total sales among outlet types.
- Grocery Stores recorded the highest average item visibility, while Supermarket Type3 recorded the lowest.

These findings are descriptive and reflect patterns observed in the analyzed dataset; they do not by themselves establish causal relationships.

---

## Business Recommendations

- Monitor demand and inventory availability for high-performing Low Fat product segments.
- Prioritize further evaluation of leading product categories such as Fruits and Vegetables and Snack Foods.
- Investigate the operational and financial characteristics of high-performing outlet formats such as Supermarket Type1.
- Evaluate medium-sized outlets as a potential area for further operational and assortment analysis.
- Investigate differences in item visibility across outlet types and assess potential optimization opportunities.

---

## Repository Structure

```text
blinkit-sales-business-analysis/
│
├── powerbi/
│   ├── Blinkit_Analysis.pbix
│   └── screenshots/
│       └── blinkit_dashboard.png
│
├── python/
│   └── Blinkit_Analysis.ipynb
│
├── sql/
│   ├── 01_Blinkit_Data_Cleaning.sql
│   └── 02_Blinkit_Business_Analysis.sql
│
└── README.md
