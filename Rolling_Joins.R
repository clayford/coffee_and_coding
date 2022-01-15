# Rolling Joins

# https://dtplyr.tidyverse.org/

# "Some data.table expressions have no direct dplyr equivalent. For example,
# there’s no way to express cross- or rolling-joins with dplyr."

library(data.table)

set.seed(1)
d1 <- data.table(
  x = round(runif(10, 1, 40)),
  date = as.POSIXct(strptime(
    c("2018-10-18 2:00:00", 
      "2018-10-18 2:05:00",
      "2018-10-18 2:10:00",
      "2018-10-18 2:15:00",
      "2018-10-18 2:20:00",
      "2018-10-18 2:25:00",
      "2018-10-18 2:30:00",
      "2018-10-18 2:35:00",
      "2018-10-18 2:40:00",
      "2018-10-18 2:45:00"), 
    "%Y-%m-%d %H:%M:%S")))

set.seed(2)
d2 <- data.table(
  y = round(runif(6, 3, 30),2),
  date = as.POSIXct(strptime(
    c("2018-10-18 1:52:00", 
      "2018-10-18 2:02:00",
      "2018-10-18 2:12:00",
      "2018-10-18 2:22:00",
      "2018-10-18 2:32:00",
      "2018-10-18 2:42:00"), 
    "%Y-%m-%d %H:%M:%S")))

# left join; data from d1 joined with d2
# record from d1 just before time in d2 merged
d1[d2, on="date", roll = TRUE]

# record from d1 just after time in d2 merged
d1[d2, on="date", roll = -Inf]

