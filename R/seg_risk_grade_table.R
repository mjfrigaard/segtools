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
    # join to segtools::lkpRiskGrade ----
    # previously lkpRiskGrade
    dplyr::full_join(
      y = segtools::lkpRiskGrade,
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
