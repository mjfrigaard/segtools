## code to prepare `LookUpRiskCat` dataset goes here
require(vroom)
LookUpRiskCat <- vroom::vroom("inst/extdata/LookUpRiskCat.csv")
names(LookUpRiskCat) <- c("risk_cat", "ABSLB", "ABSUB",
  "RiskCatRangeTxt", "RiskCatLabel")
LookUpRiskCat
usethis::use_data(LookUpRiskCat, overwrite = TRUE)
