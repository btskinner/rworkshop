################################################################################
##
## <PROJ> R Workshop
## <FILE> modeling.R 
## <INIT> 16 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## libraries
library(tidyverse)
library(haven)

## read in data
df <- read_dta('../data/els_plans_2.dta')

## ---------------------------
## linear model
## ---------------------------

## linear model
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
          data = df)
fit

## get more information
summary(fit)

## add factors
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc
          + as_factor(byrace),
          data = df)
summary(fit)

## add interactions
fit <- lm(bynels2m ~ byses1*lowinc + as_factor(bypared)*lowinc, data = df)
summary(fit)

## add polynomials
fit <- lm(bynels2m ~ bynels2r + I(bynels2r^2) + I(bynels2r^3), data = df)
summary(fit)

## ------------
## predictions
## ------------

``

## predict from first model
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
          data = df)

## old data
fit_pred <- predict(fit)

## new data
new_df <- data.frame(byses1 = c(rep(mean(df$byses1, na.rm = TRUE),2)),
                     female = c(0,1),
                     moth_ba = c(rep(mean(df$moth_ba, na.rm = TRUE),2)),
                     fath_ba = c(rep(mean(df$fath_ba, na.rm = TRUE),2)),
                     lowinc = c(rep(mean(df$lowinc, na.rm = TRUE),2)))

new_df

predict(fit, newdata = new_df, se.fit = TRUE)

## ---------------------------
## generalized linear model
## ---------------------------

## logit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial(link = 'logit'))
summary(fit)

## probit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial(link = 'probit'))
summary(fit)

## ---------------------------
## survey weights
## ---------------------------

library(survey)

## set svy design data
svy_df <- svydesign(ids = ~psu,
                    strata = ~strat_id,
                    weight = ~bystuwt,
                    data = df,
                    nest = TRUE)

svyfit <- svyglm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
                 design = svy_df)
summary(svyfit)


## =============================================================================
## END SCRIPT
################################################################################
