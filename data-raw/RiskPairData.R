## code to prepare `RiskPairData` dataset goes here
require(vroom)
RiskPairData <- vroom::vroom("inst/extdata/RiskPairData.csv")
names(RiskPairData) <- c("RiskPairID", "REF", "BGM", "RiskFactor")

# identical(segtools::AppRiskPairData$REF, RiskPairData$REF)
# identical(segtools::AppRiskPairData$BGM, RiskPairData$BGM)
#
usethis::use_data(RiskPairData, overwrite = TRUE)
