# auxs-utils.R
#  -- M.Ponce


#################################################################################################
##	Auxiliary Utilities file for the bioC.logs package
#
#	Generic auxiliary functions
#
#################################################################################################


### date's aux fns
year.to.date <- function(){
#' function that returns the range dates for the period year-to-date 
#' @keywords internal
	cur.date <- Sys.Date()

	cur.year <- substr(cur.date,1,4)
	return(list(paste(cur.year,"01","01",sep='-'),as.character(cur.date)))
}

lst.year <- function() {
#' function that returns the range dates for the last year 
#' @keywords internal
        cur.date <- Sys.Date()

        last.year <- as.integer(substr(cur.date,1,4))-1
        return(list(paste(last.year,"01","01",sep='-'),paste(last.year+1,"01","01",sep='-')))

}

year.from.now <- function() {
#' function that returns the date from one year ago
#' @keywords internal
        cur.date <- Sys.Date()
        cur.year <- substr(cur.date,1,4)
        lst.year <- as.integer(cur.year) - 1
        t0 <- paste(lst.year,substr(cur.date,5,10),sep="")

        return(list(t0,cur.date))
}

today <- function() {
#' function that returns the current date 
#' @keywords internal
	t1 <- Sys.Date()
	# Will substract 1 to do not consider today, but yesterday
	# this matches the definition from cran_downloads too
	t1 <- t1 - 1 
	message("Ending date was not specifed, will assume today: ",t1)
	return(format(t1,format="%d-%m-%Y"))
}

origin.of.times <- function() {
#' function that provides a "beginning of times" default date
#' @keywords internal
	t0 <- as.Date("1980-01-01",format="%Y-%m-%d")
	message("Initial date was not specified, will assume:", t0)
	return(format(t0,format="%d-%m-%Y"))
}



Xyear.from.now <- function() {
#' function that returns the date from one year ago
#' @keywords internal
	cur.date <- Sys.Date()-1
	cur.year <- substr(cur.date,1,4)
	lst.year <- as.integer(cur.year) - 1
	t0 <- paste(lst.year,substr(cur.date,5,10),sep="")

	message("Starting date was not specified, will assume a year from now: ",t0)
	return(t0)
}

checkDates <- function(t0,t1) {
#' function to check dates, ie that t0<t1 and t0!=t1
#' @param  t0  initial date
#' @param  t1  final date
#' @return a list with t0 being [[1]] and t1 being [[2]]
#'
#' @keywords internal

	# check if there is any missing date
	if (is.null(t0)) t0 <- origin.of.times()
	if (is.null(t1)) t1 <- as.Date(today(),format="%d-%b-%Y")

	# check whether t0 is greater than t1
	if (as.Date(t0) > as.Date(t1)) {
		# flip dates, t0 will be set to the older date
		ttemp <- t0
		t0 <- t1
		t1 <- ttemp
	} else if (as.Date(t0) == as.Date(t1)) {
		# dates should be different
		stop(t0," and ", t1," should be different!")       
	}

	return(list(t0,t1))
}

checkDate <- function(date.candidate) {
#' function to check date format for "MM-YYYY"
#' @param  date.candidate  date candidate
#' 
#'
#' @keywords internal

	# bisecting month and year...
	MM <- as.integer(substr(date.candidate,1,2))
	YYYY <- as.integer(substr(date.candidate,4,7))

	if ( !is.numeric(MM) |  ((MM<1) | (MM>12)) )
		stop(paste("Problem detected with date: ",date.candidate,"\n","Dates should be specified in 'MM-YYYY' format, with MM from '01' to '12'"))

	if (!is.numeric(YYYY))
		stop(paste("Problem detected with date: ",date.candidate,"\n","Dates should be specified in 'MM-YYYY' format, with MM from '01' to '12'"))
}
	

checkValidDates <- function(t0,t1) {
#' function to check dates, ie that t0<t1 and t0 and t1 are in MM-YYYY format
#' @param  t0  initial date
#' @param  t1  final date
#' @return a list with t0 being [[1]] and t1 being [[2]]
#'
#' @keywords internal

	# check date structure for t0 & t1
	if (!is.null(t0)) {
		checkDate(t0)
	} else {
		t0 <- substr(origin.of.times(),4,10)
	}
	if (!is.null(t1)) {
		checkDate(t1)
	} else {
		t1 <- substr(today(),4,10)
	}

	fake.t0 <- as.Date(paste0("01-",t0),format='%d-%m-%Y')
	fake.t1 <- as.Date(paste0("01-",t1),format='%d-%m-%Y')
	#fake.t1 <- as.Date(paste0(last.day.month(

	# check candidate dates
	finalDates <- checkDates(fake.t0,fake.t1)

        #return(list(t0,t1))
	return(finalDates)
}



last.day.month <- function(MonthYear) {
#' function that returns the number of dates in a given month-year
#' @param  MonthYear  string containing month and year, ie. MM-YYYY
#' @return number of days --as characters-- in the given month-year
#'
#' @keywords internal

	# convert year to numeric
	year <- as.numeric(substr(MonthYear,5,8))
	month <- substr(MonthYear,1,3)

	# check for leap years
	leap = FALSE
	if ( (year %% 4 == 0 ) | ( year %% 100 == 0  &  year %% 400 == 0) )
		leap <-  TRUE

	# obtain number of days
	nbr.days <- switch(tolower(month),
			'jan' = 31,
			'feb' = 28 + leap,  # adds 1 if leap year
                	'mar' = 31,
                	'apr' = 30,
                	'may' = 31,
                	'jun' = 30,
                	'jul' = 31,
                	'aug' = 31,
                	'sep' = 30,
                	'oct' = 31,
                	'nov' = 30,
                	'dec' = 31 )

	return(as.character(nbr.days))
}


daysInMonth <- function(d = Sys.Date()){
#' function that returns the number of dates in a given date
#' @param  d  string containing a date in YYYY-MM-DD format
#' @return number of days in the given the date 
#'
#' @keywords internal

  m = substr((as.character(d)), 6, 7)              # month number as string
  y = as.numeric(substr((as.character(d)), 1, 4))  # year number as numeric

  # Quick check for leap year
  leap = 0
  if ((y %% 4 == 0 & y %% 100 != 0) | y %% 400 == 0)
    leap = 1

  # Return the number of days in the month
  return(switch(m,
                '01' = 31,
                '02' = 28 + leap,  # adds 1 if leap year
                '03' = 31,
                '04' = 30,
                '05' = 31,
                '06' = 30,
                '07' = 31,
                '08' = 31,
                '09' = 30,
                '10' = 31,
                '11' = 30,
                '12' = 31))
}



##### //////////////////////////////////////////////////////////////////////////// #####
##### //////////////////////////////////////////////////////////////////////////// #####
##### //////////////////////////////////////////////////////////////////////////// #####

