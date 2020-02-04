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


## Features

* The function will return a list containing a dataframe per package entered with columns as indicated by the `format` argument.
Notice that when the `format` is set to "CRAN", the date will be formatted to days-month-year. Because BioConductor reports only totals per month the "day" in this case will be set to **28** for every month.

* The function will also attempt to report when a package names has been misspelled or just the server is not reachable.
If you are receiving warning messages please check either of these situations.

### Obervations
* The BioConductor website reports total downloads per month.
* The original data also includes an 'all' entry, representing the total downloads per year.
* All the month are reported independently of whether this is the current year and data is still not available.
* You may notice this when requesting the data using the default format from BioConductor, ie. format="bioC".


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

edgeR.logs <- bioC_downloads("edgeR",format="CRAN")
# data is still returned in a list
str(edgeR.logs)
edgeR.logs[[1]]
```
