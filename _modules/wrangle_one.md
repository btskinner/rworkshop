---
layout: module
title: Wrangling data I
date: 2018-01-01 00:00:03
category: module
links:
  script: wrangle_one.R
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

In this module, I’m going to show you some data wrangling procedures,
using only base R functions. There’s much to be said for the tidyverse
way of doing things (which we’ll cover in the next module), but I think
it’s still good to know how to use core commands for those edge cases
where tidyverse functions don’t quite work the way you want.

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
files from other languages later.)

Since the data come in a CSV file, we could use the special command
`read.csv()`. The more generic function `read.table()` works just as
well, though, as long as we tell R that items in each row of our data
file are separated by a `,` using the `sep = ','` argument. By default,
R assumes that the data just begin, but since our file has the variable
names in the first row, we also need to use `header = TRUE`. We won’t
talk about factors until later, but let’s read in the data keeping
string values as character vectors as well.

``` r
## read in the data, making sure that first line is read as column names
df <- read.table('../data/els_plans.csv', sep = ',', header = TRUE,
                 stringsAsFactors = FALSE)
```

…error!
-------

If you tried to read the data and got an error that looked like this

    Error in file(file, "rt") : cannot open the connection
    In addition: Warning message:
    In file(file, "rt") :
      cannot open file '../data/els_plans.csv': No such file or directory

then you have one of three issues:

1.  You haven’t downloaded the data (get it from link at top of page)
2.  You don’t have your directory/folder structure set up correctly (go
    back to the <a href="{{ site.baseurl
    }}/modules/#directory-structure">main module page</a> for
    information about how you should set things up)
3.  You don’t have R set to the correct working directory

To check your current working directory, use the `getwd()` function.

``` r
## check current directory
getwd()
```

If you had a problem, it’s possible that you aren’t in the right working
directory. This means that R can’t find your data because even though it
has directions on where to find it, it’s starting in the wrong spot so
the directions are worthless!

If you know where your `scripts` directory/folder is, you can use the
`setwd()` function to change your working directory to the right one.

``` r
## set the working directory, uncomment and change <path>/<to> as needed
## setwd('<path>/<to>/rworkshop/scripts')
```

You can correctly set the working directory by opening the script using
Rstudio’s *Files* menu, which is in the bottom right-hand box. Once
you’ve found your script, use the *More* menu option “Set As Working
Directory” to set the `scripts` directory to the working directory. Try
reading the data again.

Viewing data
============

Let’s look at the first few rows and the variable names using the
`head()` function. RStudio makes it easy to see your data by using its
[viewer](https://support.rstudio.com/hc/en-us/articles/205175388-Using-the-Data-Viewer),
(which really just calls the `View()` function around the data object).

``` r
## show the first few rows (or view in RStudio's view)
head(df)
```

      stu_id sch_id strat_id   psu f1sch_id  bystuwt  bysex
    1 101101   1011      101 psu 1     1011 178.9513 female
    2 101102   1011      101 psu 1     1011  28.2951 female
    3 101104   1011      101 psu 1     1011 589.7248 female
    4 101105   1011      101 psu 1     1011 235.7822 female
    5 101106   1011      101 psu 1     1011 178.9513 female
    6 101107   1011      101 psu 1     1011 256.9656   male
                                        byrace bydob_p
    1                 hispanic, race specified  198512
    2 asian, hawaii/pac. islander,non-hispanic  198605
    3                      white, non-hispanic  198601
    4  black or african american, non-hispanic  198607
    5              hispanic, no race specified  198511
    6              hispanic, no race specified  198510
                                 bypared                           bymothed
    1 attended college, no 4-year degree         did not finish high school
    2 attended college, no 4-year degree attended college, no 4-year degree
    3  graduated from high school or ged  graduated from high school or ged
    4  graduated from high school or ged  graduated from high school or ged
    5         did not finish high school         did not finish high school
    6  graduated from high school or ged  graduated from high school or ged
                                byfathed         byincome byses1 byses2
    1 attended college, no 4-year degree  $50,001-$75,000  -0.25  -0.23
    2 attended college, no 4-year degree $75,001-$100,000   0.58   0.69
    3  graduated from high school or ged  $50,001-$75,000  -0.85  -0.68
    4  graduated from high school or ged   $1,000 or less  -0.80  -0.89
    5         did not finish high school  $15,001-$20,000  -1.41  -1.28
    6         did not finish high school  $35,001-$50,000  -1.07  -0.93
                                       bystexp bynels2m bynels2r    f1qwt
    1 attend or complete 2-year college/school    47.84    39.04 152.9769
    2 obtain phd, md, or other advanced degree    55.30    36.35  25.3577
    3                             {don^t know}    66.24    42.68 709.4246
    4                    graduate from college    35.33    27.86 199.7193
    5                    graduate from college    29.97    13.07 152.9769
    6 attend college, 4-year degree incomplete    24.28    11.70 205.2692
       f1pnlwt                               f1psepln
    1 155.6312 don^t know or planning but unspecified
    2  25.4906        four-year college or university
    3 725.6926        four-year college or university
    4 205.1919             two-year community college
    5 155.6312        four-year college or university
    6 211.4690             two-year community college
                                   f2ps1sec
    1 {Survey component legitimate skip/NA}
    2               Public, 4-year or above
    3               Public, 4-year or above
    4                        Public, 2-year
    5                        Public, 2-year
    6             {Item legitimate skip/NA}

Remember that we can also use `names()` to see just the variable names.

``` r
## show the column names
names(df)
```

     [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "bystuwt" 
     [7] "bysex"    "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed"
    [13] "byincome" "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r"
    [19] "f1qwt"    "f1pnlwt"  "f1psepln" "f2ps1sec"

Add variables
-------------

Add a column by giving it a name and assigning what you want. R will
repeat the values as necessary to fill the number of rows. You can also
use data from other columns. R will assign values row by row, using the
right-hand side values that align.

``` r
## add simply column of ones
df$ones <- 1

## add sum of test scores (bynels2r + bynels2m)
df$sum_test <- (df$bynels2r + df$bynels2m)

## check names
names(df)
```

     [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "bystuwt" 
     [7] "bysex"    "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed"
    [13] "byincome" "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r"
    [19] "f1qwt"    "f1pnlwt"  "f1psepln" "f2ps1sec" "ones"     "sum_test"

> #### Quick exercise
>
> Create a new column that is the average of the test scores.

Drop variables
--------------

Drop variables by assigning `NULL` to the column name.

``` r
## drop follow up one panel weight
df$f1pnlwt <- NULL

## check names
names(df)
```

     [1] "stu_id"   "sch_id"   "strat_id" "psu"      "f1sch_id" "bystuwt" 
     [7] "bysex"    "byrace"   "bydob_p"  "bypared"  "bymothed" "byfathed"
    [13] "byincome" "byses1"   "byses2"   "bystexp"  "bynels2m" "bynels2r"
    [19] "f1qwt"    "f1psepln" "f2ps1sec" "ones"     "sum_test"

Conditionally change values
---------------------------

This can be tricky at first. To conditionally change or assign values,
you need to tell R where the conditions apply. There are a couple of
ways.

The first way uses brackets, `[]`, after the variable name to set the
condition where the assignment is true. For version 1 below, the new
variable `female` is assigned a value of 1 in the rows where it is
`TRUE` that `bysex == 'female'`. In the rows that’s `FALSE`, R will
assign `NA` since there’s no information. We can back fill 0s in the
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

    [1] TRUE

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

    [1] 16160

``` r
## drop if NA
df <- df[!is.na(df$bydob_p),]
nrow(df)
```

    [1] 15183

> #### Quick exercise
>
> The variable `byrace` also uses negative values to represent missing
> values. Reassign `NA`s to values that are less than zero. Next drop
> observations from the data set if they are missing `byrace` values.
> (HINT 1: Pay attention to your commas each time!) (HINT 2: Before
> dropping observations, save your data set object, `df` in another
> object, `df_hold`, just in case things don’t go well the first time…)

Order
-----

Sort the data frame using the `order()` function as a condition.

``` r
## show first few rows of student and base year math scores
df[1:10, c('stu_id','bydob_p')]
```

       stu_id bydob_p
    1  101101  198512
    2  101102  198605
    3  101104  198601
    4  101105  198607
    5  101106  198511
    6  101107  198510
    7  101108  198607
    8  101109  198512
    9  101110  198505
    10 101111  198507

``` r
## since a data frame has two dims, notice the comma in the brackets
df <- df[order(df$bydob_p),]

## show again first few rows of ID and DOB
df[1:10, c('stu_id','bydob_p')]
```

          stu_id bydob_p
    1589  133211  198300
    4286  195210  198300
    4288  195213  198300
    5578  225203  198300
    7528  268219  198300
    7532  268225  198300
    7782  274222  198300
    8055  280215  198300
    10046 324119  198300
    10203 327128  198300

> #### Quick exercise
>
> Sort by `bydob_p` again, but this time from youngest to oldest, that
> is, reverse order. Type `?order` to see the help file for the function
> and the argument you might need to do that.

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
sch_m <- aggregate(df$bynels2m, by = list(df$sch_id), FUN = mean, na.rm = T)

## show
head(sch_m)
```

      Group.1        x
    1    1011 45.26387
    2    1012 43.30400
    3    1021 28.91529
    4    1022 38.60290
    5    1031 40.01636
    6    1032 35.34429

> #### Quick exercise
>
> Get the average reading score for each school and save it to a
> different object. Don’t forget to account for missing values.

Merge
-----

Since you can have multiple data frames in memory (as objects) at the
same time in R, you may not find yourself merging data sets as often you
would in another language (like Stata, where you have to). That said, it
still needs to happen. Use the `merge()` function. Let’s merge the
aggregated test score data back into the data set.

``` r
## first fix names from aggregated data set
names(sch_m) <- c('sch_id', 'sch_bynels2m')

## merge on school ID variable
df <- merge(df, sch_m, by = 'sch_id')

## show
head(df)
```

      sch_id stu_id strat_id   psu f1sch_id  bystuwt  bysex
    1   1011 101126      101 psu 1     1011  28.2951 female
    2   1011 101105      101 psu 1     1011 235.7822 female
    3   1011 101106      101 psu 1     1011 178.9513 female
    4   1011 101132      101 psu 1       -8 192.4304   male
    5   1011 101116      101 psu 1     1011  30.2245   male
    6   1011 101131      101 psu 1     1011 620.1837   male
                                        byrace bydob_p
    1 asian, hawaii/pac. islander,non-hispanic  198410
    2  black or african american, non-hispanic  198607
    3              hispanic, no race specified  198511
    4              hispanic, no race specified  198611
    5 asian, hawaii/pac. islander,non-hispanic  198612
    6                      white, non-hispanic  198610
                                      bypared
    1              did not finish high school
    2       graduated from high school or ged
    3              did not finish high school
    4       graduated from high school or ged
    5 completed master^s degree or equivalent
    6            graduated from 2-year school
                                     bymothed
    1              did not finish high school
    2       graduated from high school or ged
    3              did not finish high school
    4       graduated from high school or ged
    5 completed master^s degree or equivalent
    6       attended 2-year school, no degree
                               byfathed          byincome byses1 byses2
    1        did not finish high school   $25,001-$35,000  -0.64  -0.67
    2 graduated from high school or ged    $1,000 or less  -0.80  -0.89
    3        did not finish high school   $15,001-$20,000  -1.41  -1.28
    4 graduated from high school or ged   $50,001-$75,000  -0.16  -0.24
    5 attended 2-year school, no degree $100,001-$200,000   0.99   0.88
    6      graduated from 2-year school   $35,001-$50,000   0.48   0.67
                                       bystexp bynels2m bynels2r    f1qwt
    1 obtain phd, md, or other advanced degree    66.73    16.65  25.3577
    2                    graduate from college    35.33    27.86 199.7193
    3                    graduate from college    29.97    13.07 152.9769
    4                    graduate from college    41.28    17.34   0.0000
    5 obtain phd, md, or other advanced degree    69.08    45.74  26.0130
    6                    graduate from college    57.19    28.60 736.6029
                             f1psepln                                f2ps1sec
    1 four-year college or university                          Public, 2-year
    2      two-year community college                          Public, 2-year
    3 four-year college or university                          Public, 2-year
    4                 {nonrespondent}               {Item legitimate skip/NA}
    5 four-year college or university Private not-for-profit, 4-year or above
    6      two-year community college                          Public, 2-year
      ones sum_test female_v1 female_v2 sch_bynels2m
    1    1    83.38         1         1     45.26387
    2    1    63.19         1         1     45.26387
    3    1    43.04         1         1     45.26387
    4    1    58.62         0         0     45.26387
    5    1   114.82         0         0     45.26387
    6    1    85.79         0         0     45.26387

> #### Quick exercise
>
> Merge the average school level reading score data set you created to
> the full data set.

Write
-----

Finally we can write our new data set to disk. We can save it as an R
data file type, but since we may want to share with non-R users, we’ll
save it as a csv file again.

``` r
write.csv(df, '../data/els_plans_mod.csv', row.names = FALSE)
```
