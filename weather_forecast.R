# function weatherForecast

library(jsonlite)
library(ggplot2)
library(sendmailR)
library(reshape2)

setwd("C:/Users/jhs/Desktop/backup/FY15/weather_forecast")

weatherForecast <- function(lat=12.9833, long=77.5833, days=14, selection=c("all", "summary")) {
  # Preparatory
  
  # Set up query paramters in time-window
  lat.long.time <- time.seq(lat, long, days)
  
  # Acquire data: Obtain weather for specified days
  wal <- call_API(lat.long.time)
  
  # Condition data: Slice to extract specified variables
  out <- select(wal, selection)
  
  return(out)
  
}

time.seq <- function(lat, long, days) {
  time.day <- Sys.time()
  time.seq <- seq(Sys.time(), length=days, by="day")
  time.seq <- format(time.seq, format="%Y-%m-%dT%H:%M:%S")
  lat.long.time <- paste(lat,long, time.seq, sep=",")
  lat.long.time <- paste0(lat.long.time, "?units=si")
  lat.long.time
}

call_API <- function(lat.long.time) {
  baseurl <- "https://api.forecast.io/forecast";
  weather_key <- "46eeedf6b77b5fd07561a80cbe88ae39"
  wal <- data.frame() # Initialize
  for (i in lat.long.time) {
    print(paste(baseurl, weather_key, i, sep="/"))
    f_bangalore <- fromJSON(paste(baseurl, weather_key, i, sep="/"))
    timestamp <- as.POSIXlt(f_bangalore$daily$data$time, 
                            origin="1970-01-01", 
                            tz="Asia/Kolkata")
    timestamp <- as.character(timestamp)
    wln <- data.frame(values=unlist(f_bangalore$daily$data[1,]),
                      keys=names(f_bangalore$daily$data))
    if (sum(dim(wal))==0) {
      wal <- wln 
    } else {
      wal <- merge(wal, wln, by="keys", all=TRUE)
      names(wal) <- c("keys", paste("Day", 1:(dim(wal)[2]-1)))
    }
  }
  wal
}

select <- function(wal, selection) {
  # TO DO grep time in any row of wal and convert to human-readable form
  # Check if sub-setting required
  if (tolower(selection[1])=="all") {
    out <- wal
    rownames(out) <- wal$keys
  } else {
    # Subset rows, remove keys column 
    chosen <- wal$keys %in% selection
    out <- wal[chosen ,]
    rownames(out) <- wal$keys[chosen]
  }
  out$keys <- NULL
  out
}


tim <- time.seq(lat=12.9833, long=77.5833, days=30)

ret <- call_API(tim)

few <-  c("summary", 
          "temperatureMin",
          "temperatureMax",
          "cloudCover", "humidity")
wea <- weatherForecast(days=30, selection=few)

today<-Sys.Date()
colnames(wea)<-seq(today,length.out=30,by="1 day")

tea<-as.data.frame(t(wea))
tea$time<-rownames(tea)
rownames(tea)<-NULL
tea$cloudCover<-as.numeric(as.character(tea$cloudCover))
tea$humidity<-as.numeric(as.character(tea$humidity))
tea$temperatureMax<-as.numeric(as.character(tea$temperatureMax))
tea$temperatureMin<-as.numeric(as.character(tea$temperatureMin))
tea$summary<-as.character(tea$summary)
tea$time<- as.POSIXct(as.Date(tea$time))

temp_range<-tea[,c(6,4,5)]
d2 <- melt(temp_range, id="time")
temp.gg<-ggplot(d2, aes(x=time, value, colour=variable)) + 
            geom_line() +
            scale_colour_manual(values=c("red", "blue"))  + labs(y="Temparature in C", x="", title="Temparature forecast for next month")
#temp.gg

prob_range<-tea[,c(6,1,2)]
d3 <- melt(prob_range, id="time")
prob.gg<-ggplot(d3, aes(x=time, value, colour=variable)) + 
  geom_line() +
  scale_colour_manual(values=c("red", "blue")) + labs(y="Probability", x="", title="Cloud cover and humidity probability")
#prob.gg

write.table(x=wea,file="weather_forecast.csv",sep=",",col.names=NA)

file<-"weather_forecast.csv"
from <- sprintf("Jeevan.HS@Monsanto.com")
to <- "hgg@monsanto.com"
cc<- "jhs@monsanto.com"
subject <- "Weather forecast for next month"
body <- list("Hi, \nPFA the weather forecast report for next 30 days! \n \nhave fun:) \n-Jeevan",
             mime_part(x=file),
             mime_part(temp.gg,"temparature.pdf"),
             mime_part(prob.gg,"cloud&Humidity.pdf"))
sendmail(from=from, to=to, subject=subject, msg=body, cc=cc,
         control=list(smtpServer="stpmls01.monsanto.com"))

