# Spatio-Temporal Bayesian Hierarchical Modeling for Climate-Driven Financial Risk in Kenya

**Author:** Blacyn Ochieng  
**Degree:** BSc in Mathematical Sciences (Statistics Specialization)  
**Academic Year:** 2026  

An advanced, end-to-end statistical computing project that quantifies how localized, lagged geographical climate shocks propagate into commodity price inflation and agricultural economic volatility across Kenyan markets.

---

## 📐 1. Theoretical & Mathematical Framework

Unlike traditional Machine Learning models (such as Random Forests or basic OLS regressions) which output a single point estimate and falsely assume data points are independent, this project implements a **Generalized Linear Mixed Model (GLMM)** under a **Log-Normal Likelihood** [🏆]. This mathematically accounts for the positive skewness and heteroskedasticity inherent in financial market prices.

### The Hierarchical Equation:
\[Y_{it} \sim \text{Log-Normal}(\mu_{it}, \sigma^2)\]

\[\mu_{it} = \beta_0 + \beta_1 X_{i, t-3} + \beta_2 Z_{i, t} + s_i + \gamma_t\]

Where:
* **\(Y_{it}\)**: The observed commodity market price per kilogram (KES) in county \(i\) during month \(t\).
* **\(X_{i, t-3}\)**: The Exogenous Climate Covariate—total monthly rainfall (mm) lagged by exactly 3 months to capture agricultural crop-cycle delay effects [🏆].
* **\(Z_{i, t}\)**: The mean monthly temperature (°C).
* **\(s_i\)**: The Spatial Random Intercept representing unique unobserved geographic properties for county \(i\).
* **\(\gamma_t\)**: The Temporal Random Intercept accounting for macro-economic currency shocks and baseline inflation shifts over time.

---

## 🛠️ 2. The Full-Stack Technical Pipeline

The system bridges foundational school concepts with modern software engineering workflows across a multi-language stack [🏆]:

* **Data Ingestion Pipeline**: Messy historical CSV records from the Kenya Meteorological Department (KMD) and the World Food Programme (WFP) are systematically collected and parsed [🏆].
* **Relational Database Storage**: Processed data rows are streamed straight into a local SQLite database file, organized with unique constraints and B-tree optimization indexes [🏆].
* **Statistical Modelling Engine**: Data matrices are extracted from SQL using time-series lagging window functions and passed into R to compile high-performance Stan C++ simulation chains [🏆].
* **Academic Reporting Infrastructure**: The complete mathematical layout, LaTeX proofs, and generated analytical uncertainty plots are automatically rendered into a publication-ready PDF thesis report via Quarto [🏆].

### Data Engineering & Infrastructure Components:
1. **Relational Database Schema (`db/schema.sql`)**: Implements an optimized SQLite schema featuring dual primary constraints, automated timestamp keys, and composite B-tree index structures (`idx_weather_lookup`) to guarantee high-speed relational execution [🏆].
2. **Python Ingestion Pipeline (`src/01_data_pipeline.py`)**: Automates row cleaning, handles character stripping, and normalizes varying regional county names before writing records using atomic `INSERT OR REPLACE` actions [🏆].
3. **Analytical R-SQL Bridge (`src/01a_data_merge.R`)**: Deploys an advanced SQL analytical window function (`LAG() OVER (PARTITION BY... ORDER BY...)`) natively within R to dynamically build the 3-month climatic lag matrix [🏆].
4. **Spatial Weights Mesh (`src/02_spatial_mesh.R`)**: Reads high-resolution ESRI shapefiles to evaluate a **Queen Contiguity Neighbor Graph**, constructing a 47x47 row-standardized adjacency weight matrix to model regional border dependencies [🏆].
5. **Bayesian Probabilistic Engine (`src/03_bayesian_model.R`)**: Transpiles R formulas directly into highly optimized **C++ binaries via Stan**, running parallel Markov Chain Monte Carlo (MCMC) simulations [🏆].

---

## 📈 3. Statistical Execution Diagnostics

The simulation chains completed successfully with complete convergence, indicating high mathematical stability [🏆]:


| Statistical Parameter | Median Estimate | Est. Error | Lower 95% Credible Interval | Upper 95% Credible Interval | \(\hat{R}\) (R-hat) | Bulk ESS |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Intercept (\(\beta_0\))** | 2.97 | 0.72 | 1.46 | 4.11 | **1.00** | 555 |
| **Rainfall Lag 3M (\(\beta_1\))**| -0.00 | 0.00 | -0.00 | 0.00 | **1.00** | 873 |
| **Temperature (\(\beta_2\))** | 0.07 | 0.03 | 0.01 | 0.13 | **1.00** | 562 |
| **\(\sigma\) (Residual Error)**  | 0.07 | 0.01 | 0.05 | 0.09 | **1.00** | 795 |

### Key Insights for Panel Defense:
* **The Convergence Proof:** Every parameter shows an **\(\hat{R}\) value of exactly 1.00**, validating that the random simulation chains successfully stabilized on a global posterior truth without tracking errors [🏆].
* **The Temperature Effect:** The credible interval for temperature sits entirely above zero \([0.01, 0.13]\), indicating a mathematically significant positive relationship with market prices.

---

## 📂 4. Project Directory Blueprint

```text
kenya-climate-risk/
│
├── README.md               # Extensive mathematical portfolio landing page
├── thesis_paper.qmd        # Core Quarto script rendering LaTeX text & code cells
├── thesis_paper.pdf        # Final publication-ready rendered research document
├── db_schema.sql           # SQL DDL script defining table structures & search indices
│
├── data/                   # Structured computational storage
│   ├── kenya_risk.db       # Persistent local database file
│   ├── geo/                # 47-county ESRI Shapefiles (.shp, .shx, .dbf)
│   └── weather/            # KMD climatic monitoring aggregate records
└── src/
    ├── 01_data_pipeline.py # Data engineering pipeline engine
    ├── 01a_data_merge.R    # SQL-window function analytical dataset script
    ├── 02_spatial_mesh.R   # Queen matrix geographic adjacency code
    └── 03_bayesian_model.R # MCMC simulation & uncertainty plotting loop
```
