## code to prepare `lkpRiskGrade` dataset goes here
require(vroom)
lkpRiskGrade <- vroom::vroom("inst/extdata/lkpRiskGrade.csv")
usethis::use_data(lkpRiskGrade, overwrite = TRUE)
