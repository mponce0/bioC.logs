bioC_downloads <- function(pckg=NULL, format="bioC", verbose=TRUE) {
#' function to download logs from bioConductor stats
#' @param  pckg  list of packages names
#' @param  format  two options: "bioC" (default) will report the downloads as reported by bioconductor, ie. "Year Month Nb_of_distinct_IPs Nb_of_downloads"; or, "CRAN" will report as CRAN logs does, ie. "Date  Nb_of_downloads package_Name"
#' @param  verbose  boolean flag indicating whether to print information about the processes...
#'
#' @return a list containing a dataframe per package entered with columns as indicated by the format argument
#'
#' @importFrom utils  read.table
#' @export
#'
#' @examples
#' bioC_downloads(c("ABarray","a4Classif"))
#' bioC_downloads("edgeR",verbose=FALSE)
#' edgeR.logs <- bioC_downloads("edgeR",format="CRAN")
#' 

	## function for error handling
	errorHandling.Msg <- function(condition,pck) {
		message("A problem was detected when trying to retrieve the data for the package: ",pck)
		if (grepl("404 Not Found",condition)) {
			message("It is possible that you misspeled the name of this package! Please check!")
		} else {
			message("It is possible that your internet connection is down! Please check!")
		}
		message(condition,'\n')

		# update problems counter
		pkg.env$problems <- pkg.env$problems + 1
	}


	# Define bioConductor URL and file ending
	bioC.url <- "http://bioconductor.org/packages/stats/bioc/"
	ending <- "_stats.tab"

	# initialize container for results
	pckgs.stats <-c() 

	# check valid argument
	if (is.null(pckg) || !is.character(pckg)) {
		warning("Must specify a valid package name!")
		return(NULL)
	}

	# Counter for detection or problems, defined within the pckg environ to avoid global variables, ie. <<- 
	pkg.env <- new.env()
	pkg.env$problems <- 0

	# process package list
	for (i in seq_along(pckg)) {
		pck <- pckg[i]

		pckgFile <- paste0(pck,'/',pck,ending)
		pckg.URL <- paste0(bioC.url,pckgFile)

		# Attempt to protect against bad internet conenction or misspelled package name
		tryCatch(
			{
			pckg.data <- read.table(pckg.URL, header=TRUE)

			if (format=="CRAN") {
				if (i==1 && verbose) message("Data will be returned as 'date  downloads  packageName'")

				# clean the entrie 'all' totals per year...
				clean.data <- pckg.data[!as.character(pckg.data$Month)=="all",]
				new.df <- data.frame(date=as.Date(paste0("28",clean.data$Month,clean.data$Year), "%d%b%Y"),
					downloads=as.numeric(clean.data$Nb_of_downloads), package=pck)
				pckg.data <- new.df
			}

			pckgs.stats[[i]] <- pckg.data 
			},

			# warning
			warning = function(cond) {
					errorHandling.Msg(cond,pck)
				},
			# error
			error = function(e){
					errorHandling.Msg(e,pck)
				}
			)
	}

	# final report
	if (verbose) {
		message(paste(i-pkg.env$problems)," packages processed from a total of ",i," requests!")
		if ((i-pkg.env$problems) != 0) message("Data was retrieved from ",bioC.url," using the *",format,"* format.")

		# problems report
		if (pkg.env$problems != 0)
			message(pkg.env$problems," problems detected, the associated entry will be set to NULL")
	}

	# return results
	return(pckgs.stats)
}
