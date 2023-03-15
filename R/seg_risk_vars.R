#' SEG risk vars
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return SEG risk variables
#' @export seg_risk_vars
#'
#' @examples
#' seg_risk_vars(data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#'             is_path = TRUE)
seg_risk_vars <- function(data, is_path) {

  risk_cats_tbl <- seg_risk_cats(data, is_path = is_path)

  seg_risk_tbl <- dplyr::mutate(risk_cats_tbl,
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
      dplyr::if_else(REF >= 100, # condition 1
        100 * abs(BGM - REF) / REF, # T 1
        dplyr::if_else(REF < 100, # condition 2
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
