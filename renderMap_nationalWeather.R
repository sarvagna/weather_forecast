# Source code
sourcePath = "C:/Users/jhs/Desktop/backup/FY15/weather_forecast/"
fname_map = "renderMap.R"
fname_weather = "nationalWeather.R"
sourceMap <- paste0(sourcePath, fname_map)
sourceWeather <- paste0(sourcePath, fname_weather)
source(sourceMap)
source(sourceWeather)

# Source data
# District Map of India
shpPath = "C:/Users/jhs/Desktop/backup/FY15/weather_forecast/IND_shape_file/"
shpName = "IND_adm2.shp"
mapName = paste0(shpPath, shpName)
# Locations with Lat-Long Coordinates
dataPath = "C:/Users/jhs/Desktop/backup/FY15/weather_forecast/"
dataName = "locations.csv"
reference_locations <- paste0(dataPath, dataName)
# Weather data
weatherPath = "C:/Users/jhs/Desktop/backup/FY15/weather_forecast/"
weatherName = "weather.csv"
weather_table = paste0(weatherPath, weatherName)

# Operate
# Obtain weather data table
we <- nationalWeather(reference_locations)
# Make file for overlay
write.csv(we, weather_table, row.names=FALSE)
# Overlay weather data on map
map<-renderMap(mapName, weather_table, join.field="Locations", plot.field="T")
