## code to prepare `No_Interference_Dogs` dataset goes here
require(vroom)
No_Interference_Dogs <- vroom::vroom("inst/extdata/No_Interference_Dogs.csv")
usethis::use_data(No_Interference_Dogs, overwrite = TRUE)
