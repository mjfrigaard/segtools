#' Create compliant pairs table
#'
#' @param risk_vars output from `seg_risk_vars()`
#'
#' @return Binomial test table
#' @export seg_binom_tbl
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' risk_cols_tbl <- seg_risk_vars(df = test_data)
#' seg_binom_tbl(risk_cols_tbl)
seg_binom_tbl <- function(risk_vars) {

  compliant_pairs <- tibble(`Compliant Pairs` =
        base::nrow(risk_vars) - base::nrow(dplyr::filter(risk_vars, iso_diff > 15)))

  # calculate the percent
  compliant_pairs_perc <-
    dplyr::mutate(compliant_pairs,
      `Compliant Pairs %` =
        base::paste0(base::round(
          100 * `Compliant Pairs` / nrow(risk_vars),
          1
        ), "%")
    )
  # create probability
  prb <- 0.95
  p_value <- 0.05
  df_size <- nrow(risk_vars)
  qbinom_vector <- qbinom(
    p = p_value,
    size = df_size,
    prob = prb
  )
    qbinom_tbl <- tibble(`Lower Bound for Acceptance` = qbinom_vector)
    # clean up this variable in the tibble for display
  # qbinom_tbl
    qbinom_tbl <- dplyr::mutate(qbinom_tbl,
      `Lower Bound for Acceptance %` =
        base::paste0(base::round(
          100 * `Lower Bound for Acceptance` / nrow(risk_vars),
          1
        ), "%")
    )

  binom_test_tbl <- dplyr::bind_cols(compliant_pairs_perc, qbinom_tbl)

  binom_table <- dplyr::mutate(binom_test_tbl,
    Result =
      dplyr::if_else(condition = `Compliant Pairs` < `Lower Bound for Acceptance`,
        true = paste0(
          binom_test_tbl$`Compliant Pairs %`[1],
          " < ",
          binom_test_tbl$`Lower Bound for Acceptance %`[1],
          " - Does not meet BGM Surveillance Study Accuracy Standard"
        ),
        false = paste0(
          binom_test_tbl$`Compliant Pairs %`[1],
          " > ",
          binom_test_tbl$`Lower Bound for Acceptance %`[1],
          " - Meets BGM Surveillance Study Accuracy Standard"
        )
      )
  )
  return(binom_table)
}
