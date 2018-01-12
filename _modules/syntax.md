---
layout: module
title: Syntax
date: 2018-01-01 00:00:02
category: module
links:
  script: syntax.R
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
---

R: language + environment
=========================

R is a port of the [S
language](https://en.wikipedia.org/wiki/S_(programming_language)), which
was developed at Bell Labs. As a [GNU project](https://www.gnu.org), R
is open source and free ([as in
freedom](https://en.wikipedia.org/wiki/Gratis_versus_libre)) to use and
distribute. It can be installed and used on most major operating
systems.

R is best thought of as an integrated [language and
environment](https://www.r-project.org/about.html) that was designed
with statistical computing and data analysis in mind. To that end, its
structure represents a compromise between a code base optimized for
mathematical procedures and one with high-level functionality that can
be used interactively (unlike compiled code). R is probably best known
for its graphing capabilities, but it has [continued to grow in
popularity among data
scientists](http://blog.revolutionanalytics.com/2018/01/tiobe-2017.html),[^1]
who are increasingly [extending R’s functionality through
user-contributed
packages](http://blog.revolutionanalytics.com/2017/01/cran-10000.html).[^2]

Compared to other statistical languages
---------------------------------------

Like all computing languages, R has its own structure and quirks. The
idiomatic R approach to data analysis can be especially challenging at
first for those who come to R from other common statistical packages or
scripting languages, like
[SPSS](https://www.ibm.com/products/spss-statistics),
[Python](https://www.python.org), and
[Stata](https://www.stata.com).[^3]

I have almost zero experience with SPSS, so I can’t speak to the
particular difficulties that SPSS users have with R other than to guess
that biggest hurdle for the average SPSS user is the transition from
point-and-click interaction to writing text-based instructions. Python
users (I’m one of them), on the other hand, will probably find that R
can be less syntactically consistent than Python and has fewer pure
programming niceties. That said, the jump from Python to R should be
fairly easy.

I came to R after learning Stata first, which is common for many
researchers trained in econometric methods. For me and others who’ve
made the same Stata-to-R transition, I think the root of many problems
is the fundamental difference between how Stata and R operate. Whereas
Stata is more of a [procedural
language](https://en.wikipedia.org/wiki/Procedural_programming) in which
commands **do** things in an environment (your data), R is more
[object-oriented](https://en.wikipedia.org/wiki/Object-oriented_programming)
in that data and functions are **stored** in variables or objects and
await instructions that pertain to them.[^4]

As pointed out by my friend and colleague [Richard
Blissett](https://www.shu.edu/profiles/RichardBlissett.cfm), users can
see this difference in the command/function names in each language.
Stata commands tend to be verbs: `summarize`, `tabulate`, and
`regress`); on the other hand, R functions are often nouns: `summary`,
`table`, and `lm` (for linear model). And so, common problems in the R
to Stata switch such as  
- *I ran a model and didn’t get any output*  
- *How do I create local/global macros in R*  
- *Which of these data objects is the actual data?*  
- *Why isn’t R **doing** anything?*

may be due to misunderstanding this difference.[^5]

Like learning a new spoken language, constantly translating between your
native tongue and the new language will only get you so far. To that
end, I encourage native-Stata users to try to approach R without Stata
procedures in mind (easier said than done, I know). That said, this
document that shows the same analysis done in [Stata and R
side-by-side](http://rslblissett.com/wp-content/uploads/2016/09/sidebyside_130826.pdf)
may be useful in the initial transition.

Integrated development environment (IDE) for R
----------------------------------------------

### RStudio

[RStudio](https://www.rstudio.com) does most everything R-related well
and with little fuss, so it’s a great all-around IDE for most R users.
We will use it in this workshop.

> #### Quick exercise
>
> If you haven’t already, open up RStudio and poke around. First, try
> entering an equation in the console (like `1 + 1`). Next, open the
> script associated with this module and run the first line.

### Other options

There are many other ways to run R. Below are just a few that, depending
on your personal preferences and project needs, may be better or worse
than RStudio.

-   R-app (comes with the R installation)
-   Terminal/shell (R executable needs to be in your path)
-   [Emacs + ESS](https://ess.r-project.org)
-   [Atom](https://atom.io) + [r-exec](https://atom.io/packages/r-exec)
-   [Jupyter](http://jupyter.org) +
    [IRkernel](https://irkernel.github.io)

Assignment
==========

Before discussing data types and structures, the first lesson in R is
how to assign values to objects, that is, how to put stuff into objects
be it data or methods. In R ([for quirky
reasons](http://blog.revolutionanalytics.com/2008/12/use-equals-or-arrow-for-assignment.html)),
the primary means of assignment is the arrow, `<-`, which is a less than
symbol, `<`, followed by a hyphen, `-`.

``` r
## assign value to object x using <-
x <- 1

## show
x
```

    ## [1] 1

You can also assign using a single equals sign, `=`, but note that
functions also use single equal signs to associate values with
arguments.

``` r
## assign value to object y using =
y = 'a'

## show
y
```

    ## [1] "a"

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
x <- TRUE
x
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

> #### Quick exercise
>
> Try to add a string digit to a numeric value. What happens? Can you
> convert the string version on the fly so that the equation works?
> (HINT: in R, you can change a vector type using `as.<type>()`, where
> `<type>` is the name of what you want.)

Structures
----------

Building on these data types, R relies on four primary data structures:

-   `vector`
-   `matrix` (`array`)
-   `list`
-   `dataframe`

### Vector

A vector in R is just a collection of the data types discussed. In fact,
a single value is a vector of one. Vectors do not have diminsions
(`dim()`), but do have `length()`. You combine values using the
concatenate (`c()`) function.

``` r
## create vector
x <- 1

## check
is.vector(x)
```

    ## [1] TRUE

``` r
## add to vector (can do so recursively)
x <- c(x, 2, 3)

## no dim, but length
dim(x)
```

    ## NULL

``` r
length(x)
```

    ## [1] 3

All values in a vector must be of the same type. If you concatenate
values of different data types, R will automatically promote all values
to least ambiguous type. We can check this with `class()`.

``` r
## check class of x
class(x)
```

    ## [1] "numeric"

``` r
## add character
x <- c(x, 'a')
x
```

    ## [1] "1" "2" "3" "a"

``` r
## check class
class(x)
```

    ## [1] "character"

### Matrix (array)

A matrix is a 2D arrangement of data types. Instead of length, it has
dimensions. Like vectors, all data elements must be of the same type.

``` r
## create 3 x 3 matrix that is the sequence of numbers between 1 and 9
x <- matrix(1:9, nrow = 3, ncol = 3)
x
```

    ##      [,1] [,2] [,3]
    ## [1,]    1    4    7
    ## [2,]    2    5    8
    ## [3,]    3    6    9

``` r
## ...fill by row this time
y <- matrix(1:9, nrow = 3, ncol = 3, byrow = TRUE)
y
```

    ##      [,1] [,2] [,3]
    ## [1,]    1    2    3
    ## [2,]    4    5    6
    ## [3,]    7    8    9

``` r
## has dimension
dim(x)
```

    ## [1] 3 3

``` r
## # of rows
nrow(x)
```

    ## [1] 3

``` r
## # of columns
ncol(x)
```

    ## [1] 3

An array is like a matrix, but can have greater than two dimensions.
Some program output comes in array form so it’s good to recognize it.

``` r
## 2D array == matrix
z <- array(1:9, dim = c(3,3))
z
```

    ##      [,1] [,2] [,3]
    ## [1,]    1    4    7
    ## [2,]    2    5    8
    ## [3,]    3    6    9

``` r
## check if same as x matrix above
identical(x,z)
```

    ## [1] TRUE

### List

Lists are a catch all data vectors that can hold an assortment of
objects. They can be flat, meaning that all values are at the same
level, or nested, with lists holding other lists.

``` r
## create single-level list
x <- list(1, 'a', TRUE)

## show
x
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [1] "a"
    ## 
    ## [[3]]
    ## [1] TRUE

``` r
## check
is.list(x)
```

    ## [1] TRUE

``` r
## create blank list
y <- list()

## add to first list, creating nested list
x <- list(x, y)

## show
x
```

    ## [[1]]
    ## [[1]][[1]]
    ## [1] 1
    ## 
    ## [[1]][[2]]
    ## [1] "a"
    ## 
    ## [[1]][[3]]
    ## [1] TRUE
    ## 
    ## 
    ## [[2]]
    ## list()

### Data frame

Data frames are really just an organized collection of lists / vectors
that are the same length. That quick description, however, belies the
importance of data frames: you will use them all the time in your data
work.

Most of the time, you will be reading in data frames, but you can also
create them.

``` r
## create data frame
df <- data.frame(col_a = c(1,2,3),
                 col_b = c(4,5,6),
                 col_c = c(7,8,9))

## show
df
```

    ##   col_a col_b col_c
    ## 1     1     4     7
    ## 2     2     5     8
    ## 3     3     6     9

``` r
## check
is.data.frame(df)
```

    ## [1] TRUE

Like matrices, data frames have a `dim()` and the number of rows and
columns can be recovered using `nrow()` and `ncol()`. The column names,
which are needed when estimating models and making graphics, are
accessed using `names()`.

``` r
## get column names
names(df)
```

    ## [1] "col_a" "col_b" "col_c"

> #### Quick exercise
>
> Create two or three equal length vectors. Next, combine to create a
> data frame.

Clearly, there’s much more data frames and the other data types (like,
*How do I access the elements?*). We’ll get more in-depth in the next
modules as the specific commands are required.

Packages
========

Like I said above, user-submitted packages are a huge part of what makes
R great. Most of your scripts will make use of one or more packages.

Installation
------------

As you’ve seen on the <a href = '{{ site.baseurl }}/start/'>getting
started</a> page, packages can be installed from the official CRAN
repository using:

``` r
install.packages(<package name>)
```

The default option installs all dependencies (other packages that the
package you want may rely on to work properly). By default, R will check
how you built R (did you download a binary file appropriate for your
operating system or build from source) and download accordingly.

Recently, people have begun sharing the source code for their R packages
on [GitHub](https://github.com). If you want to download a package on
GitHub, either because it isn’t hosted on CRAN or because you want the
newest development version, you can use the `devtools` package to get it
(you will need [`git`](https://git-scm.com) on your system, too):

``` r
library(devtools)
install_github('<github handle>/<repo name>')
```

Loading package libraries
-------------------------

Package libraries [^6] can loaded in a number of ways:

1.  `library('<library name>')`
2.  `require('<library name>')`
3.  `lapply(c('<lib 1>', '<lib 2>'), require, character.only = TRUE)`

There’s a slight difference among each option in how the packages are
loaded in the environment, but all should work for most common tasks.

Call library function using namespace
-------------------------------------

Finally, you can call library functions without first loading the
library. To do you this, you need to place the library name followed by
two colons (`::`) before the function name:
`<library name>::<function>`. This technique is useful if you only need
a single command one time, are writing your own R package, or need to
use functions with the same name that come from different packages:

``` r
devtools::install_github('<github id>/<repo name>')
```

Help
====

Even I don’t have every R function and nuance memorized. With all the
user-written packages, it would be difficult to keep up if I tried! When
stuck, there are a few ways to get help.

Help files
----------

In the console, typing a function name immediately after a question mark
will bring up that function’s help file:

``` r
## get help file for function
?sum
```

Two question marks will search for the command name in CRAN packages:

``` r
## search for function in CRAN
??sum
```

Google it!
----------

Google is a coder’s best friend. If you are having a problem, odds are a
1,000 other people have too and at least one of them has been brave (or
foolhearty!) enough to ask about it in a forum like
[StackOverflow](https://stackoverflow.com),
[CrossValidated](https://stackoverflow.com), or [R-help mailing
list](https://stat.ethz.ch/mailman/listinfo/r-help). Google it!

Other miscellaneous notes about R
=================================

-   1-indexed (indexes start at 1 instead of 0)
-   Base commands usually written in C/C++ under the hood
-   Can be run in batch mode from the terminal/command line
    -   older: `R CMD BATCH`
    -   newer: `Rscript`

Notes
=====

[^1]: The “data scientist” as a person/title, like “big data,” has
    probably become a little played out, but for lack of a better
    catch-all term, I think everyone knows what I mean.

[^2]: For a little more history on R, particularly its success as an
    open source project, see [Fox
    (2009)](https://journal.r-project.org/archive/2009-2/RJournal_2009-2_Fox.pdf)

[^3]: If you come to R knowing C/C++, Fortran, or Java, yes, R is
    probably maddeningly slow at times, but it’s so much easier for
    common interactive tasks. Also see [Rcpp](http://www.rcpp.org),
    [rFortran](http://www.rfortran.org),
    [rJava](https://www.rforge.net/rJava/index.html) for some cool
    interactivity. If you come knowing [Julia](https://julialang.org) as
    your first language, who are you?

[^4]: Stata has some object-oriented features and R some procedural
    programming behaviors, so the assigned labels aren’t perfect. They
    are mostly right, though.

[^5]: Full disclosure: all questions I asked when learning R.

[^6]: For clarity, I’ll call them packages when talking about what is
    downloaded and libraries when discussing what is loaded into memory.
    Since the names are the same, it’s really a semantic difference.
