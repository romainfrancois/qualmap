% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qm_combine.R
\name{qm_combine}
\alias{qm_combine}
\title{Combine objects}
\usage{
qm_combine(...)
}
\arguments{
\item{...}{A list of cluster objects to be combined.}
}
\value{
A single tibble with all observations from the listed cluster objects. This tibble is
stored with a custom class of \code{qm_cluster} to facilitate data validation.
}
\description{
A wrapper around \code{dplyr::bind_rows} for combining cluster objects created with
\code{qm_create} into a single tibble. Input data for \code{qm_combine} are validated using
\code{qm_is_cluster} as part of the cluster object creation process.
}
\examples{
# load and format reference data
stl <- stLouis
stl <- dplyr::mutate(stl, TRACTCE = as.numeric(TRACTCE))

# create clusters
cluster1 <- qm_define(118600, 119101, 119300)
cluster2 <- qm_define(119300, 121200, 121100)

# create cluster objects
cluster_obj1 <- qm_create(ref = stl, key = TRACTCE, value = cluster1,
    rid = 1, cid = 1, category = "positive")
cluster_obj2 <- qm_create(ref = stl, key = TRACTCE, value = cluster2,
    rid = 1, cid = 2, category = "positive")

# combine cluster objects
clusters <- qm_combine(cluster_obj1, cluster_obj2)

}
\seealso{
\code{qm_create}, \code{qm_is_cluster}
}
