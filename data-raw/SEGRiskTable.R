## code to prepare `SEGRiskTable` dataset goes here
require(vroom)
SEGRiskTable <- vroom::vroom("inst/extdata/SEGRiskTable.csv", delim = ",")
usethis::use_data(SEGRiskTable, overwrite = TRUE)
