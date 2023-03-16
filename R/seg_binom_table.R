#' Create compliant pairs table
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path Logical, dataset or path to dataset
#'
#' @return Binomial test table
#' @export seg_binom_table
#'
#' @examples
#' seg_binom_table(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#' is_path = TRUE)
seg_binom_table <- function(data, is_path) {
  risk_tbl <- seg_risk_vars(data = data, is_path = is_path)

  compliant_pairs <-
    tibble(
      `Compliant Pairs` = nrow(risk_tbl) - base::nrow(dplyr::filter(risk_tbl, iso_diff > 15)))

  # Then calculate the percent
  compliant_pairs_perc <-
    dplyr::mutate(compliant_pairs,
      `Compliant Pairs %` =
        base::paste0(base::round(
          100 * `Compliant Pairs` / nrow(risk_tbl),
          1
        ), "%")
    )
  # create probability
  prb <- 0.95
  p_value <- 0.05
  df_size <- nrow(risk_tbl)
  qbinom_vector <- qbinom(
    p = p_value,
    size = df_size,
    prob = prb
  )
    qbinom_tbl <- tibble(`Lower Bound for Acceptance` = qbinom_vector)
    # clean up this variable in the tibble for display
  # qbinom_tibble
    qbinom_tbl <- dplyr::mutate(qbinom_tbl,
      `Lower Bound for Acceptance %` =
        base::paste0(base::round(
          100 * `Lower Bound for Acceptance` / nrow(risk_tbl),
          1
        ), "%")
    )


  binom_test_tbl <- bind_cols(compliant_pairs_perc, qbinom_tbl)

  binom_table <- dplyr::mutate(binom_test_tbl,
    Result =
      if_else(condition = `Compliant Pairs` < `Lower Bound for Acceptance`,
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
