################################################################################
##
## <PROJ> R Workshop
## <FILE> spatial.R 
## <INIT> 16 January 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## libraries
libs <- c('tidyverse','leaflet','geojsonio','RColorBrewer')
suppressMessages(lapply(libs, require, character.only = TRUE))

## Charlottesville open data url
url <- 'https://opendata.arcgis.com/datasets/'

## elementary zones
## sch_link <- paste0(url, '6d17dc31b79943ee9214d048ec46be53_16.geojson')
sch_link <- '/Users/benski/Downloads/Elementary_School_Zone_Area.geojson'
sch <- geojson_read(sch_link, what = 'sp')

## 2010 census block area
## cba_link <- paste0(url, 'ea02f454046142259e8b129232aa4d39_13.geojson')
cba_link <- '/Users/benski/Downloads/US_Census_Block_Area_2010.geojson'
cba <- geojson_read(cba_link, what = 'sp')

## ---------------------------------------------------------
## Map elementary attendance zones
## ---------------------------------------------------------
## set up color palette that will align
factpal <- colorFactor(palette = brewer.pal(n = length(sch$ZONE),
                                            name = 'Accent'),
                       domain = as.factor(sch$ZONE))

## make leaflet map
map <- leaflet(sch) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2,, fillOpacity = .5,
                fillColor = ~factpal(sch$ZONE), label = ~ZONE)
map

## ---------------------------------------------------------
## Map census block areas
## ---------------------------------------------------------
## too many census blocks so will randomly assign colors
cba$group <- factor(sample.int(11L, nrow(cba), replace = TRUE))

## set up color palette that will align
factpal <- colorFactor(palette = brewer.pal(n = 8L, name = 'Accent'),
                       domain = cba$group)

## make leaflet map
map <- leaflet(cba) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2, fillOpacity = .5,
                fillColor = ~factpal(cba$group), label = ~Block)
map

