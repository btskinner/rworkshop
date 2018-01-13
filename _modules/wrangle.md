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

Data wrangling with base R
==========================

First things first, let’s read in the data. Base R can `load()` its own
data formats, `.rda` and `.RData`, as well as read flat files like
`.txt`, `.csv`, and `.tsv` files. (We’ll discuss how to read in data
files from other languages later.) Since the data come in a CSV file, we
could use the special command `read.csv()`, but `read.table()` works
just as well as long as we tell R that items in each row are `sep`arated
by a `,`. Finally, we won’t talk about factors until later, but let’s
read in the data keeping string values as character vectors.

``` r
## read in the data, making sure that first line is read as column names
df <- read.table('../data/els_plans.csv', sep = ',', header = TRUE,
                 stringsAsFactors = FALSE)
```

Let’s look at the first few rows and the variable names.

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

Access columns
--------------

Because the data frame lives in an object and not in memory (like it
does in Stata), you can’t just reference the variable name. Instead you
need to give R the data frame’s name followed by a `$` and then the
variable name.

You can also use the `df[['<var name>']]` contruction, which comes in
handy in loops and functions.

``` r
## wrong
summary(bynels2m)
```

    ## Error in summary(bynels2m): object 'bynels2m' not found

``` r
summary('bynels2m')
```

    ##    Length     Class      Mode 
    ##         1 character character

``` r
## correct
summary(df$bynels2m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   -8.00   34.34   45.46   44.44   55.76   79.27

``` r
summary(df[['bynels2m']])
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   -8.00   34.34   45.46   44.44   55.76   79.27

Add variables
-------------

Add a column by giving it a name and assigning what you want. R will
repeat the values as necessary to fill the number of rows. You can also
use data from other columns. R will assign values row by row, using the
right-hand side values that align.

``` r
## add simply column of ones
df$ones <- 1

## add average test score (bynels2r + bynels2m / 2)
df$avg_test <- (df$bynels2r + df$bynels2m) / 2

## check names
names(df)
```

    ##  [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "f1univ1" 
    ##  [7] "f1univ2a" "f1univ2b" "g10cohrt" "g12cohrt" "bystuwt"  "bysex"   
    ## [13] "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed" "byincome"
    ## [19] "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r" "f1qwt"   
    ## [25] "f1pnlwt"  "f1psepln" "f2ps1sec" "ones"     "avg_test"

Drop variables
--------------

Drop variables by assigning `NULL` to the column name.

``` r
## drop follow up one panel weight
df$f1pnlwt <- NULL

## check names
names(df)
```

    ##  [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "f1univ1" 
    ##  [7] "f1univ2a" "f1univ2b" "g10cohrt" "g12cohrt" "bystuwt"  "bysex"   
    ## [13] "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed" "byincome"
    ## [19] "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r" "f1qwt"   
    ## [25] "f1psepln" "f2ps1sec" "ones"     "avg_test"

Conditionally change values
---------------------------

This can be tricky at first. To conditionally change or assign values,
you need to tell R where the conditions apply. There are a couple of
ways.

The first way uses brackets, `[]`, after the variable name to set the
condition where the assignment is true. For version 1 below, the new
variable `female` is assigned a value of 1 in the rows where it is
`TRUE` that `bysex == 'female'`. In the rows that’s `FALSE`, R will
assign `NA` since there’s no information. We can backfill 0s in the
second line.

The other way is to use the `ifelse(test, yes, no)` function. Going row
by row, the `test` (`bysex == 'female'`) is performed. If `TRUE`, the
new variable gets a 1; if `FALSE`, it gets a 0.

``` r
## make a numeric column that == 1 if bysex is female, 0 otherwise
## v.1
df$female_v1[df$bysex == 'female'] <- 1
df$female_v1[df$bysex != 'female'] <- 0

## v.2
df$female_v2 <- ifelse(df$bysex == 'female', 1, 0)

## the same?
identical(df$female_v1, df$female_v2)
```

    ## [1] TRUE

> #### Quick exercise
>
> Create a new column called `ses_gender` that uses `byses1` for women
> and `byses2` for men. (HINT: if you use a condition, you need to use
> it on both sides of the arrow.)

Filter
------

You can also use brackets to conditionally drop rows, such as those with
missing values.

``` r
## assign as NA if < 0
df$bydob_p[df$bydob_p < 0] <- NA
nrow(df)
```

    ## [1] 16160

``` r
## drop if NA
df <- df[!is.na(df$bydob_p),]
nrow(df)
```

    ## [1] 15183

Order
-----

Sort the data frame using the `order()` function as a condition.

``` r
## show first few rows of student and base year math scores
df[1:10, c('stu_id','bydob_p')]
```

    ##    stu_id bydob_p
    ## 1  101101  198512
    ## 2  101102  198605
    ## 3  101104  198601
    ## 4  101105  198607
    ## 5  101106  198511
    ## 6  101107  198510
    ## 7  101108  198607
    ## 8  101109  198512
    ## 9  101110  198505
    ## 10 101111  198507

``` r
## since a data frame has two dims, notice the comma in the brackets
df <- df[order(df$bydob_p),]

## show again first few rows of ID and DOB
df[1:10, c('stu_id','bydob_p')]
```

    ##       stu_id bydob_p
    ## 1589  133211  198300
    ## 4286  195210  198300
    ## 4288  195213  198300
    ## 5578  225203  198300
    ## 7528  268219  198300
    ## 7532  268225  198300
    ## 7782  274222  198300
    ## 8055  280215  198300
    ## 10046 324119  198300
    ## 10203 327128  198300

Aggregate
---------

To collapse the data, generating some summary statistic in the process,
use the `aggregate(x, by, FUN)`, where `x` is the data frame, `by` is
the grouping variable in a `list()`, and `FUN` is the function that you
want to use. These can be base R functions or one you create yourself.
Let’s get the average math score within each school.

``` r
## first, make test score values < 0 == NA
df$bynels2m[df$bynels2m < 0] <- NA

## create new data frame
df_sch <- aggregate(df$bynels2r, by = list(df$sch_id), FUN = mean, na.rm = T)

## show
head(df_sch)
```

    ##   Group.1        x
    ## 1    1011 26.39290
    ## 2    1012 30.26733
    ## 3    1021 19.84647
    ## 4    1022 26.47903
    ## 5    1031 27.37318
    ## 6    1032 27.80214

Merge
-----

Since you can have multiple data frames in memory (as objects) at the
same time in R, you may not find yourself merging data sets as often you
would in another language (like Stata, where you have to). That said, it
still needs to happen. Use the `merge()` function. Let’s merge the
aggregated test score data back into the data set.

``` r
## first fix names from aggregated data set
names(df_sch) <- c('sch_id', 'sch_bynels2m')

## merge on school ID variable
df <- merge(df, df_sch, by = 'sch_id')

## show
head(df)
```

    ##   sch_id stu_id strat_id   psu f1sch_id  f1univ1              f1univ2a
    ## 1   1011 101126      101 psu 1     1011 byr f1ra base year participant
    ## 2   1011 101105      101 psu 1     1011 byr f1ra base year participant
    ## 3   1011 101106      101 psu 1     1011 byr f1ra base year participant
    ## 4   1011 101132      101 psu 1       -8 byr f1nr base year participant
    ## 5   1011 101116      101 psu 1     1011 byr f1ra base year participant
    ## 6   1011 101131      101 psu 1     1011 byr f1ra base year participant
    ##                          f1univ2b                g10cohrt
    ## 1          in school, in grade 12 sophomore cohort member
    ## 2          in school, in grade 12 sophomore cohort member
    ## 3          in school, in grade 12 sophomore cohort member
    ## 4 nonrespondent/f1 status unknown sophomore cohort member
    ## 5          in school, in grade 12 sophomore cohort member
    ## 6          in school, in grade 12 sophomore cohort member
    ##                   g12cohrt  bystuwt  bysex
    ## 1     senior cohort member  28.2951 female
    ## 2     senior cohort member 235.7822 female
    ## 3     senior cohort member 178.9513 female
    ## 4 not senior cohort member 192.4304   male
    ## 5     senior cohort member  30.2245   male
    ## 6     senior cohort member 620.1837   male
    ##                                     byrace bydob_p
    ## 1 asian, hawaii/pac. islander,non-hispanic  198410
    ## 2  black or african american, non-hispanic  198607
    ## 3              hispanic, no race specified  198511
    ## 4              hispanic, no race specified  198611
    ## 5 asian, hawaii/pac. islander,non-hispanic  198612
    ## 6                      white, non-hispanic  198610
    ##                                   bypared
    ## 1              did not finish high school
    ## 2       graduated from high school or ged
    ## 3              did not finish high school
    ## 4       graduated from high school or ged
    ## 5 completed master^s degree or equivalent
    ## 6            graduated from 2-year school
    ##                                  bymothed
    ## 1              did not finish high school
    ## 2       graduated from high school or ged
    ## 3              did not finish high school
    ## 4       graduated from high school or ged
    ## 5 completed master^s degree or equivalent
    ## 6       attended 2-year school, no degree
    ##                            byfathed          byincome byses1 byses2
    ## 1        did not finish high school   $25,001-$35,000  -0.64  -0.67
    ## 2 graduated from high school or ged    $1,000 or less  -0.80  -0.89
    ## 3        did not finish high school   $15,001-$20,000  -1.41  -1.28
    ## 4 graduated from high school or ged   $50,001-$75,000  -0.16  -0.24
    ## 5 attended 2-year school, no degree $100,001-$200,000   0.99   0.88
    ## 6      graduated from 2-year school   $35,001-$50,000   0.48   0.67
    ##                                    bystexp bynels2m bynels2r    f1qwt
    ## 1 obtain phd, md, or other advanced degree    66.73    16.65  25.3577
    ## 2                    graduate from college    35.33    27.86 199.7193
    ## 3                    graduate from college    29.97    13.07 152.9769
    ## 4                    graduate from college    41.28    17.34   0.0000
    ## 5 obtain phd, md, or other advanced degree    69.08    45.74  26.0130
    ## 6                    graduate from college    57.19    28.60 736.6029
    ##                          f1psepln                                f2ps1sec
    ## 1 four-year college or university                          Public, 2-year
    ## 2      two-year community college                          Public, 2-year
    ## 3 four-year college or university                          Public, 2-year
    ## 4                 {nonrespondent}               {Item legitimate skip/NA}
    ## 5 four-year college or university Private not-for-profit, 4-year or above
    ## 6      two-year community college                          Public, 2-year
    ##   ones avg_test female_v1 female_v2 sch_bynels2m
    ## 1    1   41.690         1         1      26.3929
    ## 2    1   31.595         1         1      26.3929
    ## 3    1   21.520         1         1      26.3929
    ## 4    1   29.310         0         0      26.3929
    ## 5    1   57.410         0         0      26.3929
    ## 6    1   42.895         0         0      26.3929

Write
-----

Finally we can write our new data set to disk. We can save it as an R
data file type, but since we may want to share with non-R users, we’ll
save it as a csv file again.

``` r
write.csv(df, '../data/els_plans_mod.csv', row.names = FALSE)
```

Tidyverse
=========

The tidyverse is a shorthand for a [number of
packages](https://www.tidyverse.org/packages/) that work well together
and can be used in place of base R functions. A few of the tidyverse
packages that you will often use are:

-   [dplyr](http://dplyr.tidyverse.org) for data manipulation  
-   [tidyr](http://tidyr.tidyverse.org) for making data
    [tidy](http://vita.had.co.nz/papers/tidy-data.html)  
-   [readr](http://readr.tidyverse.org) for flat file I/O  
-   [readxl](http://readxl.tidyverse.org) for Excel file I/O  
-   [haven](http://haven.tidyverse.org) for other file format I/O  
-   [ggplot2](http://ggplot2.tidyverse.org) for making graphics

There are many others. A lot of R users find functions from these
libraries to be more intuitive than base R functions. In some cases,
tidyverse functions are faster than base R, which is an added benefit
when working with large data sets.

Magrittr and pipes
------------------

The key feature of the tidyverse is its use of pipes, `%>%`, from the
[magrittr package](http://magrittr.tidyverse.org).

<span style="display:block;text-align:center">
[![badge](https://www.rstudio.com/wp-content/uploads/2014/04/magrittr.png)](https://www.fine-arts-museum.be/uploads/exhibitions/images/magritte_la_trahison_des_images_large@2x.jpg)
</span>

Pipes take values/output from the left side and pipe it to the input of
the right side. So `sum(x)` can be rewritten as `x %>% sum`. This is a
silly example (why would you do that?), but pipes are powerful because
they can be chained together. Nested layers of functions that would be
difficult to read from the inside out can be made clearer. Let’s see the
now canonical example from
[Hadley](https://twitter.com/_inundata/status/557980236130689024) to
make it clearer:

``` r
## foo_foo is an instance of a little bunny
foo_foo <- little_bunny()

## adventures in base R
bop_on(
    scoop_up(
        hop_through(foo_foo, forest),
        field_mouse
    ),
    head
)

## adventures w/ pipes
foo_foo %>%
    hop_through(forest) %>%
    scoop_up(field_mouse) %>%
    bop_on(head)
```

Data wrangling with tidyverse
=============================

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

Let’s reread the original data. Like `read.table()`, `read_delim()` is
the generic function that needs you to give it the separating/delimiting
character. You could also just use `read_csv()`.

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

Mutate
------

To add variables and change existing ones, use the `mutate()`.

Note that with this (and the following) tidyverse functions, you don’t
need to use the data frame name with the dollar sign construction and
you don’t need to put quotation marks around the column names.

``` r
## assign values inside function using = sign (not <-)
df <- df %>% mutate(ones = 1,
                    avg_test = (bynels2r + bynels2m) / 2) # ignore neg vals
```

To conditionally mutate variables, use the `ifelse()` construction
inside the `mutate()` function.

``` r
## (1) make a numeric column that == 1 if bysex is female, 0 otherwise
## (2) assign DOB an NA if < 0
df <- df %>%
    mutate(female = ifelse(bysex == 'female', 1, 0),
           bydob_p = ifelse(bydob_p < 0, NA, bydob_p))           
```

Select
------

To choose variables, either when making a new data frame or dropping
them, use `select()`. To drop them, use a negative sign (`-`) in front
of the variable name.

``` r
## drop follow up one panel weight
df <- df %>% select(-f1pnlwt)

## check names
names(df)
```

    ##  [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "f1univ1" 
    ##  [7] "f1univ2a" "f1univ2b" "g10cohrt" "g12cohrt" "bystuwt"  "bysex"   
    ## [13] "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed" "byincome"
    ## [19] "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r" "f1qwt"   
    ## [25] "f1psepln" "f2ps1sec" "ones"     "avg_test" "female"

Filter
------

Like `select()` works on columns, `filter()` can be used to subset based
on row conditions. Earlier we properly labeled `bydob_p` values less
than zero as `NA`. Let’s drop those.

``` r
## show number of rows
nrow(df)
```

    ## [1] 16160

``` r
## keep if not (!) missing
df <- df %>% filter(!is.na(bydob_p))
nrow(df)
```

    ## [1] 15183

Arrange
-------

Sort values using the `arrange()` function.

``` r
## show first few rows of student and base year math scores (tidyverse way)
df %>% select(stu_id, bydob_p) %>% head(10)
```

    ## # A tibble: 10 x 2
    ##    stu_id bydob_p
    ##     <int>   <int>
    ##  1 101101  198512
    ##  2 101102  198605
    ##  3 101104  198601
    ##  4 101105  198607
    ##  5 101106  198511
    ##  6 101107  198510
    ##  7 101108  198607
    ##  8 101109  198512
    ##  9 101110  198505
    ## 10 101111  198507

``` r
## arrange
df <- df %>% arrange(bydob_p)

## show again first few rows of ID and DOB
df %>% select(stu_id, bydob_p) %>% head(10)
```

    ## # A tibble: 10 x 2
    ##    stu_id bydob_p
    ##     <int>   <int>
    ##  1 133211  198300
    ##  2 195210  198300
    ##  3 195213  198300
    ##  4 225203  198300
    ##  5 268219  198300
    ##  6 268225  198300
    ##  7 274222  198300
    ##  8 280215  198300
    ##  9 324119  198300
    ## 10 327128  198300

Summarize
---------

Aggregate data using the `summarise()` or `summarize()` function
(they’re the same, just playing nice with by offering both spellings).
Unlike the `aggregate()` function, you first need to set the grouping
variable using the `group_by()` function. Since we need to replace
negative values before we summarize, we’ll chain a few functions
together into one command.

``` r
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
```

    ## # A tibble: 751 x 2
    ##    sch_id sch_bynels2m
    ##     <int>        <dbl>
    ##  1   1011         45.3
    ##  2   1012         43.3
    ##  3   1021         28.9
    ##  4   1022         38.6
    ##  5   1031         40.0
    ##  6   1032         35.3
    ##  7   1033         42.2
    ##  8   1041         44.9
    ##  9   1042         52.2
    ## 10   1051         45.9
    ## # ... with 741 more rows

Join
----

Rather than saying “merge,” dplyr uses the SQL language of joins:

-   `left_join(x, y)`: keep all x, drop unmatched y
-   `right_join(x, y)`: keep all y, drop unmatched x
-   `inner_join(x, y)`: keep only matching
-   `outer_join(x, y)`: keep everything

Since we want to join a smaller aggregated data frame to the original
data frame, we’ll use a `left_join()`. The join functions will try to
guess the joining variable (and tell you what it picked) if you don’t
supply one, but we’ll specify one to be clear.

``` r
## join on school ID variable
df <- df %>% left_join(df_sch, by = 'sch_id')
```

Write
-----

The readr library can also write delimited flat files. Instead of
`write_delim()`, we’ll use the wrapper function `write_csv()` to save a
csv file.

``` r
write_csv(df, '../data/els_plans_mod_tv.csv')
```

Reshaping data
==============

Reshaping data is a common data wrangling task. Whether going from wide
to long format or the reverse, this can be a painful process. The best
way I know to reshape data in R is by using the **tidyr** library.

Create toy data
---------------

For clarity, we’ll use toy data for this example. It will be wide to
start.

``` r
df <- data.frame(schid = c('A','B','C','D'),
                 year = 2013,
                 var_x = 1:4,
                 var_y = 5:8,
                 var_z = 9:12,
                 stringsAsFactors = FALSE) %>%
    tbl_df()

## show
df
```

    ## # A tibble: 4 x 5
    ##   schid  year var_x var_y var_z
    ##   <chr> <dbl> <int> <int> <int>
    ## 1 A      2013     1     5     9
    ## 2 B      2013     2     6    10
    ## 3 C      2013     3     7    11
    ## 4 D      2013     4     8    12

Wide –\> long
-------------

To go from wide to long format, use the `gather(key, value)` function,
where the `key` is the variable that will made long (the stub in Stata)
and the `value` is the column of associated values that will be created.
Since we want the **schid** and **year** columns to remain associated
with their rows, we ignore them (`-c(...)`) so they will be repeated as
necessary.

The `mutate()` row isn’t strictly necessary, but it does make the output
a little cleaner since we really don’t need the `var_` stub once the
data are in long form. The
`gsub('<old string>', '<new string>', variable)` function simply
replaces the `'<old string>'` with the `'<new string>'` wherever it
finds in the `variable`.

Finally we `arrange()` the data by school ID and the variable name.

``` r
df_long <- df %>%
    gather(var, value, -c(schid, year)) %>%
    mutate(var = gsub('var_', '', var)) %>%
    arrange(schid, var)

## show
df_long
```

    ## # A tibble: 12 x 4
    ##    schid  year var   value
    ##    <chr> <dbl> <chr> <int>
    ##  1 A      2013 x         1
    ##  2 A      2013 y         5
    ##  3 A      2013 z         9
    ##  4 B      2013 x         2
    ##  5 B      2013 y         6
    ##  6 B      2013 z        10
    ##  7 C      2013 x         3
    ##  8 C      2013 y         7
    ##  9 C      2013 z        11
    ## 10 D      2013 x         4
    ## 11 D      2013 y         8
    ## 12 D      2013 z        12

Long –\> wide
-------------

To go in the opposite direction, use the `spread(var, value)` function,
which makes columns for every unique `var` and assigns the `value` that
was in the `var`s row. Unlike `gather()`, we don’t have explicily say to
ignore columns that want to ignore.

Because we were clever before and dropped the stub from the variable
name, the `mutate()` function uses `gsub()` with a [regular
expression](https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html)
to add the stub back.

``` r
df_wide <- df_long %>%
    mutate(var = gsub('(.*)', 'var_\\1', var)) %>%
    spread(var, value) %>%
    arrange(schid)

## show
df_wide
```

    ## # A tibble: 4 x 5
    ##   schid  year var_x var_y var_z
    ##   <chr> <dbl> <int> <int> <int>
    ## 1 A      2013     1     5     9
    ## 2 B      2013     2     6    10
    ## 3 C      2013     3     7    11
    ## 4 D      2013     4     8    12

In theory, our new `df_wide` data frame should be the same as the one we
started with. Let’s check:

``` r
## confirm that df_wide == df
identical(df, df_wide)
```

    ## [1] TRUE

Success!

Notes
=====

[^1]: Except maybe under the hood in a few cases.
