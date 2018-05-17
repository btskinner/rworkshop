################################################################################
##
## <PROJ> R Workshop
## <FILE> mapping.R 
## <INIT> 25 April 2018
## <AUTH> Benjamin Skinner (GitHub/Twitter: @btskinner)
##
################################################################################

## clear memory
rm(list = ls())

## libraries
libs <- c('tidyverse','leaflet','sf','RColorBrewer')
lapply(libs, require, character.only = TRUE)

## ---------------------------------------------------------
## Quick API function for requesting data
## ---------------------------------------------------------

## quick function to help use Charlottesville API
cville_api_url <- function(mapserver_number,
                           open_data_number = 1,
                           variable_vector = c('*')) {
    base <- paste0('https://gisweb.charlottesville.org/',
                   'arcgis/rest/services/OpenData_',
                   open_data_number,
                   '/MapServer/')
    mid <- '/query?where=1%3D1&outFields='
    var <- paste(variable_vector, collapse = ',')
    end <- '&outSR=4326&f=json'
    return(paste0(base, mapserver_number, mid, var, end))
}

## ---------------------------------------------------------
## Request data
## ---------------------------------------------------------

## get school link
sch_link <- cville_api_url(mapserver_number = 16)

## get school data
sch <- st_read(sch_link) %>%
    ## lower variable names
    setNames(tolower(names(.))) %>%
    ## rename the unique id for later join
    rename(objectid_sch = objectid)

## show
sch

## get census block data link, with subset of variables
vars <- c('OBJECTID','Block','Population',
          'Hispanic_Origin','NH_Wht','NH_Blk',
          'NH_Ind','NH_Asn')
cba_link <- cville_api_url(mapserver_number = 13,
                           variable_vector = vars)

## get census block data
cba <- st_read(cba_link) %>%
    ## set names to lower
    setNames(tolower(names(.))) %>%
    ## rename for later join and to make names clearer
    rename(objectid_cba = objectid,
           pop = population,      
           amerind = nh_ind,
           asian = nh_asn,
           black = nh_blk,
           hispanic = hispanic_origin,
           white = nh_wht) %>%
    ## create other race/ethnicity category
    mutate(other = pop - amerind - asian - black - hispanic - white)

## show
cba

## ---------------------------------------------------------
## Map elementary attendance zones
## ---------------------------------------------------------
## set up color palette that will align
factpal <- colorFactor(palette = brewer.pal(n = length(sch$zone),
                                            name = 'Accent'),
                       domain = as.factor(sch$zone))

## make leaflet map
map <- leaflet(sch) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2,, fillOpacity = .5,
                fillColor = ~factpal(sch$zone), label = ~zone)
map

## ---------------------------------------------------------
## Map census block areas
## ---------------------------------------------------------
## too many census blocks so will randomly assign indices for colors
cba$group <- factor(sample.int(11L, nrow(cba), replace = TRUE))

## set up color palette that will align with indices
factpal <- colorFactor(palette = brewer.pal(n = 8L, name = 'Accent'),
                       domain = cba$group)

## make leaflet map
map <- leaflet(cba) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2, fillOpacity = .5,
                fillColor = ~factpal(cba$group), label = ~block)
map

## ---------------------------------------------------------
## Merging spatial data
## ---------------------------------------------------------
## merge polygons
cba_sch <- st_intersection(cba, sch)

## ---------------------------------------------
## plot one zone as example, making an inset map
## ---------------------------------------------

## primary zoomed in map
g1 <- ggplot(sch) +
    geom_sf() +
    geom_sf(aes(fill = factor(zone)), color = NA,
            data = cba_sch %>% filter(objectid_cba == 28)) +
    coord_sf(xlim = c(-78.514, -78.5035), ylim = c(38.015, 38.023)) +
    guides(fill = guide_legend(title = 'School Zone')) 

## whole Charlottesville map for inset, just wrap in ggplotGlob()
g2 <- ggplotGrob(
    ggplot(sch) +
    geom_sf() +
    geom_sf(aes(fill = factor(zone)), 
            data = cba_sch %>% filter(objectid_cba == 28)) +
    theme(panel.background = element_rect(fill = 'white'),
          legend.position = 'none',
          line = element_blank(),
          text = element_blank(),
          axis.ticks = element_blank(),
          panel.grid.major = element_line(colour = 'white'),
          panel.grid.minor = element_blank())
)

## combine and show
g3 <- g1 +
      annotation_custom(grob = g2, xmin = -78.510, xmax = -78.5018,
                        ymin = 38.019, ymax = 38.0232)
g3

## 1. get sub group area
cba_sch <- cba_sch %>%
    mutate(area = st_area(.) %>% as.numeric())

## 2. get original areas of census blocks
cb_area <- cba %>%
    mutate(area = st_area(.) %>% as.numeric()) %>%
    select(block, full_area = area) %>%
    st_set_geometry(NULL)

## 3. join and ...
cba_sch <- cba_sch %>%
    left_join(cb_area) %>%
    ## ...compute fraction as weight
    mutate(prop_w = area / full_area)


## check our example
cba_sch %>%
    select(block, objectid_cba, area, full_area, prop_w) %>%
    filter(objectid_cba == 28) %>%
    st_set_geometry(NULL)

## ---------------------------------------------------------
## Aggregate demographics within each school zone
## ---------------------------------------------------------
## get aggregate population counts (weighted by proportion of block in zone)
sch_pop <- cba_sch %>%
    group_by(objectid_sch) %>%
    ## weighted counts...
    summarise(amerind = round(sum(amerind * prop_w)),
              asian = round(sum(asian * prop_w)),
              black = round(sum(black * prop_w)),
              hispanic = round(sum(hispanic * prop_w)),
              other = round(sum(other * prop_w)),
              white = round(sum(white * prop_w))) %>%
    ## ...then total...
    mutate(pop = amerind + asian + black + hispanic + other + white,
           ## ...then proportion
           amerinc_pct = amerind / pop,
           asian_pct = asian / pop,
           black_pct = black / pop,
           hispanic_pct = hispanic / pop,
           other_pct = other / pop,
           white_pct = white / pop) %>%
    st_set_geometry(NULL)

## join with school spatial data
sch <- sch %>% left_join(sch_pop)
              
## make leaflet map: % Black population
binpal <- colorBin('Reds', sch$black_pct, 6)
map_bl_pct <- leaflet(sch) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2,, fillOpacity = .5,
                fillColor = ~binpal(black_pct)) %>%
    addLegend('topright', pal = binpal, values = ~black_pct,
              title = '% Black population (2010)')

## make leaflet map: % Hispanic population
binpal <- colorBin('Reds', sch$hispanic_pct, 6)
map_hi_pct <- leaflet(sch) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2,, fillOpacity = .5,
                fillColor = ~binpal(hispanic_pct)) %>%
    addLegend('topright', pal = binpal, values = ~hispanic_pct,
              title = '% Hispanic population (2010)')

## make leaflet map: % Asian population
binpal <- colorBin('Reds', sch$asian_pct, 6)
map_as_pct <- leaflet(sch) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2,, fillOpacity = .5,
                fillColor = ~binpal(asian_pct)) %>%
    addLegend('topright', pal = binpal, values = ~asian_pct,
              title = '% Asian population (2010)')

## make leaflet map: % White population
binpal <- colorBin('Reds', sch$white_pct, 6)
map_wh_pct <- leaflet(sch) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addPolygons(color = 'black', weight = 2,, fillOpacity = .5,
                fillColor = ~binpal(white_pct)) %>%
    addLegend('topright', pal = binpal, values = ~white_pct,
              title = '% White population (2010)')

## show each map
map_bl_pct
map_hi_pct
map_as_pct
map_wh_pct


## =============================================================================
## END SCRIPT
################################################################################
