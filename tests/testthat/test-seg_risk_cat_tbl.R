test_that("seg_risk_cat_tbl works", {
  test_data <- vroom::vroom(
                system.file("extdata", "VanderbiltComplete.csv",
                package = "segtools"), delim = ",", show_col_types = FALSE)
  risk_cols_tbl <- segtools::seg_risk_vars(df = test_data)

  app_risk_level_tbl <- as.data.frame(
  tibble::tibble(
    `SEG Risk Level` = c(0L, 1L, 2L, 3L, 4L, 5L, 6L, 7L),
    `SEG Risk Category` = c(
      'None',
      'Slight, Lower', 'Slight, Higher',
      'Moderate, Lower','Moderate, Higher',
      'Severe, Lower', 'Severe, Higher',
      'Extreme'
    ),
    `Number of Pairs` = c(9474L, 294L, 55L, 24L, 11L, 10L, NA_integer_, NA_integer_),
    Percent = c(
      '96%', '3%', '0.6%', '0.2%', '0.1%', '0.1%', NA_character_, NA_character_
    ),
  )
)
  expect_equal(
    object = segtools::seg_risk_cat_tbl(risk_cols_tbl)$`Number of Pairs`,
    expected = app_risk_level_tbl$`Number of Pairs`)
})
