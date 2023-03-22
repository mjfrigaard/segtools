test_that("seg_iso_vars works", {
  test_data <- vroom::vroom(
    system.file("extdata", "VanderbiltComplete.csv",
      package = "segtools"),
    delim = ",",
    show_col_types = FALSE
  )
  expect_equal(
    object = names(
      segtools::seg_iso_vars(risk_cat_vars =
          segtools::seg_risk_cat_vars(test_data))),
    expected = c(
      "BGM",
      "REF",
      "bgm_pair_cat",
      "ref_pair_2cat",
      "included",
      "RiskPairID",
      "RiskFactor",
      "abs_risk",
      "risk_cat",
      "ABSLB",
      "ABSUB",
      "risk_cat_txt",
      "rel_diff",
      "abs_rel_diff",
      "sq_rel_diff",
      "iso_diff",
      "iso_range",
      "risk_grade",
      "risk_grade_txt"
    )
  )
})
