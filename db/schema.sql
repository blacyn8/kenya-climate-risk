-- db/schema.sql
-- Establishes structured, indexed tables for Kenya climate risk analysis

-- 1. Weather Table (KMD Historical Aggregates)
CREATE TABLE IF NOT EXISTS weather_records (
    record_id INTEGER PRIMARY KEY AUTOINCREMENT,
    county_name TEXT NOT NULL,
    record_date TEXT NOT NULL,      -- Format: YYYY-MM-DD
    rainfall_mm REAL,               -- Total monthly rainfall
    temperature_c REAL,             -- Average monthly temperature
    UNIQUE(county_name, record_date) -- Prevents duplicate entries for the same month
);

-- 2. Food Prices Table (WFP Commodity Metrics)
CREATE TABLE IF NOT EXISTS food_prices (
    price_id INTEGER PRIMARY KEY AUTOINCREMENT,
    county_name TEXT NOT NULL,
    market_name TEXT NOT NULL,
    record_date TEXT NOT NULL,      -- Format: YYYY-MM-DD
    commodity_type TEXT NOT NULL,   -- e.g., 'Maize', 'Rice', 'Sugar'
    price_per_kg_kes REAL NOT NULL,
    UNIQUE(county_name, market_name, record_date, commodity_type)
);

-- 3. Database Performance Indices (Proves database optimization skills)
CREATE INDEX IF NOT EXISTS idx_weather_lookup ON weather_records (county_name, record_date);
CREATE INDEX IF NOT EXISTS idx_price_lookup ON food_prices (county_name, record_date);
