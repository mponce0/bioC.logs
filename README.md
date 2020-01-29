# bioC.logs

## Introduction
This package allows you to download the statistics of BioConductor packages'
downloads as reported by http://bioconductor.org/packages/stats/.


## Usage
The main function of this package is called ```bioC_downloads```.
The function accepts several arguments:

bioC_downloads("edgeR",format="CRAN")

## Installation

For using the "bioC.logs" package, first you will need to install it.

Thes table version can be downloaded from the CRAN repository:
```
install.packages("bioC.logs")
```

To obtain the development version you can get it from the github repository, i.e.
```
# need devtools for installing from the github repo
install.packages("devtools")

# install bioC.logs
devtools::install_github("mponce0/bioC.logs")

# load bioC.logs
library(bioC.logs)
```


## Examples
You will need an active internet connection, as bioC.logs will download the
reports from the BioConductor website on demand.

```
bioC_downloads(c("ABarray","a4Classif"))

bioC_downloads("edgeR",format="CRAN")
```
