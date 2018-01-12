################################################################################
##
## <PROJ> R Workshop
## <FILE> wrangle.R 
## <INIT> 15 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## reading in data
df <- read.table('../data/els_plans.csv', sep = ',', header = TRUE)

## show the first few rows (or view in RStudio's view)
head(df)

## show the column names
names(df)


## =============================================================================
## END SCRIPT
################################################################################
