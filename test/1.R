# Test Suite for WeatherForecast()
# Ref: http://forecast.io/#/f/12.9833,77.5833

# Files:
# weatherForecast.R             # Contains functions for testing
# tests_weatherForecast         # THIS FOLDER contains test scripts
# 1.R                           # THIS FILE A set of tests to run
# runTests_weatherForecast.R    # Master File to run all tests

# weatherForecast.R:
#   Function to provide weather for all districts in India

# tests_weatherForecast\1.R
#   1st set of tests
#   This goes in 1.R under folder tests_weatherForecast
#   Follows the naming convention test.* for functions

library(RUnit)

test.examples <- function() {
  #tim <- time.seq(lat=40.7142, long=-74.0064, days=2) # New York
  tim <- time.seq(lat=12.9833, long=77.5833, days=14)
  checkEquals(length(tim), 14, "14 formated dates selected for weather forecast")
  checkTrue(grepl('\\d+T\\d+', tim[1]), "T used to seperate date and time")
  checkTrue(grepl('\\d+-\\d+', tim[1]), "- used to seperate year, month, day")
  checkTrue(grepl('\\d+:\\d+', tim[1]), ": used to seperate hour, minute, second")
  
  ret <- call_API(tim)
  checkEquals(dim(ret)[1], 35, "35 descriptors of weather")
  checkEquals(dim(ret)[2], 15, "14 days plus keys column")
  
  out <- select(ret, c("all"))
  checkEquals(dim(out)[1], 35, "All 35 descriptors of weather selected")
  checkEquals(dim(out)[2], 14, "14 days")
  out <- select(ret, c("summary", "icon", "humidity"))
  checkEquals(dim(out)[1], 3, "3 descriptors of weather sub-selected")
  checkEquals(dim(out)[2], 14, "14 days")
  
  out <- select(ret, c("summary", "icon", "humidity", "hdh2ihe9"))
  checkEquals(dim(out)[1], 3, "3 descriptors of weather sub-selected, 1 ignored")
  checkEquals(dim(out)[2], 14, "14 days")
  
  wea <- weatherForecast(days=14)
  checkEquals(dim(wea)[1], 35, "Reported 35 descriptors of weather")
  checkEquals(dim(wea)[2], 14, "14 days weather forecast")
#   few <-  c("summary", "icon", 
#             "temperatureMin", "temperatureMinTime", 
#             "temperatureMax", "temperatureMaxTime",
#             "cloudCover", "humidity")
  few <-  c("summary", "temperatureMin", "temperatureMax", "cloudCover", "humidity")
  out <- wea[few,]
  checkEquals(dim(out)[1], 5, "8 descriptors of weather selected")
  checkEquals(dim(out)[2], 14, "14 days weather forecast")
  
  
  few <-  c("summary", "icon", 
            "temperatureMin", "temperatureMinTime", 
            "temperatureMax", "temperatureMaxTime",
            "cloudCover", "humidity", "hfdyhi2w")
  wea <- weatherForecast(days=14, selection=few)
  checkEquals(dim(wea)[1], 8, "8 descriptors of weather selected")
  checkEquals(dim(wea)[2], 14, "14 days weather forecast")
  
}