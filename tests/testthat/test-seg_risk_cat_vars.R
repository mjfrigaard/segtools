test_that("seg_risk_cat_vars works", {
  test_data <- vroom::vroom(
                system.file("extdata", "VanderbiltComplete.csv",
                package = "segtools"), delim = ",",
                show_col_types = FALSE)
  expect_equal(
    object = names(seg_risk_cat_vars(test_data)),
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
      "risk_cat_txt"
    )
  )
})
