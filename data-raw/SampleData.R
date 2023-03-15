## code to prepare `SampleData` dataset goes here
require(vroom)
SampleData <- vroom::vroom("inst/extdata/SampleData.csv")
usethis::use_data(SampleData, overwrite = TRUE)
