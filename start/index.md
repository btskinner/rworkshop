---
layout: default
---

# Software links

Unless you have experience building from source, select the binary
download that matches your operating system (e.g., Windows, OS
X/MacOS). If no options are available, the download will work on all
systems.

## Required
### R (version 3.4.3)  
- [Windows](https://cran.r-project.org/bin/windows/base/)  
- [OS X](https://cran.r-project.org/bin/macosx/)  

### RStudio (version 1.1.383)
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
- [RColorBrewer](https://CRAN.R-project.org/package=RColorBrewer)
- [xtable](https://CRAN.R-project.org/package=xtable)

Once you've installed R and RStudio, open RStudio (or the base R app)
and run the following code:

```r
pkgs <- c('tidyverse','labelled','plotly','RColorBrewer','xtable')
install.packages(pkgs)
```

##### NOTE 
You may be asked to choose a download mirror. Just pick one that
is nearby.
