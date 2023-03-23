test_that("seg_iso_range_tbl works", {
  test_data <- vroom::vroom(
                system.file("extdata", "VanderbiltComplete.csv",
                package = "segtools"), delim = ",", show_col_types = FALSE)
  risk_cols_tbl <- segtools::seg_risk_vars(df = test_data)
  app_iso_range_tbl <- tibble::tribble(
     ~ID,          ~`ISO range`,    ~N, ~Percent,
      1L,    "<= 5% or 5 mg/dL", 5328L,    "54%",
      2L,  "> 5 - 10% or mg/dL", 2842L,  "28.8%",
      3L, "> 10 - 15% or mg/dL", 1050L,  "10.6%",
      4L,    "> 15 - 20% mg/dL",  340L,   "3.4%",
      5L,   "> 20% or 20 mg/dL",  308L,   "3.1%"
     )
  expect_equal(
    object = seg_iso_range_tbl(risk_cols_tbl),
    expected = app_iso_range_tbl)
})
