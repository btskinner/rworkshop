---
layout: default
---

# Software links

Unless you have experience building from source, select the binary
download that matches your operating system (e.g., Windows, OS
X/MacOS). If no options are available, the download will work on all
systems.

## Required
### R (get latest version)  
- [Windows](https://cran.r-project.org/bin/windows/base/)  
- [OS X](https://cran.r-project.org/bin/macosx/)  

### RStudio (get latest version)
- [Download links](https://www.rstudio.com/products/rstudio/download/#download)  

## Suggested

### Markdown (v. 1.0.1)  
- [Windows/OS X](https://daringfireball.net/projects/markdown/)  

### (La)TeX: 
- [MiKTeX (Windows)](https://miktex.org/download)  
- [MacTeX (OS X)](http://tug.org/mactex/)  

## R packages to install

This workshop uses the following packages:

- [tidyverse](https://CRAN.R-project.org/package=tidyverse)
- [labelled](https://CRAN.R-project.org/package=labelled)
- [plotly](https://CRAN.R-project.org/package=plotly)
- [survey](https://CRAN.R-project.org/package=survey)
- [Rcpp](https://CRAN.R-project.org/package=Rcpp)
- [microbenchmark](https://CRAN.R-project.org/package=microbenchmark)
- [rvest](https://CRAN.R-project.org/package=rvest)
- [lubridate](https://CRAN.R-project.org/package=lubridate)
- [leaflet](https://CRAN.R-project.org/package=leaflet)
- [sf](https://CRAN.R-project.org/package=sf)
- [RColorBrewer](https://CRAN.R-project.org/package=RColorBrewer)
- [devtools](https://CRAN.R-project.org/package=devtools)


Once you've installed R and RStudio, open RStudio (or the base R app)
and run the following code:

```r
pkgs <- c('tidyverse','labelled','plotly','survey','Rcpp',
          'microbenchmark','rvest','lubridate','leaflet',
		  'sf','RColorBrewer','devtools')
install.packages(pkgs)
```

You will also need the development version of ggplot2 from
GitHub. Once you've installed devtools, run the following code:

```r
devtools::install_github('tidyverse/ggplot2')
```

##### NOTE 
You may be asked to choose a download mirror. Just pick one that
is nearby.
