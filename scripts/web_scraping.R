################################################################################
##
## <PROJ> R Workshop
## <FILE> web_scraping.R 
## <INIT> 25 April 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## libraries
library(tidyverse)
library(rvest)
library(lubridate)

## ---------------------------------------------------------
## Read underlying web page code
## ---------------------------------------------------------

## set site
url <- 'https://nces.ed.gov/programs/digest/d17/tables/dt17_302.10.asp'

## get site
site <- read_html(url)

## show
site

## ---------------------------------------------------------
## Get data for recent graduate totals
## ---------------------------------------------------------

## subset to just first column
tot <- site %>%
    html_nodes('.tableBracketRow td:nth-child(2)') %>%
    html_text()

## show
tot

## ...this time trim blank spaces
tot <- site %>%
    html_nodes('.tableBracketRow td:nth-child(2)') %>%
    html_text(trim = TRUE)

## show
tot

## remove blank values
tot <- tot[tot != '']

## show
tot

## remove commas, replacing with empty string
tot <- gsub(',', '', tot)

## show
tot

## convert to numeric
tot <- as.integer(tot)

## show
tot

## ---------------------------------------------------------
## Add years
## ---------------------------------------------------------

## get years column
years <- site %>%
    html_nodes('tbody th') %>%
    html_text(trim = TRUE)

## remove blank spaces like before
years <- years[years != '']

## show
years

## trim footnote that's become extra digit
years <- substring(years, 1, 4)

## show
years

## put in data frame
df <- bind_cols(years = years, total = tot) %>%
    mutate(years = as.Date(years, format = '%Y'))
df

## plot
g <- ggplot(df, mapping = aes(x = years, y = total)) +
    geom_line() +
    scale_x_date(breaks = seq(min(df$years), max(df$years), '5 years'),
                 minor_breaks = seq(min(df$years), max(df$years), '1 years'),
                 date_labels = '%Y') +
    labs(x = 'Year',
         y = 'High school completers (1000s)',
         title = 'Total number of high school completers: 1960 to 2016',
         caption = 'Source: NCES Digest of Education Statistics, 2017, Table 302.10')
g

## ---------------------------------------------------------
## Scrape entire table
## ---------------------------------------------------------

## save node
node <- paste0('.TblCls002 , td.TblCls005 , tbody .TblCls008 , ',
               '.TblCls009 , .TblCls011 , .TblCls010')

## save more dataframe-friendly column names
nms <- c('year','hs_comp_tot', 'hs_comp_tot_se',
         'hs_comp_m', 'hs_comp_m_se',
         'hs_comp_f', 'hs_comp_f_se',
         'enr_pct', 'enr_pct_se',
         'enr_pct_2', 'enr_pct_2_se',
         'enr_pct_4', 'enr_pct_4_se',
         'enr_pct_m', 'enr_pct_m_se',
         'enr_pct_2_m', 'enr_pct_2_m_se',
         'enr_pct_4_m', 'enr_pct_4_m_se',
         'enr_pct_f', 'enr_pct_f_se',
         'enr_pct_2_f', 'enr_pct_2_f_se',
         'enr_pct_4_f', 'enr_pct_4_f_se')

## whole table
tab <- site %>%
    ## use nodes
    html_nodes(node) %>%
    ## to text with trim
    html_text(trim = TRUE)

## show first few elements
tab[1:30]

## convert to matrix
tab <- tab %>%
    matrix(., ncol = 25, byrow = TRUE)

## dimensions
dim(tab)

## show first few columns
tab[1:10,1:10]

## clean up table
tab <- tab %>%
    ## remove commas
    gsub(',', '', .) %>%
    ## remove dagger and parentheses
    gsub('\\(\U2020\\)', NA, .) %>%
    ## remove hyphens
    gsub('\U2014', NA, .) %>%
    ## remove parentheses, but keep any content that was inside
    gsub('\\((.*)\\)', '\\1', .) %>%
    ## remove blank strings (^ = start, $ = end, so ^$ = start to end w/ nothing)
    gsub('^$', NA, .) %>%
    ## convert to table
    tbl_df() %>%
    ## rename using names above
    setNames(nms) %>%
    ## drop rows with missing year (blank online)
    drop_na(year) %>%
    ## fix years like above
    mutate(year = substring(year, 1, 4)) %>%
    ## convert to numbers
    mutate_all(.funs = funs(as.numeric(.)))

## show
tab

## ---------------------------------------------------------
## Reshape data
## ---------------------------------------------------------

## gather for long data
df <- tab %>%
    ## gather estimates, leaving standard errors wide for the moment
    gather(group, estimate, -c(year, ends_with('se'))) %>%
    ## gather standard errors
    gather(group_se, se, -c(year, group, estimate)) %>%
    ## drop '_se' from standard error estimates
    mutate(group_se = gsub('_se', '', group_se)) %>%
    ## filter where group == group_se
    filter(group == group_se) %>%
    ## drop extra column
    select(-group_se) %>%
    ## arrange
    arrange(year)
    
df

## ---------------------------------------------------------
## Plot trends
## ---------------------------------------------------------

## adjust data for specific plot
plot_df <- df %>%
    filter(group %in% c('enr_pct', 'enr_pct_m', 'enr_pct_f')) %>%
    mutate(hi = estimate + se * qnorm(.975),
           lo = estimate - se * qnorm(.975),
           year = as.Date(as.character(year), format = '%Y'),
           group = ifelse(group == 'enr_pct_f', 'Women',
                   ifelse(group == 'enr_pct_m', 'Men', 'All')))

## show
plot_df

## plot overall average
g <- ggplot(plot_df %>% filter(group == 'All'),
            mapping = aes(x = year, y = estimate)) +
    geom_ribbon(aes(ymin = lo, ymax = hi), fill = 'grey70') +
    geom_line() +
    scale_x_date(breaks = seq(min(plot_df$year), max(plot_df$year),
                              '5 years'),
                 minor_breaks = seq(min(plot_df$year), max(plot_df$year),
                                    '1 years'),
                 date_labels = '%Y') +
    labs(x = 'Year',
         y = 'Percent',
         title = 'Percent of recent high school completers in college: 1960 to 2016',
         caption = 'Source: NCES Digest of Education Statistics, 2017, Table 302.10')    
g

## plot comparison between men and women
g <- ggplot(plot_df %>% filter(group %in% c('Men','Women')),
            mapping = aes(x = year, y = estimate, colour = group)) +
    geom_ribbon(aes(ymin = lo, ymax = hi, fill = group), alpha = 0.2) +
    geom_line() +
    scale_x_date(breaks = seq(min(plot_df$year),
                              max(plot_df$year),
                              '5 years'),
                 minor_breaks = seq(min(plot_df$year),
                                    max(plot_df$year),
                                    '1 years'),
                 date_labels = '%Y') +
    labs(x = 'Year',
         y = 'Percent',
         title = 'Percent of recent high school completers in college: 1960 to 2016',
         caption = 'Source: NCES Digest of Education Statistics, 2017, Table 302.10') +
    guides(fill = guide_legend(title = 'Group'),
           colour = FALSE) +
    theme(legend.position = c(1,0), legend.justification = c(1,0))
g


## =============================================================================
## END SCRIPT
################################################################################
