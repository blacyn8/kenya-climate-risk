# src/03_bayesian_model.R
# Estimates a Log-Normal Bayesian Hierarchical Model to measure climate risk

if (!require("brms")) install.packages("brms", dependencies = TRUE)
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("tidybayes")) install.packages("tidybayes")

library(brms)
library(ggplot2)
library(tidybayes)

print("--- Step 1: Loading Processed Analytical Dataset ---")
analysis_data <- read.csv("data/cleaned_merged_dataset.csv")

print("--- Step 2: Formulating the Hierarchical Equation ---")
# Dependent variable: price_per_kg_kes modeled as Log-Normal
# Fixed effect: rainfall_lag_3months
# Random intercepts: group variations across counties and dates
bayesian_formula <- bf(
  price_per_kg_kes ~ rainfall_lag_3months + temperature_c + (1 | county_name) + (1 | record_date),
  family = lognormal()
)

print("--- Step 3: Setting Prior Mathematical Distributions ---")
# Weakly informative prior distributions for model stability
model_priors <- c(
  prior(normal(0, 1), class = "b"),       # Slopes for weather variables
  prior(normal(4, 1), class = "Intercept") # Base price intercept on log scale
)

print("--- Step 4: Compiling and Running Bayesian Estimation Chains ---")
# This automatically converts your math formula into fast C++ binaries!
fit_climate_risk <- brm(
  formula = bayesian_formula,
  prior = model_priors,
  data = analysis_data,
  chains = 2,         # Number of parallel MCMC simulation pipelines
  iter = 1000,        # Total simulation steps per chain
  warmup = 500,       # Initial learning steps to discard
  cores = 2,          # Utilizes dual processors for speed
  seed = 254          # Kenya's country code for perfect reproducibility!
)

print("--- Step 5: Model Diagnostics Summary ---")
print(summary(fit_climate_risk))

print("--- Step 6: Generating Bayesian Uncertainty Visualizations ---")
# Plotting the posterior distribution density for your climate parameters
p <- ggplot(fit_climate_risk, aes(y = "Rainfall Lag (3 Mo)", x = b_rainfall_lag_3months)) +
  stat_halfeye(fill = "steelblue", .width = c(0.50, 0.95)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Posterior Distribution of Rainfall Impact on Maize Prices",
    subtitle = "Visualizing the 50% and 95% Bayesian Credible Intervals",
    x = "Effect Size (Log-Scale Impact)", y = ""
  )

# Save the plot image directly inside your data directory
ggsave("data/bayesian_uncertainty_plot.png", plot = p, width = 7, height = 4, dpi = 150)
print("✓ Uncertainty visualization safely rendered and exported.")
