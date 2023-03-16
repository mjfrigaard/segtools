#' SEG BMR/REF Variables
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return seg BGM/REF included and excluded variables
#' @export seg_bgm_ref_vars
#'
#' @importFrom dplyr mutate case_when
#' @importFrom dplyr filter bind_rows if_else
#'
#' @examples
#' seg_bgm_ref_vars(
#' data = system.file("extdata", "VanderbiltComplete.csv",
#'         package = "segtools"),
#' is_path = TRUE)
seg_bgm_ref_vars <- function(data, is_path) {
  # import data frame ----
  if (is_path == TRUE) {
    samp_meas_data <- segtools::import_flat_file(path = data)
  } else {
    samp_meas_data <- data
  }
    # as double ----
  bgm_ref_vars <- dplyr::mutate(.data = samp_meas_data,
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
  return(bgm_ref_vars)
}
#' SEG Risk Pair Variables
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return seg risk pair variables
#' @export seg_risk_pairs
#'
#' @importFrom dplyr mutate case_when inner_join
#' @importFrom dplyr filter bind_rows if_else
#'
#' @examples
#' seg_risk_pairs(data = system.file("extdata", "VanderbiltComplete.csv",
#'        package = "segtools"), is_path = TRUE)
seg_risk_pairs <- function(data, is_path) {
  # import bgm ref/vars
  bgm_ref_vars <- seg_bgm_ref_vars(data = data, is_path = is_path)
  # get risk pairs data (from APP)
  risk_pair_data <- app_data_switch(
    data = "RiskPairData",
    app = TRUE)
  # join to risk_pair_data ----
  risk_pairs <- dplyr::inner_join(
    x = bgm_ref_vars,
    y = risk_pair_data,
    by = c("BGM", "REF")
  )
  return(risk_pairs)
}
#' SEG Risk Category Variables
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return seg risk category variables
#' @export seg_risk_cats
#'
#' @importFrom dplyr mutate case_when inner_join
#' @importFrom dplyr filter bind_rows if_else
#'
#' @examples
#' seg_risk_cats(
#'  data =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"),
#'   is_path = TRUE)
seg_risk_cats <- function(data, is_path) {
  # risk pair data
  risk_pairs <- seg_risk_pairs(data = data,
                  is_path = is_path)
  # risk look-up category data
  risk_cat_lookup <- app_data_switch(
    data = "LookUpRiskCat",
    app = TRUE)

  abs_risk_tbl <- dplyr::mutate(
    # create absolute value from RiskFactor
    risk_pairs,
    abs_risk = abs(risk_pairs$RiskFactor),
    #  Create risk_cat variable ----
    risk_cat =
      base::findInterval(
        # the abs_risk absolute value
        x = abs_risk,
         # the lower bound absolute risk
        vec = risk_cat_lookup$ABSLB,
        left.open = TRUE
      )
  )
  # abs_risk_tbl
  #  Join to risk_cat_lookup data ----
  risk_cats_tbl <- dplyr::inner_join(
    x = abs_risk_tbl,
    # inner join to look-up
    y = risk_cat_lookup,
    by = "risk_cat"
  )
  return(risk_cats_tbl)
}
