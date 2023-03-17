## code to prepare `lkpRiskGrade` dataset goes here
# require(vroom)
# lkpRiskGrade <- vroom::vroom("inst/extdata/lkpRiskGrade.csv")
require(tibble)
lkpRiskGrade <- tibble::tribble(
    ~`risk_grade_id`, ~`risk_grade`, ~`REF`,
    1, "A", "0 - 0.5",
    2, "B", "> 0.5 - 1.5",
    3, "C", "> 1.5 - 2.5",
    4, "D", "> 2.5 - 3.5",
    5, "E", "> 3.5")

usethis::use_data(lkpRiskGrade, overwrite = TRUE)
