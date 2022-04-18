# Rolling Joins

# https://dtplyr.tidyverse.org/

# "Some data.table expressions have no direct dplyr equivalent. For example,
# there’s no way to express cross- or rolling-joins with dplyr."

library(data.table)
library(lubridate)


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



# monitor 1 data
mt1_dates <- lubridate::make_datetime(year = 2022, month = 01, day = 10, 
                           hour = 2, min = c(0,8))
mt1 <- data.frame(date = mt1_dates,
                  X = 1:2)
mt1

# monitor 2 data collecting Y every 3 minutes
mt2_dates <- lubridate::make_datetime(year = 2022, month = 01, day = 10, 
                           hour = 2, min = 5)
mt2 <- data.frame(date = mt2_dates,
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
mt2[mt1, on = "date", roll = -Inf]


mt2[mt1, on = "date", roll = TRUE, rollends = c(T, T)]
mt2[mt1, on = "date", roll = TRUE, rollends = c(F, F)]
mt2[mt1, on = "date", roll = TRUE, rollends = c(T, F)]
mt2[mt1, on = "date", roll = TRUE, rollends = c(F, T)]




# Data to use for exercises

# monitor 1 data collecting X every 5 minutes
dt1 <- lubridate::make_datetime(year = 2022, month = 01, day = 10, 
                           hour = rep(c(2,3), each = 30), 
                           min = rep(seq(0, 58, 2), 2))
set.seed(1)
d2 <- data.frame(date = dt1,
                  X = round(rnorm(60), 2))
d2

# monitor 2 data collecting Y every 7 minutes
dt2 <- lubridate::make_datetime(year = 2022, month = 01, day = 10, 
                     hour = rep(c(2,3), each = 12),
                     min = sample(1:59, 24, replace = TRUE))
set.seed(2)
d2 <- data.frame(date = sort(dt2),
                  Y = round(rnorm(24,5), 2))
d2

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