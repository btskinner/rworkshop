################################################################################
##
## <PROJ> R Workshop
## <FILE> wrangle_two.R 
## <INIT> 15 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## -----------------------------------------------------------------------------
## Data wrangling with tidyverse
## -----------------------------------------------------------------------------

## library
library(tidyverse)

## read in the data
df <- read_delim('../data/els_plans.csv', delim = ',')

## ---------------------------
## mutate
## ---------------------------

## assign values inside function using = sign (not <-)
df <- df %>%
    mutate(ones = 1,
           avg_test = (bynels2r + bynels2m) / 2) # ignore neg vals

## (1) make a numeric column that == 1 if bysex is female, 0 otherwise
## (2) assign DOB an NA if < 0
df <- df %>%
    mutate(female = ifelse(bysex == 'female', 1, 0),
           bydob_p = ifelse(bydob_p < 0, NA, bydob_p))           

## ---------------------------
## select
## ---------------------------

## just view first few rows of stu_id and sch_id (no assignment)
df %>% select(stu_id, sch_id)

## drop follow up one panel weight
df <- df %>% select(-f1pnlwt)

## check names
names(df)

## ---------------------------
## filter
## ---------------------------

## show number of rows
nrow(df)

## keep if not (!) missing
df <- df %>% filter(!is.na(bydob_p))
nrow(df)

## ---------------------------
## arrange
## ---------------------------

## show first few rows of student and base year math scores (tidyverse way)
df %>% select(stu_id, bydob_p) %>% head(10)

## arrange
df <- df %>% arrange(bydob_p)

## show again first few rows of ID and DOB
df %>% select(stu_id, bydob_p) %>% head(10)

## ---------------------------
## summarize
## ---------------------------

## create new data frame
sch_m <- df %>%
    ## (1) make test score values < 0 into NAs
    mutate(bynels2m = ifelse(bynels2m < 0, NA, bynels2m)) %>%
    ## (2) group by school ID
    group_by(sch_id) %>%
    ## (3) get the average math score, removing missing values
    summarise(sch_bynels2m = mean(bynels2m, na.rm = TRUE))

## show
sch_m

## ---------------------------
## join
## ---------------------------

## join on school ID variable
df <- df %>% left_join(sch_m, by = 'sch_id')

## ---------------------------
## write
## ---------------------------

## ## write flat file
## write_csv(df, '../data/els_plans_mod_tv.csv')
## 

## =============================================================================
## END SCRIPT
################################################################################
