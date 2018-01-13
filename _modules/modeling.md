---
layout: module
title: Econometric modeling
date: 2018-01-01 00:00:06
category: module
links:
  script: modeling.R
  data: els_plans.dta
output:
  md_document:
    variant: markdown_mmd
    preserve_yaml: true
    toc: true
    toc_depth: 2
---

``` r
## libraries
library(tidyverse)
library(haven)
```

``` r
## read in data
df <- read_dta('../data/els_plans.dta')

## create some 
df <- df %>%
    mutate(female = ifelse(bysex == 2, 0, bysex),
           moth_ba = ifelse(bymothed >= 6, 1, 0),
           fath_ba = ifelse(byfathed >= 6, 1, 0),
           par_ba = ifelse(bypared >= 6, 1, 0),
           lowinc = ifelse(byincome <= 7, 1, 0),
           pared_f = as_factor(bypared),
           race_f = as_factor(byrace),
           inc_f = as_factor(byincome),
           plan_col_grad = ifelse(bystexp >= 5, 1, 0))
```

linear model
============

``` r
## linear model
fit <- lm(bynels2m ~ bynels2r + byses1 + female + moth_ba + fath_ba,
          data = df)
fit
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ bynels2r + byses1 + female + moth_ba + 
    ##     fath_ba, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)     bynels2r       byses1       female      moth_ba  
    ##     13.8224       1.0068       2.0392       2.7126       0.1862  
    ##     fath_ba  
    ##      0.6318

``` r
## get more information
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ bynels2r + byses1 + female + moth_ba + 
    ##     fath_ba, data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -33.783  -5.874  -0.078   5.685  47.715 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 13.822370   0.283237  48.801  < 2e-16 ***
    ## bynels2r     1.006799   0.008341 120.703  < 2e-16 ***
    ## byses1       2.039231   0.153873  13.253  < 2e-16 ***
    ## female       2.712557   0.142749  19.002  < 2e-16 ***
    ## moth_ba      0.186248   0.205364   0.907  0.36447    
    ## fath_ba      0.631801   0.203144   3.110  0.00187 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 8.768 on 15230 degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## Multiple R-squared:  0.5861, Adjusted R-squared:  0.5859 
    ## F-statistic:  4313 on 5 and 15230 DF,  p-value: < 2.2e-16

``` r
## add factors
fit <- lm(bynels2m ~ bynels2r + byses1 + female + moth_ba + fath_ba + lowinc
          + factor(byrace),
          data = df)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ bynels2r + byses1 + female + moth_ba + 
    ##     fath_ba + lowinc + factor(byrace), data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -33.475  -5.684  -0.063   5.665  42.186 
    ## 
    ## Coefficients:
    ##                  Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)     13.188114   0.791755  16.657  < 2e-16 ***
    ## bynels2r         0.969816   0.008363 115.966  < 2e-16 ***
    ## byses1           1.709427   0.174398   9.802  < 2e-16 ***
    ## female           2.656546   0.139011  19.110  < 2e-16 ***
    ## moth_ba          0.140950   0.202634   0.696  0.48670    
    ## fath_ba          0.527029   0.203781   2.586  0.00971 ** 
    ## lowinc          -0.466387   0.206990  -2.253  0.02426 *  
    ## factor(byrace)2  6.455306   0.782949   8.245  < 2e-16 ***
    ## factor(byrace)3 -1.534942   0.772634  -1.987  0.04698 *  
    ## factor(byrace)4  0.655776   0.797002   0.823  0.41063    
    ## factor(byrace)5 -0.041299   0.788027  -0.052  0.95820    
    ## factor(byrace)6  1.156803   0.813534   1.422  0.15506    
    ## factor(byrace)7  2.468047   0.757302   3.259  0.00112 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 8.537 on 15223 degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## Multiple R-squared:  0.6078, Adjusted R-squared:  0.6075 
    ## F-statistic:  1966 on 12 and 15223 DF,  p-value: < 2.2e-16

``` r
## add factors created earlier
fit <- lm(bynels2m ~ byses1 + female + moth_ba + fath_ba + lowinc
          + race_f ,
          data = df)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ byses1 + female + moth_ba + fath_ba + 
    ##     lowinc + race_f, data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -39.154  -8.387   0.424   8.639  39.873 
    ## 
    ## Coefficients:
    ##                                                Estimate Std. Error t value
    ## (Intercept)                                     39.5040     1.0410  37.949
    ## byses1                                           5.7360     0.2345  24.456
    ## female                                           1.1955     0.1900   6.293
    ## moth_ba                                          0.6500     0.2780   2.338
    ## fath_ba                                          0.8482     0.2796   3.033
    ## lowinc                                          -1.2536     0.2839  -4.416
    ## race_fasian, hawaii/pac. islander,non-hispanic   9.1538     1.0740   8.523
    ## race_fblack or african american, non-hispanic   -2.2185     1.0603  -2.092
    ## race_fhispanic, no race specified                1.2778     1.0937   1.168
    ## race_fhispanic, race specified                   0.2387     1.0814   0.221
    ## race_fmultiracial, non-hispanic                  4.2457     1.1158   3.805
    ## race_fwhite, non-hispanic                        6.9514     1.0379   6.698
    ##                                                Pr(>|t|)    
    ## (Intercept)                                     < 2e-16 ***
    ## byses1                                          < 2e-16 ***
    ## female                                         3.21e-10 ***
    ## moth_ba                                        0.019407 *  
    ## fath_ba                                        0.002423 ** 
    ## lowinc                                         1.01e-05 ***
    ## race_fasian, hawaii/pac. islander,non-hispanic  < 2e-16 ***
    ## race_fblack or african american, non-hispanic  0.036419 *  
    ## race_fhispanic, no race specified              0.242696    
    ## race_fhispanic, race specified                 0.825295    
    ## race_fmultiracial, non-hispanic                0.000142 ***
    ## race_fwhite, non-hispanic                      2.19e-11 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 11.71 on 15224 degrees of freedom
    ##   (924 observations deleted due to missingness)
    ## Multiple R-squared:  0.2613, Adjusted R-squared:  0.2608 
    ## F-statistic: 489.6 on 11 and 15224 DF,  p-value: < 2.2e-16

``` r
## add interactions
fit <- lm(bynels2m ~ byses1*lowinc + pared_f*lowinc, data = df)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = bynels2m ~ byses1 * lowinc + pared_f * lowinc, data = df)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -39.016  -8.858   0.318   9.060  39.495 
    ## 
    ## Coefficients:
    ##                                                        Estimate Std. Error
    ## (Intercept)                                             44.2379     0.6497
    ## byses1                                                   7.8484     0.3134
    ## lowinc                                                   0.6514     1.1689
    ## pared_fgraduated from high school or ged                 1.4347     0.6584
    ## pared_fattended 2-year school, no degree                 0.4443     0.7248
    ## pared_fgraduated from 2-year school                      1.6640     0.7328
    ## pared_fattended college, no 4-year degree                1.2604     0.7353
    ## pared_fgraduated from college                            1.1010     0.7690
    ## pared_fcompleted master^s degree or equivalent           1.5597     0.8716
    ## pared_fcompleted phd, md, other advanced degree          0.2949     0.9773
    ## byses1:lowinc                                           -1.1041     0.6718
    ## lowinc:pared_fgraduated from high school or ged         -2.5121     0.9752
    ## lowinc:pared_fattended 2-year school, no degree         -3.2148     1.1841
    ## lowinc:pared_fgraduated from 2-year school              -3.8948     1.2453
    ## lowinc:pared_fattended college, no 4-year degree        -3.7355     1.2389
    ## lowinc:pared_fgraduated from college                    -3.1859     1.3334
    ## lowinc:pared_fcompleted master^s degree or equivalent   -5.5557     1.7121
    ## lowinc:pared_fcompleted phd, md, other advanced degree  -8.0319     1.9636
    ##                                                        t value Pr(>|t|)
    ## (Intercept)                                             68.091  < 2e-16
    ## byses1                                                  25.047  < 2e-16
    ## lowinc                                                   0.557  0.57737
    ## pared_fgraduated from high school or ged                 2.179  0.02935
    ## pared_fattended 2-year school, no degree                 0.613  0.53987
    ## pared_fgraduated from 2-year school                      2.271  0.02317
    ## pared_fattended college, no 4-year degree                1.714  0.08652
    ## pared_fgraduated from college                            1.432  0.15223
    ## pared_fcompleted master^s degree or equivalent           1.789  0.07355
    ## pared_fcompleted phd, md, other advanced degree          0.302  0.76282
    ## byses1:lowinc                                           -1.644  0.10028
    ## lowinc:pared_fgraduated from high school or ged         -2.576  0.01000
    ## lowinc:pared_fattended 2-year school, no degree         -2.715  0.00664
    ## lowinc:pared_fgraduated from 2-year school              -3.128  0.00177
    ## lowinc:pared_fattended college, no 4-year degree        -3.015  0.00257
    ## lowinc:pared_fgraduated from college                    -2.389  0.01690
    ## lowinc:pared_fcompleted master^s degree or equivalent   -3.245  0.00118
    ## lowinc:pared_fcompleted phd, md, other advanced degree  -4.090 4.33e-05
    ##                                                           
    ## (Intercept)                                            ***
    ## byses1                                                 ***
    ## lowinc                                                    
    ## pared_fgraduated from high school or ged               *  
    ## pared_fattended 2-year school, no degree                  
    ## pared_fgraduated from 2-year school                    *  
    ## pared_fattended college, no 4-year degree              .  
    ## pared_fgraduated from college                             
    ## pared_fcompleted master^s degree or equivalent         .  
    ## pared_fcompleted phd, md, other advanced degree           
    ## byses1:lowinc                                             
    ## lowinc:pared_fgraduated from high school or ged        *  
    ## lowinc:pared_fattended 2-year school, no degree        ** 
    ## lowinc:pared_fgraduated from 2-year school             ** 
    ## lowinc:pared_fattended college, no 4-year degree       ** 
    ## lowinc:pared_fgraduated from college                   *  
    ## lowinc:pared_fcompleted master^s degree or equivalent  ** 
    ## lowinc:pared_fcompleted phd, md, other advanced degree ***
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

generalized linear model
========================

``` r
## logit
fit <- glm(plan_col_grad ~ bynels2m + pared_f,
           data = df,
           family = binomial(link = 'logit'))
summary(fit)
```

    ## 
    ## Call:
    ## glm(formula = plan_col_grad ~ bynels2m + pared_f, family = binomial(link = "logit"), 
    ##     data = df)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.6467  -0.9581   0.5211   0.7695   1.5815  
    ## 
    ## Coefficients:
    ##                                                  Estimate Std. Error
    ## (Intercept)                                     -1.824413   0.090000
    ## bynels2m                                         0.056427   0.001636
    ## pared_fgraduated from high school or ged         0.042315   0.079973
    ## pared_fattended 2-year school, no degree         0.204831   0.088837
    ## pared_fgraduated from 2-year school              0.480828   0.092110
    ## pared_fattended college, no 4-year degree        0.499019   0.090558
    ## pared_fgraduated from college                    0.754817   0.084271
    ## pared_fcompleted master^s degree or equivalent   0.943558   0.101585
    ## pared_fcompleted phd, md, other advanced degree  1.052006   0.121849
    ##                                                 z value Pr(>|z|)    
    ## (Intercept)                                     -20.271  < 2e-16 ***
    ## bynels2m                                         34.491  < 2e-16 ***
    ## pared_fgraduated from high school or ged          0.529   0.5967    
    ## pared_fattended 2-year school, no degree          2.306   0.0211 *  
    ## pared_fgraduated from 2-year school               5.220 1.79e-07 ***
    ## pared_fattended college, no 4-year degree         5.511 3.58e-08 ***
    ## pared_fgraduated from college                     8.957  < 2e-16 ***
    ## pared_fcompleted master^s degree or equivalent    9.288  < 2e-16 ***
    ## pared_fcompleted phd, md, other advanced degree   8.634  < 2e-16 ***
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
fit <- glm(plan_col_grad ~ bynels2m + pared_f,
           data = df,
           family = binomial(link = 'probit'))
summary(fit)
```

    ## 
    ## Call:
    ## glm(formula = plan_col_grad ~ bynels2m + pared_f, family = binomial(link = "probit"), 
    ##     data = df)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.7665  -0.9796   0.5238   0.7812   1.5517  
    ## 
    ## Coefficients:
    ##                                                   Estimate Std. Error
    ## (Intercept)                                     -1.0522131  0.0539072
    ## bynels2m                                         0.0326902  0.0009357
    ## pared_fgraduated from high school or ged         0.0325415  0.0488225
    ## pared_fattended 2-year school, no degree         0.1316456  0.0539301
    ## pared_fgraduated from 2-year school              0.2958810  0.0554114
    ## pared_fattended college, no 4-year degree        0.3065176  0.0544813
    ## pared_fgraduated from college                    0.4553127  0.0505009
    ## pared_fcompleted master^s degree or equivalent   0.5525198  0.0588352
    ## pared_fcompleted phd, md, other advanced degree  0.6115358  0.0688820
    ##                                                 z value Pr(>|z|)    
    ## (Intercept)                                     -19.519  < 2e-16 ***
    ## bynels2m                                         34.938  < 2e-16 ***
    ## pared_fgraduated from high school or ged          0.667   0.5051    
    ## pared_fattended 2-year school, no degree          2.441   0.0146 *  
    ## pared_fgraduated from 2-year school               5.340 9.31e-08 ***
    ## pared_fattended college, no 4-year degree         5.626 1.84e-08 ***
    ## pared_fgraduated from college                     9.016  < 2e-16 ***
    ## pared_fcompleted master^s degree or equivalent    9.391  < 2e-16 ***
    ## pared_fcompleted phd, md, other advanced degree   8.878  < 2e-16 ***
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

predictions
===========
