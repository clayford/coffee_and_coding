# Rolling Joins

# https://dtplyr.tidyverse.org/

# "Some data.table expressions have no direct dplyr equivalent. For example,
# there’s no way to express cross- or rolling-joins with dplyr."

library(data.table)
# library(lubridate)


# 0. review join ----------------------------------------------------------

dat1 <- data.frame(id = 1:5, x = 15:11)
dat2 <- data.frame(id = c(4,4,5,5,6), y = c(2,4,6,7,10))

dat1
dat2

dplyr::left_join(dat1, dat2, by = "id")
dplyr::right_join(dat1, dat2, by = "id")
dplyr::inner_join(dat1, dat2, by = "id")
dplyr::full_join(dat1, dat2, by = "id")

# data.table joins

dat1 <- as.data.table(dat1)
dat2 <- as.data.table(dat2)

# look up dat2 rows using dat1 (left join)
# dplyr::left_join(dat1, dat2, by = "id")
dat2[dat1, on="id"]

# look up dat1 rows using dat2 (right join)
# dplyr::right_join(dat1, dat2, by = "id")
dat1[dat2, on="id"]

# inner join
dat1[dat2, on="id", nomatch = NULL]

# outer join
merge(dat1, dat2, by = "id", all = TRUE)


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


# Look up d2 rows using d1
# merge d2 records into d1 that come before;
# d1 dates are preserved
d2[d1, on="date"]
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


# data logged every 10 minutes
dates1 <- lubridate::make_datetime(year = 2022,
                                   month = 01, 
                                   day = 10, 
                                   hour = 2, 
                                   min = c(0,10))
mt1 <- data.frame(date = dates1,
                  X = 1:2)
mt1

# time some event occurred
dates2 <- lubridate::make_datetime(year = 2022, 
                                   month = 01, 
                                   day = 10, 
                                   hour = 2, 
                                   min = 8)
mt2 <- data.frame(date = dates2,
                  Y = 1)
mt2


mt1 <- as.data.table(mt1)
mt2 <- as.data.table(mt2)

mt1;mt2

# Merge mt1 data with mt2
# roll forward, just before
mt1[mt2, on = "date", roll = TRUE]

# roll backward, just after
mt1;mt2
mt1[mt2, on = "date", roll = -Inf]

# roll nearest
mt1[mt2, on = "date", roll = "nearest"]

# roll within 60 seconds before (1 minute)
mt1[mt2, on = "date", roll = 60]

# roll within 5 minutes
mt1[mt2, on = "date", roll = 5*60]

# roll within 60 seconds after
mt1[mt2, on = "date", roll = -60]

# roll within 3 minutes after
mt1[mt2, on = "date", roll = 3*-60]


mt2[mt1, on = "date", roll = TRUE]
mt2[mt1, on = "date", roll = TRUE, rollends = c(T, T)]
mt2[mt1, on = "date", roll = TRUE, rollends = c(F, F)]
mt2[mt1, on = "date", roll = TRUE, rollends = c(T, F)]
mt2[mt1, on = "date", roll = TRUE, rollends = c(F, T)]




# Data to use for exercises

# monitor 1 - regular measures - every 10 minutes
set.seed(1)
dt1 <- lubridate::make_datetime(year = 2022, month = 01, day = 10, 
                           hour = rep(c(2,3,4), each = 6), 
                           min = rep(seq(0,50,10), 3))
d1 <- data.frame(date = dt1,
                 d1_date = dt1, 
                 d1 = round(rnorm(6*3, 6), 2))
head(d1)

# monitor 2 - time of observed events
set.seed(2)
dt2 <- lubridate::make_datetime(year = 2022, month = 01, day = 10, 
                     hour = sample(2:4, 5, replace = TRUE),
                     min = sample(3:57, 5, replace = TRUE))
d2 <- data.table(date = sort(dt2),
                 d2 = round(rnorm(5, 10), 2))
d2

d1 <- as.data.table(d1)
d2 <- as.data.table(d2)

# roll d1 forward, just before
d1[d2, on = "date", roll = TRUE]

# drop d1_date column
d1[d2, on = "date", roll = TRUE][,!("d1_date")]

# roll backward, just after
d1[d2, on = "date", roll = -Inf]

# roll nearest (closest before or after)
d1[d2, on = "date", roll = "nearest"]

# roll within 1 minute before (60 seconds)
d1[d2, on = "date", roll = 60]

# roll within 5 minutes before (5 * 60)
d1[d2, on = "date", roll = 5*60]

# roll within 8 minutes after (-8 * 60)
d1[d2, on = "date", roll = -8*60]


