#' App data switch (function data switch)
#'
#' @param data name of data
#' @param app logical, app data or not
#'
#' @return Lookup table
#' @export app_data_switch
#'
#' @examples
#' app_data_switch(data = "RiskPairData", app = TRUE)
app_data_switch <- function(data, app) {
  if (app == TRUE) {
    app_data_file <- data
      switch(EXPR = app_data_file,
       LookUpRiskCat = segtools::AppLookUpRiskCat,
       RiskPairData = segtools::AppRiskPairData
      )
  } else {
    data_file <- data
      switch(EXPR = data_file,
       LookUpRiskCat = segtools::LookUpRiskCat,
       RiskPairData = segtools::RiskPairData
      )
  }
}
