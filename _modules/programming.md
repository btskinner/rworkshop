---
layout: module
title: Programming in R
date: 2018-01-01 00:00:08
category: module
links:
  script: programming.R
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
---

``` r
## libraries
library(tidyverse)
```

This short module is meant to introduce you to some of R programming
features. In the first section, we’ll go through some common control
flow functions. In the second section, we’ll go over building our own R
functions.

Control flow
============

By control flow, I just mean the functions that help you change how your
script is read. Scripts in R are read from top to bottom unless specific
commands tell R to skip some lines if some condition is false or repeat
a set of commands while some condition is true.

Repeating commands often involves a loop. Loops have a bad reputation in
R, mostly for being slow, but they aren’t *that* slow and they are easy
to write and understand.[^1]

for
---

The `for()` function allows you to build loops. There are few ways to
use `for()`, but its construction is the same:
`for(variable in sequence)`.

Reading it backwards, the `sequence` is just the set of numbers or
objects that we’re going to work through. The `variable` is a new
variable that will temporarily hold a value in each run through the
loop. When the `sequence` is finished, so is the loop.

First, let’s loop through a sequence of 10 numbers, printing each one at
a time as we work through the loop.

``` r
## make vector of numbers between 1 and 10
num_sequence <- 1:10

## loop through, printing each num_sequence value, one at a time
for (i in num_sequence) {
    print(i)
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9
    ## [1] 10

Notice the braces `{}` that come after `for()`. This is the code in the
loop that will be repeated as long as the loop is run.

Let’s do it again with characters.

``` r
## character vector using letters object from R base
chr_sequence <- letters[1:10]

for (i in chr_sequence) {
    print(i)
}
```

    ## [1] "a"
    ## [1] "b"
    ## [1] "c"
    ## [1] "d"
    ## [1] "e"
    ## [1] "f"
    ## [1] "g"
    ## [1] "h"
    ## [1] "i"
    ## [1] "j"

With each loop, the `variable` `i` takes on each `chr_sequence` value in
turn.

> #### Quick exercise
>
> Can you modify the above loop so that it works through both the
> `num_sequence` and `chr_sequence` in the same loop? (HINT: how might
> you combine the two sequences?)

Another way to make a for loop is work through a vector by its indices.

``` r
## for loop by indices
for (i in 1:length(chr_sequence)) {
    print(chr_sequence[i])
}
```

    ## [1] "a"
    ## [1] "b"
    ## [1] "c"
    ## [1] "d"
    ## [1] "e"
    ## [1] "f"
    ## [1] "g"
    ## [1] "h"
    ## [1] "i"
    ## [1] "j"

The result is the same as before, but instead of the values of
`chr_sequence`, `i` takes on the values 1 through 10 (the length of the
vector)

> #### Quick exercise
>
> Add another print statement to the last loop that shows the value of
> `i` with each loop.

while
-----

The `while()` function is similar to `for()` except that it doesn’t have
a predetermined stopping point. As long the expression inside the
parentheses is `TRUE`, the loop will keep going. Only when it becomes
`FALSE` will it stop.

``` r
## set up a counter
i <- 1

## with each loop, add one to i
while(i < 11) {
    print(i)
    i <- i + 1
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9
    ## [1] 10

You have to careful with `while()` loops. If you forget to increment the
counter (like I did the first time I set up this example), the loop
won’t ever stop because `i` will never get larger and will always be
less than 11!

if
--

We’ve already used a version of if, `ifelse()`, quite a bit. We can also
use `if()` in a `for()` loop to set a condition that changes behavior
sometimes.

``` r
## only print if number is not 5
for (i in num_sequence) {
    if (i != 5) {
        print(i)
    }
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9
    ## [1] 10

Notice how `5` wasn’t printed to the console. It worked!

> #### Quick exercise
>
> Change the condition to print only numbers below 3 and above 7.

We can add one or more `else()` partners to `if()` if we need, for
example, option **B** to happen if option **A** does not.

``` r
## if/else loop
for (i in num_sequence) {
    if (i != 5) {
        print(i)
    } else {
        print('five')
    }
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] "five"
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9
    ## [1] 10

Writing functions
=================

You can write your own functions in R and should! They don’t need to be
complex. In fact, they tend to be best when kept simple. Mostly, you
want a function to do one thing really well.

To make a function, you use the `function()` function. Put the code that
you want your function to run in the braces `{}`. Any arguments that you
want you argument to take should be in the parentheses `()` right after
the word `function`. The name of your function is the name of the object
you assign it to.

Let’s make one. The function below, `my_function()`, doesn’t take any
arguments and prints a simple string when called. After you’ve built it,
call your function using its name, not forgetting to include the
parentheses.

``` r
## function to say hi!
my_function <- function() {
    print('Hi!')
}

## call it
my_function()
```

    ## [1] "Hi!"

Let’s make another one with an argument so that it’s more flexible. This
time, we want it to print out a sequence of numbers, but we want to be
able to change the number each time we call it.

Notice how the variable `num_vector` is repeated in both the main
function argument and inside the `for` parentheses. The `for()` function
sees `num_vector` and looks for it in the main function. It finds it
because the `num_vector` you give the main function, `print_nums()`, is
passed through to the code inside. Now `for()` can see it and use it!

``` r
## new function to print sequence of numbers
print_nums <- function(num_vector) {
    ## this code looks familiar...
    for (i in num_vector) {
        print(i)
    }
}

## try it out!
print_nums(1:10)
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9
    ## [1] 10

> #### Quick exercise
>
> What happens if you forget to put an argument in your new function?
> How do you think you might set a default argument for `num_vector`?
> Could you set it equal to something?

Moving to a more realistic example, we could make a function that filled
in missing values, a common task we’ve had. First, we’ll generate some
fake data with missing values.

Note that since we’re using R’s `sample()` function, your data will look
a little different from mine due to randomness in the sample, but
everything will work the same.

``` r
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
```

    ## # A tibble: 100 x 4
    ##       id   age sibage parage
    ##    <int> <dbl>  <dbl>  <dbl>
    ##  1     1  11.0 -98.0    48.0
    ##  2     2  17.0  10.0    45.0
    ##  3     3  19.0   6.00   50.0
    ##  4     4  11.0   6.00   50.0
    ##  5     5  17.0   6.00   52.0
    ##  6     6  19.0   7.00   53.0
    ##  7     7  20.0  12.0    48.0
    ##  8     8  20.0   7.00   50.0
    ##  9     9  11.0   9.00   45.0
    ## 10    10  19.0   6.00   55.0
    ## # ... with 90 more rows

We could fix these manually like we have been, but it would be nice have
a shorthand function. The function needs to flexible though, because the
missing data values are coded differently in each column.

``` r
## function to fix missing values
fix_missing <- function(x, miss_val) {

    ## in the vector, wherever the vector is the missval_num, make NA
    x[x == miss_val] <- NA

    ## return instead of print because we want to store it
    return(x)
}
```

Our `fix_missing()` function should work. It takes the same bracket code
we used in past modules, but instead of using the name of the object
(like `df`), uses a variable name `x` that we can set each time. It does
the same for `miss_val`. Instead of choosing a hard-coded value (a
[magic
number](https://en.wikipedia.org/wiki/Magic_number_(programming))), we
can change it each time we call the function. Let’s try it out.

``` r
## check
table(df$age, useNA = 'ifany')
```

    ## 
    ## -97  11  12  13  14  15  16  17  18  19  20 
    ##   9   4   6  12   9   8   8  10  10  10  14

``` r
## missing values in age are coded as -97
df$age <- fix_missing(df$age, -97)

## recheck
table(df$age, useNA = 'ifany')
```

    ## 
    ##   11   12   13   14   15   16   17   18   19   20 <NA> 
    ##    4    6   12    9    8    8   10   10   10   14    9

> #### Quick exercise
>
> Our new function should work in the tidyverse framework. Load
> tidyverse and see if you can fix the other two columns with our new
> command. (HINT: look back at a past module if you need to)

Notes
=====

[^1]: If you want to use more idimatic R, check out the
    [apply](https://www.r-bloggers.com/r-tutorial-on-the-apply-family-of-functions/)
    functions. If want to go really fast, check out
    [Rcpp](http://www.rcpp.org) which incorporates C/C++ libraries and
    coding with R.
