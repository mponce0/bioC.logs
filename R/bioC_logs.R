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
#' bioC_downloads("edgeR",format="CRAN")
#'

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

	# process package list
	for (i in seq_along(pckg)) {
		pck <- pckg[i]

		pckgFile <- paste0(pck,'/',pck,ending)
		pckg.URL <- paste0(bioC.url,pckgFile)

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
	}

	# final report
	if (verbose) message(paste(i,"packages processed, with data retrieved from",bioC.url))

	# return results
	return(pckgs.stats)
}
