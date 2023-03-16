#' SEG MARD table
#'
#' @description Mean absolute relative difference (MARD) table. See
#'     [article](https://journals.sagepub.com/doi/10.1177/1932296816662047)
#'     for more information,
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path Logical, dataset or path to dataset
#'
#' @return MARD table
#' @export seg_mard_table
#'
#' @importFrom tibble add_column
#' @importFrom dplyr mutate filter bind_rows if_else
#'
#' @examples
#' seg_mard_table(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#' is_path = TRUE)
seg_mard_table <- function(data, is_path = FALSE) {
  # create risk variables
  sample_measure_data <- seg_risk_vars(data = data, is_path = is_path)

  # MARD columns ----
  mard_cols <- data.frame(
    Total = c(nrow(sample_measure_data)),
    Bias = c(mean(sample_measure_data$rel_diff)),
    MARD = c(mean(sample_measure_data$abs_rel_diff)),
    CV = c(sd(sample_measure_data$rel_diff)),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
  # lower limit ----
  mard_ll_tbl <- tibble::add_column(mard_cols,
    `Lower 95% Limit of Agreement` = mard_cols$Bias - 1.96 * mard_cols$CV
  )
  # upper limit ----
  mard_ul_tbl <- tibble::add_column(mard_ll_tbl,
    `Upper 95% Limit of Agreement` = mard_cols$Bias + 1.96 * mard_cols$CV
  )
  # convert BIAS to percent -----
  mard_tbl <- dplyr::mutate(mard_ul_tbl,
    Bias = base::paste0(base::round(
      100 * Bias,
      digits = 1
    ), "%"),
    # convert MARD to percent -----
    MARD = base::paste0(base::round(
      100 * MARD,
      digits = 2
    ), "%"),
    # convert CV to percent -----
    CV = base::paste0(base::round(
      100 * CV,
      digits = 1
    ), "%"),
    # convert LL to percent -----
    `Lower 95% Limit of Agreement` =
      base::paste0(
        base::round(
          100 * `Lower 95% Limit of Agreement`,
          digits = 1
        ), "%"
      ),
    # convert UL to percent -----
    `Upper 95% Limit of Agreement` =
      base::paste0(
        base::round(
          100 * `Upper 95% Limit of Agreement`,
          digits = 1
        ), "%"
      )
  )
  return(mard_tbl)
}
