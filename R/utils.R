#' Find inst/extdata/ paths
#'
#' @return list of absolute file paths for `inst/extdata`
#' @export list_extdata_paths
#'
#' @examples
#' list_extdata_paths()
list_extdata_paths <- function() {
    curr_path <- base::getwd()
    curr_folder <- base::basename(curr_path)
    parent_path <- stringr::str_remove_all(
      string = curr_path,
      paste0("/", curr_folder)
    )
    # get all current paths
    curr_path_files <- base::list.files(
      path = curr_path,
      full.names = TRUE, recursive = TRUE
    )
    # get all parent paths
    parent_path_files <- base::list.files(
      path = parent_path,
      full.names = TRUE, recursive = TRUE
    )
    # combine
    all_paths <- c(curr_path_files, parent_path_files)
    # return only those with inst/extdata
    all_paths[stringr::str_detect(all_paths, "inst/extdata")]
  }

#' Import data files from inst/extdata/ folder
#'
#' @description Intended to be used inside pakcage folder
#'
#' @param file_name name of file
#'
#' @return data file
#' @export get_extdata
#'
#' @importFrom stringr str_detect
#' @importFrom cli cli_alert_danger cli_abort
#' @importFrom glue glue_collapse glue
#' @importFrom tools file_path_as_absolute
#' @importFrom fs file_exists
#' @importFrom vroom vroom
#'
#' @examples
#' # meant to be used for package development!
#' # get_extdata("RiskPairData.csv")
#' # get_extdata("AppRiskPairData.csv")
get_extdata <- function(file_name) {

  all_files <- list_extdata_paths()

  search_file <- file_name

  pth_detected <- all_files[stringr::str_detect(all_files, search_file)]

  pth_detected

  if (length(pth_detected) > 1) {
    cli::cli_alert_danger(
      paste0(
        "More than one file \n\n",
        glue::glue_collapse(
          glue::glue("{pth_detected}"),
          sep = "\n"
        ),
        "\n\n Please refine file name"
      )
    )
  } else if (length(pth_detected) == 0) {
    cli::cli_abort("not a file")
  } else {
    abs_pth <- tools::file_path_as_absolute(pth_detected)

    if (isFALSE(fs::file_exists(abs_pth))) {
      cli::cli_abort("not a file")
    } else {
      vroom::vroom(abs_pth, delim = ",", show_col_types = FALSE)
    }
  }
}


#' RGB to hex color
#'
#' @param r red
#' @param g green
#' @param b blue
#'
#' @return colors as hex
#' @export rgb2hex
#'
#' @examples
#' rgb2hex(0, 165, 0)
rgb2hex <- function(r, g, b) {
  rgb(r, g, b, maxColorValue = 255)
}


#' Get roxygen2 tags (`@importFrom`)
#'
#' @param pkg package (must be installed)
#' @param fun string of function names
#'
#' @return tags for `roxygen2`
#' @export get_importFrom
#'
#' @examples
#' require(bs4Dash)
#' get_importFrom(pkg = 'bs4Dash', fun = 'valueBox')
get_importFrom <- function(pkg, fun = NULL) {
  if (is.null(fun)) {
    pkg_search <- paste0("package:", pkg)
    pkg_funs <- ls(pkg_search)
    glue::glue("#' @importFrom {pkg} {pkg_funs}")
  } else {
    pkg_search <- paste0("package:", pkg)
    pkg_funs <- ls(pkg_search)
    funs_found <- pkg_funs[stringr::str_detect(pkg_funs, fun)]
    glue::glue("#' @importFrom {pkg} {funs_found}")
  }
}

#' Get installed packages
#'
#' @return character vector of installed packages
#' @export get_pkgs
#'
#' @examples
#' get_pkgs()
get_pkgs <- function() {
  pkg_lst <- installed.packages()
  pkg_dimnames <- attr(pkg_lst, "dimnames")
  pkgs <- pkg_dimnames[[1]]
  dput(pkgs)
}

