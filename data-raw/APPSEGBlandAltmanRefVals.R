## code to prepare `APPSEGBlandAltmanRefVals` dataset goes here
require(vroom)
APPSEGBlandAltmanRefVals <- vroom::vroom("inst/extdata/APPSEGBlandAltmanRefVals.csv")
usethis::use_data(APPSEGBlandAltmanRefVals, overwrite = TRUE)
