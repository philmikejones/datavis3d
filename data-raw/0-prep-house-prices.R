# Create directories
dir.create("inst/extdata/", recursive = TRUE, showWarnings = FALSE)
dir.create("data/", showWarnings = FALSE)


# Packages ====
library("magrittr")
library("dplyr")


# Download source data ====
# ONS median house price
if (!file.exists("inst/extdata/hpm.xls")) {
  download.file(paste0("https://www.ons.gov.uk/file?uri=/",
                       "peoplepopulationandcommunity/housing/datasets/",
                       "medianhousepricefornationalandsubnationalgeographies",
                       "quarterlyrollingyearhpssadataset09/current/",
                       "hpssadataset9medianhousepricefornationalandsubnational",
                       "geographiesquarterlyrollingyear.xls"),
                destfile = "inst/extdata/hpm.xls")
}

hpm <- readxl::read_excel("inst/extdata/hpm.xls",
                          sheet = "2a", skip = 6, col_names = TRUE)
hpm <- hpm[, c(3:4, 85)]
colnames(hpm) <- c("la_code", "la_name", "med_price")

save(hpm, file = "data/hpm.RData", compress = "xz")


# HPI
if (!file.exists("inst/extdata/hpi.csv")) {
  download.file(paste0("http://publicdata.landregistry.gov.uk/market-trend-data/house-price-index-data/Average-prices-2016-07.csv"),
                destfile = "inst/extdata/hpi.csv")
}

hpi <- readr::read_csv("inst/extdata/hpi.csv")
hpi <- hpi[, 1:3]

hpi <- hpi %>%
  filter(Date == "2016-07-01") %>%
  filter(Region_Name != "Northern Ireland") %>%
  filter(Region_Name != "Scotland") %>%
  filter(Region_Name != "Wales") %>%
  filter(Region_Name != "England") %>%
  filter(Region_Name != "Outer London") %>%
  filter(Region_Name != "Inner London") %>%
  select(-Date)

save(hpi, file = "data/hpi.RData", compress = "xz")
