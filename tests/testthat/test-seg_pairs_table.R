testthat::test_that("Test pair type table", {
github_data_root <-
  "https://raw.githubusercontent.com/mjfrigaard/seg-shiny-data/master/Data/"

full_sample_repo <- base::paste0(github_data_root,
  "VanderbiltComplete.csv")

test_vand_comp_data <-
  vroom::vroom(file = full_sample_repo, delim = ",")

app_pairs_tbl <- tibble::as_tibble(
  data.frame(
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
  pkg_pairs_tbl <- seg_pairs_table(data = test_vand_comp_data,
                    is_path = FALSE)

  testthat::expect_equal(
    # function table
    object = pkg_pairs_tbl,
    # application table
    expected = app_pairs_tbl
  )
})
