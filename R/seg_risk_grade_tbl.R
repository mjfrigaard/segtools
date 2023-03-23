#' SEG risk grade table
#'
#' @param risk_vars output from `seg_risk_vars()`
#'
#' @return risk grade table
#' @export seg_risk_grade_tbl
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' risk_cols_tbl <- seg_risk_vars(df = test_data)
#' seg_risk_grade_tbl(risk_cols_tbl)
seg_risk_grade_tbl <- function(risk_vars) {
  risk_grade_cnts <- dplyr::count(risk_vars,
    risk_grade,
    sort = TRUE
  )

  lkpRiskGrade <- tibble::tibble(
      risk_grade_id = c(1, 2, 3, 4, 5),
      risk_grade = c("A", "B", "C", "D", "E"),
      REF = c("0 - 0.5", "> 0.5 - 1.0", "> 1.0 - 2.0", "> 2.0 - 3.0", "> 3.0"))

  risk_grade_joined <- dplyr::full_join(
    x = risk_grade_cnts,
    y = lkpRiskGrade,
    by = "risk_grade"
  )

  # change lkp table variables
  risk_grade_vars_tbl <- dplyr::mutate(
    .data = risk_grade_joined,
    risk_grade_id = as.numeric(risk_grade_id),
    Percent = base::paste0(
      base::round(n / nrow(risk_vars) * 100,
        digits = 1
      ),
      if_else(condition = is.na(n),
        true = "", false = "%"
      )
    )
  ) |>
    # rename variables
    dplyr::select(
      ID = risk_grade_id,
      `Risk Grade` = risk_grade,
      `Number of Pairs` = n,
      Percent,
      # `REF Range` = REF
      `Risk Factor Range` = REF
    )
  return(risk_grade_vars_tbl)
}
