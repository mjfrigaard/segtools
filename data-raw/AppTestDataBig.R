## code to prepare `AppTestDataBig.csv` dataset goes here
require(vroom)
AppTestDataBig <- vroom::vroom("inst/extdata/AppTestDataBig.csv")
usethis::use_data(AppTestDataBig, overwrite = TRUE)
