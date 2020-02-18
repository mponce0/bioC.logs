# bioC.logs

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version-last-release/bioC.logs)](https://cran.r-project.org/package=bioC.logs)
[![Downloads](https://cranlogs.r-pkg.org/badges/bioC.logs)](https://cran.r-project.org/package=bioC.logs)

## Introduction
This package allows you to download the statistics of BioConductor packages'
downloads as reported by http://bioconductor.org/packages/stats/.


## Usage
The main function of this package is called ```bioC_downloads```.
The function accepts several arguments: `packages names`, `format`, `from/to` **or** `when` and `verbose`.

argument	 | Description
-----------|---------------
`packages names` | is the name(s) of the package(s) you want to download the stats, for multiple package it should be a list of the packages names
`format`     | accepts two options: `"bioC"` (default) will report the downloads as reported by bioconductor, ie. *"Year Month Nb_of_distinct_IPs Nb_of_downloads"*; or, `"CRAN"` will report as CRAN logs does, ie. *"Date  Nb_of_downloads package_Name"*
`from/to`    | optional arguments to indicate range of dates to recover the data within -- can NOT be used in combination with `when`
`when`       | optional argument to specify the range of dates to recover the data within -- can NOT be used in combination with `from/to`; possible options are "`ytd`","`year-to-date`","`year-from-now`","`last-year`"
`verbose`    | is a boolean flag indicating whether to print information about the processes
---------------------------


## Features

* The function will return a list containing a dataframe per package entered with columns as indicated by the `format` argument.
Notice that when the `format` is set to "CRAN", the date will be formatted to days-month-year. Because BioConductor reports only totals per month the "day" in this case will be set to the last date of the corresponding month/year.

* The function will also attempt to report when a package names has been misspelled or just the server is not reachable.
If you are receiving warning messages please check either of these situations.

### Obervations
* The BioConductor website reports total downloads per month.
* The original data also includes an 'all' entry, representing the total downloads per year.
* All the month are reported independently of whether this is the current year and data is still not available.
* You may notice this when requesting the data using the default format from BioConductor, ie. format="bioC".

* When using `format="CRAN"`:
	- the `all` entry is removed
	- the last month to be reported is the previous to the current one, ie. months in the future with no data or the current one (with incomplete data) will not be reported
	- the entries will be order cronologically from the oldest to the newest records


## Installation

For using the "bioC.logs" package, first you will need to install it.

The stable version can be downloaded from the CRAN repository:
```
install.packages("bioC.logs")
```

To obtain the development version you can get it from the github repository, i.e.
```
# need devtools for installing from the github repo
install.packages("devtools")

# install bioC.logs
devtools::install_github("mponce0/bioC.logs")
```

For using the package, either the stable or developmemnt version, just load it
using the library function:
```
# load bioC.logs
library(bioC.logs)
```


## Examples
You will need an active internet connection, as bioC.logs will download the
reports from the BioConductor website on demand.

```
# it is possible to download multiple packages, the data will be returned in a list with one entry per package
bioC_downloads(c("ABarray","a4Classif"))

# the 'verbose' option allow you to turn off information reported by the function
bioC_downloads("edgeR",verbose=FALSE)

# setting format="CRAN", will structure the data "a-la-CRAN"
edgeR.logs <- bioC_downloads("edgeR",format="CRAN")
# data is still returned in a list
str(edgeR.logs)
# access data from package
edgeR.logs[[1]]

# get the data in a particular range of dates using 'when'
edgeR.logs <- bioC_downloads("edgeR", when='last-year', format='bioC')

# get the data in a particular range of dates using 'to/from'
# not specifying 'from' will assume since the very first record
edgeR.logs <- bioC_downloads("edgeR", to='03-2015', format='bioC')

# not specifying 'from' will assume until the current day
edgeR.logs <- bioC_downloads("edgeR", from='03-2015', format='bioC')

edgeR.logs <- bioC_downloads("edgeR", from='03-2015',to='05-2016', format='bioC')
```
