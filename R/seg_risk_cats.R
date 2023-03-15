#' SEG Risk Category Variables
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return seg risk category variables
#' @export seg_risk_pairs
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
                  is_path = is_path,
                  app_data = TRUE)
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
