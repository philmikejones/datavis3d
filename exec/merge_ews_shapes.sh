#! /bin/bash

ogr2ogr -f 'ESRI Shapefile' inst/extdata/ews.shp \
  inst/extdata/england_lad_2011.shp
ogr2ogr -f 'ESRI Shapefile' -update -append inst/extdata/ews.shp \
  inst/extdata/wales_lad_2011.shp
ogr2ogr -f 'ESRI Shapefile' -update -append inst/extdata/ews.shp \
inst/extdata/scotland_ca_2001.shp
