#' SEG risk category variables
#'
#' @param df data with `BGM` and `REF` columns
#'
#' @return seg risk category columns table
#' @export seg_risk_cat_cols
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' seg_risk_cat_cols(test_data)
seg_risk_cat_cols <- function(df) {
    LookUpRiskCat <- data.frame(
      risk_cat = c(0L, 1L, 2L, 3L, 4L, 5L, 6L, 7L),
      ABSLB = c(-0.001, 0.5, 1, 1.5, 2, 2.5, 3, 3.5),
      ABSUB = c(0.5, 1, 1.5, 2, 2.5, 3, 3.5, 10)
    )

    # import RiskPairData -----
    RiskPairData <- segtools::RiskPairData

    # directly manipulate df
    bgm_ref_tbl <- dplyr::mutate(df,
      BGM = as.double(BGM),
      REF = as.double(REF)
    )

    # create bgm_pair_cat ----
    bgm_pair_cat_tbl <- dplyr::mutate(bgm_ref_tbl,
      bgm_pair_cat =
        dplyr::case_when(
          BGM < REF ~ "BGM < REF",
          BGM == REF ~ "BGM = REF",
          BGM > REF ~ "BGM > REF"
        )
    )
    # create ref_pair_2cat ----
    ref_pair_2cat_tbl <- dplyr::mutate(bgm_pair_cat_tbl,
      ref_pair_2cat =
        dplyr::case_when(
          REF > 600 ~ "REF > 600: Excluded from SEG Analysis",
          REF < 21 & REF <= 600 ~ "REF <21: Included in SEG Analysis"
        )
    )
    # create included ----
    included_tbl <- dplyr::mutate(ref_pair_2cat_tbl,
      included =
        dplyr::case_when(
          REF <= 600 ~ "Total included in SEG Analysis",
          REF > 600 ~ "Total excluded in SEG Analysis"
        )
    )
    # join to RiskPairData ----
    risk_pair_tbl <- dplyr::inner_join(included_tbl,
      y = RiskPairData,
      by = c("BGM", "REF")
    )
    # Create risk_cat variable ----
    risk_cat_tbl <- dplyr::mutate(risk_pair_tbl,
      risk_cat =
        base::findInterval(
          x = abs_risk, # the abs_risk absolute value
          vec = LookUpRiskCat$ABSLB, # the lower bound absolute risk
          left.open = TRUE
        ) - 1
    )
    # Join to LookUpRiskCat data ----
    risk_cat_join_tbl <- dplyr::inner_join(
      x = risk_cat_tbl,
      y = LookUpRiskCat, # inner join to look-up
      by = "risk_cat"
    )
    # create text risk categories ----
    seg_risk_cat_cols_tbl <- dplyr::mutate(risk_cat_join_tbl,
      risk_cat_txt =
        dplyr::case_when(
          abs_risk < 0.5 ~ "None",
          abs_risk >= 0.5 & abs_risk <= 1 ~ "Slight, Lower",
          abs_risk > 1 & abs_risk <= 1.5 ~ "Slight, Higher",
          abs_risk > 1.5 & abs_risk <= 2.0 ~ "Moderate, Lower",
          abs_risk > 2 & abs_risk <= 2.5 ~ "Moderate, Higher",
          abs_risk > 2.5 & abs_risk <= 3.0 ~ "Severe, Lower",
          abs_risk > 3.0 & abs_risk <= 3.5 ~ "Severe, Higher",
          abs_risk > 3.5 ~ "Extreme"
        )
    )
    return(seg_risk_cat_cols_tbl)
  }

#' Title
#'
#' @param risk_cat_cols output from `seg_risk_cat_cols()`
#'
#' @return ISO range variable table
#' @export seg_iso_cols
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' risk_cat_tbl <- seg_risk_cat_cols(test_data)
#' seg_iso_cols(risk_cat_cols = risk_cat_tbl)
seg_iso_cols <- function(risk_cat_cols) {
  iso_cols_tbl <- dplyr::mutate(risk_cat_cols,
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
    iso_range = # # 4.3.16 create iso range variable ----
      dplyr::case_when(
        iso_diff <= 5 ~ "<= 5% or 5 mg/dL",
        iso_diff > 5 & iso_diff <= 10 ~ "> 5 - 10% or mg/dL",
        iso_diff > 10 & iso_diff <= 15 ~ "> 10 - 15% or mg/dL",
        iso_diff > 15 & iso_diff <= 20 ~ "> 15 - 20% mg/dL",
        iso_diff > 20 ~ "> 20% or 20 mg/dL"
      ),
    risk_grade = dplyr::case_when(
      abs_risk >= 0.0 & abs_risk < 0.5 ~ "A",
      abs_risk >= 0.5 & abs_risk < 1.5 ~ "B",
      abs_risk >= 1.5 & abs_risk < 2.5 ~ "C",
      abs_risk >= 2.5 & abs_risk < 3.5 ~ "D",
      abs_risk >= 3.5 ~ "E"
    ),
    risk_grade_txt = dplyr::case_when(
      abs_risk >= 0.0 & abs_risk < 0.5 ~ "0 - 0.5",
      abs_risk >= 0.5 & abs_risk < 1.5 ~ "> 0.5 - 1.5",
      abs_risk >= 1.5 & abs_risk < 2.5 ~ "> 1.5 - 2.5",
      abs_risk >= 2.5 & abs_risk < 3.5 ~ "> 2.5 - 3.5",
      abs_risk >= 3.5 ~ "> 3.5"
    )
  )
  return(iso_cols_tbl)
}

#' SEG risk columns (wrapper function)
#'
#' @param df data with `BGM` and `REF` columns
#'
#' @return SEG risk columns
#' @export seg_risk_vars
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' seg_risk_vars(df = test_data)
seg_risk_vars <- function(df) {

  risk_cat_vars_tbl <- seg_risk_cat_cols(df = df)

  iso_vars_tbl <- seg_iso_cols(risk_cat_cols = risk_cat_vars_tbl)

  return(iso_vars_tbl)
}
