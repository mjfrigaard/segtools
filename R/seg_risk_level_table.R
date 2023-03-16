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
    y = segtools::lkpSEGRiskCat4,
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
