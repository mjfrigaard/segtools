% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/seg_iso_range_tbl.R
\name{seg_iso_range_tbl}
\alias{seg_iso_range_tbl}
\title{SEG iso range table}
\usage{
seg_iso_range_tbl(risk_vars)
}
\arguments{
\item{risk_vars}{output from \code{seg_risk_vars()}}
}
\value{
ISO range variables
}
\description{
SEG iso range table
}
\examples{
test_data <- vroom::vroom(
                system.file("extdata", "VanderbiltComplete.csv",
                package = "segtools"), delim = ",")
risk_cols_tbl <- seg_risk_vars(df = test_data)
seg_iso_range_tbl(risk_cols_tbl)
}
