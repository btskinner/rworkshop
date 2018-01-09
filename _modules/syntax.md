---
layout: module
title: Syntax
date: 2018-01-01 00:00:02
category: module 
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
    toc: true
    toc_depth: 2
links:
  scripts: syntax.R
---

R: language + environment
=========================

From CRAN, the Comprehensive R Network:

> R is a language and environment for statistical computing and
> graphics. It is a [GNU project](https://www.gnu.org) which is similar
> to the S language and environment which was developed at Bell
> Laboratories (formerly AT&T, now Lucent Technologies) by John Chambers
> and colleagues.
>
> \[…\]
>
> R provides a wide variety of statistical (linear and nonlinear
> modelling, classical statistical tests, time-series analysis,
> classification, clustering, …) and graphical techniques, and is highly
> extensible. [^1]

As a GNU project, R is open source and free ([as in
freedom](https://en.wikipedia.org/wiki/Gratis_versus_libre)) to use and
distribute. It can be installed and used on most major operating
systems.

Object oriented vs procedural programming
=========================================

Data types and structures
=========================

Types
-----

There are three primary data types in R that you will regularly use:  
- `logical`  
- `numeric` (`integer` & `double`)  
- `character`

### Logical

Logical vectors can be `TRUE`, `FALSE`, or `NA`. They can be assigned to
objects or returned by logical operators, which makes them useful for
control flow in loops and functions.

**NB** In R, you can shorten `TRUE` to `T` and `FALSE` to `F`, but both
the short and long versions must be capitalized.

``` r
## assignment
(x <- TRUE)
```

    ## [1] TRUE

``` r
## ! == NOT
!x
```

    ## [1] FALSE

``` r
## check
is.logical(x)
```

    ## [1] TRUE

``` r
## evaluate
1 + 1 == 2
```

    ## [1] TRUE

It’s useful to note that `1` evaluates to `TRUE` and `0` evaluates to
`FALSE`:

``` r
## 1 == TRUE
x <- 1
isTRUE(x)
```

    ## [1] FALSE

``` r
## 0 == FALSE
y <- 0
isTRUE(y)
```

    ## [1] FALSE

### Numeric: Integer and Double

Numeric values can be both **integers** and double precision floating
point values, or just **doubles**. R automatically converts between the
two data types for you, so knowing the difference between the two isn’t
really important for most analyses.

``` r
## use 'L' after digit to store as integer
x <- 1L
is.integer(x)
```

    ## [1] TRUE

``` r
## R stores as double by default
y <- 1
is.double(y)
```

    ## [1] TRUE

``` r
## both are numeric
is.numeric(x)
```

    ## [1] TRUE

``` r
is.numeric(y)
```

    ## [1] TRUE

### Character

Character values are stored as strings. Numeric values can also be
stored as strings (sometimes useful if you must store leading zeroes),
but they have to coverted back to numbers before you can perform numeric
operations on them.

``` r
## store a string using quotation marks
x <- 'The quick brown fox jumps over the lazy dog.'
x
```

    ## [1] "The quick brown fox jumps over the lazy dog."

``` r
## store a number with leading zeros
x <- '00001'
x
```

    ## [1] "00001"

``` r
## cannot add strings...
x + 1
```

    ## Error in x + 1: non-numeric argument to binary operator

``` r
## ...must convert back first
as.numeric(x) + 1
```

    ## [1] 2

Structures
----------

Building on these data types, R relies on four primary data structures:

-   `vector`
-   `matrix` (`array`)
-   `list`
-   `dataframe`

Packages
========

Other useful notes about R
==========================

-   1-indexed (indexes start at 1 instead of 0)
-   Can be run in batch mode from the terminal/command line
    -   older: `R CMD BATCH`
    -   newer: `Rscript`

Footnotes
---------

[^1]: <https://www.r-project.org/about.html>
