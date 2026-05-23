# src/03_bayesian_model.R
# Estimates a Log-Normal Bayesian Hierarchical Model to measure climate risk

if (!require("brms")) install.packages("brms", dependencies = TRUE)
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("tidybayes")) install.packages("tidybayes")
if (!require("magrittr")) install.packages("magrittr")

library(brms)
library(ggplot2)
library(tidybayes)
library(magrittr)

print("--- Step 1: Loading Processed Analytical Dataset ---")
analysis_data <- read.csv("data/cleaned_merged_dataset.csv")

print("--- Step 2: Formulating the Hierarchical Equation ---")
bayesian_formula <- bf(
  price_per_kg_kes ~ rainfall_lag_3months + temperature_c + (1 | county_name) + (1 | record_date),
  family = lognormal()
)

print("--- Step 3: Setting Prior Mathematical Distributions ---")
model_priors <- c(
  prior(normal(0, 1), class = "b"),       
  prior(normal(4, 1), class = "Intercept") 
)

print("--- Step 4: Compiling and Running Bayesian Estimation Chains ---")
fit_climate_risk <- brm(
  formula = bayesian_formula,
  prior = model_priors,
  data = analysis_data,
  chains = 2,         
  iter = 1000,        
  warmup = 500,       
  cores = 2,          
  seed = 254          
)

print("--- Step 5: Model Diagnostics Summary ---")
print(summary(fit_climate_risk))

print("--- Step 6: Generating Bayesian Uncertainty Visualizations ---")
# Extract draws explicitly using tidybayes to prevent data frame coercion errors
draws_df <- fit_climate_risk %>%
  gather_draws(b_rainfall_lag_3months, b_temperature_c)

p <- ggplot(draws_df, aes(y = .variable, x = .value)) +
  stat_halfeye(fill = "steelblue", .width = c(0.50, 0.95)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red", linewidth = 1) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Posterior Distribution of Climatic Impact on Maize Prices",
    subtitle = "Visualizing the 50% and 95% Bayesian Credible Intervals",
    x = "Effect Size (Log-Scale Impact on Prices)",
    y = "Model Parameters"
  )

# Save the plot directly in the root directory for Quarto access
ggsave("bayesian_uncertainty_plot.png", plot = p, width = 7, height = 4, dpi = 150)
print("✓ Uncertainty visualization safely rendered and exported to root folder!")

