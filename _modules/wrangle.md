---
layout: module
title: Wrangling data
date: 2018-01-01 00:00:03
category: module
links:
  script: wrangle.R
  data: els_plans.csv
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
---

Being able to read, manipulate, and save data, that is, [wrangle
data](https://en.wikipedia.org/wiki/Data_wrangling), is a key part of
any analysis. In fact (as you’re probably already aware), building and
cleaning data usually takes more time and lines of code than the actual
analysis.

R has undergone a transformation in the past few years and this may
change how you choose to approach data wrangling. While the core R
functions for data manipulation haven’t really changed[^1], a new suite
of packages, the [tidyverse](https://www.tidyverse.org) (formerly known
as the “Hadleyverse” after their key creater, [Hadley
Wickham](http://hadley.nz)), has really changed the way many people
approach using R.

In this module, I’m going to show you two ways to perform the same set
of data wrangling procedures, first using base R and then the tidyverse
way. It’s up to you which you prefer. There’s much to be said for the
tidyverse, but I think it’s still good to know how to use core commands
for those edge cases (ever diminishing) where tidyverse functions don’t
quite work the way you want.

Data for this module come from the public release files of the [NCES
Education Longitudinal Study of
2002](https://nces.ed.gov/surveys/els2002/). For descriptions of the
variables, see the <a href = '{{ site.baseurl
}}/data/#els_planscsv'>codebook</a>.

Base R
======

First things first, let’s read in the data. Base R can `load()` its own
data formats, `.rda` and `.RData`, as well as read flat files like
`.txt`, `.csv`, and `.tsv` files. (We’ll discuss how to read in data
files from other languages later.) Since the data come in a CSV file, we
could use the special command `read.csv()`, but `read.table()` works
just as well as long as we tell R that items in each row are `sep`arated
by a `,`.

``` r
## read in the data, making sure that first line is read as column names
df <- read.table('../data/els_plans.csv', sep = ',', header = TRUE)
```

``` r
## show the first few rows (or view in RStudio's view)
head(df)
```

    ##   stu_id sch_id strat_id   psu f1sch_id  f1univ1              f1univ2a
    ## 1 101101   1011      101 psu 1     1011 byr f1ra base year participant
    ## 2 101102   1011      101 psu 1     1011 byr f1ra base year participant
    ## 3 101104   1011      101 psu 1     1011 byr f1ra base year participant
    ## 4 101105   1011      101 psu 1     1011 byr f1ra base year participant
    ## 5 101106   1011      101 psu 1     1011 byr f1ra base year participant
    ## 6 101107   1011      101 psu 1     1011 byr f1ra base year participant
    ##                 f1univ2b                g10cohrt             g12cohrt
    ## 1 in school, in grade 12 sophomore cohort member senior cohort member
    ## 2 in school, in grade 12 sophomore cohort member senior cohort member
    ## 3 in school, in grade 12 sophomore cohort member senior cohort member
    ## 4 in school, in grade 12 sophomore cohort member senior cohort member
    ## 5 in school, in grade 12 sophomore cohort member senior cohort member
    ## 6 in school, in grade 12 sophomore cohort member senior cohort member
    ##    bystuwt  bysex                                   byrace bydob_p
    ## 1 178.9513 female                 hispanic, race specified  198512
    ## 2  28.2951 female asian, hawaii/pac. islander,non-hispanic  198605
    ## 3 589.7248 female                      white, non-hispanic  198601
    ## 4 235.7822 female  black or african american, non-hispanic  198607
    ## 5 178.9513 female              hispanic, no race specified  198511
    ## 6 256.9656   male              hispanic, no race specified  198510
    ##                              bypared                           bymothed
    ## 1 attended college, no 4-year degree         did not finish high school
    ## 2 attended college, no 4-year degree attended college, no 4-year degree
    ## 3  graduated from high school or ged  graduated from high school or ged
    ## 4  graduated from high school or ged  graduated from high school or ged
    ## 5         did not finish high school         did not finish high school
    ## 6  graduated from high school or ged  graduated from high school or ged
    ##                             byfathed         byincome byses1 byses2
    ## 1 attended college, no 4-year degree  $50,001-$75,000  -0.25  -0.23
    ## 2 attended college, no 4-year degree $75,001-$100,000   0.58   0.69
    ## 3  graduated from high school or ged  $50,001-$75,000  -0.85  -0.68
    ## 4  graduated from high school or ged   $1,000 or less  -0.80  -0.89
    ## 5         did not finish high school  $15,001-$20,000  -1.41  -1.28
    ## 6         did not finish high school  $35,001-$50,000  -1.07  -0.93
    ##                                    bystexp bynels2m bynels2r    f1qwt
    ## 1 attend or complete 2-year college/school    47.84    39.04 152.9769
    ## 2 obtain phd, md, or other advanced degree    55.30    36.35  25.3577
    ## 3                             {don^t know}    66.24    42.68 709.4246
    ## 4                    graduate from college    35.33    27.86 199.7193
    ## 5                    graduate from college    29.97    13.07 152.9769
    ## 6 attend college, 4-year degree incomplete    24.28    11.70 205.2692
    ##    f1pnlwt                               f1psepln
    ## 1 155.6312 don^t know or planning but unspecified
    ## 2  25.4906        four-year college or university
    ## 3 725.6926        four-year college or university
    ## 4 205.1919             two-year community college
    ## 5 155.6312        four-year college or university
    ## 6 211.4690             two-year community college
    ##                                f2ps1sec
    ## 1 {Survey component legitimate skip/NA}
    ## 2               Public, 4-year or above
    ## 3               Public, 4-year or above
    ## 4                        Public, 2-year
    ## 5                        Public, 2-year
    ## 6             {Item legitimate skip/NA}

``` r
## show the column names
names(df)
```

    ##  [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "f1univ1" 
    ##  [7] "f1univ2a" "f1univ2b" "g10cohrt" "g12cohrt" "bystuwt"  "bysex"   
    ## [13] "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed" "byincome"
    ## [19] "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r" "f1qwt"   
    ## [25] "f1pnlwt"  "f1psepln" "f2ps1sec"

Tidyverse
=========

Magrittr and pipes
------------------

<span style="display:block;text-align:center">
![badge](https://www.rstudio.com/wp-content/uploads/2014/04/magrittr.png)
</span>

``` r
## library
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ## ✔ tibble  1.4.1     ✔ dplyr   0.7.4
    ## ✔ tidyr   0.7.2     ✔ stringr 1.2.0
    ## ✔ readr   1.1.1     ✔ forcats 0.2.0

    ## ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
## read in the data
df <- read_delim('../data/els_plans.csv', delim = ',')
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   stu_id = col_integer(),
    ##   sch_id = col_integer(),
    ##   strat_id = col_integer(),
    ##   f1sch_id = col_integer(),
    ##   bystuwt = col_double(),
    ##   bydob_p = col_integer(),
    ##   byses1 = col_double(),
    ##   byses2 = col_double(),
    ##   bynels2m = col_double(),
    ##   bynels2r = col_double(),
    ##   f1qwt = col_double(),
    ##   f1pnlwt = col_double()
    ## )

    ## See spec(...) for full column specifications.

Notes
=====

[^1]: Except maybe under the hood in a few cases.
