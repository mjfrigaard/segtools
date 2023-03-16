## code to prepare `lkpISORanges` dataset goes here
# source: https://github.com/quesgen/seg-shiny-1-3-3/blob/4582582ee56547e4f03c4a683c8958f74c9f2f07/App/helpers.R#LL96
require(tibble)
lkpISORanges <- tibble::tribble(
       ~ID,            ~iso_range,
        1L,    "<= 5% or 5 mg/dL",
        2L,  "> 5 - 10% or mg/dL",
        3L, "> 10 - 15% or mg/dL",
        4L,    "> 15 - 20% mg/dL",
        5L,   "> 20% or 20 mg/dL")
usethis::use_data(lkpISORanges, overwrite = TRUE)
