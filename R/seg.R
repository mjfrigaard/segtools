#' Create Pair Type Table
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return pair type table
#' @export seg_pairs_table
#'
#' @importFrom dplyr mutate case_when count rename
#' @importFrom dplyr filter bind_rows if_else
#' @importFrom tibble add_row
#'
#' @examples
#' seg_pairs_table(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#' is_path = TRUE)
#'
seg_pairs_table <- function(data, is_path = FALSE) {
  if (is_path == TRUE) {
    samp_meas_data <- import_flat_file(path = data)
  } else {
    samp_meas_data <- data
  }
  # import
  # convert the columns to numeric  ----
  samp_meas_data <- samp_meas_data |>
    dplyr::mutate(
      BGM = as.double(BGM),
      REF = as.double(REF),
      # create bgm_pair_cat ----
      bgm_pair_cat =
        dplyr::case_when(BGM < REF ~ "BGM < REF",
          BGM == REF ~ "BGM = REF",
          BGM > REF ~ "BGM > REF"),
      # create excluded ----
      excluded =
        dplyr::case_when(
          REF > 600 ~ "REF > 600: Excluded from SEG Analysis",
          TRUE ~ NA_character_
        ),
      # create included ----
      included =
        dplyr::case_when(
          REF <= 600 ~ "Total included in SEG Analysis",
          REF > 600 ~ "Total excluded in SEG Analysis"
        )
    )
  # create bgm_pairs ----
  bgm_pairs <- samp_meas_data |>
    dplyr::count(bgm_pair_cat) |>
    dplyr::rename(
      `Pair Type` = bgm_pair_cat,
      Count = n
    )
  # create excluded_data ----
  excluded_data <- samp_meas_data |>
    dplyr::count(excluded) |>
    dplyr::rename(
      `Pair Type` = excluded,
      Count = n
    ) |>
    dplyr::filter(!is.na(`Pair Type`))
  # create included_data ----
  included_data <- samp_meas_data |>
    dplyr::count(included) |>
    dplyr::rename(
      `Pair Type` = included,
      Count = n
    ) |>
    dplyr::filter(`Pair Type` == "Total included in SEG Analysis")
  # create seg_pairs_tbl ----
  pair_types <- dplyr::bind_rows(bgm_pairs,
                                    excluded_data,
                                    included_data)
  # 2.9 add the Total row  ----
  seg_pairs_tbl <- pair_types |>
    tibble::add_row(
    `Pair Type` = "Total",
    Count = nrow(samp_meas_data),
    .after = 0
  )
  return(seg_pairs_tbl)
}

#' SEG Risk Variables
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return seg risk table variables
#' @export seg_risk_vars
#'
#' @importFrom dplyr mutate case_when inner_join
#' @importFrom dplyr filter bind_rows if_else
#'
#' @examples
#' seg_risk_vars(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#' is_path = TRUE)
#'
seg_risk_vars <- function(data, is_path) {
  # import data frame ----
  if (is_path == TRUE) {
    samp_meas_data <- import_flat_file(path = data)
  } else {
    samp_meas_data <- data
  }

  # as double ----
  pair_cat <- dplyr::mutate(samp_meas_data,
    BGM = as.double(BGM),
    REF = as.double(REF),
    # create bgm_pair_cat ----
    bgm_pair_cat =
      dplyr::case_when(
        BGM < REF ~ "BGM < REF",
        BGM == REF ~ "BGM = REF",
        BGM > REF ~ "BGM > REF"
      ),
    # create excluded ----
    excluded =
      dplyr::case_when(
        REF > 600 ~ "REF > 600: Excluded from SEG Analysis",
        REF < 21 & REF <= 600 ~ "REF <21: Included in SEG Analysis"
      ),
    #  create included ----
    included =
      dplyr::case_when(
        REF <= 600 ~ "Total included in SEG Analysis",
        REF > 600 ~ "Total excluded in SEG Analysis"
      )
  )
  # join to segtools::risk_pair_data ----
  risk_pair_cat <- dplyr::inner_join(
    x = pair_cat,
    y = segtools::risk_pair_data,
    by = c("BGM", "REF")
  )
  abs_risk_tbl <- dplyr::mutate(risk_pair_cat,
    #  Create risk_cat variable ----
    risk_cat =
      base::findInterval(
        # the abs_risk absolute value
        x = abs_risk,
         # the lower bound absolute risk
        vec = segtools::risk_cat_lookup$ABSLB,
        left.open = TRUE
      )
  )
  #  Join to segtools::risk_cat_lookup data ----
  risk_cat_tbl <- dplyr::inner_join(
    x = abs_risk_tbl,
    # inner join to look-up
    y = segtools::risk_cat_lookup,
    by = "risk_cat"
  )
  # seg_risk_tbl ----
  seg_risk_tbl <- dplyr::mutate(risk_cat_tbl,
    risk_cat_txt = # text risk categories
      dplyr::case_when(
        abs_risk < 0.5 ~ "None",
        abs_risk >= 0.5 & abs_risk <= 1 ~ "Slight, Lower",
        abs_risk > 1 & abs_risk <= 1.5 ~ "Slight, Higher",
        abs_risk > 1.5 & abs_risk <= 2.0 ~ "Moderate, Lower",
        abs_risk > 2 & abs_risk <= 2.5 ~ "Moderate, Higher",
        abs_risk > 2.5 & abs_risk <= 3.0 ~ "Severe, Lower",
        abs_risk > 3.0 & abs_risk <= 3.5 ~ "Severe, Higher",
        abs_risk > 3.5 ~ "Extreme"
      ),
    rel_diff = (BGM - REF) / REF, # relative diff
    abs_rel_diff = abs(rel_diff), # abs relative diff
    sq_rel_diff = rel_diff^2,
    iso_diff =
      if_else(REF >= 100, # condition 1
        100 * abs(BGM - REF) / REF, # T 1
        if_else(REF < 100, # condition 2
          abs(BGM - REF), # T 2
          NA_real_
        ), # F 2
        NA_real_
      ), # F1
    iso_range = ## create iso range variable ----
      dplyr::case_when(
        iso_diff <= 5 ~ "<= 5% or 5 mg/dL",
        iso_diff > 5 & iso_diff <= 10 ~ "> 5 - 10% or mg/dL",
        iso_diff > 10 & iso_diff <= 15 ~ "> 10 - 15% or mg/dL",
        iso_diff > 15 & iso_diff <= 20 ~ "> 15 - 20% mg/dL",
        iso_diff > 20 ~ "> 20% or 20 mg/dL"
      ),
    ## create risk_grade variable ----
    risk_grade = dplyr::case_when(
      abs_risk >= 0.0 & abs_risk < 0.5 ~ "A",
      abs_risk >= 0.5 & abs_risk < 1.0 ~ "B",
      abs_risk >= 1.0 & abs_risk < 2.0 ~ "C",
      abs_risk >= 2.0 & abs_risk < 3.0 ~ "D",
      abs_risk >= 3.0 ~ "E"
    ),
    ## create risk_grade_txt variable ----
    risk_grade_txt = dplyr::case_when(
      abs_risk >= 0.0 & abs_risk < 0.5 ~ "0 - 0.5",
      abs_risk >= 0.5 & abs_risk < 1.0 ~ "> 0.5 - 1.0",
      abs_risk >= 1.0 & abs_risk < 2.0 ~ "> 1.0 - 2.0",
      abs_risk >= 2.0 & abs_risk < 3.0 ~ "> 2.0 - 3.0",
      abs_risk >= 3.0 ~ "> 3.0"
    )
  )
  return(seg_risk_tbl)
}

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
