library("rgdal")
library("rmapshaper")

# unzip("inst/extdata/England_gor_2011.zip", exdir = "inst/extdata",
#       overwrite = TRUE)
# unzip("inst/extdata/England_lad_2011.zip", exdir = "inst/extdata",
#       overwrite = TRUE)
# unzip("inst/extdata/Wales_lad_2011.zip", exdir = "inst/extdata",
#       overwrite = TRUE)

# e_lad <- readOGR("inst/extdata", "england_lad_2011")
# w_lad <- readOGR("inst/extdata", "wales_lad_2011")

# # bash
# ogr2ogr -f 'ESRI Shapefile' inst/extdata/ew_lad.shp inst/extdata/england_lad_2011.shp
# ogr2ogr -f 'ESRI Shapefile' -update -append inst/extdata/ew_lad.shp inst/extdata/wales_lad_2011.shp

lad <- readOGR("inst/extdata", "ew_lad")

lad <- ms_simplify(lad, keep = 0.01)

lad@data$rmapshaperid <- NULL

writeOGR(lad, dsn = "inst/extdata", layer = "ew_lad_simp",
         driver = "ESRI Shapefile")
