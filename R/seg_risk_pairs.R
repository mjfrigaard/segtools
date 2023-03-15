#' SEG Risk Pair Variables
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#' @param app_data logical, include data with `App` prefix
#'
#' @return seg risk pair variables
#' @export seg_risk_pairs
#'
#' @importFrom dplyr mutate case_when inner_join
#' @importFrom dplyr filter bind_rows if_else
#'
#' @examples
#' seg_risk_pairs(data = system.file("extdata", "VanderbiltComplete.csv",
#'        package = "segtools"), is_path = TRUE)
seg_risk_pairs <- function(data, is_path) {
  # import bgm ref/vars
  bgm_ref_vars <- seg_bgm_ref_vars(data = data, is_path = is_path)
  # get risk pairs data (from APP)
  risk_pair_data <- app_data_switch(
    data = "RiskPairData",
    app = TRUE)
  # join to risk_pair_data ----
  risk_pairs <- dplyr::inner_join(
    x = bgm_ref_vars,
    y = risk_pair_data,
    by = c("BGM", "REF")
  )
  return(risk_pairs)
}




