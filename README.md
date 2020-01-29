# bioC.logs

## Introduction
This package allows you to download the statistics of BioConductor packages'
downloads as reported by http://bioconductor.org/packages/stats/.


## Usage
The main function of this package is called ```bioC_downloads```.
The function accepts several arguments: `packages names`, `format` and `verbose`.

argument	 | Description
-----------|---------------
`packages names` | is the name(s) of the package(s) you want to download the stats, for multiple package it should be a list of the packages names
`format`     | accepts two options: `"bioC"` (default) will report the downloads as reported by bioconductor, ie. *"Year Month Nb_of_distinct_IPs Nb_of_downloads"*; or, `"CRAN"` will report as CRAN logs does, ie. *"Date  Nb_of_downloads package_Name"*
`verbose`    | is a boolean flag indicating whether to print information about the processes
---------------------------

The function will return a list containing a dataframe per package entered with columns as indicated by the `format` argument

The function will also attempt to report when a package names has been misspelled or just the server is not reachable.
If you are receiving warning messages please check either of these situations.


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

bioC_downloads("edgeR",verbose=FALSE)

bioC_downloads("edgeR",format="CRAN")
```
