################################################################################
##
## <PROJ> R Workshop
## <FILE> eda_two.R 
## <INIT> 16 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## libraries
library(tidyverse)
library(haven)
library(labelled)

## read in Stata data file
df <- read_dta('../data/els_plans.dta')

## ---------------------------------------------------------
## Base R graphics
## ---------------------------------------------------------

## ---------------------------
## histogram
## ---------------------------

## histogram of math scores
hist(df$bynels2m)

## ---------------------------
## density
## ---------------------------

## density plot of math scores
plot(density(df$bynels2m, na.rm = TRUE))

## ---------------------------
## box plot
## ---------------------------

## box plot of math scores against student expectations
boxplot(bynels2m ~ bystexp, data = df)

## ---------------------------
## scatter
## ---------------------------

## scatter plot of math against reading scores
plot(df$bynels2m, df$bynels2r)

## ---------------------------------------------------------
## Graphics with ggplot2
## ---------------------------------------------------------

## ---------------------------
## histogram
## ---------------------------

## init ggplot 
p <- ggplot(data = df, mapping = aes(x = bynels2m))
p

## add histogram instruction
p <- p + geom_histogram()
p

## ---------------------------
## density
## ---------------------------

## density
p <- ggplot(data = df, mapping = aes(x = bynels2m)) +
    geom_density()
p
## histogram with density plot overlapping
p <- ggplot(data = df, mapping = aes(x = bynels2m)) +
    geom_histogram(mapping = aes(y = ..density..)) +
    geom_density()
p

## histogram with density plot overlapping (add color to see better)
p <- ggplot(data = df, mapping = aes(x = bynels2m)) +
    geom_histogram(mapping = aes(y = ..density..),
                   color = 'black',
                   fill = 'white') +
    geom_density(fill = 'red', alpha = 0.2)
p
## ---------------------------
## two way plot
## ---------------------------

## get parental education levels, use `val_labels()` to show them
val_labels(df$bypared)

## need to set up data
plot_df <- df %>%
    select(bypared, bynels2m) %>%
    na.omit() %>%                       # can't plot NAs, so drop them
    mutate(pared_coll = ifelse(bypared %in% c(4,6,7,8), 1, 0)) %>%
    select(-bypared) 

## show
head(plot_df)

## two way histogram
p <- ggplot(data = plot_df,
            aes(x = bynels2m, fill = factor(pared_coll))) +
    geom_histogram(alpha = 0.5, stat = 'density', position = 'identity')
p
## ---------------------------
## box plot
## ---------------------------

## box plot using both factor() and as_factor()
p <- ggplot(data = df,
            mapping = aes(x = factor(bypared),
                          y = bynels2r,
                          fill = as_factor(bypared))) +
    geom_boxplot()
p

## ---------------------------
## scatter plot
## ---------------------------

## sample 10% to make figure clearer
df_10 <- df %>% sample_frac(0.1)

## scatter
p <- ggplot(data = df_10, mapping = aes(x = bynels2m, y = bynels2r)) +
    geom_point()
p

## see student base year plans
table(as_factor(df$bystexp))
val_labels(df$bystexp)

## create variable for students who plan to graduate from college
df_10 <- df_10 %>%
    mutate(plan_col_grad = ifelse(bystexp >= 5, 'yes', 'no'))

## scatter
p <- ggplot(data = df_10,
            mapping = aes(x = bynels2m, y = bynels2r)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5)
p

## add fitted line with linear fit
p <- ggplot(data = df_10, mapping = aes(x = bynels2m, y = bynels2r)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = lm)
p

## add fitted line with polynomial linear fit
p <- ggplot(data = df_10, mapping = aes(x = bynels2m, y = bynels2r)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = lm, formula = y ~ poly(x,2))
p

## add fitted line with lowess
p <- ggplot(data = df_10, mapping = aes(x = bynels2m, y = bynels2r)) +
    geom_point(mapping = aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = loess)
p

library(plotly)
## redo last figure with addition of text in aes()
p <- ggplot(data = df_10, mapping = aes(x = bynels2m, y = bynels2r)) +
    geom_point(mapping = aes(color = factor(plan_col_grad),
                             text = paste0('stu_id: ', stu_id)), alpha = 0.5) +
    geom_smooth(method = loess)
p

## create an interactive plot with the last figure
p <- ggplotly(p)
p


## =============================================================================
## END SCRIPT
################################################################################
