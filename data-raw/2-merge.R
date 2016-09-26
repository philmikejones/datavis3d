# Packages ====
library("magrittr")
library("dplyr")
library("rgdal")


# Load shapefiles and house price data ====
load("data/ews.RData")
load("data/hpi.RData")


# Merge in house price data ====
ews@data <- left_join(ews@data, hpi, by = c("name" = "Region_Name"))


# Fix missing data
ews@data$Average_Price[grep("Kensington", ews@data$name)] <-
  hpi$Average_Price[grep("Kensington", hpi$Region_Name)]

ews@data$Average_Price[grep("Nottingham", ews@data$name)] <-
  hpi$Average_Price[grep("City of Nottingham", hpi$Region_Name)]

ews@data$Average_Price[grep("Peterborough", ews@data$name)] <-
  hpi$Average_Price[grep("Peterborough", hpi$Region_Name)]

ews@data$Average_Price[grep("Kingston upon Hull", ews@data$name)] <-
  hpi$Average_Price[grep("Kingston upon Hull", hpi$Region_Name)]

ews@data$Average_Price[grep("Westminster", ews@data$name)] <-
  hpi$Average_Price[grep("Westminster", hpi$Region_Name)]

ews@data$Average_Price[ews@data$code == "E06000015"] <-
  hpi$Average_Price[grep("City of Derby", hpi$Region_Name)]

ews@data$Average_Price[grep("Herefordshire", ews@data$name)] <-
  hpi$Average_Price[grep("Herefordshire", hpi$Region_Name)]

ews@data$Average_Price[grep("Plymouth", ews@data$name)] <-
  hpi$Average_Price[grep("Plymouth", hpi$Region_Name)]

# Copy Cornwall to Scilly
ews@data$Average_Price[grep("Scilly", ews@data$name)] <-
  hpi$Average_Price[grep("Cornwall", hpi$Region_Name)]

ews@data$Average_Price[grep("Bristol", ews@data$name)] <-
  hpi$Average_Price[grep("Bristol", hpi$Region_Name)]

ews@data$Average_Price[grep("Helens", ews@data$name)] <-
  hpi$Average_Price[grep("Helens", hpi$Region_Name)]

ews@data$Average_Price[grep("Glamorgan", ews@data$name)] <-
  hpi$Average_Price[grep("Glamorgan", hpi$Region_Name)]

ews@data$Average_Price[grep("Argyll", ews@data$name)] <-
  hpi$Average_Price[grep("Argyll", hpi$Region_Name)]

ews@data$Average_Price[grep("Dumfries", ews@data$name)] <-
  hpi$Average_Price[grep("Dumfries", hpi$Region_Name)]

ews@data$Average_Price[grep("Kinross", ews@data$name)] <-
  hpi$Average_Price[grep("Kinross", hpi$Region_Name)]

ews@data$Average_Price[grep("Eilean", ews@data$name)] <-
  hpi$Average_Price[grep("Eilean", hpi$Region_Name)]

ews@data$Average_Price[grep("Edinburgh", ews@data$name)] <-
  hpi$Average_Price[grep("Edinburgh", hpi$Region_Name)]

ews@data$Average_Price[grep("Glasgow", ews@data$name)] <-
  hpi$Average_Price[grep("Glasgow", hpi$Region_Name)]

ews@data$Average_Price[grep("Aberdeen", ews@data$name)] <-
  hpi$Average_Price[grep("Aberdeen", hpi$Region_Name)]

ews@data$Average_Price[grep("Dundee", ews@data$name)] <-
  hpi$Average_Price[grep("Dundee", hpi$Region_Name)]


# Export ====
ews@data <- select(ews@data, -label)
colnames(ews@data)[3] <- "price"

list.files("inst/extdata/", pattern = "_simp",
           full.names = TRUE,
           include.dirs = TRUE) %>%
  file.remove()
writeOGR(ews, dsn = "inst/extdata", layer = "ews_simp", overwrite_layer = TRUE,
         driver = "ESRI Shapefile")
