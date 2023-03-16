# external packages ----
c("attachment", "cli", "config", "devtools",
  "dplyr", "datapasta", "rhub", "extrafont",
  "fs", "ggplot2", "glue", "janitor", "jpeg",
  "knitr", "png", "purrr", "rmarkdown",
  "shiny", "shinyjs", "showtext", "spelling",
  "stringr", "styler", "sysfonts",
  "testthat", "tibble", "vroom", "waldo") -> ext_pkgs
# dput(unique(sort(ext_pkgs)))
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
# ext_pkgs <- c('dplyr', 'vroom', 'janitor', 'extrafont', 'sysfonts', 'showtext')
pak::pkg_install(ext_pkgs)
