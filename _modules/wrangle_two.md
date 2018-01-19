---
layout: module
title: Wrangling data II
date: 2018-01-01 00:00:04
category: module
links:
  script: wrangle_two.R
  data: els_plans.csv
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
---

R has undergone a transformation in the past few years and this may
affect how you choose to approach data wrangling. While the core R
functions for data manipulation are still the same, a new suite of
packages, the [tidyverse](https://www.tidyverse.org) (formerly known as
the “Hadleyverse” after their key creator, [Hadley
Wickham](http://hadley.nz)), has really changed the way many people use
R.

In this module, I’m going to show you how to wrangle data the tidyverse
way. The sequence is almost the same as those in the last module. In the
end, it’s up to you which approach you prefer.

Data for this module are the same as those used in the last, from the
[NCES Education Longitudinal Study of
2002](https://nces.ed.gov/surveys/els2002/). For descriptions of the
variables, see the <a href = '{{ site.baseurl
}}/data/#els_planscsv'>codebook</a>. If you saved your cleaned up data
set using the same name, go ahead and download a fresh copy of the
original data.

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

Pipes take output from the left side and pipe it to the input of the
right side. So `sum(x)` can be rewritten as `x %>% sum`: `x` outputs
itself and the pipe, `%>%`, makes it the input for `sum()`.

This is a silly example (why would you do that?), but pipes are powerful
because they can be chained together. Functions can be nested in R, but
after too many, the code becomes difficult to parse since it has to be
read from the inside out. Pipes allow functions to come one after
another in the order of the work being done.

Let’s use [Hadley’s canonical
example](https://twitter.com/_inundata/status/557980236130689024) to
make the readability comparison between nested functions and piped
functions clearer:

``` r
## foo_foo is an instance of a little bunny
foo_foo <- little_bunny()

## adventures in base R must be read from the middle up and backwards
bop_on(
    scoop_up(
        hop_through(foo_foo, forest),
        field_mouse
    ),
    head
)

## adventures w/ pipes start at the top and work down
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

    ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──

    ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ✔ tibble  1.4.1     ✔ dplyr   0.7.4
    ✔ tidyr   0.7.2     ✔ stringr 1.2.0
    ✔ readr   1.1.1     ✔ forcats 0.2.0

    ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()

Let’s reread the original data. Like `read.table()`, `read_delim()` is
the generic function that needs you to give it the separating/delimiting
character. You could also just use `read_csv()`.

``` r
## read in the data
df <- read_delim('../data/els_plans.csv', delim = ',')
```

    Parsed with column specification:
    cols(
      .default = col_character(),
      stu_id = col_integer(),
      sch_id = col_integer(),
      strat_id = col_integer(),
      f1sch_id = col_integer(),
      bystuwt = col_double(),
      bydob_p = col_integer(),
      byses1 = col_double(),
      byses2 = col_double(),
      bynels2m = col_double(),
      bynels2r = col_double(),
      f1qwt = col_double(),
      f1pnlwt = col_double()
    )

    See spec(...) for full column specifications.

Mutate
------

To add variables and change existing ones, use the `mutate()` function.

Most if not all of the primary tidyverse functions take the data object
as the first argument. So the `mutate()` function would be
`mutate(df, ...)` where `...` is the stuff we want to do. Because we’re
using the `%>%`, however, we start with the data by itself and pipe it
into the `mutate()` function. We’ll do this with the rest of the
tidyverse functions. While not necessary, I think it helps reading
through the code: *Starting with the data (`df`), we next create new
variables with the `mutate()` function…* and so on.

Note that with tidyverse functions, you usually don’t need to use the
data frame name with the dollar sign construction (`df$<var_name>`) and
you don’t need to put quotation marks around the column names. There are
some rare cases where you do, but we won’t get into those.

``` r
## assign values inside function using = sign (not <-)
df <- df %>%
    mutate(ones = 1,
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

> #### Quick exercise
>
> Create dummy variables for each race/ethnicity category in `byrace`.
> (Hint: use (`table()`) to see the possible values; adv. hint:
> `ifelse()` statements can be nested.)

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

     [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "bystuwt" 
     [7] "bysex"    "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed"
    [13] "byincome" "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r"
    [19] "f1qwt"    "f1psepln" "f2ps1sec" "ones"     "avg_test" "female"  

> #### Quick exercise
>
> Without assigning back to your data frame (no `<-`), see if you can
> first keep a set of variables and then drop a set of variables. (Hint:
> consider `c()`)

Filter
------

Like `select()` works on columns, `filter()` can be used to subset based
on row conditions. Earlier we properly labeled `bydob_p` values less
than zero as `NA`. Let’s drop those.

``` r
## show number of rows
nrow(df)
```

    [1] 16160

``` r
## keep if not (!) missing
df <- df %>% filter(!is.na(bydob_p))
nrow(df)
```

    [1] 15183

> #### Quick exercise
>
> Filter out observations if they are missing `bysex` values. You can do
> it in two steps, first `mutate()`ing negative values to be `NA` and
> then `filter()`ing out missing values, or in one step, just
> `filter()`ing out if `bysex` has a value below zero.

Arrange
-------

Sort values using the `arrange()` function.

``` r
## show first few rows of student and base year math scores (tidyverse way)
df %>% select(stu_id, bydob_p) %>% head(10)
```

    # A tibble: 10 x 2
       stu_id bydob_p
        <int>   <int>
     1 101101  198512
     2 101102  198605
     3 101104  198601
     4 101105  198607
     5 101106  198511
     6 101107  198510
     7 101108  198607
     8 101109  198512
     9 101110  198505
    10 101111  198507

``` r
## arrange
df <- df %>% arrange(bydob_p)

## show again first few rows of ID and DOB
df %>% select(stu_id, bydob_p) %>% head(10)
```

    # A tibble: 10 x 2
       stu_id bydob_p
        <int>   <int>
     1 133211  198300
     2 195210  198300
     3 195213  198300
     4 225203  198300
     5 268219  198300
     6 268225  198300
     7 274222  198300
     8 280215  198300
     9 324119  198300
    10 327128  198300

> #### Quick exercise
>
> `Arrange()` by `bydob_p` again, but this time in reverse order. Google
> “dplyr arrange” to find information about the function and see if can
> figure out how to sort in descending order.

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
sch_m <- df %>%
    ## first, make test score values < 0 == NA
    mutate(bynels2m = ifelse(bynels2m < 0, NA, bynels2m)) %>%
    ## group by school ID
    group_by(sch_id) %>%
    ## summarize
    summarise(sch_bynels2m = mean(bynels2m, na.rm = TRUE))

## show
sch_m
```

    # A tibble: 751 x 2
       sch_id sch_bynels2m
        <int>        <dbl>
     1   1011         45.3
     2   1012         43.3
     3   1021         28.9
     4   1022         38.6
     5   1031         40.0
     6   1032         35.3
     7   1033         42.2
     8   1041         44.9
     9   1042         52.2
    10   1051         45.9
    # ... with 741 more rows

> #### Quick exercise
>
> Find the average reading test score for each school and save it in an
> object.

The `group_by()` and `summarise()` functions are very useful for
generating summary statistics and exploring your data. We’ll use them
more in the modules on exploratory data analysis.

Join
----

Rather than saying “merge,” dplyr uses the SQL language of joins:

-   `left_join(x, y)`: keep all x, drop unmatched y
-   `right_join(x, y)`: keep all y, drop unmatched x
-   `inner_join(x, y)`: keep only matching
-   `full_join(x, y)`: keep everything

<img src="{{ site.baseurl }}/images/joins.png" alt="Joins">

Since we want to join a smaller aggregated data frame to the original
data frame, we’ll use a `left_join()`. The join functions will try to
guess the joining variable (and tell you what it picked) if you don’t
supply one, but we’ll specify one to be clear.

``` r
## join on school ID variable
df <- df %>% left_join(sch_m, by = 'sch_id')
```

> #### Quick exercise
>
> Join the average reading test score data frame you made to the main
> data object.

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

    # A tibble: 4 x 5
      schid  year var_x var_y var_z
      <chr> <dbl> <int> <int> <int>
    1 A      2013     1     5     9
    2 B      2013     2     6    10
    3 C      2013     3     7    11
    4 D      2013     4     8    12

Wide –\> long
-------------

To go from wide to long format, use the `gather(key, value)` function,
where the `key` is the variable that will made long (the stub in Stata)
and the `value` is the column of associated values that will be created.
Since we want the **schid** and **year** columns to remain associated
with their rows, we ignore them (`-c(...)`) so they will be repeated as
necessary.

Finally we `arrange()` the data by school ID and the variable name.

``` r
df_long <- df %>%
    gather(var, value, -c(schid, year)) %>%
    arrange(schid, var)

## show
df_long
```

    # A tibble: 12 x 4
       schid  year var   value
       <chr> <dbl> <chr> <int>
     1 A      2013 var_x     1
     2 A      2013 var_y     5
     3 A      2013 var_z     9
     4 B      2013 var_x     2
     5 B      2013 var_y     6
     6 B      2013 var_z    10
     7 C      2013 var_x     3
     8 C      2013 var_y     7
     9 C      2013 var_z    11
    10 D      2013 var_x     4
    11 D      2013 var_y     8
    12 D      2013 var_z    12

> #### Quick exercise
>
> What happens if you don’t include `-c(schid, year)` in the `gather()`
> function? Try it.

Long –\> wide
-------------

To go in the opposite direction, use the `spread(var, value)` function,
which makes columns for every unique `var` and assigns the `value` that
was in the `var`s row. Unlike `gather()`, we don’t have explicitly say
to ignore columns that want to ignore.

``` r
df_wide <- df_long %>%
    spread(var, value) %>%
    arrange(schid)

## show
df_wide
```

    # A tibble: 4 x 5
      schid  year var_x var_y var_z
      <chr> <dbl> <int> <int> <int>
    1 A      2013     1     5     9
    2 B      2013     2     6    10
    3 C      2013     3     7    11
    4 D      2013     4     8    12

In theory, our new `df_wide` data frame should be the same as the one we
started with. Let’s check:

``` r
## confirm that df_wide == df
identical(df, df_wide)
```

    [1] TRUE

Success![^1]

> #### Quick exercise
>
> Reshape this long data frame wide and then back:
>
>     df <- data.frame(id = rep(c('A','B','C','D'), each = 4),
>                      year = paste0('y', rep(2000:2003, 4)),
>                      test_score = rnorm(16),
>                      stringsAsFactors = FALSE) %>%
>           tbl_df()

Notes
=====

[^1]: For a slightly more complicated version that uses [regular
    expressions](https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html)
    to adjust the variable names and values after each reshape, see this
    [gist](https://gist.github.com/btskinner/a1f5bc5c1c32b48d4f45b05d2531e423)
