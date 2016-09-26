# Function renderMap
library(maptools)
library(rgeos)
library(ggplot2)

renderMap <- function(mapName, overlayName, join.field, plot.field) {
  print(mapName)
  #overlayName<-weather_table
  print(overlayName)
  #join.field="Locations"
  print(join.field)
  #plot.field="T"
  print(plot.field)
  
  if (!file.exists(mapName)) { stop("You have not provided a shp file") }
  if (!file.exists(overlayName)) { stop("You have not provided a file with data to overlay") }
  
  Map <- createMap(mapName)
  Overlay <- createOverlay(overlayName)
  
  # Merge data
  Map@data <- mergeMO(Map@data, Overlay, join.field)
  
  # Flatten for plot
  DD <- flattenMap(Map);  
  
  # Plot
  plotMap(DD, plot.field);
  
}

createMap <- function(mapName) {
  readShapePoly(mapName)  
}

createOverlay <- function(overlayName) {
  read.csv(overlayName)
}

mergeMO <- function(M.d, O, place) {
  M.d$id <- as.numeric(rownames(M.d))
  M.dd <- merge(M.d, O, by.x="NAME_2", by.y=place, all.x=T)
  M.dd <- M.dd[order(M.dd$id), ]
  M.dd$id <- NULL
  rownames(M.dd) <- rownames(M.d)
  M.dd
  # merge mixes the order! No good!
  # How to preserve the original order?
}

flattenMap <- function(Map) {
  Map@data$id <- rownames(Map@data)
  DD <- fortify(Map, region="id")
  DD <- merge(DD, Map@data, by="id")
}

plotMap <- function(DD, Name) {
  #Name<-plot.field
  gg <- ggplot(data=DD, aes_string(x="long", y="lat", group="group", color=Name))+
    geom_polygon()  +
    geom_path(fill = "white") +
    coord_equal() +
    scale_fill_gradient(low="white", high="black") +
    theme(legend.position = "none", title = element_blank(),
          axis.text = element_blank())
  print(gg)
}