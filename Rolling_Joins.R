# Rolling Joins

# https://dtplyr.tidyverse.org/

# "Some data.table expressions have no direct dplyr equivalent. For example,
# there’s no way to express cross- or rolling-joins with dplyr."

library(data.table)
library(lubridate)


# 0. review join ----------------------------------------------------------

dat1 <- data.frame(id = 1:5, x = 15:11)
dat2 <- data.frame(id = 2:6, y = c(2,4,6,7,10))

dat1
dat2

dplyr::left_join(dat1, dat2, by = "id")
dplyr::right_join(dat1, dat2, by = "id")
dplyr::inner_join(dat1, dat2, by = "id")
dplyr::full_join(dat1, dat2, by = "id")

# data.table joins

dat1 <- as.data.table(dat1)
dat2 <- as.data.table(dat2)

# left join: look up dat2 rows using dat1
dat2[dat1, on="id"]
# right join: look up dat1 rows using dat2
dat1[dat2, on="id"]
# inner join
dat1[dat2, on="id", nomatch = NULL]


# 1. forward --------------------------------------------------------------


d1 <- data.frame(date = ymd("2022-01-01",
                            "2022-01-03",
                            "2022-01-07"),
                 x = 1:3)
d1

d2 <- data.frame(date = ymd("2022-01-02",
                            "2022-01-05"),
                 y = 1:2)
d2

d1 <- as.data.table(d1)
d2 <- as.data.table(d2)

# merge d2 records into d1 that come before;
# d1 dates are preserved
d2[d1, on="date", roll = TRUE]

# merge d2 records into d1 that come 1 day before;
# d1 dates are preserved
d2[d1, on="date", roll = 1]

# merge d2 records into d1 that come after;
# d1 dates are preserved
d2[d1, on="date", roll = -Inf]

# merge d2 records into d1 that come 1 day after;
# d1 dates are preserved
d2[d1, on="date", roll = -1]

# merge d2 records into d1 that come 3 days after;
# d1 dates are preserved
d2[d1, on="date", roll = -3]





# 
# 2. backward
# 3. within x days
# 4. nearest

# Data to use for exercises

# monitor 1 data collecting X
mt1_dates <- make_datetime(year = 2022, month = 01, day = 10, 
                           hour = 2, min = seq(0, 60, 5))
set.seed(1)
mt1 <- data.frame(date = mt1_dates,
                  X = round(rnorm(13), 2))
mt1

# monitor 2 data collecting Y
mt2_dates <- make_datetime(year = 2022, month = 01, day = 10, 
                           hour = 2, min = seq(1, 57, 7))
set.seed(2)
mt2 <- data.frame(date = mt2_dates,
                  Y = round(rnorm(9), 2))
mt2

# Merge mt1 data with mt2
mt1 <- as.data.table(mt1)
mt2 <- as.data.table(mt2)

# roll forward, just before
mt1[mt2, on = "date", roll = TRUE]

# roll backward, just after
mt1[mt2, on = "date", roll = -Inf]

# roll nearest
mt1[mt2, on = "date", roll = "nearest"]

# roll within 60 seconds before (1 minute)
mt1[mt2, on = "date", roll = 60]

# roll within 120 seconds after (2 minutes)
mt1[mt2, on = "date", roll = -120]

