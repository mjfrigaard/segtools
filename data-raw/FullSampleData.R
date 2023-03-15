## code to prepare `FullSampleData` dataset goes here
require(vroom)
FullSampleData <- vroom::vroom("inst/extdata/FullSampleData.csv")
usethis::use_data(FullSampleData, overwrite = TRUE)
