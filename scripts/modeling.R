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
## t-test
## ---------------------------

## t-test of difference in math scores across mother education (BA/BA or not)
t.test(bynels2m ~ moth_ba, data = df, var.equal = TRUE)

## ---------------------------
## linear model
## ---------------------------

## ------------
## ttest
## ------------

## compute same test as above, but in a linear model
fit <- lm(bynels2m ~ moth_ba, data = df)
fit

## use summary to see more information about regression
summary(fit)

## ------------
## lm w/terms
## ------------

## linear model with more than one covariate on the RHS
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
          data = df)
summary(fit)

## check number of observations
nobs(fit)

## see what fit object holds
names(fit)

## see first few fitted values and residuals
head(fit$fitted.values)
head(fit$residuals)

## see the design matrix
head(model.matrix(fit))

## ------------
## factors
## ------------

## add factors
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc
          + factor(byrace),
          data = df)
summary(fit)

## same model, but use as_factor() instead of factor() to use labels
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc
          + as_factor(byrace),
          data = df)
summary(fit)

## see what R did under the hood to convert categorical to dummies
head(model.matrix(fit))

## ------------
## interactions
## ------------

## add interactions
fit <- lm(bynels2m ~ byses1*lowinc + factor(bypared)*lowinc, data = df)
summary(fit)

## ------------
## polynomials
## ------------

## add polynomials
fit <- lm(bynels2m ~ bynels2r + I(bynels2r^2) + I(bynels2r^3), data = df)
summary(fit)

## ---------------------------
## generalized linear model
## ---------------------------

## logit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial())
summary(fit)

## probit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial(link = 'probit'))
summary(fit)

## ---------------------------
## survey weights
## ---------------------------

## survey library
library(survey)

## set svy design data
svy_df <- svydesign(ids = ~psu,
                    strata = ~strat_id,
                    weight = ~bystuwt,
                    data = df,
                    nest = TRUE)

## fit the svyglm regression and show output
svyfit <- svyglm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
                 design = svy_df)
summary(svyfit)

## ------------
## predictions
## ------------

## predict from first model
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
          data = df)

## old data
fit_pred <- predict(fit, se.fit = TRUE)

## show options
names(fit_pred)
head(fit_pred$fit)
head(fit_pred$se.fit)

## create new data that has two rows, with averages and one marginal change

## (1) save model matrix
mm <- model.matrix(fit)
head(mm)

## (2) drop intercept column of ones (predict() doesn't need them)
mm <- mm[,-1]
head(mm)

## (3) convert to data frame so we can use $ notation in next step
mm <- as.data.frame(mm)

## (4) new data frame of means where only lowinc changes
new_df <- data.frame(byses1 = mean(mm$byses1),
                     female = mean(mm$female),
                     moth_ba = mean(mm$moth_ba),
                     fath_ba = mean(mm$fath_ba),
                     lowinc = c(0,1))

## see new data
new_df

## predict margins
predict(fit, newdata = new_df, se.fit = TRUE)


## =============================================================================
## END SCRIPT
################################################################################
