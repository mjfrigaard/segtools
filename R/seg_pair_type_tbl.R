#' SEG pairs type table
#'
#' @param df data with `BGM` and `REF` columns
#'
#' @return pair type columns
#' @export seg_pair_type_tbl
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' seg_pair_type_tbl(test_data)
seg_pair_type_tbl <- function(df) {
  # manipulate data directly
  samp_meas_data <- dplyr::mutate(.data = df,
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
        TRUE ~ NA_character_
      ),
    # create included ----
    included =
      dplyr::case_when(
        REF <= 600 ~ "Total included in SEG Analysis",
        REF > 600 ~ "Total excluded in SEG Analysis"
      )
  )

  # create bgm_pair_cnt_tbl ----
  bgm_pair_cnt_tbl <- dplyr::count(samp_meas_data,
    bgm_pair_cat)
  # create bgm_pairs_tbl ----
  bgm_pairs_tbl <- dplyr::rename(.data = bgm_pair_cnt_tbl,
                      `Pair Type` = bgm_pair_cat,
                      Count = n)

  # create excluded_cnts_tbl ----
  excluded_cnts_tbl <- dplyr::count(samp_meas_data, excluded)
  # create excluded_pairs_tbl ----
  excluded_pairs_tbl <- dplyr::rename(excluded_cnts_tbl,
      `Pair Type` = excluded,
      Count = n) |>
    dplyr::filter(!is.na(`Pair Type`))

  # create Included ----
  included_cnts_tbl <- dplyr::count(samp_meas_data, included)

  included_pairs_tbl <- dplyr::rename(included_cnts_tbl,
      `Pair Type` = included,
      Count = n
    ) |>
    dplyr::filter(`Pair Type` == "Total included in SEG Analysis")

  # 2.8 create pair_types ----
  pair_types <- dplyr::bind_rows(bgm_pairs_tbl,
                                    excluded_pairs_tbl,
                                    included_pairs_tbl)
  # 2.9 add the Total row  ----
  pair_type_tbl <- tibble::add_row(pair_types,
    `Pair Type` = "Total",
    Count = nrow(samp_meas_data),
    .after = 0
  )
  return(pair_type_tbl)
}
