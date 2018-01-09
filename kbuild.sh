#!/usr/local/bin/bash

# ==============================================================================
# SET OPTIONS
# ==============================================================================

usage()
{
    cat <<EOF
 
 PURPOSE:
 This script knits and builds jekyll website.
 
 USAGE: 
 $0 <arguments>
 
 ARGUMENTS:
    [-i]        Directory of *.Rmd files
    [-s]        Directory where purled scripts files should go
    [-b]        Suffix to go on _config*.yml and _site* directory
    [-v]        Render / build verbosely (optional flag)
    		
 EXAMPLE:
 
 ./knit_build.sh -i _modules -s scripts -b _dev

 DEFAULT VALUES:
 
 i = _modules
 s = scripts
 b = <empty string>
 v = 0 (knit/build quietly)

EOF
}

# defaults
i="_modules"
s="scripts"
b=""
v=0

knit_q="TRUE"
build_q="--quiet"

while getopts "hi:s:b:v" opt;
do
    case $opt in
	h)
	    usage
	    exit 1
	    ;;
	i)
	   i=$OPTARG
	    ;;
	s)
	    s=$OPTARG
	    ;;
	b)
	    b=$OPTARG
	    ;;
	v)
	    v=1
	    ;;
	\?)
	    usage
	    exit 1
	    ;;
    esac
done

# change quiet options if verbose flag is chosen
if [[ $v == 1 ]]; then
    knit_q="FALSE"
    build_q=""
fi

printf "\nKNIT RMARKDOWN / BUILD JEKYLL SITE\n"
printf -- "----------------------------------\n"

# ==============================================================================
# PRINT OPTIONS
# ==============================================================================

printf "\n[ Options ]\n\n"

printf "  *.Rmd input director        = %s\n" "$i"
printf "  *.R script output directory = %s\n" "$s"
printf "  Directory of built site     = _site%s\n" "$b"

# ==============================================================================
# KNIT
# ==============================================================================

printf "\n[ Knitting and purling... ]\n\n"

# loop through all Rmd files
for file in ${i}/*.Rmd
do
    ## get file name without ending
    f=$(basename "${file%.*}")
    printf "  $f.Rmd ==> \n"
    ## knit
    Rscript -e "rmarkdown::render('$file', output_dir='$i', quiet = $knit_q)"
    printf "     $i/$f.md\n"
    ## purl
    Rscript -e "knitr::purl('$file', documentation = 0, quiet = $knit_q)" > /dev/null
    printf "     $s/$f.R\n"
    # get file name without date
    newf=${f##*-}
    ## move R file to scripts directory
    mv ${f}.R $s/${f}.R
done

# ==============================================================================
# BUILD
# ==============================================================================

printf "\n[ Building... ]\n\n"

jekyll build $build_q --config ./_config${b}.yml --destination ./_site${b} 
printf "  Built site ==>\n"
printf "     config file:   _config$b\n"
printf "     location:      _site$b\n"

# ==============================================================================
# BUILD
# ==============================================================================

printf "\n[ Finished! ]\n\n"

# ==============================================================================
