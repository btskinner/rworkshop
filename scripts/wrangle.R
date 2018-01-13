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
## Data wrangling with base R
## -----------------------------------------------------------------------------

## read in the data, making sure that first line is read as column names
df <- read.table('../data/els_plans.csv', sep = ',', header = TRUE,
                 stringsAsFactors = FALSE)

## show the first few rows (or view in RStudio's view)
head(df)

## show the column names
names(df)

## ---------------------------
## access columns
## ---------------------------

## wrong
summary(bynels2m)
summary('bynels2m')

## correct
summary(df$bynels2m)
summary(df[['bynels2m']])

## ---------------------------
## add variables
## ---------------------------

## add simply column of ones
df$ones <- 1

## add average test score (bynels2r + bynels2m / 2)
df$avg_test <- (df$bynels2r + df$bynels2m) / 2

## check names
names(df)

## ---------------------------
## drop variables
## ---------------------------

## drop follow up one panel weight
df$f1pnlwt <- NULL

## check names
names(df)

## ---------------------------
## conditionally change values
## ---------------------------

## make a numeric column that == 1 if bysex is female, 0 otherwise
## v.1
df$female_v1[df$bysex == 'female'] <- 1
df$female_v1[df$bysex != 'female'] <- 0

## v.2
df$female_v2 <- ifelse(df$bysex == 'female', 1, 0)

## the same?
identical(df$female_v1, df$female_v2)

## ---------------------------
## filter
## ---------------------------

## assign as NA if < 0
df$bydob_p[df$bydob_p < 0] <- NA
nrow(df)

## drop if NA
df <- df[!is.na(df$bydob_p),]
nrow(df)

## ---------------------------
## order
## ---------------------------

## show first few rows of student and base year math scores
df[1:10, c('stu_id','bydob_p')]

## since a data frame has two dims, notice the comma in the brackets
df <- df[order(df$bydob_p),]

## show again first few rows of ID and DOB
df[1:10, c('stu_id','bydob_p')]

## ---------------------------
## aggregate
## ---------------------------

## first, make test score values < 0 == NA
df$bynels2m[df$bynels2m < 0] <- NA

## create new data frame
df_sch <- aggregate(df$bynels2r, by = list(df$sch_id), FUN = mean, na.rm = T)

## show
head(df_sch)

## ---------------------------
## merge
## ---------------------------

## first fix names from aggregated data set
names(df_sch) <- c('sch_id', 'sch_bynels2m')

## merge on school ID variable
df <- merge(df, df_sch, by = 'sch_id')

## show
head(df)

## ---------------------------
## write
## ---------------------------

## write.csv(df, '../data/els_plans_mod.csv', row.names = FALSE)
## 
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
df <- df %>% mutate(ones = 1,
                    avg_test = (bynels2r + bynels2m) / 2) # ignore neg vals

## (1) make a numeric column that == 1 if bysex is female, 0 otherwise
## (2) assign DOB an NA if < 0
df <- df %>%
    mutate(female = ifelse(bysex == 'female', 1, 0),
           bydob_p = ifelse(bydob_p < 0, NA, bydob_p))           

## ---------------------------
## select
## ---------------------------

## drop follow up one panel weight
df <- df %>% select(-f1pnlwt)

## check names
names(df)

## ---------------------------
## select
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
df_sch <- df %>%
    ## first, make test score values < 0 == NA
    mutate(bynels2m = ifelse(bynels2m < 0, NA, bynels2m)) %>%
    ## group by school ID
    group_by(sch_id) %>%
    ## summarize
    summarise(sch_bynels2m = mean(bynels2m, na.rm = TRUE))

## show
df_sch

## ---------------------------
## join
## ---------------------------

## join on school ID variable
df <- df %>% left_join(df_sch, by = 'sch_id')

## ---------------------------
## write
## ---------------------------

## write_csv(df, '../data/els_plans_mod_tv.csv')
## 
## -----------------------------------------------------------------------------
## Reshaping data
## -----------------------------------------------------------------------------

## ---------------------------
## Create toy data
## ---------------------------

df <- data.frame(schid = c('A','B','C','D'),
                 year = 2013,
                 var_x = 1:4,
                 var_y = 5:8,
                 var_z = 9:12,
                 stringsAsFactors = FALSE) %>%
    tbl_df()

## show
df

## ---------------------------
## wide --> long
## ---------------------------

df_long <- df %>%
    gather(var, value, -c(schid, year)) %>%
    mutate(var = gsub('var_', '', var)) %>%
    arrange(schid, var)

## show
df_long

## ---------------------------
## long --> wide
## ---------------------------

df_wide <- df_long %>%
    mutate(var = gsub('(.*)', 'var_\\1', var)) %>%
    spread(var, value) %>%
    arrange(schid)

## show
df_wide

## confirm that df_wide == df
identical(df, df_wide)

## =============================================================================
## END SCRIPT
################################################################################
