% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qm_define.R
\name{qm_define}
\alias{qm_define}
\title{Define input values}
\usage{
qm_define(...)
}
\arguments{
\item{...}{A comma separated list of individual features}
}
\value{
A vector list each feature.
}
\description{
A wrapper around \code{base::c} that is used for constructing vectors of individual feature values.
Each output should correspond to a single cluster on the respondent's map.
}
\examples{
cluster <- qm_define(118600, 119101, 119300)

}
