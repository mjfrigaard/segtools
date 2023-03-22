testthat::test_that("Test seg_pair_type_tbl()", {
  testthat::expect_equal(
    # function table
    object = segtools::seg_pair_type_tbl(df = vroom::vroom(
      system.file("extdata", "VanderbiltComplete.csv",
        package = "segtools"
      ),
      delim = ",",
      show_col_types = FALSE
    )),
    # application table
    expected = tibble::as_tibble(data.frame(
      stringsAsFactors = FALSE,
      check.names = FALSE,
      `Pair Type` = c(
        "Total",
        "BGM < REF",
        "BGM = REF",
        "BGM > REF",
        "REF > 600: Excluded from SEG Analysis",
        "Total included in SEG Analysis"
      ),
      Count = c(9891L, 4710L, 479L, 4702L, 23L, 9868L)
    ))
  )
})
