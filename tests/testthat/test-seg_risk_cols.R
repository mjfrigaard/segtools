test_that("seg_risk_cols works", {
  test_data <- vroom::vroom(
      system.file("extdata", "VanderbiltComplete.csv",
        package = "segtools"
      ),
      delim = ",",
      show_col_types = FALSE
    )
  expect_equal(
    object = segtools::seg_risk_cols(df = test_data),
    expected = segtools::seg_iso_vars(segtools::seg_risk_cat_vars(df = test_data)))

})
