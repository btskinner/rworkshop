################################################################################
##
## <PROJ> R Workshop
## <FILE> programming.R 
## <INIT> 16 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## libraries
library(tidyverse)

## ---------------------------------------------------------
## Control flow
## ---------------------------------------------------------

## ---------------------------
## for
## ---------------------------

## make vector of numbers between 1 and 10
num_sequence <- 1:10

## loop through, printing each num_sequence value, one at a time
for (i in num_sequence) {
    print(i)
}

## character vector using letters object from R base
chr_sequence <- letters[1:10]

## loop through, printing each chr_sequence value, one at a time
for (i in chr_sequence) {
    print(i)
}

## for loop by indices
for (i in 1:length(chr_sequence)) {
    print(chr_sequence[i])
}

## ---------------------------
## while
## ---------------------------

## set up a counter
i <- 1

## with each loop, add one to i
while(i < 11) {
    print(i)
    i <- i + 1
}

## ---------------------------
## if
## ---------------------------

## only print if number is not 5
for (i in num_sequence) {
    if (i != 5) {
        print(i)
    }
}

## if/else loop
for (i in num_sequence) {
    if (i != 3 & i != 5) {
        print(i)
    } else if (i == 3) {
        print('three')
    } else {
        print('five')
    }
}

## ---------------------------------------------------------
## Writing functions
## ---------------------------------------------------------

## function to say hi!
my_function <- function() {
    print('Hi!')
}

## call it
my_function()

## new function to print sequence of numbers
print_nums <- function(num_vector) {
    ## this code looks familiar...
    for (i in num_vector) {
        print(i)
    }
}

## try it out!
print_nums(1:10)

## create tbl_df with around 10% missing values (-97,-98,-99) in three columns
df <- data.frame('id' = 1:100,
                 'age' = sample(c(seq(11,20,1), -97),
                                size = 100,
                                replace = TRUE,
                                prob = c(rep(.09, 10), .1)),
                 'sibage' = sample(c(seq(5,12,1), -98),
                                   size = 100,
                                   replace = TRUE,
                                   prob = c(rep(.115, 8), .08)),
                 'parage' = sample(c(seq(45,55,1), -99),
                                   size = 100,
                                          replace = TRUE,
                                   prob = c(rep(.085, 11), .12))
                 ) %>%
    tbl_df()

## show
df

## function to fix missing values
fix_missing <- function(x, miss_val) {

    ## in the vector, wherever the vector is the missval_num, make NA
    x[x == miss_val] <- NA

    ## return instead of print because we want to store it
    return(x)
}

## check
table(df$age, useNA = 'ifany')

## missing values in age are coded as -97
df$age <- fix_missing(df$age, -97)

## recheck
table(df$age, useNA = 'ifany')


## =============================================================================
## END SCRIPT
################################################################################
