
<!-- README.md is generated from README.Rmd. Please edit that file -->

<br>

<img src="man/figures/package_hex.png" width="20%" style="display: block; margin: auto 0 auto auto;" />

<br>

# segtools

<!-- badges: start -->
<!-- badges: end -->

`segtools` provides the underlying functions and calculations for [The
Surveillance Error Grid](https://www.diabetestechnology.org/seg.shtml)
shiny application.

For more information, see the original paper:

Klonoff, David C., Courtney Lias, Robert Vigersky, William Clarke, Joan
Lee Parkes, David B. Sacks, M. Sue Kirkman, et al. 2014. “*The
Surveillance Error Grid.*” Journal of Diabetes Science and Technology 8
(4): 658–72. <https://doi.org/10.1177/1932296814539589>

## Installation

You can install the development version of `segtools` from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("mjfrigaard/segtools")
```

## Previous work

The previous shiny applications are stored in the [Quesgen GitHub
repositories](https://github.com/quesgen):

- [Version 1.3.2](https://github.com/quesgen/seg-shiny-1-3-2)

- [Version 1.3.3](https://github.com/quesgen/seg-shiny-1-3-3)

## SEG Graph

The SEG graph can be created from a dataset with `BGM` and `REF` values:

``` r
library(segtools)
library(vroom)
# import data
test_data <- vroom::vroom(
  file =
    system.file("extdata", "VanderbiltComplete.csv",
        package = "segtools"), delim = ",")
# plot
segtools::seg_graph(
  data = test_data
)
```

<img src="man/figures/example-1.png" width="100%" />

Read more [here](https://www.diabetestechnology.org/seg.shtml).
