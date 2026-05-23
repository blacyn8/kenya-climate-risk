-- db_schema.sql
-- Run this to initialize your local relational storage tables

CREATE TABLE IF NOT EXISTS weather_records (
    record_id INTEGER PRIMARY KEY AUTOINCREMENT,
    county_name TEXT NOT NULL,
    record_date TEXT NOT NULL, -- Stored as YYYY-MM-DD
    rainfall_mm REAL,
    temperature_c REAL
);

CREATE TABLE IF NOT EXISTS food_prices (
    price_id INTEGER PRIMARY KEY AUTOINCREMENT,
    county_name TEXT NOT NULL,
    market_name TEXT NOT NULL,
    record_date TEXT NOT NULL,
    commodity_type TEXT NOT NULL, -- e.g., 'Maize', 'Rice'
    price_per_kg_kes REAL
);
