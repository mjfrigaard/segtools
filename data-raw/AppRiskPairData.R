## code to prepare `AppRiskPairData` dataset goes here
require(vroom)
AppRiskPairData <- vroom::vroom("inst/extdata/AppRiskPairData.csv")
usethis::use_data(AppRiskPairData, overwrite = TRUE)
