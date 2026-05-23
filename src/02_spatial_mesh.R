# src/02_spatial_mesh.R
# Pre-requisites: Computes the spatial neighbor structure for Kenya's 47 counties

# 1. Install missing spatial analysis libraries if they aren't on your machine
if (!require("sf")) install.packages("sf", dependencies = TRUE)
if (!require("spdep")) install.packages("spdep", dependencies = TRUE)

library(sf)
library(spdep)

print("--- Step 1: Loading Kenya County Shapefile ---")
# Adjust the filename below if your unzipped files have a slightly different name
shapefile_path <- "data/geo/geoBoundaries-KEN-ADM1.shp"

# Read the spatial data frame
kenya_counties <- st_read(shapefile_path)

print("--- Step 2: Computing Contiguity Neighbors (Queen Matrix) ---")
# Poly2nb checks which counties share a border or vertex (Queen contiguity)
county_neighbors <- poly2nb(kenya_counties, queen = TRUE)

# Print out a summary of the connections to your console
print(summary(county_neighbors))

print("--- Step 3: Generating the Sparse Spatial Weight Matrix ---")
# Style 'W' row-standardizes the matrix so weights sum to 1 per county
spatial_weights <- nb2mat(county_neighbors, style = "W", zero.policy = TRUE)

# View the dimensions - it should be a perfect 47x47 matrix for Kenya's counties!
print(paste("Matrix Dimensions:", nrow(spatial_weights), "x", ncol(spatial_weights)))

print("--- Success: Spatial Neighbor Setup Complete! ---")
 j