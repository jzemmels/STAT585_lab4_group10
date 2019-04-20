# 

# Change Date variable from character class to date class
d <- d %>% separate(date,c("date","time"),sep="T") %>% select(-time)
d <- d %>% mutate(date = ymd(date))

# Change columns to numeric
num_cols <- c('county_number','pack','sale_gallons','state_bottle_retail',
              'bottle_volume_ml','itemno','sale_bottles','sale_liters',
              'sale_dollars','state_bottle_cost','store_location_zip','zipcode')
d[,num_cols] = apply(d[,num_cols], 2, function(x) as.numeric(x))

# Clean up store location
dflat <- flatten(flatten(d))
store_location_lat <- as.numeric(unlist(as.character(purrr::map(dflat$store_location.coordinates, function(d) d[[1]]))))
store_location_long <- as.numeric(unlist(as.character(purrr::map(dflat$store_location.coordinates, function(d) d[[2]]))))
d <- cbind(d, store_location_lat, store_location_long)
d <- d %>% select(-store_location)