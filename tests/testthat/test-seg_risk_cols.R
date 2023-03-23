test_that("seg_risk_vars works", {
  test_data <- vroom::vroom(
      system.file("extdata", "VanderbiltComplete.csv",
        package = "segtools"
      ),
      delim = ",",
      show_col_types = FALSE
    )
  expect_equal(
    object = segtools::seg_risk_vars(df = test_data),
    expected = segtools::seg_iso_cols(segtools::seg_risk_cat_cols(df = test_data)))

})
