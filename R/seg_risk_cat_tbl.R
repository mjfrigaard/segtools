#' SEG risk category table
#'
#' @param risk_cols output from `seg_risk_cols()`
#'
#' @return risk cat variable table
#' @export seg_risk_cat_tbl
#'
#' @examples
#' test_data <- vroom::vroom(
#'                 system.file("extdata", "VanderbiltComplete.csv",
#'                 package = "segtools"), delim = ",")
#' risk_cols_tbl <- seg_risk_cols(df = test_data)
#' seg_risk_cat_tbl(risk_cols_tbl)
seg_risk_cat_tbl <- function(risk_cols) {
  # count risk cats
  risk_cat_cnts <- dplyr::count(risk_cols,
    risk_cat,
    sort = TRUE
  )

  # define lkpSEGRiskCat4 ----
  lkpSEGRiskCat4 <- tibble::tibble(
    risk_cat = 0:7,
    risk_cat_txt = c(
      "None",
      "Slight, Lower",
      "Slight, Higher",
      "Moderate, Lower",
      "Moderate, Higher",
      "Severe, Lower",
      "Severe, Upper",
      "Extreme"
    ),
    ABSLB = c(-0.001, 0.5, 1, 1.5, 2, 2.5, 3, 3),
    ABSUB = c(0.5, 1, 1.5, 2, 2.5, 3, 3.5, 1000)
  )

  risk_cat_joined <- dplyr::full_join(
    x = risk_cat_cnts,
    y = lkpSEGRiskCat4,
    by = "risk_cat"
  )

  risk_cat_cols <- dplyr::mutate(
    risk_cat_joined,
    risk_cat = as.numeric(risk_cat),
    Percent = base::paste0(
      base::round(n / nrow(risk_cols) * 100,
        digits = 1
      ),
      if_else(
        condition = is.na(n),
        true = "",
        false = "%"
      )
    )
  ) |>
    dplyr::arrange(desc(n))

  risk_cat_vars <- dplyr::select(risk_cat_cols,
    `SEG Risk Level` = risk_cat,
    `SEG Risk Category` = risk_cat_txt,
    `Number of Pairs` = n,
    Percent
  )
  return(risk_cat_vars)
}
