# Spatio-Temporal Bayesian Hierarchical Modeling for Climate-Driven Financial Risk in Kenya

**Author:** Blacyn Ochieng  
**Degree:** BSc in Mathematical Sciences (Statistics Specialization)  
**Academic Year:** 2026  

An advanced, end-to-end statistical computing project that quantifies how localized, lagged geographical climate shocks propagate into commodity price inflation and agricultural economic volatility across Kenyan markets.

---

## 📐 1. Theoretical & Mathematical Framework

Unlike traditional Machine Learning models (such as Random Forests or basic OLS regressions) which output a single point estimate and falsely assume data points are independent, this project implements a **Generalized Linear Mixed Model (GLMM)** under a **Log-Normal Likelihood** [🏆]. This mathematically accounts for the positive skewness and heteroskedasticity inherent in financial market prices.

### The Hierarchical Equation:
$$Y_{it} \sim \text{Log-Normal}(\mu_{it}, \sigma^2)$$

$$\mu_{it} = \beta_0 + \beta_1 X_{i, t-3} + \beta_2 Z_{i, t} + s_i + \gamma_t$$

Where:
* **$Y_{it}$**: The observed commodity market price per kilogram (KES) in county $i$ during month $t$.
* **$X_{i, t-3}$**: The Exogenous Climate Covariate—total monthly rainfall (mm) lagged by exactly 3 months to capture agricultural crop-cycle delay effects [🏆].
* **$Z_{i, t}$**: The mean monthly temperature (°C).
* **$s_i$**: The Spatial Random Intercept representing unique unobserved geographic properties for county $i$.
* **$\gamma_t$**: The Temporal Random Intercept accounting for macro-economic currency shocks and baseline inflation shifts over time.

---

## 🛠️ 2. The Full-Stack Technical Pipeline

The system bridges foundational school concepts with modern software engineering workflows across a multi-language stack [🏆]:

