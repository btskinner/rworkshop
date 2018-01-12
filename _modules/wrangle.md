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

``` r
## reading in data
df <- read.table('../data/els_plans.csv', sep = ',', header = TRUE)

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

For descriptions of the variables, see the
<a href = '{{ site.baseurl }}/data/#els_planscsv'>codebook</a>.
