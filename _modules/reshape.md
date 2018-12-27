---
layout: module
title: Reshaping data
date: 2018-01-01 00:00:05
category: module
links:
  script: reshape.R
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

Reshaping data is a common data wrangling task. Whether going from [wide
to long format or long to
wide](https://en.wikipedia.org/wiki/Wide_and_narrow_data), this can be a
painful process. Though you can reshape data frames using base R
commands, the best way I know to reshape data in R is by using functions
in the [tidyr](http://tidyr.tidyverse.org) library.

``` r
## library
library(tidyverse)
```

    ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──

    ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
    ✔ tibble  1.4.2     ✔ dplyr   0.7.8
    ✔ tidyr   0.8.2     ✔ stringr 1.3.1
    ✔ readr   1.3.1     ✔ forcats 0.3.0

    ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()

# Create toy data

For clarity, we’ll use toy data for this example. Let’s say these data
represent average school-wide test scores on three tests, math, reading,
and science, for four schools (A, B, C, and D), in 2013.

``` r
df <- data.frame(schid = c('A','B','C','D'),
                 year = 2013,
                 math = round(rnorm(4, 500, 10)),
                 read = round(rnorm(4, 300, 20)),
                 science = round(rnorm(4, 800, 15)),
                 stringsAsFactors = FALSE) %>%
    tbl_df()
```

This data structure should be wide and look like this:

| schid | year | math  | read  | science |
| :---: | :--: | :---: | :---: | :-----: |
|   A   | 2013 | `496` | `306` |  `814`  |
|   B   | 2013 | `504` | `280` |  `786`  |
|   C   | 2013 | `507` | `322` |  `788`  |
|   D   | 2013 | `486` | `307` |  `807`  |

``` r
## confirm that it is wide
df
```

    # A tibble: 4 x 5
      schid  year  math  read science
      <chr> <dbl> <dbl> <dbl>   <dbl>
    1 A      2013   496   306     814
    2 B      2013   504   280     786
    3 C      2013   507   322     788
    4 D      2013   486   307     807

## Wide –\> long

To start, the data are wide. While this setup can be efficient for
storage, it’s not always the best for analysis or even just browsing.
What we want is for the data to be long. Instead of each test having its
own column, there should be one column for the test subject (**test**)
and another column that gives the value (**score**). It should look like
this:

| schid | year |  test   | score |
| :---: | :--: | :-----: | :---: |
|   A   | 2013 |  math   | `496` |
|   A   | 2013 |  read   | `306` |
|   A   | 2013 | science | `814` |
|   B   | 2013 |  math   | `504` |
|   B   | 2013 |  read   | `280` |
|   B   | 2013 | science | `786` |
|   C   | 2013 |  math   | `507` |
|   C   | 2013 |  read   | `322` |
|   C   | 2013 | science | `788` |
|   D   | 2013 |  math   | `486` |
|   D   | 2013 |  read   | `307` |
|   D   | 2013 | science | `807` |

To go from wide to long format, use the `gather(key, value)` function,
where `key` is a new column that will hold all the variable names that
were columns in the wide data frame and `value` is a new column that
will hold their values. In our case, the key will be `test` (we can call
it what we want), because that’s what we’re gathering in. The value will
be `score` and will hold the test score values.

We don’t want to gather every column, though. Since we want the
**schid** and **year** columns to remain associated with their rows, we
ignore them (`-c(...)`). By ignoring them, `gather()` will repeat their
values down the rows as necessary.

Finally, to tidy up, we `arrange()` the data by school ID and the
variable name.

``` r
df_long <- df %>%
    gather(test, score, -c(schid, year)) %>%
    arrange(schid, test)

## show
df_long
```

    # A tibble: 12 x 4
       schid  year test    score
       <chr> <dbl> <chr>   <dbl>
     1 A      2013 math      496
     2 A      2013 read      306
     3 A      2013 science   814
     4 B      2013 math      504
     5 B      2013 read      280
     6 B      2013 science   786
     7 C      2013 math      507
     8 C      2013 read      322
     9 C      2013 science   788
    10 D      2013 math      486
    11 D      2013 read      307
    12 D      2013 science   807

> #### Quick exercise
> 
> What happens if you don’t include `-c(schid, year)` in the `gather()`
> function? Try it.

## Long –\> wide

To go in the opposite direction, use the `spread(var, value)` function,
which makes columns for every unique `var` and assigns the `value` that
was in the `var`’s row. In our case, these are **test** and **score**,
respectively. Unlike `gather()`, we don’t have explicitly say to ignore
columns that want to ignore.

``` r
df_wide <- df_long %>%
    spread(test, score) %>%
    arrange(schid)

## show
df_wide
```

    # A tibble: 4 x 5
      schid  year  math  read science
      <chr> <dbl> <dbl> <dbl>   <dbl>
    1 A      2013   496   306     814
    2 B      2013   504   280     786
    3 C      2013   507   322     788
    4 D      2013   486   307     807

In theory, our new `df_wide` data frame should be the same as the one we
started with. Let’s check:

``` r
## confirm that df_wide == df
identical(df, df_wide)
```

    [1] TRUE

Success\!

> #### Quick exercise
> 
> Reshape this long data frame wide and then back:
> 
>     df <- data.frame(id = rep(c('A','B','C','D'), each = 4),
>                      year = paste0('y', rep(2000:2003, 4)),
>                      score = rnorm(16),
>                      stringsAsFactors = FALSE) %>%
>           tbl_df()
