#' The SEG modified Bland-Altman plot
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param is_path logical, dataset or path to dataset
#'
#' @return modified Bland-Altman plot
#' @export seg_modba_graph
#'
#' @examples
#' require(vroom)
#' vanderbilt_complete <- vroom::vroom(
#'  file =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"), delim = ",")
#' seg_modba_graph(data = vanderbilt_complete, is_path = FALSE)

seg_modba_graph <- function(data) {

  risk_tbl <- seg_risk_vars(df = data)

      # calculate LN of REF and BGM -----

      ln_risk_tbl <- dplyr::mutate(risk_tbl,

        lnREF = log(REF),

        lnBGM = log(BGM),

        lnDiff = lnBGM - lnREF,

        rel_perc_diff = exp(lnDiff) - 1

      )

      # create points layer -----
      ggplot2::ggplot(data = ln_risk_tbl,
        mapping = aes(x = REF,
                          y = rel_perc_diff)) +

      ggplot2::geom_point(alpha = 0.5, color = "royalblue") +

      ggplot2::scale_y_continuous(

        name = "% Error",

        limits = c(-0.50, 0.50)

      ) +

      # use segtools::seg_bland_altman_ref_vals -----

      ggplot2::geom_line(aes(x = Ref, y = UB),

        data = segtools::APPSEGBlandAltmanRefVals,

        linetype = "1111",

        color = "red",

        linewidth = 2.5

      ) +

      ggplot2::geom_line(aes(x = Ref, y = LB),

        data = segtools::APPSEGBlandAltmanRefVals,

        linetype = "1111",

        color = "red",

        linewidth = 2.5

      ) +

    segtools::theme_seg()
}