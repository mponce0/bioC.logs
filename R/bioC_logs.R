bioC_downloads <- function(pckg=NULL, format="bioC", from=NULL,to=NULL, when=NULL, verbose=TRUE) {
#' function to download logs from bioConductor stats
#' @param  pckg  list of packages names
#' @param  format  two options: "bioC" (default) will report the downloads as reported by bioconductor, ie. "Year  Month  Nb_of_distinct_IPs  Nb_of_downloads"; or, "CRAN" will report as CRAN logs does, ie. "Date  counts  package_Name" (in cranlogs 'Nb_of_downloads' are referred as 'counts')
#' @param  from  date in "MM-YYYY" format, specifying the initial date to be considered (optional argument)
#' @param  to  date in "MM-YYYY" format, specifying the final date to be considered (optional argument)
#' @param  when  optional argument, to specify pre-defined range dates; ie. 'ytd', 'year-to-date', 'last-year'
#' @param  verbose  boolean flag indicating whether to print information about the processes...
#'
#' @return a list containing a dataframe per package entered with columns as indicated by the format argument
#'
#' @importFrom utils  read.table
#' @importFrom stats  na.omit
#' @export
#'
#' @examples
#' bioC_downloads(c("ABarray","a4Classif"))
#' bioC_downloads("edgeR", verbose=FALSE)
#' edgeR.logs <- bioC_downloads("edgeR", format="CRAN")
#' edgeR.logs <- bioC_downloads("edgeR", when='last-year', format='bioC')
#' edgeR.logs <- bioC_downloads("edgeR", to='03-2015', format='bioC')
#' edgeR.logs <- bioC_downloads("edgeR", from='03-2015', format='bioC')
#' edgeR.logs <- bioC_downloads("edgeR", from='03-2015',to='05-2016', format='bioC')

	## function to inform the user about some general observations
	bioC_disclaimer <- function() {
		header <- paste(paste(rep("-",80),collapse=''), '')
		msg <- paste(header,
			"The BioConductor website reports total downloads per month.",
			"The data also includes an 'all' entry, representing the total downloads per year.",
			"All the month are reported independently of whether this is the current year and data is still not available.",
			"You may notice this when requesting the data using the default format from BioConductor.",
			header, sep='\n')

		message(msg)
	}


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

	###############################

	# define valid formats
	fmt.opts <- c("bioC","CRAN")

	# define date ranges for 'when'
	when.opts <- c("ytd","year-to-date","last-year","year-from-now")
	date.range <- NULL

	# Define bioConductor URL and file ending
	bioC.url <- "http://bioconductor.org/packages/stats/bioc/"
	ending <- "_stats.tab"

	# define day to when assign the value of downloads (bioConductor stats report monthly values)
	# will pcik '28' as last day of the month, to avoid issues with Feb...
	# day.assign <- "28"

	# initialize container for results
	pckgs.stats <-c() 


	#######

	# check valid argument
	if (is.null(pckg) || !is.character(pckg)) {
		stop("Must specify a valid package name!")
	}

	# check valid format
	if (!is.character(format) | !(format %in% fmt.opts) ) {
		stop("Invalid 'format'! Possible optiosn are: ", paste(fmt.opts,collapse=" "))
	}

	# check valid dates
	if ( (!is.null(from) | !is.null(to))  &  !is.null(when) )
		stop("Options 'from'/'to' and 'when' can not be combined. \n You either must specify a range 'from'-'to' or use 'when'.")

	# check whether the argument 'when' has been specified
        if (!is.null(when)) {
		if (tolower(when) %in% when.opts) {
			if (tolower(when) == "ytd" | tolower(when) == "year-to-date") {
				date.range <- year.to.date()
			} else if (tolower(when) == "last-year") {
				date.range <- lst.year()
			} else if (tolower(when) == "year-from-now") {
				date.range <- year.from.now()
			}
		} else {
			message("Unrecognized option for argument 'when', valid ones are: ", paste(when.opts,collapse=" "))
		}
	}

	# check whether 'from/to' was specified
	if (!is.null(from) | !is.null(to)) {
		date.range <- checkValidDates(from,to)
	}

	# if format was set to 'CRAN' and not date range was specified, set it to origin and current date
	if (format=="CRAN" & is.null(from) & is.null(to) & is.null(when)) {
		date.range <- checkValidDates(NULL,NULL)
	}


	# check that verbose is a boolean
	if (!is.logical(verbose)) {
		stop("'verbose' should be a Boolean variable, i.e. TRUE or FALSE!")
	}
	#######


	# Counter for detection or problems, defined within the pckg environ to avoid global variables, ie. <<- 
	pkg.env <- new.env()
	pkg.env$problems <- 0

	# process package list
	for (ind.pckg in seq_along(pckg)) {
		pck <- pckg[ind.pckg]

		pckgFile <- paste0(pck,'/',pck,ending)
		pckg.URL <- paste0(bioC.url,pckgFile)

		# Attempt to protect against bad internet conenction or misspelled package name
		tryCatch(
			{
			# read data
			pckg.data <- read.table(pckg.URL, header=TRUE)

			# this implies that a range of dates have been specified
			#if (!is.null(when) | (!is.null(from) & !is.null(to)) ) {
if(!is.null(date.range)) {
			# check whether the argument 'when' has been specified
#			if (!is.null(when)) {
#				if (tolower(when) %in% when.opts) {
#					if (tolower(when) == "ytd" | tolower(when) == "year-to-date") {
#						date.range <- year.to.date()
#					} else if (tolower(when) == "last-year") {
#						date.range <- lst.year()
#					} else if (tolower(when) == "year-from-now") {
#						date.range <- year.from.now()
#					}
				# hence will have to remove the 'all'
				pckg.data <- pckg.data[!as.character(pckg.data$Month)=="all",]

					# restrict subset to specified dates...
					# will assign the last day of the month for each specific entry
					day.assign <- sapply(paste(pckg.data$Month,pckg.data$Year,sep='-'),last.day.month)
					pckg.dates <- paste(pckg.data$Year,pckg.data$Month,day.assign,sep='-')
					#.#.#pckg.dates <- paste(pckg.data$Year,pckg.data$Month,last.day.month(pckg.data$Month,pckg.data$Year), sep='-')
					# re-format dates to match YYYY-mm-dd
					pckg.dates <- format(as.Date(pckg.dates, format = "%Y-%b-%d"), "%Y-%m-%d")
					# select the entries within the actual range of dates
					# na.omit() is necessary as bioC-logs include totals per month labelled "all"
					pckg.data <- na.omit(pckg.data[((pckg.dates > date.range[[1]]) & (pckg.dates < date.range[[2]])),])
#				} else {
#					message("Unrecognized option for argument 'when', valid ones are: ", paste(when.opts,collapse=" "))
#				}
			}


			# reformat data into CRAN format
                        if (format=="CRAN") {
                                if (ind.pckg==1 && verbose) message("Data will be returned as 'date  counts  packageName'")

                                # clean the entrie 'all' totals per year...
                                clean.data <- pckg.data[!as.character(pckg.data$Month)=="all",]
				# set the date to the last day of the month
				day.assign <- sapply(paste(clean.data$Month,clean.data$Year,sep='-'),last.day.month)
                                pckg.dates <- paste(clean.data$Year,clean.data$Month,day.assign,sep='-')

				#new.df <- data.frame( date=as.Date(paste0(day.assign,clean.data$Month,clean.data$Year), "%d%b%Y"),
				new.df <- data.frame( date=as.Date(pckg.dates, '%Y-%b-%d'),
				#.#.#new.df <- data.frame( date=as.Date(paste0(last.day.month(clean.data$Month,clean.data$Year),clean.data$Month,clean.data$Year), "%d%b%Y"),
							# in cranlogs 'Nb_of_downloads' are referred as 'counts'
							counts=as.numeric(clean.data$Nb_of_downloads),
							package=pck )

				# in cranlogs, also the dates are ordered...
				new.df <- new.df[order(as.Date(new.df$date,format='%Y-%b-%d')),]
                                pckg.data <- new.df
                        }

			pckgs.stats[[ind.pckg]] <- pckg.data 
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
		message(paste(ind.pckg-pkg.env$problems)," packages processed from a total of ",ind.pckg," requests!")
		if ((ind.pckg-pkg.env$problems) != 0) {
			message("Data was retrieved from ",bioC.url," using the *",format,"* format.")
			if (verbose) bioC_disclaimer()
		}

		# problems report
		if (pkg.env$problems != 0)
			message(pkg.env$problems," problems detected, the associated entry will be set to NULL")
	}

	# return results
	return(pckgs.stats)
}


##### //////////////////////////////////////////////////////////////////////////// #####

