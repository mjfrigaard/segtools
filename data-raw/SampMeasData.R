## code to prepare `SampMeasData` dataset goes here
require(vroom)
SampMeasData <- vroom::vroom("inst/extdata/SampMeasData.csv")
usethis::use_data(SampMeasData, overwrite = TRUE)
