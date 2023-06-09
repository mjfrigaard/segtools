% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/seg_risk_cat_tbl.R
\name{seg_risk_cat_tbl}
\alias{seg_risk_cat_tbl}
\title{SEG risk category table}
\usage{
seg_risk_cat_tbl(risk_vars)
}
\arguments{
\item{risk_vars}{output from \code{seg_risk_vars()}}
}
\value{
risk cat variable table
}
\description{
SEG risk category table
}
\examples{
test_data <- vroom::vroom(
                system.file("extdata", "VanderbiltComplete.csv",
                package = "segtools"), delim = ",")
risk_cols_tbl <- seg_risk_vars(df = test_data)
seg_risk_cat_tbl(risk_cols_tbl)
}
