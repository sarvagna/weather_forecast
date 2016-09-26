library(Rforecastio)
library(ggplot2)
library(plyr)

# NEVER put API keys in revision control systems or source code!
fio.api.key= "46eeedf6b77b5fd07561a80cbe88ae39"

my.latitude = "12.9833"
my.longitude = "77.5833"

# can add proxy='host:port' and ssl.verifypeer=FALSE to the end of the fio.forecast call

fio.list <- fio.forecast(fio.api.key, my.latitude, my.longitude, time.formatter=as.POSIXct,ssl.verifypeer=FALSE)

fio.gg <- ggplot(data=fio.list$hourly.df, aes(x=time, y=temperature))
fio.gg <- fio.gg + labs(y="Readings", x="", title="Hourly Readings")
fio.gg <- fio.gg + geom_line(aes(y=humidity*100), color="green", size=0.25)
fio.gg <- fio.gg + geom_line(aes(y=temperature), color="red", size=0.25)
fio.gg <- fio.gg + geom_line(aes(y=dewPoint), color="blue", size=0.25)
fio.gg <- fio.gg + theme_bw()
fio.gg

fio.gg <- ggplot(data=fio.list$daily.df, aes(x=time, y=temperature))
fio.gg <- fio.gg + labs(y="Readings", x="", title="Daily Readings")
fio.gg <- fio.gg + geom_line(aes(y=humidity*100), color="green", size=0.25)
fio.gg <- fio.gg + geom_line(aes(y=temperatureMax), color="red", size=0.25)
fio.gg <- fio.gg + geom_line(aes(y=temperatureMin), color="red", linetype=2, size=0.25)
fio.gg <- fio.gg + geom_line(aes(y=dewPoint), color="blue", size=0.25)
fio.gg <- fio.gg + theme_bw()
fio.gg

