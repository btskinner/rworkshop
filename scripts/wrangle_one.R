################################################################################
##
## <PROJ> R Workshop
## <FILE> wrangle_one.R 
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

## ## check current directory
## getwd()
## 
## set the working directory, uncomment and change <path>/<to> as needed
## setwd('<path>/<to>/rworkshop/scripts')

## show the first few rows (or view in RStudio's view)
head(df)

## show the column names
names(df)

## ---------------------------
## add variables
## ---------------------------

## add a column of ones (the 1 will repeat and fill each row)
df$ones <- 1

## add sum of test scores (bynels2r + bynels2m)
df$sum_test <- df$bynels2r + df$bynels2m

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
df$female_v1[df$bysex == 'female'] <- 1 # double == for IS EQUAL TO
df$female_v1[df$bysex != 'female'] <- 0 # != --> NOT EQUAL TO

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
df[1:10, c('stu_id','bydob_p')]         # subset columns using c() + names

## since a data frame has two dims, notice the comma in the brackets
df <- df[order(df$bydob_p),]

## show again first few rows of ID and DOB
df[1:10, c('stu_id','bydob_p')]

## ---------------------------
## aggregate
## ---------------------------

## first, make test score values < 0 ==> NA (if you didn't already)
df$bynels2m[df$bynels2m < 0] <- NA

## create new data frame with mean math scores, dropping NAs
sch_m <- aggregate(df$bynels2m, by = list(df$sch_id), FUN = mean, na.rm = T)

## show
head(sch_m)

## ---------------------------
## merge
## ---------------------------

## first fix names from aggregated data set
names(sch_m) <- c('sch_id', 'sch_bynels2m')

## merge on school ID variable
df <- merge(df, sch_m, by = 'sch_id')

## show
head(df)

## ---------------------------
## write
## ---------------------------

## write.csv(df, '../data/els_plans_mod.csv', row.names = FALSE)

## =============================================================================
## END SCRIPT
################################################################################
