test_that("seg_binom_table works", {
  test_data <- vroom::vroom(
    system.file("extdata", "VanderbiltComplete.csv",
      package = "segtools"
    ),
    delim = ",", show_col_types = FALSE
  )
  risk_cols_tbl <- segtools::seg_risk_cols(df = test_data)
  app_binomial_tbl <- tibble::as_tibble(data.frame(
    stringsAsFactors = FALSE,
    check.names = FALSE,
    `Compliant Pairs` = c(9220L),
    `Compliant Pairs %` = c("93.4%"),
    `Lower Bound for Acceptance` = c(9339L),
    `Lower Bound for Acceptance %` = c("94.6%"),
    Result = c("93.4% < 94.6% - Does not meet BGM Surveillance Study Accuracy Standard")
  ))
  expect_equal(
    object = segtools::seg_binom_table(risk_cols = risk_cols_tbl),
    expected = app_binomial_tbl
  )
})
