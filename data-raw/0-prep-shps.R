
# Packages ====
library("rgdal")
library("rmapshaper")


# Unzip shapefiles ====
if (!file.exists("inst/extdata/england_lad_2011.shp")) {
  download.file(paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                       "prebuilt/shape/England_lad_2011.zip"),
                destfile = "inst/extdata/england.zip", method = "wget")
  unzip("inst/extdata/england.zip", exdir = "inst/extdata",
        overwrite = TRUE)
}

if (!file.exists("inst/extdata/wales_lad_2011.shp")) {
  download.file(paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                       "prebuilt/shape/Wales_lad_2011.zip"),
                destfile = "inst/extdata/wales.zip", method = "wget")
  unzip("inst/extdata/wales.zip", exdir = "inst/extdata",
        overwrite = TRUE)
}

if (!file.exists("inst/extdata/scotland_ca_2001.shp")) {
  download.file(paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                       "prebuilt/shape/Scotland_ca_2001.zip"),
                destfile = "inst/extdata/scotland.zip", method = "wget")
  unzip("inst/extdata/scotland.zip", exdir = "inst/extdata/",
        overwrite = TRUE)
}


# Merge into one shapefile ====

# Use ogr2ogr as it's more straightforward than gUnaryUnion()

system("chmod u+x exec/merge_ews_shapes.sh")
system("exec/merge_ews_shapes.sh")


#
#

lad <- readOGR("inst/extdata", "ew_lad")

lad <- ms_simplify(lad, keep = 0.01)

lad@data$rmapshaperid <- NULL

writeOGR(lad, dsn = "inst/extdata", layer = "ew_lad_simp",
         driver = "ESRI Shapefile")
