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



#' Create risk grade table
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path Logical, dataset or path to dataset
#'
#' @return risk grade tibble
#' @export seg_risk_grade_table
#'
#' @importFrom dplyr count full_join select
#' @importFrom janitor clean_names
#' @importFrom dplyr mutate filter bind_rows if_else
#' @importFrom purrr set_names
#'
#'
#' @examples
#' seg_risk_grade_table(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#' is_path = TRUE)
seg_risk_grade_table <- function(data, is_path) {
  # create risk variables ----
  seg_risk_data <- seg_risk_vars(
                            data = data,
                            is_path = is_path
                          )

  seg_risk_data |>
    # count risk grade ----
    dplyr::count(risk_grade, sort = TRUE) |>
    # join to segtools::risk_level_lookup ----
    # previously lkpRiskGrade
    dplyr::full_join(
      y = segtools::risk_grade_lookup,
      by = "risk_grade"
    ) |>
    # clean names ----
    janitor::clean_names() |>
    # change lkp table variables ----
    dplyr::mutate(
      risk_grade_id = as.numeric(risk_grade_id),
      Percent = base::paste0(
        base::round(n / nrow(seg_risk_data) * 100,
          digits = 1
        ),
        if_else(
          condition = is.na(n),
          true = "",
          false = "%"
        )
      )
    ) |>
    # select & rename variables ----
    dplyr::select(
      risk_grade_id, risk_grade,
      n, Percent, ref
    ) |>
    purrr::set_names(
      nm = c(
        "ID",
        "Risk Grade",
        "Number of Pairs",
        "Percent",
        "Risk Factor Range"))
}

#' Create risk level (and category) table
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path Logical, dataset or path to dataset
#'
#' @return Risk level (and category) tibble
#' @export seg_risk_level_table
#'
#' @importFrom dplyr count full_join
#' @importFrom janitor clean_names
#' @importFrom dplyr mutate select
#' @importFrom purrr set_names
#'
#' @examples
#' seg_risk_level_table(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#' is_path = TRUE)
seg_risk_level_table <- function(data, is_path) {
  # create risk variables ----
  seg_risk_data <- seg_risk_vars(
    data = data,
    is_path = is_path
  )

  # count risk categories ----
  risk_counts <- dplyr::count(seg_risk_data,
    risk_cat,
    sort = TRUE
  )

  # join to risk cat (4-level) lookup table ----
  # previously lkpSEGRiskCat4
  risk_cat_levels <- dplyr::full_join(
    x = risk_counts,
    y = segtools::risk_level_lookup,
    by = "risk_cat"
  )

  # create percent ----
  risk_perc <- dplyr::mutate(risk_cat_levels,
    risk_cat = as.numeric(risk_cat),
    Percent = base::paste0(
      base::round(n / nrow(seg_risk_data) * 100,
        digits = 1
      ),
      if_else(condition = is.na(n),
        true = "", false = "%"
      )
    )
  ) |>
    dplyr::arrange(desc(n))
  # select and rename variables ----
  risk_level_table <- dplyr::select(
    risk_perc,
    risk_cat, risk_cat_txt, n, Percent
  ) |>
    purrr::set_names(c(
      "SEG Risk Level", "SEG Risk Category",
      "Number of Pairs", "Percent"
    ))
  return(risk_level_table)
}

#' Create ISO range table
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path Logical, dataset or path to dataset
#'
#' @return ISO range (and category) tibble
#' @export seg_iso_range_table
#'
#' @examples
#' seg_iso_range_table(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#' is_path = TRUE)
seg_iso_range_table <- function(data, is_path) {
risk_tbl <- seg_risk_vars(data = data , is_path = is_path)
iso_range_cnts <- dplyr::count(risk_tbl,
                                iso_range, sort = TRUE)
      iso_ranges <- dplyr::full_join(
        x = iso_range_cnts,
        y = segtools::iso_range_lookup,
                by = "iso_range")

      iso_perc <- dplyr::mutate(
        iso_ranges,
          Percent = base::paste0(base::round(n / nrow(risk_tbl) * 100,
            digits = 1),
          dplyr::if_else(condition = is.na(n),
                          true = "",
                          false = "%"))) |>
          dplyr::arrange(desc(n))
       iso_range_tbl <- dplyr::select(iso_perc,
                ID,
                `ISO range` = iso_range,
                N = n,
                Percent)
       return(iso_range_tbl)
}


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
    tibble(`Compliant Pairs` = nrow(risk_tbl) - base::nrow(dplyr::filter(risk_tbl, iso_diff > 15)))

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
