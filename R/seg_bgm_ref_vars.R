#' SEG BMR/REF Variables
#' @noRd
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
