## code to prepare `AppTestDataSmall` dataset goes here
require(vroom)
AppTestDataSmall <- vroom::vroom("inst/extdata/AppTestDataSmall.csv")
usethis::use_data(AppTestDataSmall, overwrite = TRUE)
