## code to prepare `AppTestDataMed` dataset goes here
require(vroom)
AppTestDataMed <- vroom::vroom("inst/extdata/AppTestDataMed.csv")
usethis::use_data(AppTestDataMed, overwrite = TRUE)
