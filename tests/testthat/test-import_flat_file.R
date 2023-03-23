testthat::test_that("import_flat_file works", {

  testthat::expect_equal(
    object = import_flat_file(path = "csv/VanderbiltComplete.csv"),
    expected = vroom::vroom(file = "csv/VanderbiltComplete.csv", delim = ",",
      show_col_types = FALSE))

  testthat::expect_equal(
    object = import_flat_file(path = "tsv/VanderbiltComplete.tsv"),
    expected = vroom::vroom(file = "tsv/VanderbiltComplete.tsv", delim = "\t",
      show_col_types = FALSE))

  testthat::expect_equal(
    object = import_flat_file(path = "txt/VanderbiltComplete.txt"),
    expected = vroom::vroom(file = "txt/VanderbiltComplete.txt",
      show_col_types = FALSE))

})
