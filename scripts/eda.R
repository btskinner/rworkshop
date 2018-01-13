################################################################################
##
## <PROJ> R Workshop
## <FILE> eda.R 
## <INIT> 15 January 2018
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

## summary
summary(df$bynels2m)
summary(df$bynels2r)

## summary with dplyr
df %>%
    select(bynels2m, bynels2r) %>%
    na.omit() %>%
    summarise_all(.funs = funs(mean, sd))

## table of parental education levels
table(as_factor(df$bypared))

## ...using dplyr
df %>%
    count(bypared) %>%
    as_factor()

## table of parental education levels
table(as_factor(df$bypared), as_factor(df$bysex))

## ...using dplyr
df %>%
    group_by(bysex) %>%
    count(bypared) %>%
    as_factor()

## spread to look like other table
df %>%
    group_by(bysex) %>%
    count(bypared) %>%
    as_factor() %>%
    na.omit() %>%
    spread(bysex, n)

## histogram
p <- ggplot(df, aes(x = bynels2m)) +
    geom_histogram()
p
## density
p <- ggplot(df, aes(x = bynels2m)) +
    geom_density()
p
## histogram with density plot overlapping
p <- ggplot(df, aes(x = bynels2m)) +
    geom_histogram(aes(y = ..density..)) +
    geom_density()
p
## histogram with density plot overlapping (add color to see better)
p <- ggplot(df, aes(x = bynels2m)) +
    geom_histogram(aes(y = ..density..),
                   color = 'black',
                   fill = 'white') +
    geom_density(fill = 'red', alpha = 0.2)
p
## get parental education levels, use `val_labels()` to show them
val_labels(df$bypared)

## need to set up data
plot_df <- df %>%
    select(bypared, bynels2m) %>%
    na.omit() %>%
    mutate(pared_coll = ifelse(bypared %in% c(4,6,7,8), 1, 0)) %>%
    select(-bypared) 

## show
head(plot_df)

## histogram
p <- ggplot(plot_df, aes(x = bynels2m, fill = factor(pared_coll))) +
    geom_histogram(alpha = 0.5, stat = 'density', position = 'identity')
p
## box plot using both factor() and as_factor()
p <- ggplot(df, aes(x = factor(bypared), y = bynels2r,
                    fill = as_factor(bypared))) +
    geom_boxplot()
p

## sample 10%
df <- df %>%
    sample_frac(0.1)

## scatter
p <- ggplot(df, aes(x = bynels2m, y = bynels2r)) +
    geom_point()
p

## see student base year plans
table(as_factor(df$bystexp))
val_labels(df$bystexp)

## create variable for students who plan to graduate from college
df <- df %>%
    mutate(plan_col_grad = ifelse(bystexp >= 5, 'yes', 'no'))

## scatter
p <- ggplot(df, aes(x = bynels2m, y = bynels2r)) +
    geom_point(aes(color = factor(plan_col_grad)), alpha = 0.5)
p

## add fitted line with linear fit
p <- ggplot(df, aes(x = bynels2m, y = bynels2r)) +
    geom_point(aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = lm)
p

## add fitted line with polynomial linear fit
p <- ggplot(df, aes(x = bynels2m, y = bynels2r)) +
    geom_point(aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = lm, formula = y ~ poly(x,2))
p

## add fitted line with lowess
p <- ggplot(df, aes(x = bynels2m, y = bynels2r)) +
    geom_point(aes(color = factor(plan_col_grad)), alpha = 0.5) +
    geom_smooth(method = loess)
p

library(plotly)
## create an interactive plot with the last figure
p <- plotly::ggplotly(p)
p

## median test scores across parental education levels
df_plot <- df %>%
    select(bynels2m, bynels2r, bypared) %>%
    na.omit() %>%
    group_by(bypared) %>%
    summarise(math_q50 = quantile(bynels2m, probs = 0.5),
              math_q05 = quantile(bynels2m, probs = 0.05),
              math_q95 = quantile(bynels2m, probs = 0.95),
              read_q50 = quantile(bynels2r, probs = 0.5),
              read_q05 = quantile(bynels2r, probs = 0.05),
              read_q95 = quantile(bynels2r, probs = 0.95))

df_plot <- df_plot %>%
    gather(xtile, score, -bypared) %>%
    separate(xtile, c('test', 'xtile'), sep = '_') %>%
    arrange(bypared, test, xtile)

df_plot <- df_plot %>%
    spread(xtile, score)

p <- ggplot(df_plot, aes(x = bypared, fill = test)) +
    geom_ribbon(aes(ymin = q05, ymax = q95), alpha = 0.1) +
    geom_line(aes(y = q50, colour = test))
p

## create an interactive plot with the last figure
p <- plotly::ggplotly(p)
p


## =============================================================================
## END SCRIPT
################################################################################
