# src/01_data_pipeline.py
# Reads raw climatic and price datasets, cleans text, and pushes to SQLite database

import os
import sqlite3
import pandas as pd
import numpy as np

# 1. Define the absolute path to your active database file
DB_PATH = r"C:\Users\USER\Documents\kenya-climate-risk\data\kenya_risk.db"

def initialize_mock_data():
    """Generates synthetic, structured Kenyan data for testing your pipeline."""
    print("--- Step 1: Generating Test Data Profiles ---")
    
    # Generate 12 months of dates for 2025
    months = pd.date_range(start="2025-01-01", end="2025-12-01", freq="MS").strftime("%Y-%m-%d")
    counties = ["Nairobi", "Mombasa", "Kericho", "Kitui", "Meru"]
    
    weather_rows = []
    price_rows = []
    
    # Generate realistic values based on Kenya's climatology and market baselines
    for county in counties:
        for month in months:
            # Weather patterns (Kericho gets more rain, Kitui gets less)
            base_rain = 150 if county == "Kericho" else (40 if county == "Kitui" else 80)
            rain = max(0, base_rain + np.random.normal(0, 20))
            temp = 18 if county == "Kericho" else (26 if county == "Kitui" else 22)
            
            weather_rows.append({
                "county_name": county,
                "record_date": month,
                "rainfall_mm": round(rain, 2),
                "temperature_c": round(temp, 1)
            })
            
            # Food Prices (Maize price moves opposite to rainfall)
            base_price = 70 if county == "Kericho" else 95
            # Simulate price surge if rainfall drops
            price_shock = 25 if rain < 40 else 0
            final_price = max(50, base_price + price_shock + np.random.normal(0, 5))
            
            price_rows.append({
                "county_name": county,
                "market_name": f"{county} Central Market",
                "record_date": month,
                "commodity_type": "Maize",
                "price_per_kg_kes": round(final_price, 2)
            })
            
    # Save these as your initial CSV assets
    os.makedirs("data/weather", exist_ok=True)
    os.makedirs("data/prices", exist_ok=True)
    
    pd.DataFrame(weather_rows).to_csv("data/weather/kmd_monthly_raw.csv", index=False)
    pd.DataFrame(price_rows).to_csv("data/prices/wfp_prices_raw.csv", index=False)
    print("✓ Local CSV text files populated successfully.")

def ingest_to_database():
    """Reads the CSV assets, standardizes strings, and writes to SQLite tables."""
    print("--- Step 2: Processing and Ingesting to SQL Tables ---")
    
    # Connect directly to your persistent database file
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Read the data back using Pandas
    df_weather = pd.read_csv("data/weather/kmd_monthly_raw.csv")
    df_prices = pd.read_csv("data/prices/wfp_prices_raw.csv")
    
    # Text standardization rule: Capitalize names properly and remove extra spaces
    df_weather["county_name"] = df_weather["county_name"].str.strip().str.title()
    df_prices["county_name"] = df_prices["county_name"].str.strip().str.title()
    
    # Push into your existing SQL tables using INSERT OR REPLACE to avoid duplicate keys
    for _, row in df_weather.iterrows():
        cursor.execute("""
            INSERT OR REPLACE INTO weather_records (county_name, record_date, rainfall_mm, temperature_c)
            VALUES (?, ?, ?, ?)
        """, (row["county_name"], row["record_date"], row["rainfall_mm"], row["temperature_c"]))
        
    for _, row in df_prices.iterrows():
        cursor.execute("""
            INSERT OR REPLACE INTO food_prices (county_name, market_name, record_date, commodity_type, price_per_kg_kes)
            VALUES (?, ?, ?, ?, ?)
        """, (row["county_name"], row["market_name"], row["record_date"], row["commodity_type"], row["price_per_kg_kes"]))
        
    conn.commit()
    conn.close()
    print("✓ SQLite Database successfully synchronized.")

if __name__ == "__main__":
    initialize_mock_data()
    ingest_to_database()
