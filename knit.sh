#!/bin/sh

# arguments
postdir=$1
scriptdir=$2

# loop through all Rmd files
for file in ${postdir}*.Rmd
do
    ## get file name without ending
    f=$(basename "${file%.*}")
    ## knit
    Rscript -e "rmarkdown::render('$file', output_dir='$postdir')"
    ## purl
    Rscript -e "knitr::purl('$file', documentation = 0)"
    # get file name without date
    newf=${f##*-}
    ## move R file to scripts directory
    mv ${f}.R $scriptdir/${newf}.R
done
    

