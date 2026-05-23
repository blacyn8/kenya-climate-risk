# src/01a_data_merge.R
# Connects to SQLite, extracts records using SQL window functions, and prepares the model dataset

if (!require("DBI")) install.packages("DBI")
if (!require("RSQLite")) install.packages("RSQLite")

library(DBI)
library(RSQLite)

print("--- Step 1: Connecting to Local SQL Database ---")
db_path <- "C:\\Users\\USER\\Documents\\kenya-climate-risk\\data\\kenya_risk.db"
con <- dbConnect(RSQLite::SQLite(), db_path)

print("--- Step 2: Running SQL Analytical Lag Query ---")
# This SQL query merges both tables and creates a 3-month lag for rainfall
query <- "
    SELECT 
        p.county_name,
        p.record_date,
        p.commodity_type,
        p.price_per_kg_kes,
        w.rainfall_mm,
        w.temperature_c,
        -- Use the SQL LAG window function to look back 3 months in time
        LAG(w.rainfall_mm, 3) OVER (
            PARTITION BY p.county_name, p.commodity_type 
            ORDER BY p.record_date
        ) AS rainfall_lag_3months
    FROM food_prices p
    INNER JOIN weather_records w 
        ON p.county_name = w.county_name 
        AND p.record_date = w.record_date
"

# Execute query and load into an R data frame
merged_data <- dbGetQuery(con, query)
dbDisconnect(con)

print("--- Step 3: Cleaning Missing Lag Rows & Saving ---")
# Remove rows where the 3-month lag is empty (the first 3 months of the series)
cleaned_data <- na.omit(merged_data)

# Save as your clean analytical modeling target file
write.csv(cleaned_data, "data/cleaned_merged_dataset.csv", row.names = FALSE)

print(paste("✓ Successfully merged dataset created with", nrow(cleaned_data), "clean statistical rows!"))
