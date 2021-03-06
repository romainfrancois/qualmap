<!-- README.md is generated from README.Rmd. Please edit that file -->

qualmap <img src="man/figures/qualmapLogo.png" align="right" />
===============================================================

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis-CI Build
Status](https://travis-ci.org/slu-openGIS/qualmap.svg?branch=master)](https://travis-ci.org/slu-openGIS/qualmap)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/slu-openGIS/qualmap?branch=master&svg=true)](https://ci.appveyor.com/project/chris-prener/qualmap)
[![Coverage
Status](https://img.shields.io/codecov/c/github/slu-openGIS/qualmap/master.svg)](https://codecov.io/github/slu-openGIS/qualmap?branch=master)
[![DOI](https://zenodo.org/badge/122496910.svg)](https://zenodo.org/badge/latestdoi/122496910)
[![CRAN\_status\_badge](http://www.r-pkg.org/badges/version/qualmap)](https://cran.r-project.org/package=qualmap)

The goal of `qualmap` is to make it easy to enter data from qualitative
maps. `qualmap` provides a set of functions for taking qualitative GIS
data, hand drawn on a map, and converting it to a simple features
object. These tools are focused on data that are drawn on a map that
contains some type of polygon features. For each area identified on the
map, the id numbers of these polygons can be entered as vectors and
transformed using `qualmap`.

News
----

`qualmap` is under construction right now as a new release is prepared.
Among the changes:

-   Add `qm_verify()` as a means for verifying data data previously
    saved to disk prior to processing them with `qm_summarize()`
-   Add second approach to producing counts using `qm_summarize()` that
    returns counts of participants rather than counts of clusters
    associated with each feature
-   Remove the inclusion of the `COUNT` from what is returned with
    `qm_create()`

Motivation and Approach
-----------------------

Qualitative GIS outputs are notoriously difficult to work with because
individuals’ conceptions of space can vary greatly from each other and
from the realities of physical geography themselves. `qualmap` builds on
a semi-structured approach to qualitative GIS data collection.
Respondents use a specially designed basemap that allows them free reign
to identify geographic features of interest and makes it easy to convert
their annotations into digital map features. This is facilitated by
including on the basemap a series of polygons, such as neighborhood
boundaries or census geography, along with an identification number that
can be used by `qualmap`. A circle drawn on the map can therefore be
easily associated with the features that it touches or contains.

`qualmap` provides a suite of functions for entering, validating, and
creating `sf` objects based on these hand drawn clusters and their
associated identification numbers. Once the clusters have been created,
they can be summarized and analyzed either within R or using another
tool.

This approach provides an alternative to either unstructured qualitative
GIS data, which are difficult to work with empirically, and to
digitizing respondents’ annotations as rasters, which require a
sophisticated workflow. This semi-structured approach makes integrating
qualitative GIS with existing census and administrative data simple and
straightforward, which in turn allows these data to be used as measures
in spatial statistical models.

More details on the package and how it fits into the broader ecosystem
of qualitative GIS are available in a [pre-print on
SocArXiv](https://osf.io/preprints/socarxiv/p9qn5/). All data associated
with the pre-print are also available on [Open Science
Framework](https://osf.io/pxzuc/), and the code are available via [Open
Science Framework](https://osf.io/pxzuc/) and
[GitHub](http://github.com/PrenerLab/sketch_mapping/).

Installation
------------

### Installing Dependencies

You should check the [`sf` package
website](https://r-spatial.github.io/sf/) for the latest details on
installing dependencies for that package. Instructions vary
significantly by operating system. For best results, have `sf` installed
before you install `qualmap`. Other dependencies, like `dplyr` and
`leaflet`, will be installed automatically with `qualmap` if they are
not already present.

### Installing qualmap

The easiest way to get `qualmap` is to install it from CRAN:

``` r
install.packages("qualmap")
```

You can install the development version of `qualmap` from
[Github](https://github.com/slu-openGIS/qualmap) with the `remotes`
package:

``` r
# install.packages("remotes")
remotes::install_github("slu-openGIS/qualmap")
```

Usage
-----

`qualmap` implements six primary verbs for working with mental map data:

1.  `qm_define()` - create a vector of feature id numbers that
    constitute a single “cluster”
2.  `qm_validate()` - check feature id numbers against a reference data
    set to ensure that the values are valid
3.  `qm_preview()` - plot cluster on an interactive map to ensure the
    feature ids have been entered correctly (the preview should match
    the map used as a data collection instrument)
4.  `qm_create()` - create a single cluster object once the data have
    been validated and visually inspected
5.  `qm_combine()` - combine multiple cluster objects together into a
    single tibble data object
6.  `qm_summarize()` - summarize the combined data object based on a
    single qualitative construct to prepare for mapping

The [primary
vignette](https://slu-openGIS.github.io/qualmap/articles/qualmap.html)
contains an overview of the workflow for implementing these functions.

Contributor Code of Conduct
---------------------------

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
