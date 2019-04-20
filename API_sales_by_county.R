# Use the API to download liquor sales for story county (the first 1,000
# records). Reformat the data -- change variable names, variable classes, and
# column order -- to match the fomatting in Iowa_Liquor_Sales-Story.csv. Create
# a Store.Location variable from address, city, zip, and latitude and longitude
# data to match the formatting of the Store.Location variable in
# Iowa_Liquor_Sales-Story.csv. 
#
# Save the data as Iowa_Liquor_Sales-Story_1000.csv

library(tidyverse)
library(lubridate)
library(rvest)
library(jsonlite)

# Read data
url <- "https://data.iowa.gov/resource/m3tr-qhgy.json?county=Story"
d <- jsonlite::fromJSON(url)

# Change column names to match Iowa_Liquor_Sales-Story.csv

names(d)[names(d) == 'invoice_line_no'] <- 'Invoice.Item.Number'
names(d)[names(d) == 'name'] <- 'Store.Name'
names(d)[names(d) == 'zipcode'] <- 'Zip.Code'
names(d)[names(d) == 'county'] <- 'County'
names(d)[names(d) == 'vendor_no'] <- 'Vendor.Number'
names(d)[names(d) == 'vendor_name'] <- 'Vendor.Name'
names(d)[names(d) == 'state_bottle_cost'] <- 'State.Bottle.Cost'
names(d)[names(d) == 'sale_dollars'] <- 'Sale..Dolars.'
names(d)[names(d) == 'date'] <- 'Date'
names(d)[names(d) == 'address'] <- 'Address'
names(d)[names(d) == 'category'] <- 'Category'
names(d)[names(d) == 'im_desc'] <- 'Item.Description'
names(d)[names(d) == 'pack'] <- 'Pack'
names(d)[names(d) == 'state_bottle_retail'] <- 'State.Bottle.Retail'
names(d)[names(d) == 'state_bottle_retail'] <- 'Volume.Sold..Liters.'
names(d)[names(d) == 'store'] <- 'Store.Number'
names(d)[names(d) == 'store_location_city'] <- 'City'
names(d)[names(d) == 'county_number'] <- 'County.Number'
names(d)[names(d) == 'category_name'] <- 'Category.Name'
names(d)[names(d) == 'itemno'] <- 'Item.Number'
names(d)[names(d) == 'bottle_volume_ml'] <- 'Bottle.Volume..ml.'
names(d)[names(d) == 'store'] <- 'Store.Number'
names(d)[names(d) == 'sale_gallons'] <- 'Volume.Sold..Gallons.'
names(d)[names(d) == 'sale_bottles'] <- 'Bottles.Sold'
names(d)[names(d) == 'sale_liters'] <- 'Volume.Sold..Liters.'

# Create and format Store.Location variable to match Iowa_Liquor_Sales-Story.csv
dflat <- flatten(flatten(d))
store_location_lat <- as.numeric(unlist(as.character(purrr::map(dflat$store_location.coordinates, function(d) d[[1]]))))
store_location_long <- as.numeric(unlist(as.character(purrr::map(dflat$store_location.coordinates, function(d) d[[2]]))))
d <- cbind(d, store_location_lat, store_location_long)
d <- d %>% mutate(city.zip = paste(city,Zip.Code),
             lat.lon = paste0("(",store_location_lat,', ',store_location_long,")"),
             Store.Location = factor(paste(Address,city.zip,lat.lon,sep="\n")))

# Reorder columns to match Iowa_Liquor_Sales-Story.csv
d <- d %>% select(Invoice.Item.Number,
             Date,
             Store.Number,
             Store.Name,
             Address,
             City,
             Zip.Code,
             Store.Location,
             County.Number,
             County,
             Category,
             Category.Name,
             Vendor.Number,
             Vendor.Name,
             Item.Number,
             Item.Description,
             Pack,
             Bottle.Volume..ml.,
             State.Bottle.Cost,
             State.Bottle.Retail,
             Bottles.Sold,
             Sale..Dolars.,
             Volume.Sold..Liters.,
             Volume.Sold..Gallons.)

# Change variable classes to match Iowa_Liquor_Sales-Story.csv
d <- d %>% mutate(Invoice.Item.Number = factor(Invoice.Item.Number),
             Date = factor(Date),
             Store.Number = as.integer(Store.Number),
             Store.Name = factor(Store.Name),
             Address = factor(Address),
             City = factor(City),
             Zip.Code = as.integer(Zip.Code),
             County.Number = as.integer(County.Number),
             County = factor(County),
             Category = as.integer(Category),
             Category.Name = factor(Category.Name),
             Vendor.Number = as.integer(Vendor.Number),
             Item.Number = as.integer(Item.Number),
             Pack = as.integer(Pack),
             Bottle.Volume..ml. = as.integer(Bottle.Volume..ml.),
             State.Bottle.Cost = as.double(State.Bottle.Cost),
             State.Bottle.Retail = as.double(State.Bottle.Retail),
             Bottles.Sold = as.integer(Bottles.Sold),
             Sale..Dolars. = as.double(Sale..Dolars.),
             Volume.Sold..Liters. = as.double(Volume.Sold..Liters.),
             Volume.Sold..Gallons. = as.double(Volume.Sold..Gallons.))

# Save data to data folder
write.csv(d,'data/Iowa_Liquor_Sales-Story_1000.csv')

