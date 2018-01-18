---
layout: module
title: Exploratory data analysis I
date: 2018-01-01 00:00:05
category: module
links: 
  script: eda_one.R
  data: els_plans.dta
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
always_allow_html: yes
---

This module takes the first steps in more formally exploring a data set.
Because building and cleaning a data set is often an iterative process,
especially in the early stages of a project, some of the techniques
below could still be considered part of data wrangling.

Using data from another program
===============================

Doing data analysis often means working in teams, which, in turn, can
mean working with a variety of programs and file types. When you need to
use data that aren’t flat files (those ending in `*.txt`, `*.csv`, or
`*.tsv`, for example) or in an R format, you can use one of the
following libraries:

-   [readxl](http://readxl.tidyverse.org)
    -   Excel: `read_excel()`
-   [haven](http://haven.tidyverse.org/reference/index.html)
    -   Stata: `read_dta()`, `write_dta()`
    -   SAS: `read_sas()`, `write_sas()`
    -   SPSS: `read_sav()`, `write_sav()`

For practice, we’ll use the same ELS plans data set as before, but this
time stored in a Stata `*.dta` file.

One benefit of Stata and other stats programs like SAS is that you can
label variable and values. Base R data frames don’t support labels, but
tibbles (`tbl_df()`) in the tidyverse do. By default, the `read_dta()`
function we’ll use puts the data in tibble. So that we can access the
variable and value labels that were saved in the `*dta` file, we’ll also
load the `labelled` library.

``` r
## libraries: tidyverse + haven and labelled
library(tidyverse)
library(haven)
library(labelled)
```

``` r
## read in Stata dta file
df <- read_dta('../data/els_plans.dta')
```

Labels
------

First, let’s take a quick bird’s eye view of our data. In RStudio, you
can use the `View()` command or just click on the data object in the
**Environment** window. You can see the variable labels under the
variable names in the view.

You can also use the `glimpse()` function to see a nicely formatted
glimpse of the data

``` r
## use glipse
glimpse(df)
```

    ## Observations: 16,160
    ## Variables: 22
    ## $ stu_id   <dbl> 101101, 101102, 101104, 101105, 101106, 101107, 10110...
    ## $ sch_id   <dbl> 1011, 1011, 1011, 1011, 1011, 1011, 1011, 1011, 1011,...
    ## $ strat_id <dbl> 101, 101, 101, 101, 101, 101, 101, 101, 101, 101, 101...
    ## $ psu      <dbl+lbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
    ## $ f1sch_id <dbl> 1011, 1011, 1011, 1011, 1011, 1011, 1011, NA, NA, 101...
    ## $ bystuwt  <dbl> 178.9513, 28.2951, 589.7248, 235.7822, 178.9513, 256....
    ## $ bysex    <dbl+lbl> 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 2...
    ## $ byrace   <dbl+lbl> 5, 2, 7, 3, 4, 4, 4, 7, 4, 3, 3, 4, 3, 2, 2, 3, 3...
    ## $ bydob_p  <dbl> 198512, 198605, 198601, 198607, 198511, 198510, 19860...
    ## $ bypared  <dbl+lbl> 5, 5, 2, 2, 1, 2, 6, 2, 2, 1, 6, 4, 4, 2, 7, 2, 7...
    ## $ bymothed <dbl+lbl> 1, 5, 2, 2, 1, 2, 6, 2, 2, 1, 6, 4, 3, 2, 7, 2, 2...
    ## $ byfathed <dbl+lbl> 5, 5, 2, 2, 1, 1, 3, 2, 1, 1, 4, 2, 4, 2, 3, 2, 7...
    ## $ byincome <dbl+lbl> 10, 11, 10, 2, 6, 9, 10, 10, 8, 3, 8, 8, 5, 8, 12...
    ## $ byses1   <dbl> -0.25, 0.58, -0.85, -0.80, -1.41, -1.07, 0.27, -0.16,...
    ## $ byses2   <dbl> -0.23, 0.69, -0.68, -0.89, -1.28, -0.93, 0.36, -0.24,...
    ## $ bystexp  <dbl+lbl> 3, 7, -1, 5, 5, 4, -1, 6, 7, 6, -1, 6, 6, -1, 7, ...
    ## $ bynels2m <dbl> 47.84, 55.30, 66.24, 35.33, 29.97, 24.28, 45.16, 66.0...
    ## $ bynels2r <dbl> 39.04, 36.35, 42.68, 27.86, 13.07, 11.70, 19.66, 45.3...
    ## $ f1qwt    <dbl> 152.9769, 25.3577, 709.4246, 199.7193, 152.9769, 205....
    ## $ f1pnlwt  <dbl> 155.6312, 25.4906, 725.6926, 205.1919, 155.6312, 211....
    ## $ f1psepln <dbl+lbl> 2, 5, 5, 4, 5, 4, 4, NA, NA, 5, 5, 5, 4, 5, 5, 4,...
    ## $ f2ps1sec <dbl+lbl> NA, 1, 1, 4, 4, NA, 4, 2, NA, 4, 1, NA, NA, 4, 2,...

The `glimpse()` function doesn’t show the labels, but it does let you
know that columns like `bysex` have them with the `<dbl+lbl>` tag.

To see the variable labels, use the `var_label()` function from the
**labelled** library.

``` r
## show the labels for just a few variables
df %>%
    select(stu_id, bysex, bypared, bynels2m) %>%
    var_label()
```

    ## $stu_id
    ## [1] "student id"
    ## 
    ## $bysex
    ## [1] "sex-composite"
    ## 
    ## $bypared
    ## [1] "parents^ highest level of education"
    ## 
    ## $bynels2m
    ## [1] "els-nels 1992 scale equated sophomore math score"

Unfortunately, the label for the `bysex` column doesn’t really tell us
anything that we probably didn’t already guess. The problem with the
name and label is that it is ambiguous. So are the values:

``` r
## who first few rows of bysex
df %>% select(bysex)
```

    ## # A tibble: 16,160 x 1
    ##    bysex    
    ##    <dbl+lbl>
    ##  1 2        
    ##  2 2        
    ##  3 2        
    ##  4 2        
    ##  5 2        
    ##  6 1        
    ##  7 1        
    ##  8 1        
    ##  9 1        
    ## 10 1        
    ## # ... with 16,150 more rows

What does having a value of 1 or 2 mean? Use the `val_labels()` function
to see.

``` r
## see value labels for bysex
df %>% select(bysex) %>% val_labels()
```

    ## $bysex
    ## {survey component legitimate skip/na} 
    ##                                    -8 
    ##                       {nonrespondent} 
    ##                                    -4 
    ##                                  male 
    ##                                     1 
    ##                                female 
    ##                                     2

Ok. In this data set, male students are coded as 1 and female students
are coded as 2.

> #### Quick exercise
>
> Use the `var_label()` and `val_labels()` functions to inspect another
> variable with labels.

It turns out that the `head()` function (which works with regular data
frames and vectors) will also give the value labels if it’s given a
tibble.

``` r
## show more information about bysex variable
head(df$bysex)
```

    ## <Labelled double>
    ## [1] 2 2 2 2 2 1
    ## 
    ## Labels:
    ##  value                                 label
    ##     -8 {survey component legitimate skip/na}
    ##     -4                       {nonrespondent}
    ##      1                                  male
    ##      2                                female

Moving forward, it probably will be clearer if we generate a new
indicator variable. For example, we could create the variable `female`
that equals one if `bysex` is 2 and 0 otherwise.

``` r
## create an indicator variable for female
df <- df %>%
    mutate(female = ifelse(bysex == 2, 1, 0))
```

> #### Quick exercise
>
> Whoops! Our new indicator variable isn’t quite right because it
> doesn’t account for missing values. Redo the last command so that
> `female == 1` when `bysex == 2`, `female == 0` when `bysex == 1` and
> `female == NA` when `bysex` is missing. (HINT: in R, use `is.na(<x>)`
> to check whether a value is missing.)

Summary statistics
==================

Continuous values
-----------------

We can get the mean and standard deviation of continuous variables using
the `mean()` and `sd()` functions…

``` r
## get mean and sd
mean(df$bynels2m)
```

    ## [1] NA

``` r
sd(df$bynels2m)
```

    ## [1] NA

…except that `bynels2m` has missing values and R doesn’t automatically
drop those when calculating those statistics. It can be a little
annoying at first, but really it’s a nice feature because it lets you
know that your data aren’t complete.

To ignore `NA`s, set the `na.rm` to `TRUE`.

``` r
## need to tell R to remove NAs
mean(df$bynels2m, na.rm = TRUE)
```

    ## [1] 45.35452

``` r
sd(df$bynels2m, na.rm = TRUE)
```

    ## [1] 13.53664

> #### Quick exercise
>
> Find the mean and standard deviation of reading scores.

You can also compute summary statistics using dplyr and the
`summarise_all()`, `summarise_at()`, and `summarise_if()` functions.
Since we want to focus on one variable, we’ll use the `summarise_at()`
function. (More information about the other commands can be found
[here](http://dplyr.tidyverse.org/reference/summarise_all.html).)

``` r
## mean and sd using dplyr
df %>%
    summarise_at(.vars = vars(bynels2m),
                 .funs = funs(mean, sd, .args = list(na.rm = TRUE)))
```

    ## # A tibble: 1 x 2
    ##    mean    sd
    ##   <dbl> <dbl>
    ## 1  45.4  13.5

> #### Quick exercise
>
> Modify the above code to summarize reading scores at the same time.

Discrete values
---------------

Use the `table()` function for discrete variables. Because we know or
maybe suspect that there are missing values, we add the `useNA` argument
with the argument `'ifany'`.

``` r
## table of parental education levels
table(df$bypared, useNA='ifany')
```

    ## 
    ##    1    2    3    4    5    6    7    8 <NA> 
    ##  942 3044 1663 1597 1758 3466 1785 1049  856

Unfortunately, these numbers don’t mean much without reference to a
codebook. However, because are data are labelled, we can use the
`as_factor()` function to see the labels.

``` r
## use as_factor() to get the value labels
table(as_factor(df$bypared), useNA='ifany')
```

    ## 
    ##                                {missing} 
    ##                                        0 
    ##    {survey component legitimate skip/na} 
    ##                                        0 
    ##                          {nonrespondent} 
    ##                                        0 
    ##               did not finish high school 
    ##                                      942 
    ##        graduated from high school or ged 
    ##                                     3044 
    ##        attended 2-year school, no degree 
    ##                                     1663 
    ##             graduated from 2-year school 
    ##                                     1597 
    ##       attended college, no 4-year degree 
    ##                                     1758 
    ##                   graduated from college 
    ##                                     3466 
    ##  completed master^s degree or equivalent 
    ##                                     1785 
    ## completed phd, md, other advanced degree 
    ##                                     1049 
    ##                                     <NA> 
    ##                                      856

Now we can see what the numbers represent. Why aren’t there any counts
for the three missing labels, the ones with braces, while there are a
number of `NA` values? Checking how the labels are assigned using the
`val_labels()` function…

``` r
## check how bypared labels are assigned
val_labels(df$bypared)
```

    ##                                {missing} 
    ##                                       -9 
    ##    {survey component legitimate skip/na} 
    ##                                       -8 
    ##                          {nonrespondent} 
    ##                                       -4 
    ##               did not finish high school 
    ##                                        1 
    ##        graduated from high school or ged 
    ##                                        2 
    ##        attended 2-year school, no degree 
    ##                                        3 
    ##             graduated from 2-year school 
    ##                                        4 
    ##       attended college, no 4-year degree 
    ##                                        5 
    ##                   graduated from college 
    ##                                        6 
    ##  completed master^s degree or equivalent 
    ##                                        7 
    ## completed phd, md, other advanced degree 
    ##                                        8

…confirms that when the original data values indicating missingness were
changed from negative numbers to `.` in Stata, the labels no longer
applied. At the moment, we don’t care why the values are missing, but if
we did, would have to find the original Stata data set that retained the
negative values.

> #### Quick exercise
>
> Get counts for base year income levels.

To generate counts using dplyr, use the `count()` function. By chaining
`as_factor()` to the end of the call, we can get the counts with
associated labels.

``` r
## using dplyr to make a table
df %>%
    count(bypared) %>%
    as_factor()
```

    ## # A tibble: 9 x 2
    ##   bypared                                      n
    ##   <fct>                                    <int>
    ## 1 did not finish high school                 942
    ## 2 graduated from high school or ged         3044
    ## 3 attended 2-year school, no degree         1663
    ## 4 graduated from 2-year school              1597
    ## 5 attended college, no 4-year degree        1758
    ## 6 graduated from college                    3466
    ## 7 completed master^s degree or equivalent   1785
    ## 8 completed phd, md, other advanced degree  1049
    ## 9 <NA>                                       856

> #### Quick exercise
>
> Get counts for base year income levels again, this time using the
> dplyr method. What do you see if you drop `as_factor()` from the end?

Two-way table
-------------

Cross tabulations are also useful. With the `table()` function, instead
of doing just `table(x)`, do `table(x, y)`.

``` r
## table of parental education levels
table(as_factor(df$bypared), as_factor(df$bysex))
```

    ##                                           
    ##                                            {survey component legitimate skip/na}
    ##   {missing}                                                                    0
    ##   {survey component legitimate skip/na}                                        0
    ##   {nonrespondent}                                                              0
    ##   did not finish high school                                                   0
    ##   graduated from high school or ged                                            0
    ##   attended 2-year school, no degree                                            0
    ##   graduated from 2-year school                                                 0
    ##   attended college, no 4-year degree                                           0
    ##   graduated from college                                                       0
    ##   completed master^s degree or equivalent                                      0
    ##   completed phd, md, other advanced degree                                     0
    ##                                           
    ##                                            {nonrespondent} male female
    ##   {missing}                                              0    0      0
    ##   {survey component legitimate skip/na}                  0    0      0
    ##   {nonrespondent}                                        0    0      0
    ##   did not finish high school                             0  440    502
    ##   graduated from high school or ged                      0 1496   1548
    ##   attended 2-year school, no degree                      0  823    840
    ##   graduated from 2-year school                           0  849    748
    ##   attended college, no 4-year degree                     0  859    899
    ##   graduated from college                                 0 1737   1729
    ##   completed master^s degree or equivalent                0  911    874
    ##   completed phd, md, other advanced degree               0  503    546

> #### Quick exercise
>
> What happens when you switch the order of the variables in the
> `table()` function (*i.e.*, `table(y, x)` instead of `table(x, y)`?

To make a cross table with dplyr, use `group_by()` before `count()` to
generate counts within groups.

``` r
## use the group_by() and count() functions to make two-way table
df %>%
    group_by(bysex) %>%
    count(bypared) %>%
    as_factor()
```

    ## # A tibble: 19 x 3
    ## # Groups: bysex [3]
    ##    bysex  bypared                                      n
    ##    <fct>  <fct>                                    <int>
    ##  1 male   did not finish high school                 440
    ##  2 male   graduated from high school or ged         1496
    ##  3 male   attended 2-year school, no degree          823
    ##  4 male   graduated from 2-year school               849
    ##  5 male   attended college, no 4-year degree         859
    ##  6 male   graduated from college                    1737
    ##  7 male   completed master^s degree or equivalent    911
    ##  8 male   completed phd, md, other advanced degree   503
    ##  9 male   <NA>                                        21
    ## 10 female did not finish high school                 502
    ## 11 female graduated from high school or ged         1548
    ## 12 female attended 2-year school, no degree          840
    ## 13 female graduated from 2-year school               748
    ## 14 female attended college, no 4-year degree         899
    ## 15 female graduated from college                    1729
    ## 16 female completed master^s degree or equivalent    874
    ## 17 female completed phd, md, other advanced degree   546
    ## 18 female <NA>                                        16
    ## 19 <NA>   <NA>                                       819

To make the dplyr table look more like the table made with base R, use
the `spread()` function from tidyr.

``` r
## spread to look like other table
df %>%
    group_by(bysex) %>%
    count(bypared) %>%
    as_factor() %>%
    spread(bysex, n)
```

    ## # A tibble: 9 x 4
    ##   bypared                                   male female `<NA>`
    ## * <fct>                                    <int>  <int>  <int>
    ## 1 did not finish high school                 440    502     NA
    ## 2 graduated from high school or ged         1496   1548     NA
    ## 3 attended 2-year school, no degree          823    840     NA
    ## 4 graduated from 2-year school               849    748     NA
    ## 5 attended college, no 4-year degree         859    899     NA
    ## 6 graduated from college                    1737   1729     NA
    ## 7 completed master^s degree or equivalent    911    874     NA
    ## 8 completed phd, md, other advanced degree   503    546     NA
    ## 9 <NA>                                        21     16    819

> #### Quick exercise
>
> The last table has an ugly `<NA>` column as well as an `NA` row in the
> `bypared` column. Can you modify the last function chain to remove
> those?

Conditional mean
================

Aside from crosstabs, finding averages of continuous variables within
groups or conditional means is a common task. We’ve already done this in
the last couple of modules. With base R, use the `aggregate()` function
to compute summary statistics of continuous values by group.

``` r
## get average math score by parental education 
aggregate(df$bynels2m, by = list(df$bypared), mean, na.rm = TRUE)
```

    ##   Group.1        x
    ## 1       1 36.29864
    ## 2       2 40.52292
    ## 3       3 42.57740
    ## 4       4 44.45236
    ## 5       5 44.65419
    ## 6       6 48.50667
    ## 7       7 51.99566
    ## 8       8 52.88417

> #### Quick exercise
>
> Is there a way to modify the code above to use the parental education
> levels instead of just the number in the above tables?

Adding a secondary group is not difficult. Just add another variable to
the `by` list:

``` r
df <- df %>%
    mutate(lowinc = ifelse(byincome <= 7, 1, 0))

## get average math score by low income status and parental education levels
aggregate(df$bynels2m, by = list(df$lowinc, df$bypared), mean, na.rm = TRUE)
```

    ##    Group.1 Group.2        x
    ## 1        0       1 36.74020
    ## 2        1       1 35.88120
    ## 3        0       2 42.09193
    ## 4        1       2 37.64148
    ## 5        0       3 44.01492
    ## 6        1       3 38.03843
    ## 7        0       4 45.79327
    ## 8        1       4 39.06331
    ## 9        0       5 46.01975
    ## 10       1       5 38.93340
    ## 11       0       6 49.33081
    ## 12       1       6 41.50602
    ## 13       0       7 52.82858
    ## 14       1       7 41.42392
    ## 15       0       8 54.15734
    ## 16       1       8 38.45988

The dplyr way of computing a conditional mean is clearer in some ways
and a little more confusing in others. On one hand, using the
`group_by()` function makes it very clear which is the grouping
variable. On the other hand, the `summarise_at()` function is a bit more
involved. The main thing to remember is that (like with the base R
`aggregate()` function above), you need to pass the `na.rm = TRUE`
argument to the `mean` function. Otherwise, R won’t know what to do with
the missing values and will return `NA`.

``` r
## using dplyr to get average math score by parental education level
df %>%
    group_by(bypared) %>%
    summarise_at(.vars = vars(bynels2m),
                 .funs = funs(mean, .args = list(na.rm = TRUE))) %>%
    as_factor()
```

    ## # A tibble: 9 x 2
    ##   bypared                                  bynels2m
    ##   <fct>                                       <dbl>
    ## 1 did not finish high school                   36.3
    ## 2 graduated from high school or ged            40.5
    ## 3 attended 2-year school, no degree            42.6
    ## 4 graduated from 2-year school                 44.5
    ## 5 attended college, no 4-year degree           44.7
    ## 6 graduated from college                       48.5
    ## 7 completed master^s degree or equivalent      52.0
    ## 8 completed phd, md, other advanced degree     52.9
    ## 9 <NA>                                         44.8

Once you’ve got the format, finding the conditional mean within a cross
tabulation (group 1 X group 2) is straightforward: just add the variable
to the `group_by()` function.

``` r
## using dplyr to get average math score by income and parental education level
df %>%
    group_by(bypared, lowinc) %>%
    summarise_at(vars(bynels2m),
                 funs(mean, .args = list(na.rm = TRUE))) %>%
    as_factor()
```

    ## # A tibble: 18 x 3
    ## # Groups: bypared [?]
    ##    bypared                                  lowinc bynels2m
    ##    <fct>                                     <dbl>    <dbl>
    ##  1 did not finish high school                 0        36.7
    ##  2 did not finish high school                 1.00     35.9
    ##  3 graduated from high school or ged          0        42.1
    ##  4 graduated from high school or ged          1.00     37.6
    ##  5 attended 2-year school, no degree          0        44.0
    ##  6 attended 2-year school, no degree          1.00     38.0
    ##  7 graduated from 2-year school               0        45.8
    ##  8 graduated from 2-year school               1.00     39.1
    ##  9 attended college, no 4-year degree         0        46.0
    ## 10 attended college, no 4-year degree         1.00     38.9
    ## 11 graduated from college                     0        49.3
    ## 12 graduated from college                     1.00     41.5
    ## 13 completed master^s degree or equivalent    0        52.8
    ## 14 completed master^s degree or equivalent    1.00     41.4
    ## 15 completed phd, md, other advanced degree   0        54.2
    ## 16 completed phd, md, other advanced degree   1.00     38.5
    ## 17 <NA>                                       0        46.2
    ## 18 <NA>                                       1.00     39.3

> #### Quick exercise
>
> Modify the above example slightly so that the average reading scores
> by parental education level are also included. Next, compute the
> standard deviation in addition to the mean. Finally, see if you can
> gather the resulting table to make it look more like a published table
> (mean above standard deviation).
