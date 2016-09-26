
# Packages ====
library("readxl")

download.file(paste0("http://www.ons.gov.uk/file?uri=/",
                     "peoplepopulationandcommunity/housing/datasets/",
                     "housepricestatisticsforsmallareas/current/",
                     "hpssa19952014_tcm77-407774.xls"),
              destfile = "inst/extdata/house_prices.xls")

hp <- readxl::excel_sheets("inst/extdata/house_prices.xls")
