#' SEG MARD table
#'
#' @param risk_vars output from `seg_risk_vars()`
#'
#' @return MARD table
#' @export seg_mard_tbl
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' risk_cols_tbl <- seg_risk_vars(df = test_data)
#' seg_mard_tbl(risk_cols_tbl)
seg_mard_tbl <- function(risk_vars) {
  mard_cols <- data.frame(
    Total = c(nrow(risk_vars)),
    Bias = c(mean(risk_vars$rel_diff)),
    MARD = c(mean(risk_vars$abs_rel_diff)),
    CV = c(sd(risk_vars$rel_diff)),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )

  lower_tbl <- tibble::add_column(
    .data = mard_cols,
    `Lower 95% Limit of Agreement` = mard_cols$Bias - 1.96 * mard_cols$CV
  )
  upper_tbl <- tibble::add_column(
    .data = lower_tbl,
    `Upper 95% Limit of Agreement` = mard_cols$Bias + 1.96 * mard_cols$CV
  )
  mard_vars <- dplyr::mutate(
    .data = upper_tbl,
    Bias = base::paste0(base::round(
      100 * Bias,
      digits = 1
    ), "%"),
    MARD = base::paste0(base::round(
      100 * MARD,
      digits = 1
    ), "%"),
    CV = base::paste0(base::round(
      100 * CV,
      digits = 1
    ), "%"),
    `Lower 95% Limit of Agreement` = base::paste0(base::round(
      100 * `Lower 95% Limit of Agreement`,
      digits = 1
    ), "%"),
    `Upper 95% Limit of Agreement` = base::paste0(base::round(
      100 * `Upper 95% Limit of Agreement`,
      digits = 1
    ), "%")
  )
  mard_vars_tbl <- tibble::as_tibble(mard_vars)
  return(mard_vars_tbl)
}
