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
#'
#' @examples
#' test_data <- import_flat_file(system.file("extdata", "VanderbiltComplete.csv",
#'                               package = "segtools"))
#' utils::str(test_data)
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
