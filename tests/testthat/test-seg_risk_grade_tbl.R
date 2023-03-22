test_that("seg_risk_grade_tbl works", {
  test_data <- vroom::vroom(
                system.file("extdata", "VanderbiltComplete.csv",
                package = "segtools"), delim = ",", show_col_types = FALSE)
  risk_cols_tbl <- segtools::seg_risk_cols(df = test_data)
  risk_grade_tbl <- segtools::seg_risk_grade_tbl(risk_cols_tbl)
  app_risk_grade_tbl <- as.data.frame(
  tibble::tibble(
    ID = c(1L, 2L, 3L, 4L, 5L),
    `Risk Grade` = c('A', 'B', 'C', 'D', 'E'),
    `Number of Pairs` = c(9474L, 349L, 35L, 10L, NA_integer_),
    Percent = c('96%', '3.5%', '0.4%', '0.1%', NA_character_),
    `Risk Factor Range` = c('0 - 0.5', '> 0.5 - 1.5', '> 1.5 - 2.5',
      '> 2.5 - 3.5', '> 3.5'),
  )
)
  expect_equal(
    object = risk_grade_tbl$`Number of Pairs`,
    expected = app_risk_grade_tbl$`Number of Pairs`)
})
