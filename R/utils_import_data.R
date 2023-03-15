#' Import plain text data file
#'
#' @param path path to file
#'
#' @return imported flat file
#'
#' @importFrom vroom vroom
#' @importFrom tibble as_tibble
#'
#' @export import_flat_file
import_flat_file <- function(path) {
  ext <- tools::file_ext(path)
  data <- switch(ext,
    txt = vroom::vroom(path, show_col_types = FALSE),
    csv = vroom::vroom(path, delim = ",", show_col_types = FALSE),
    tsv = vroom::vroom(path, delim = "\t", show_col_types = FALSE)
  )
  # just to be sure
  return_data <- tibble::as_tibble(data)
  return(return_data)
}


#' Import plain text or excel data
#'
#' @param path path to file
#' @param sheet sheet number or name (if .xlsx)
#'
#' @return imported data
#' @export import_data
#'
#' @importFrom tools file_ext
#' @importFrom readxl read_excel
#' @importFrom tibble as_tibble
#'
import_data <- function(path, sheet = NULL) {
  ext <- tools::file_ext(path)
  if (ext == "xlsx") {
    raw_data <- readxl::read_excel(
        path = path,
        sheet = sheet
      )
    uploaded <- tibble::as_tibble(raw_data)
  } else {
    # call the import function
    uploaded <- import_flat_file(path = path)
  }
  return(uploaded)
}
