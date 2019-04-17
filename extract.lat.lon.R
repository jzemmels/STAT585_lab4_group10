
# whatever you have named locally
small.df <- small.df %>%
  mutate(coord.data = str_extract(Store.Location, "\\(.*\\)"),
         lat = str_extract(coord.data, "\\(.*,"),
         lon = str_extract(coord.data, ",.*\\)")) %>%
  mutate(lat = str_extract(lat, "[0-9\\.-]{1,}"),
         lon = str_extract(lon, "[0-9\\.-]{1}"))