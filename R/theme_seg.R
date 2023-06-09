#' ggplot2 theme (for SEG grid)
#'
#' @param base_size font size
#' @param base_family font family
#' @param base_line_size base graph line size
#' @param base_rect_size base graph rectangle size
#'
#' @return ggplot2 theme
#' @export theme_seg
#'
theme_seg <- function(base_size = 14, base_family = "Ubuntu",
                        base_line_size = base_size / 22,
                        base_rect_size = base_size / 22) {

  half_line <- base_size / 2
  # most of this is borrowed from theme_minimal()/theme_void(), but with some
  # adjustments to panel, margins, and legend see the original here:
  # https://github.com/tidyverse/ggplot2/blob/d9f179b038f020158773fac54af9a84cf961b54b/R/theme-defaults.r#L459
  thm <- theme(
    # RECTANGLE ----------------------------------------------------
    rect =               element_blank(),
    # TEXT ---------------------------------------------------------
    text =               element_text(
                            family = "Ubuntu",
                            # face = "plain",
                            colour = "black",
                            size = base_size,
                            lineheight = 0.9,
                            hjust = 0.5, vjust = 0.5,
                            angle = 0,
                            margin = margin(),
                            debug = FALSE),
    ## AXES --------------------------------------------------------------
    axis.text =          element_text(
                            family = base_family, size = rel(0.65)),
    axis.title.x =       element_text(vjust = -4.75),
    axis.title.y =       element_text(vjust = 4.25, angle = 90),
    axis.title =         element_text(size = rel(0.8)),
    ### AXIS TICKS ----
    ## remove all axis ticks
    ## https://ggplot2-book.org/polishing.html#theme-axis
    axis.ticks.length =  unit(0, "pt"),
    axis.ticks.length.x = NULL,
    axis.ticks.length.x.top = NULL,
    axis.ticks.length.x.bottom = NULL,
    axis.ticks.length.y = NULL,
    axis.ticks.length.y.left = NULL,
    axis.ticks.length.y.right = NULL,
    ## STRIP ----
    ##
    strip.clip =         "inherit",
    strip.text.x =         element_text(size = rel(0.7)),
    # strip.text.x affects both facet_wrap() or facet_grid()
    strip.text.y =         element_text(size = rel(0.7)),
    # strip.text.y only affects facet_grid()
    strip.switch.pad.grid = unit(half_line / 2, "pt"),
    strip.switch.pad.wrap = unit(half_line / 2, "pt"),
    strip.background = element_rect(fill = "#d0d0d0"),
    ## PANEL ----
    ## here we introduce thin, light gray lines for the graph area (with
    ## vertical lines slightly larger than horizontal lines)
    ## https://ggplot2-book.org/polishing.html#panel-elements
    panel.ontop =        FALSE,
    panel.spacing =      unit(half_line, "pt"),
    panel.grid.major.x = element_line(color = "#d0d0d0", linewidth = 0.3),
    panel.grid.major.y = element_line(color = "#d0d0d0", linewidth = 0.3),
    panel.grid.minor.x = element_line(color = "#d0d0d0", linewidth = 0.1),
    panel.grid.minor.y = element_line(color = "#d0d0d0", linewidth = 0.1),
    ## TITLES ----
    ### Title -----
    # location of title
    plot.title.position = "panel",
    ## slightly larger text
    plot.title =         element_text(
                           size = rel(1.1),
                           hjust = 0, vjust = 2,
                           margin = margin(b = half_line)
                         ),
    ### subtitle -----
    # slightly smaller text, italic
    plot.subtitle =      element_text(
                           size = rel(0.9),
                           hjust = 0, vjust = 2,
                           margin = margin(b = half_line)
                         ),
    ### caption -----
    plot.caption =       element_text(
                           size = rel(0.8),
                           hjust = 1, vjust = 1,
                           margin = margin(b = half_line)
                         ),

    plot.caption.position = "panel",
    ### tag -----
    plot.tag =           element_text(
                           size = rel(1.2),
                           hjust = 0.5, vjust = 0.5
                         ),
    plot.tag.position =  'topleft',
    ## LEGEND ----
    ## https://ggplot2-book.org/polishing.html#legend-elements
    # legend.direction =   "",
    # legend.box.just =    "",
    legend.box =         NULL,
    legend.key.size =    unit(1.2, "lines"),
        # the positioning is = c(horizontal, vertical)
        # c(1, 0) = bottom right
        # c(0.5, 0.5) = dead center
        # c(0, 1) = top left
        # https://ggplot2-book.org/scale-colour.html#legend-layout
    # legend.position =    c(1, 0.5), # c(horizontal, vertical)
    # legend.justification = c(-0.015, 0.0), # c(horizontal, vertical)
    legend.text =        element_text(
                            size = rel(0.60)),
    legend.title =       element_text(
                            size = rel(0.70),
                            hjust = 0),
    # legend.margin =      unit(c(1.5, 1.5, 1.5, 1.5), "mm"),
    legend.margin =      margin(t = 2.5, r = 2.5, b = 2.5, l = 2.5),
    ## PLOT MARGIN ----
    ## https://ggplot2-book.org/polishing.html#plot-elements
    plot.margin =        unit(x = c(1.5, 5.0, 1.5, 1.5), "lines"),
    complete = TRUE
 )
  return(thm)
}
