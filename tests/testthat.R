# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/tests.html
# * https://testthat.r-lib.org/reference/test_package.html#special-files

library(testthat)
library(segtools)

testthat::test_file(path = "tests/testthat/test-seg_pair_type_tbl.R")
testthat::test_file(path = "tests/testthat/test-seg_risk_cat_cols.R")
testthat::test_file(path = "tests/testthat/test-seg_iso_cols.R")
testthat::test_file(path = "tests/testthat/test-seg_risk_vars.R")

