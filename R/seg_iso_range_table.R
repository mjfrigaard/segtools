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
        y = segtools::lkpISORanges,
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
