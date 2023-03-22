## code to prepare `RiskPairData` dataset goes here
require(vroom)
github_data_root <-
      "https://raw.githubusercontent.com/mjfrigaard/seg-shiny-data/master/Data/"
app_riskpair_repo <- base::paste0(
      github_data_root,
      "AppRiskPairData.csv"
    )
RiskPairData <- vroom::vroom(file = app_riskpair_repo, delim = ",")

usethis::use_data(RiskPairData, overwrite = TRUE)
