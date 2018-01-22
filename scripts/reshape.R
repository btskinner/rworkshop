################################################################################
##
## <PROJ> R Workshop
## <FILE> reshape.R 
## <INIT> 15 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## library
library(tidyverse)

## -----------------------------------------------------------------------------
## Reshaping data
## -----------------------------------------------------------------------------

## ---------------------------
## Create toy data
## ---------------------------

df <- data.frame(schid = c('A','B','C','D'),
                 year = 2013,
                 math = round(rnorm(4, 500, 10)),
                 read = round(rnorm(4, 300, 20)),
                 science = round(rnorm(4, 800, 15)),
                 stringsAsFactors = FALSE) %>%
    tbl_df()

## confirm that it is wide
df

## ---------------------------
## wide --> long
## ---------------------------

df_long <- df %>%
    gather(test, score, -c(schid, year)) %>%
    arrange(schid, test)

## show
df_long

## ---------------------------
## long --> wide
## ---------------------------

df_wide <- df_long %>%
    spread(test, score) %>%
    arrange(schid)

## show
df_wide

## confirm that df_wide == df
identical(df, df_wide)

## ---------------------------
## QUICK EXERCISE
## ---------------------------

## reshape to wide and then back
df <- data.frame(id = rep(c('A','B','C','D'), each = 4),
                 year = paste0('y', rep(2000:2003, 4)),
                 score = rnorm(16),
                 stringsAsFactors = FALSE) %>%
    tbl_df()

## =============================================================================
## END SCRIPT
################################################################################
