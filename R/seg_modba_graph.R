#' The SEG modified Bland-Altman plot
#'
#' @param data Dataset containing only `BGM` and `REF` columns
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
        mapping = ggplot2::aes(x = REF, y = rel_perc_diff)) +

      ggplot2::geom_point(
        alpha = 1.0,
        size = 2.5,
        shape = 21,
        fill = "#FFFFFF",
        color = "#005b96") +

        ggplot2::geom_point(
        alpha = 1.0,
        shape = 21,
        size = 1.88,
        color = "#def3f6", #03396c
        fill = "#03396c") +

      ggplot2::scale_y_continuous(
        limits = c(-0.50, 0.50)
      ) +

      ggplot2::geom_line(
        ggplot2::aes(x = Ref, y = UB),
        data = segtools::APPSEGBlandAltmanRefVals,
        linetype = "dotted",
        lineend = "round",
        linejoin = "round",
        color = "#ce2b37",
        linewidth = 2.2,
        alpha = 0.85
      ) +

      ggplot2::geom_line(
        ggplot2::aes(x = Ref, y = LB),
        data = segtools::APPSEGBlandAltmanRefVals,
        linetype = "dotted",
        lineend = "round",
        linejoin = "round",
        color = "#ce2b37",
        linewidth = 2.2,
        alpha = 0.85
      ) +

    ggplot2::labs(title = "Modified Bland–Altman Plot",
        subtitle = "Blood Glucose Monitoring Surveillance Program",
        x = "Reference (mg/dL)", y = "% Error") +

    segtools::theme_seg(base_size = 16)
}
