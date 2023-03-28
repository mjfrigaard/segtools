#' ggplot2 function for SEG grid
#'
#' @param data Dataset containing only `BGM` and `REF` columns
#' @param alpha_var alpha setting
#' @param size_var size setting
#' @param color_var color setting
#' @param fill_var fill setting
#'
#' @return SEG grid graph
#' @export seg_graph
#'
#' @examples
#' require(vroom)
#' vanderbilt_complete <- vroom::vroom(
#'  file =
#'    system.file("extdata", "VanderbiltComplete.csv",
#'                package = "segtools"), delim = ",")
#' seg_graph(vanderbilt_complete)
seg_graph <- function(data,
                      text_size = 14,
                      alpha_var = 0.6,
                      size_var = 2.3,
                      color_var = "#000000",
                      fill_var = "#FFFFFF") {

  risk_tbl <- seg_risk_vars(df = data)

  base_layer <- segtools::base_data |>
  ggplot(aes(
      x = x_coordinate,
      y = y_coordinate,
      fill = color_gradient)) +
  geom_point(size = 0.00000001,
             color = "white")
  scales_layer <- base_layer +
    ggplot2::scale_y_continuous(
      limits = c(0, 600),
      sec.axis =
        sec_axis(~. / segtools::mmolConvFactor,
          name = "Measured blood glucose (mmol/L)"
        ),
      name = "Measured blood glucose (mg/dL)"
    ) +
    scale_x_continuous(
      limits = c(0, 600),
      sec.axis =
        sec_axis(~. / segtools::mmolConvFactor,
          name = "Reference blood glucose (mmol/L)"
        ),
      name = "Reference blood glucose (mg/dL)"
    )

  gaussian_layer <- scales_layer +
  ggplot2::annotation_custom(
    grid::rasterGrob(image = segtools::seg_gaussian_array,
                               width = unit(1,"npc"),
                               height = unit(1,"npc")),
                               xmin = 0,
                               xmax =  600,
                               ymin = 0,
                               ymax =  600) +
    ggplot2::scale_fill_gradientn(
        values = scales::rescale(
          c(
          0, # darkgreen
          0.4375, # green
          1.0625, # yellow
          2.75, # red
          4.0 # brown
        )),
        limits = c(0, 4),
        colors = segtools::risk_factor_colors,
        guide = guide_colorbar(
          ticks = FALSE,
          barheight = unit(100, "mm")
        ),
        breaks = c(
          0.25,
          1,
          2,
          3,
          3.75
        ),
        labels = c(
          "none",
          "slight",
          "moderate",
          "high",
          "extreme"
        ),
        name = "risk level")

  seg_grid <- gaussian_layer +
  ggplot2::geom_point(
    data = risk_tbl,
    ggplot2::aes(
      x = REF,
      y = BGM
    ),
    shape = 21,
    color = color_var,
    size = size_var,
    fill = fill_var,
    alpha = alpha_var,
    stroke = 0.4
  )

  seg_grid +
    theme_seg(base_size = text_size)

}
