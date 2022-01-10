# Working with Dates in R

# 1. format dates and date-times
# 2. extract date components
# 3. calculate elapsed time (days, months, weeks)


# Tip: always use 4 digit years and use ymd order: 2020-02-23

library(lubridate)

# Dates formatted as number of days since Jan 1, 1970
# Date-times formatted as number of seconds since Jan 1, 1970

# Dates
d <- "January 10, 2022"
typeof(d)

d <- mdy(d)
d # prints like character string, but is actually a number
str(d)

# number of days since Jan 1, 1970
as.numeric(d)

# every permutation of m, d, y are available as a function:
ymd("2001-02-23") |> as.numeric()
dmy("01/01/2001") |> as.numeric()

# add hms for hours, minutes and seconds
d2 <- mdy_hms("Feb 23, 2003 3:45:23")

str(d2)

# number of seconds since Jan 1, 1970
as.numeric(d2)


# Why do this?
# - extract day of week, month, year
# - proper ordering of days and months
# - calculate elapsed time
# - proper formatting in plots

month(d)
month(d, label = TRUE)
month(d, label = TRUE, abbr = FALSE)

wday(d)
wday(d, label = TRUE)
wday(d, label = TRUE, abbr = FALSE)
wday(d, label = TRUE, abbr = FALSE, week_start = 1) # start on Monday

year(d)
mday(d)
yday(d) # year day


d2 <- c("4/5/73", "1/10/22")
d2 <- mdy(d2)

d2[2] - d2[1]
interval(d2[1], d2[2])
time_length(interval(d2[1], d2[2]), unit = "years")

# St. Helens volcano
# https://volcano.si.edu/volcano.cfm?vn=321050
# Last 4 eruptive periods

msh <- data.frame(start = c("2004 Oct 1", 
                            "1990 Nov 5", 
                            "1989 Dec 7", 
                            "1980 Mar 27"),
                    stop = c("2008 Jan 27", 
                             "1991 Feb 14", 
                             "1990 Jan 6", 
                             "1986 Oct 28"))
str(msh)

msh$start <- ymd(msh$start)
msh$stop <- ymd(msh$stop)
msh$interval <- interval(msh$start, msh$stop) |> time_length("days")
msh

msh$interval_days <- msh$stop - msh$start
msh$interval_months <- interval(msh$start, msh$stop) |> time_length("months")


# La Palma volcano (Spain)
# last 7 events
# https://volcano.si.edu/volcano.cfm?vn=383010
lp <- data.frame(start = c("2021 Sep 19",
                           "1971 Oct 26",
                           "1949 Jun 24",
                           "1712 Oct 9 ",
                           "1677 Nov 17",
                           "1646 Oct 2 ",
                           "1585 May 19"),
                 stop = c("2021 Dec 9 ",
                          "1971 Nov 18",
                          "1949 Jul 30",
                          "1712 Dec 3 ",
                          "1678 Jan 21",
                          "1646 Dec 21",
                          "1585 Aug 10"))
lp

# Exercises:
# - format dates
# - extract components
# - duration of events
# - time between events