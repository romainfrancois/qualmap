<!-- README.md is generated from README.Rmd. Please edit that file -->
qualmap <img src="https://slu-dss.github.io/img/gisLogoSm.png" align="right" />
===============================================================================

[![lifecycle\_badge](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://github.com/slu-openGIS/qualmap) [![CRAN\_status\_badge](http://www.r-pkg.org/badges/version/gateway)](https://cran.r-project.org/package=gateway)

The goal of qualmap is to make it easy to enter data from qualitative maps.

Motivation and Approach
-----------------------

Qualitative GIS outputs are notoriously difficult to work with because individuals' conceptions of space can vary greatly from each other and from the realities of physical geography themselves. This package implements a process for converting qualitative GIS data from an exercise where respondents are asked to identify salient locations on a map. The basemaps used in this approach have a series of polygons, such as neighborhood boundaries or census geography. A circle drawn on the map is compared during data entry to a key identifying each feature, and the feature ids are entered for each feature that the respondent's cricle touches. These circles are referred to as "clusters".

Installation
------------

You can install `qualmap` from GitHub with:

``` r
devtools::install_github("slu-openGIS/qualmap")
```

Useage
------

### Verbs

`qualmap` implements a six verbs for working with mental map data:

-   `qm_define()` - create a vector of feature id numbers that constitute a single "cluster"
-   `qm_validate()` - check feature id numbers against a reference data set to ensure that the values are valid
-   `qm_preview()` - plot cluster on an interactive map to ensure the feature ids have been entered correctly (the preview should match the map used as a data collection instrument)
-   `qm_create()` - create a single cluster object once the data have been validated and visually inspected
-   `qm_combine()` - combine multiple cluster objects together into a single tibble data object
-   `qm_summarize()` - summarize the combined data object based on a single qualitative construct to prepare for mapping

### Data Preparation

To begin, you will need a simple features object containing the polygons you will be matching respondents' data to. Census geography polygons can be downloaded via `tigris`, and other polygon shapefiles can be read into `R` using the `sf` package.

Here is an example of preparing data downloaded via `tigris`:

``` r
library(dplyr)   # data wrangling
library(sf)      # simple features objects
library(tigris)  # access census tiger/line data

stLouis <- tracts(state = "MO", county = 510)
stLouis <- st_as_sf(stLouis)
stLouis <- mutate(stLouis, TRACTCE = as.numeric(TRACTCE))
```

We download the census tract data for St. Louis, which come in `sp` format, using the `tracts()` function from `tigris`. We then use the `sf` package's `st_as_sf()` function to convert these data to a simple features object and convert the `TRACTCE` variable to numeric format.

### Data Entry

Once we have a reference data set constructed, we can begin entering the tract numbers that constitute a single circle on the map or "cluster". We use the `qm_define()` function to input these id numbers into a vector:

``` r
cluster1 <- qm_define(118600, 119101, 119300)
```

We can then use the `qm_validate()` function to check each value in the vector and ensure that these values all match the `key` variable in the reference data:

``` r
> qm_validate(ref = stLouis, key = TRACTCE, value = cluster1)
[1] TRUE
```

If `qm_validate()` returns a `TRUE` value, all data are matches. If it returns `FALSE`, at least one of the input values does not match any of the `key` variable values. In this case, our `key` is the `TRACTCE` variable in the `sf` object we created earlier.

Once the data are validated, we can preview them interactively using `qm_preview()`, which will show the features identified in the given vector in red on the map:

``` r
qm_preview(ref = stLouis, key = TRACTCE, value = cluster1)
```

![](/man/figures/previewMap.png)

### Create Cluster Object

A cluster object is tibble data frame that is "tidy" - each feature in the reference data is a row. Cluster objects also contain metadata about the cluster itself: the respondent's identification number from the study, a cluster identification number, and a category that describes what the cluster represents. Clusters are created using `qm_create()`:

``` r
> cluster1_obj <- qm_create(ref = stLouis, key = TRACTCE, value = cluster1, rid = 1, cid = 1, category = "positive")
> cluster1_obj
# A tibble: 3 x 5
    RID   CID CAT      TRACTCE COUNT
* <int> <int> <chr>      <dbl> <dbl>
1     1     1 positive  119300  1.00
2     1     1 positive  118600  1.00
3     1     1 positive  119101  1.00
```

### Combine and Summarize Multiple Clusters

Once several cluster objects have been created, they can be combined using `qm_combine()` to produce a tidy tibble formatted data object:

``` r
> clusters <- qm_combine(cluster1_obj, cluster2_obj, cluster3_obj)
> clusters
# A tibble: 9 x 5
    RID   CID CAT      TRACTCE COUNT
  <int> <int> <chr>      <dbl> <dbl>
1     1     1 positive  119300  1.00
2     1     1 positive  118600  1.00
3     1     1 positive  119101  1.00
4     1     2 positive  119300  1.00
5     1     2 positive  121200  1.00
6     1     2 positive  121100  1.00
7     1     3 negative  119300  1.00
8     1     3 negative  118600  1.00
9     1     3 negative  119101  1.00
```

Since the same census tract appaers in multiple rows as part of different clusters, we need to summarize these data before we can map them. Part of `qualmap`'s opionated approach revolves around clusters represting only one construct. When we summarize, therefore, we also subset our data so that they represent only one phenomenon. In the above example, there are both "positive" and "negative" clusters. We can use `qm_summarize()` to extract only the "positive" clusters and then summarize them so that we have one row per census tract:

``` r
> pos <- qm_summarize(clusters = clusters, key = TRACTCE, category = "positive")
> pos
# A tibble: 5 x 2
  TRACTCE positive
    <dbl>    <int>
1  118600        1
2  119101        1
3  119300        2
4  121100        1
5  121200        1
```

If these data are to be mapped, the `qm_summarize()` function has an option `ref` argument that can be used to specify an `sf` object for the summarized data to be joined to:

``` r
possf <- qm_summarize(clusters = clusters, key = TRACTCE, category = "positive", ref = stLouis)
```

### Mapping Summarized Data

Finally, we can use the `geom_sf()` geom from the [development version of `ggplot2`](https://github.com/tidyverse/ggplot2) to map our summarized data, highlighting areas most discussed as being "positive" parts of St. Louis in our hypothetical study:

``` r
library(ggplot2)
library(viridis)

possf <- qm_summarize(clusters = clusters, key = TRACTCE, category = "positive", ref = stLouis)
ggplot() + 
  geom_sf(data = possf, mapping = aes(fill = positive)) + 
  scale_fill_viridis()
```

![](/man/figures/exampleMap.png)

Contributor Code of Conduct
---------------------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
