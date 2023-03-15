## code to prepare `AppTestData` dataset goes here
require(vroom)
AppTestData <- vroom::vroom("inst/extdata/AppTestData.csv")
usethis::use_data(AppTestData, overwrite = TRUE)
