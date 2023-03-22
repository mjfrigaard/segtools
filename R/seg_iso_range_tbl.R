#' SEG iso range table
#'
#' @param risk_cols output from `seg_risk_cols()`
#'
#' @return ISO range variables
#' @export seg_iso_range_tbl
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' risk_cols_tbl <- seg_risk_cols(df = test_data)
#' seg_iso_range_tbl(risk_cols_tbl)
seg_iso_range_tbl <- function(risk_cols) {

  lkpISORanges <- tibble::tribble(
       ~ID,                ~iso_range,
        1L,    "<= 5% or 5 mg/dL",
        2L,  "> 5 - 10% or mg/dL",
        3L, "> 10 - 15% or mg/dL",
        4L,    "> 15 - 20% mg/dL",
        5L,   "> 20% or 20 mg/dL")

  iso_range_cnts <- dplyr::count(risk_cols,
    iso_range,
    sort = TRUE
  )

  iso_range_joined <- dplyr::full_join(
    x = iso_range_cnts,
    y = lkpISORanges,
    by = "iso_range"
  )
    iso_range_vars <- dplyr::mutate(iso_range_joined,
    Percent = base::paste0(
      base::round(n / nrow(risk_cols) * 100,
        digits = 1
      ),
      dplyr::if_else(condition = is.na(n),
        true = "",
        false = "%"
      )
    )
  ) |>
    dplyr::arrange(desc(n))

  iso_range_tbl <- dplyr::select(iso_range_vars, ID,
    `ISO range` = iso_range,
    N = n,
    Percent
  )
  return(iso_range_tbl)
}
