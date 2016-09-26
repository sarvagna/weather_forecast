# function nationalWeather

library('jsonlite')
library('GetoptLong')
library('plyr')

nationalWeather <- function(locations) {
  loc <- fetchLocations(locations)
  wea <- apply(loc, 1, function(x) { 
    w <- getWeather(x[2], x[3]); 
    o <- c(w$now$data$temperature, w$now$data$summary, 
           w$now$data$apparentTemperature,
           w$next_hour$data$summary,
           w$next_day$data$summary,
           w$next_week$data$summary)
    names(o) <- c("NOW DEG F", "NOW", 
                  "NOW APPARENT DEG F",
                  w$next_hour$name,
                  w$next_day$name,
                  w$next_week$name)
    return(o)
  }
  );  
  wea <- cbind(loc, t(wea))
}

fetchLocations <- function(locations) {
  read.csv(locations)
}

getWeather <- function(lat, long) {
  # Weather API
  # https://developer.forecast.io/
  # uid|pwd: sanjay.bhatikar@gmail.com | Em01an12
  
  out <- list();  # Return object, 
  # See: http://forecast.io/#/f/12.9833,77.5833
  
  baseurl <- "https://api.forecast.io/forecast";
  weather_key <- "46eeedf6b77b5fd07561a80cbe88ae39"
  lat.long <- qq("@{lat},@{long}")  #lat.long.bangalore = "12.9833,77.5833"
  #lat<-12.9833
  #long<-77.5833
  w <- fromJSON(paste(baseurl, weather_key, lat.long, sep="/"))
  
  # RIGHT NOW
  tc <-             w$currently$temperature
  sc <-             w$currently$summary
  ac <-             w$currently$apparentTemperature
  out$now  <-       list(name = "RIGHT NOW", data = list())
  out$now$data <-   list(temperature = tc, summary = sc, apparentTemperature = ac)
  
  # NEXT HOUR
  sh <-             w$hourly$data$summary[1]
  out$next_hour <-  list(name = "NEXT HOUR", data = list(summary = sh))
  
  # NEXT 24 HOURS
  sd <-             w$hourly$summary
  out$next_day <-   list(name = "NEXT 24 HOURS", data = list(summary = sd))
  
  # NEXT 7 DAYS
  sw <-             w$daily$summary
  out$next_week <-  list(name = "NEXT 7 DAYS", data = list(summary = sw))
  
  return(out)  
}