#Install Packages
libs <- c('tidyverse', 'sf', 'haven', 'raster', 'units', 'rgdal', 'lwgeom')
sapply(libs, require, character.only = TRUE)
# 'plotly', 'RSQLite'

# Set up file pathing
setwd(file.path('..'))

## Structure taken from: https://github.com/brhkim/mapping-education-deserts/blob/main/Code/00_main.R
project_data <- file.path('01_Data')
# Set this director to the project data folder, relative to the project root folder.

project_code <- file.path('02_Code')
# Set this director to the project code folder, relative to the project root folder.

project_output <- file.path('03_Output')
# Set this director to the project output folder, relative to the project root folder.

temp = list.files(path= project_data, pattern="*.csv")
myfiles = lapply(temp, read.delim)
