## code to prepare `ModBAData` dataset goes here
require(vroom)
ModBAData <- vroom::vroom("inst/extdata/ModBAData.csv")
usethis::use_data(ModBAData, overwrite = TRUE)
