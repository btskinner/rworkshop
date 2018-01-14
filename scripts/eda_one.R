################################################################################
##
## <PROJ> R Workshop
## <FILE> eda_one.R 
## <INIT> 15 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## libraries: tidyverse + haven and labelled
library(tidyverse)
library(haven)
library(labelled)

## ---------------------------------------------------------
## Read in data from another program
## ---------------------------------------------------------

## read in Stata dta file
df <- read_dta('../data/els_plans.dta')

## ---------------------------------------------------------
## Viewing data and labels
## ---------------------------------------------------------

## use glipse
glimpse(df)

## show the labels for just a few variables
df %>%
    select(stu_id, bysex, bypared, bynels2m) %>%
    var_label()

## who first few rows of bysex
df %>% select(bysex)

## see value labels for bysex
df %>% select(bysex) %>% val_labels()

## show more information about bysex variable
head(df$bysex)

## create an indicator variable for female
df <- df %>%
    mutate(female = ifelse(bysex == 2, 1, 0))

## ---------------------------------------------------------
## Summary statistics
## ---------------------------------------------------------
## ---------------------------
## continuous values
## ---------------------------

## get mean and sd
mean(df$bynels2m)
sd(df$bynels2m)

## need to tell R to remove NAs
mean(df$bynels2m, na.rm = TRUE)
sd(df$bynels2m, na.rm = TRUE)

## mean and sd using dplyr
df %>%
    summarise_at(.vars = vars(bynels2m),
                 .funs = funs(mean, sd, .args = list(na.rm = TRUE)))

## ---------------------------
## discrete values
## ---------------------------
## ------------
## one-way 
## ------------

## table of parental education levels
table(df$bypared, useNA='ifany')

## use as_factor() to get the value labels
table(as_factor(df$bypared), useNA='ifany')

## check how bypared labels are assigned
val_labels(df$bypared)

## using dplyr to make a table
df %>%
    count(bypared) %>%
    as_factor()

## ------------
## two-way 
## ------------

## table of parental education levels
table(as_factor(df$bypared), as_factor(df$bysex))

## use the group_by() and count() functions to make two-way table
df %>%
    group_by(bysex) %>%
    count(bypared) %>%
    as_factor()

## spread to look like other table
df %>%
    group_by(bysex) %>%
    count(bypared) %>%
    as_factor() %>%
    spread(bysex, n)

## ---------------------------
## conditional means
## ---------------------------

## get average math score by parental education 
aggregate(df$bynels2m, by = list(df$bypared), mean, na.rm = TRUE)

df <- df %>%
    mutate(lowinc = ifelse(byincome <= 7, 1, 0))

## get average math score by low income status and parental education levels
aggregate(df$bynels2m, by = list(df$lowinc, df$bypared), mean, na.rm = TRUE)

## using dplyr to get average math score by parental education level
df %>%
    group_by(bypared) %>%
    summarise_at(.vars = vars(bynels2m),
                 .funs = funs(mean, .args = list(na.rm = TRUE))) %>%
    as_factor()

## using dplyr to get average math score by income and parental education level
df %>%
    group_by(bypared, lowinc) %>%
    summarise_at(vars(bynels2m),
                 funs(mean, .args = list(na.rm = TRUE))) %>%
    as_factor()

## =============================================================================
## END SCRIPT
################################################################################
