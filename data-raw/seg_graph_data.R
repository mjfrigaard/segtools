## code to prepare `base_data` dataset goes here
base_data <- data.frame(
  x_coordinate = 0,
  y_coordinate = 0,
  color_gradient = c(0:4)
)
usethis::use_data(base_data, overwrite = TRUE)

## code to prepare `mmolConvFactor` dataset goes here
mmolConvFactor <- 18.01806
usethis::use_data(mmolConvFactor, overwrite = TRUE)

## code to prepare `seg_gaussian_array` dataset goes here
seg_gaussian_array <- png::readPNG("inst/extdata/seg600.png")
usethis::use_data(seg_gaussian_array, overwrite = TRUE)

## code to prepare `risk_factor_colors` dataset goes here
# risk factor colors ----
# These are the values for the colors in the heatmap.
abs_risk_0.0000_color <- rgb2hex(0, 165, 0)
# abs_risk_0.0000_color
abs_risk_0.4375_color <- rgb2hex(0, 255, 0)
# abs_risk_0.4375_color
abs_risk_1.0625_color <- rgb2hex(255, 255, 0)
# abs_risk_1.0625_color
abs_risk_2.7500_color <- rgb2hex(255, 0, 0)
# abs_risk_2.7500_color
abs_risk_4.0000_color <- rgb2hex(128, 0, 0)
# abs_risk_4.0000_color
risk_factor_colors <- c(
  abs_risk_0.0000_color,
  abs_risk_0.4375_color,
  abs_risk_1.0625_color,
  abs_risk_2.7500_color,
  abs_risk_4.0000_color
)
usethis::use_data(risk_factor_colors, overwrite = TRUE)
