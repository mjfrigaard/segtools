## code to prepare `lkpSEGRiskCat4.csv` dataset goes here
require(vroom)
lkpSEGRiskCat4 <- vroom::vroom("inst/extdata/lkpSEGRiskCat4.csv")
usethis::use_data(lkpSEGRiskCat4, overwrite = TRUE)
