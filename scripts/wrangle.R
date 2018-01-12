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

## -----------------------------------------------------------------------------
## Wrangling data using Base R commands
## -----------------------------------------------------------------------------

## read in the data, making sure that first line is read as column names
df <- read.table('../data/els_plans.csv', sep = ',', header = TRUE)

## show the first few rows (or view in RStudio's view)
head(df)

## show the column names
names(df)

## -----------------------------------------------------------------------------
## Wrangling data using the Tidyverse
## -----------------------------------------------------------------------------

## library
library(tidyverse)

## read in the data
df <- read_delim('../data/els_plans.csv', delim = ',')


## =============================================================================
## END SCRIPT
################################################################################
