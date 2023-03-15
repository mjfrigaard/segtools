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
