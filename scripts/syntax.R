################################################################################
##
## <PROJ> R Workshop
## <FILE> syntax.R 
## <INIT> 15 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## ---------------------------------------------------------
## Language and environment
## ---------------------------------------------------------
## ---------------------------------------------------------
## Data types and structures
## ---------------------------------------------------------
## ---------------------------
## types
## ---------------------------
## ------------
## logical
## ------------

## assignment
(x <- TRUE)

## ! == NOT
!x

## check
is.logical(x)

## evaluate
1 + 1 == 2

## 1 == TRUE
x <- 1
isTRUE(x)

## 0 == FALSE
y <- 0
isTRUE(y)

## ------------
## numeric
## ------------

## use 'L' after digit to store as integer
x <- 1L
is.integer(x)

## R stores as double by default
y <- 1
is.double(y)

## both are numeric
is.numeric(x)
is.numeric(y)

## ------------
## character
## ------------

## store a string using quotation marks
x <- 'The quick brown fox jumps over the lazy dog.'
x

## store a number with leading zeros
x <- '00001'
x

## cannot add strings...
x + 1

## ...must convert back first
as.numeric(x) + 1

