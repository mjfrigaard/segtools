## code to prepare `VanderbiltComplete` dataset goes here
require(vroom)
VanderbiltComplete <-
  vroom::vroom("inst/extdata/VanderbiltComplete.csv", delim = ",")
usethis::use_data(VanderbiltComplete, overwrite = TRUE)
