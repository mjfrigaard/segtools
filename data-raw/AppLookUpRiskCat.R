## code to prepare `AppLookUpRiskCat` dataset goes here
require(vroom)
AppLookUpRiskCat <- vroom::vroom("inst/extdata/AppLookUpRiskCat.csv")
usethis::use_data(AppLookUpRiskCat, overwrite = TRUE)
