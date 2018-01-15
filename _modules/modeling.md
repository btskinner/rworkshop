---
layout: module
title: Modeling
date: 2018-01-01 00:00:07
category: module
links:
  script: modeling.R
  data: els_plans.dta
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
---

``` r
## libraries
library(tidyverse)
library(haven)
```

``` r
## read in data
df <- read_dta('../data/els_plans_2.dta')
```

Linear model
============

``` r
## linear model
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
          data = df)
fit
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ byses1 + female + moth_ba + fath_ba + 
    ##     lowinc, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)       byses1       female      moth_ba      fath_ba  
    ##     45.7155       6.8058      -1.1483       0.4961       0.8242  
    ##      lowinc  
    ##     -2.1425

``` r
## get more information
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ byses1 + female + moth_ba + fath_ba + 
    ##     lowinc, data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -39.456  -8.775   0.432   9.110  40.921 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  45.7155     0.1811 252.420  < 2e-16 ***
    ## byses1        6.8058     0.2387  28.511  < 2e-16 ***
    ## female       -1.1483     0.1985  -5.784 7.42e-09 ***
    ## moth_ba       0.4961     0.2892   1.715  0.08631 .  
    ## fath_ba       0.8242     0.2903   2.840  0.00452 ** 
    ## lowinc       -2.1425     0.2947  -7.271 3.75e-13 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 12.24 on 15230 degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## Multiple R-squared:  0.1929, Adjusted R-squared:  0.1926 
    ## F-statistic: 728.1 on 5 and 15230 DF,  p-value: < 2.2e-16

``` r
## add factors
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc
          + as_factor(byrace),
          data = df)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ byses1 + female + moth_ba + fath_ba + 
    ##     lowinc + as_factor(byrace), data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -39.154  -8.387   0.424   8.639  39.873 
    ## 
    ## Coefficients:
    ##                            Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                 40.6995     1.0386  39.189  < 2e-16 ***
    ## byses1                       5.7360     0.2345  24.456  < 2e-16 ***
    ## female                      -1.1955     0.1900  -6.293 3.21e-10 ***
    ## moth_ba                      0.6500     0.2780   2.338 0.019407 *  
    ## fath_ba                      0.8482     0.2796   3.033 0.002423 ** 
    ## lowinc                      -1.2536     0.2839  -4.416 1.01e-05 ***
    ## as_factor(byrace)asian_pi    9.1538     1.0740   8.523  < 2e-16 ***
    ## as_factor(byrace)black_aa   -2.2185     1.0603  -2.092 0.036419 *  
    ## as_factor(byrace)hisp_nr     1.2778     1.0937   1.168 0.242696    
    ## as_factor(byrace)hisp_rs     0.2387     1.0814   0.221 0.825295    
    ## as_factor(byrace)mult_race   4.2457     1.1158   3.805 0.000142 ***
    ## as_factor(byrace)white       6.9514     1.0379   6.698 2.19e-11 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 11.71 on 15224 degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## Multiple R-squared:  0.2613, Adjusted R-squared:  0.2608 
    ## F-statistic: 489.6 on 11 and 15224 DF,  p-value: < 2.2e-16

``` r
## add interactions
fit <- lm(bynels2m ~ byses1*lowinc + as_factor(bypared)*lowinc, data = df)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ byses1 * lowinc + as_factor(bypared) * 
    ##     lowinc, data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -39.016  -8.858   0.318   9.060  39.495 
    ## 
    ## Coefficients:
    ##                                  Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                       44.2379     0.6497  68.091  < 2e-16 ***
    ## byses1                             7.8484     0.3134  25.047  < 2e-16 ***
    ## lowinc                             0.6514     1.1689   0.557  0.57737    
    ## as_factor(bypared)hsged            1.4347     0.6584   2.179  0.02935 *  
    ## as_factor(bypared)att2yr           0.4443     0.7248   0.613  0.53987    
    ## as_factor(bypared)grad2ry          1.6640     0.7328   2.271  0.02317 *  
    ## as_factor(bypared)att4yr           1.2604     0.7353   1.714  0.08652 .  
    ## as_factor(bypared)grad4yr          1.1010     0.7690   1.432  0.15223    
    ## as_factor(bypared)ma               1.5597     0.8716   1.789  0.07355 .  
    ## as_factor(bypared)phprof           0.2949     0.9773   0.302  0.76282    
    ## byses1:lowinc                     -1.1041     0.6718  -1.644  0.10028    
    ## lowinc:as_factor(bypared)hsged    -2.5121     0.9752  -2.576  0.01000 *  
    ## lowinc:as_factor(bypared)att2yr   -3.2148     1.1841  -2.715  0.00664 ** 
    ## lowinc:as_factor(bypared)grad2ry  -3.8948     1.2453  -3.128  0.00177 ** 
    ## lowinc:as_factor(bypared)att4yr   -3.7355     1.2389  -3.015  0.00257 ** 
    ## lowinc:as_factor(bypared)grad4yr  -3.1859     1.3334  -2.389  0.01690 *  
    ## lowinc:as_factor(bypared)ma       -5.5557     1.7121  -3.245  0.00118 ** 
    ## lowinc:as_factor(bypared)phprof   -8.0319     1.9636  -4.090 4.33e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 12.23 on 15218 degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## Multiple R-squared:  0.195,  Adjusted R-squared:  0.1941 
    ## F-statistic: 216.8 on 17 and 15218 DF,  p-value: < 2.2e-16

``` r
## add polynomials
fit <- lm(bynels2m ~ bynels2r + I(bynels2r^2) + I(bynels2r^3), data = df)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ bynels2r + I(bynels2r^2) + I(bynels2r^3), 
    ##     data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -33.695  -5.970  -0.159   5.758  46.097 
    ## 
    ## Coefficients:
    ##                 Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    1.777e+01  1.611e+00  11.028  < 2e-16 ***
    ## bynels2r       5.167e-01  1.850e-01   2.793 0.005221 ** 
    ## I(bynels2r^2)  2.142e-02  6.604e-03   3.243 0.001185 ** 
    ## I(bynels2r^3) -2.492e-04  7.416e-05  -3.360 0.000782 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 8.918 on 15880 degrees of freedom
    ##   (276 observations deleted due to missingness)
    ## Multiple R-squared:  0.5661, Adjusted R-squared:  0.566 
    ## F-statistic:  6905 on 3 and 15880 DF,  p-value: < 2.2e-16

Predictions
-----------

    ## Error: attempt to use zero-length variable name

``` r
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
```

    ##       byses1 female   moth_ba  fath_ba    lowinc
    ## 1 0.04210423      0 0.2739037 0.319419 0.2095916
    ## 2 0.04210423      1 0.2739037 0.319419 0.2095916

``` r
predict(fit, newdata = new_df, se.fit = TRUE)
```

    ## $fit
    ##        1        2 
    ## 45.95221 44.80394 
    ## 
    ## $se.fit
    ##         1         2 
    ## 0.1407063 0.1399319 
    ## 
    ## $df
    ## [1] 15230
    ## 
    ## $residual.scale
    ## [1] 12.24278

Generalized linear model
========================

``` r
## logit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial(link = 'logit'))
summary(fit)
```

    ## 
    ## Call:
    ## glm(formula = plan_col_grad ~ bynels2m + as_factor(bypared), 
    ##     family = binomial(link = "logit"), data = df)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.6467  -0.9581   0.5211   0.7695   1.5815  
    ## 
    ## Coefficients:
    ##                            Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)               -1.824413   0.090000 -20.271  < 2e-16 ***
    ## bynels2m                   0.056427   0.001636  34.491  < 2e-16 ***
    ## as_factor(bypared)hsged    0.042315   0.079973   0.529   0.5967    
    ## as_factor(bypared)att2yr   0.204831   0.088837   2.306   0.0211 *  
    ## as_factor(bypared)grad2ry  0.480828   0.092110   5.220 1.79e-07 ***
    ## as_factor(bypared)att4yr   0.499019   0.090558   5.511 3.58e-08 ***
    ## as_factor(bypared)grad4yr  0.754817   0.084271   8.957  < 2e-16 ***
    ## as_factor(bypared)ma       0.943558   0.101585   9.288  < 2e-16 ***
    ## as_factor(bypared)phprof   1.052006   0.121849   8.634  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 17545  on 15235  degrees of freedom
    ## Residual deviance: 15371  on 15227  degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## AIC: 15389
    ## 
    ## Number of Fisher Scoring iterations: 4

``` r
## probit
fit <- glm(plan_col_grad ~ bynels2m + as_factor(bypared),
           data = df,
           family = binomial(link = 'probit'))
summary(fit)
```

    ## 
    ## Call:
    ## glm(formula = plan_col_grad ~ bynels2m + as_factor(bypared), 
    ##     family = binomial(link = "probit"), data = df)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.7665  -0.9796   0.5238   0.7812   1.5517  
    ## 
    ## Coefficients:
    ##                             Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)               -1.0522131  0.0539072 -19.519  < 2e-16 ***
    ## bynels2m                   0.0326902  0.0009357  34.938  < 2e-16 ***
    ## as_factor(bypared)hsged    0.0325415  0.0488225   0.667   0.5051    
    ## as_factor(bypared)att2yr   0.1316456  0.0539301   2.441   0.0146 *  
    ## as_factor(bypared)grad2ry  0.2958810  0.0554114   5.340 9.31e-08 ***
    ## as_factor(bypared)att4yr   0.3065176  0.0544813   5.626 1.84e-08 ***
    ## as_factor(bypared)grad4yr  0.4553127  0.0505009   9.016  < 2e-16 ***
    ## as_factor(bypared)ma       0.5525198  0.0588352   9.391  < 2e-16 ***
    ## as_factor(bypared)phprof   0.6115358  0.0688820   8.878  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 17545  on 15235  degrees of freedom
    ## Residual deviance: 15379  on 15227  degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## AIC: 15397
    ## 
    ## Number of Fisher Scoring iterations: 4

Using survey weights
====================

``` r
library(survey)
```

``` r
## set svy design data
svy_df <- svydesign(ids = ~psu,
                    strata = ~strat_id,
                    weight = ~bystuwt,
                    data = df,
                    nest = TRUE)

svyfit <- svyglm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc,
                 design = svy_df)
summary(svyfit)
```

    ## 
    ## Call:
    ## svyglm(formula = bynels2m ~ byses1 + female + moth_ba + fath_ba + 
    ##     lowinc, design = svy_df)
    ## 
    ## Survey design:
    ## svydesign(ids = ~psu, strata = ~strat_id, weight = ~bystuwt, 
    ##     data = df, nest = TRUE)
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  45.2221     0.2710 166.867  < 2e-16 ***
    ## byses1        6.9470     0.2913  23.849  < 2e-16 ***
    ## female       -1.0715     0.2441  -4.389 1.47e-05 ***
    ## moth_ba       0.6633     0.3668   1.809   0.0713 .  
    ## fath_ba       0.5670     0.3798   1.493   0.1363    
    ## lowinc       -2.4860     0.3644  -6.822 3.49e-11 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for gaussian family taken to be 159.713)
    ## 
    ## Number of Fisher Scoring iterations: 2
