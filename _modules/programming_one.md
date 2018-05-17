---
layout: module
title: Programming in R I
date: 2018-01-01 00:00:09
category: module
links:
  script: programming_one.R
output:
  md_document:
    variant: gfm
    preserve_yaml: true
---

This short module is meant to introduce you to some of R programming
features. In the first section, we’ll go through some common control
flow functions. In the second section, we’ll go over building our own R
functions.

``` r
## libraries
library(tidyverse)
```

# Control flow

By control flow, I just mean the functions that help you change how your
script is read. Scripts in R are read from top to bottom unless specific
commands tell R to skip some lines or repeat a set of commands if
certain conditions are met.

Repeating commands often involves a loop. Loops have a bad reputation in
R, mostly for being slow, but they aren’t *that* slow and they are easy
to write and understand.\[1\]

## for

The `for()` function allows you to build loops. There are few ways to
use `for()`, but its construction is the same: `for(variable in
sequence)`.

Reading it backwards, the `sequence` is just the set of numbers or
objects that we’re going to work through. The `variable` is a new
variable that will temporarily hold a value from the sequence in each
run through the loop. When the `sequence` is finished, so is the loop.

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

    [1] 1
    [1] 2
    [1] 3
    [1] 4
    [1] 5
    [1] 6
    [1] 7
    [1] 8
    [1] 9
    [1] 10

Notice the braces `{}` that come after `for()`. This is the code in the
loop that will be repeated as long as the loop is run. With each loop,
`i` takes on the next value in the `num_sequence`. This is why we see 1
through 10 printed to the console.

Let’s do it again, but this time with characters.

``` r
## character vector using letters object from R base
chr_sequence <- letters[1:10]

## loop through, printing each chr_sequence value, one at a time
for (i in chr_sequence) {
    print(i)
}
```

    [1] "a"
    [1] "b"
    [1] "c"
    [1] "d"
    [1] "e"
    [1] "f"
    [1] "g"
    [1] "h"
    [1] "i"
    [1] "j"

Once more, with each loop, `i` takes on each `chr_sequence` value in
turn and `print()` prints it to the console.

> #### Quick exercise
> 
> Can you modify the above loop so that it works through both the
> `num_sequence` and `chr_sequence` in the same loop? (HINT: how might
> you combine the two sequences?)

Another way to make a for loop is work through a vector by its indices.
Let’s break the code into pieces to make it clearer.

Inside the `for()` parentheses, we have `i in 1:length(chr_sequence)`.
We know what `i in` means since it’s like what we’ve seen before. What’s
`1:length(chr_sequence)`? Starting at the end, we know that `length()`
will return the number of items in the vector. Since we know that there
are ten letters in `chr_sequence`, then we know that
`length(chr_sequence) == 10`. That means that `1:length(chr_sequence)`
is the same thing as saying `1:10`, which is what we’ve seen before.
It’s just another, more flexible way, to get the end number of our
sequence.

Inside the braces (`{}`), we have `print(chr_sequence[i])`. From the
first module, we know that brackets (`[]`) are way of pulling out
specific values from a vector. We’ve only used numbers before, but we
can also use variables that represent numbers. Since we know that `i` is
going to take on values 1 through 10 in the loop, that means the
`print()` function will get `chr_sequence[1]`, `chr_sequence[2]`, and so
on. Because of the brackets, these will turn into…`a`, `b`, and so on.
We should get the same thing as before\!

``` r
## for loop by indices
for (i in 1:length(chr_sequence)) {
    print(chr_sequence[i])
}
```

    [1] "a"
    [1] "b"
    [1] "c"
    [1] "d"
    [1] "e"
    [1] "f"
    [1] "g"
    [1] "h"
    [1] "i"
    [1] "j"

And we do\!

Whether you decide to loop using actual values from the sequence or
indices will usually depend on the code you want to run in the loop.
Sometimes one way works better and other times the other. Just do
whatever works best for you at that time.

> #### Quick exercise
> 
> Add another print statement to the last loop that shows the value of
> `i` with each loop.

## while

The `while()` function is similar to `for()` except that it doesn’t have
a predetermined stopping point. As long the expression inside the
parentheses is `TRUE`, the loop will keep going. Only when it becomes
`FALSE` will it stop.

One way to use a `while()` loop is to set up a counter. When the counter
reaches some value, the expression inside the `while()` parentheses is
no longer true and the loop stops.

``` r
## set up a counter
i <- 1

## with each loop, add one to i
while(i < 11) {
    print(i)
    i <- i + 1
}
```

    [1] 1
    [1] 2
    [1] 3
    [1] 4
    [1] 5
    [1] 6
    [1] 7
    [1] 8
    [1] 9
    [1] 10

Using a `while()` loop with a counter is often the same as using a
`for()` loop with a sequence. If that’s the case, it’s probably better
just to use a `for()` loop.

`while()` loops are most useful when it’s not clear, from the start,
when the loop should stop. Imagine you have an algorithm that should
only stop when a certain number is reached. If the time it takes to
reach the number changes depending on the input, then a `for()` loop
probably won’t work, but a `while()` loop will.

You have to careful, however, with `while()` loops. If you forget to
increment the counter (like I did the first time I set up this example),
the loop won’t ever stop because `i` will never get larger and will
always be less than 11\! If your `while()` loop will only stop when a
certain condition is met, it’s still a good idea to build in a
pre-specified number of trials. If your loop has tried, let’s say 1000
times to meet the condition and still hasn’t done so, it should stop
with an error or return what it has so far (depending on your needs).

You have been warned\!

## if

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

    [1] 1
    [1] 2
    [1] 3
    [1] 4
    [1] 6
    [1] 7
    [1] 8
    [1] 9
    [1] 10

Notice how `5` wasn’t printed to the console. It worked\!

> #### Quick exercise
> 
> Change the condition to print only numbers below 3 and above 7.

We can add one or more `else if() / else()` partners to `if()` if we
need, for example, option **B** to happen if option **A** does not.

``` r
## if/else loop
for (i in num_sequence) {
    if (i != 3 & i != 5) {
        print(i)
    } else if (i == 3) {
        print('three')
    } else {
        print('five')
    }
}
```

    [1] 1
    [1] 2
    [1] "three"
    [1] 4
    [1] "five"
    [1] 6
    [1] 7
    [1] 8
    [1] 9
    [1] 10

# Writing functions

You can write your own functions in R and should\! They don’t need to be
complex. In fact, they tend to be best when kept simple. Mostly, you
want a function to do one thing really well.

To make a function, you use the `function()` function. Put the code that
you want your function to run in the braces `{}`. Any arguments that you
want your function to take should be in the parentheses `()` right after
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

    [1] "Hi!"

Let’s make another one with an argument so that it’s more flexible. This
time, we want it to print out a sequence of numbers, but we want to be
able to change the number each time we call it.

Notice how the variable `num_vector` is repeated in both the main
function argument and inside the `for` parentheses. The `for()` function
sees `num_vector` and looks for it in the main function. It finds it
because the `num_vector` you give the main function, `print_nums()`, is
passed through to the code inside. Now `for()` can see it and use it\!

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

    [1] 1
    [1] 2
    [1] 3
    [1] 4
    [1] 5
    [1] 6
    [1] 7
    [1] 8
    [1] 9
    [1] 10

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
everything will work the
same.

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

    # A tibble: 100 x 4
          id   age sibage parage
       <int> <dbl>  <dbl>  <dbl>
     1     1  -97.     7.    50.
     2     2   12.     5.    46.
     3     3   11.     7.    50.
     4     4   13.     6.    45.
     5     5   15.     7.    46.
     6     6  -97.    11.    47.
     7     7   17.    10.    49.
     8     8   13.    10.    47.
     9     9  -97.    10.    50.
    10    10   14.     8.    54.
    # ... with 90 more rows

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
number](https://en.wikipedia.org/wiki/Magic_number_\(programming\))), we
can change it each time we call the function. Let’s try it out.

``` r
## check
table(df$age, useNA = 'ifany')
```

``` 

-97  11  12  13  14  15  16  17  18  19  20 
  9  10   9  10   9  10   5  11   7   9  11 
```

``` r
## missing values in age are coded as -97
df$age <- fix_missing(df$age, -97)

## recheck
table(df$age, useNA = 'ifany')
```

``` 

  11   12   13   14   15   16   17   18   19   20 <NA> 
  10    9   10    9   10    5   11    7    9   11    9 
```

It worked\! All the values that were -97 before, are now in the `NA`
table column. Importantly, none of the other values changed.

> #### Quick exercise
> 
> Our new function should work in the tidyverse framework. Load
> tidyverse and see if you can fix the other two columns with our new
> command. (HINT: look back at a past module if you need to)

# Notes

1.  If you want to use more idiomatic R, check out the
    [apply](https://www.r-bloggers.com/r-tutorial-on-the-apply-family-of-functions/)
    functions. If want to go really fast, check out
    [Rcpp](http://www.rcpp.org) which incorporates C/C++ libraries and
    coding with R.
