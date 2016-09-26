
# Packages ====
library("rgdal")
library("rmapshaper")
library("dplyr")


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
if (!file.exists("inst/extdata/ews.shp")) {
  system("exec/merge_ews_shapes.sh")
}


# Simplify with rmapshaper::ms_simplify()
ews <- readOGR("inst/extdata", "ews", stringsAsFactors = FALSE)
pryr::object_size(ews)  # 63.3 MB

# Plot for blog
if (!file.exists("figures/ews.png")) {
  dir.create("figures/")
  png("figures/ews.png", width = 1920, height = 2840, units = "px")
  plot(ews)
  dev.off()
}

# Simplify geometries
ews <- ms_simplify(ews, keep = 0.005)
pryr::object_size(ews)  # 1.3 MB!

# Plot for blog
if (!file.exists("figures/ews_simp.png")) {
  png("figures/ews_simp.png", width = 1920, height = 2840, units = "px")
  plot(ews)
  dev.off()
}


# Save simplified for merging
ews@data$rmapshaperid <- NULL
ews@data[] <- lapply(ews@data, as.character)
ews@data <- select(ews@data, -altname)

save(ews, file = "data/ews.RData", compress = "xz")
