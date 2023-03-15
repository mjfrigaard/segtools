## code to prepare `test_table` dataset goes here
test_table <-

  structure(

    list(

      double_var = c(3.49, 5.543, 88.45, 20.44, 1.5),

      character_var = c("Bird", "Fox", "Tree", "Pond", "Car"),

      long_character_var = c(
        "These days a chicken leg is a rare dish.",
        "The chap slipped into the crowd and was lost.",
        "A stuffed chair slipped from the moving van.",
        "She danced like a swan, tall and graceful.",
        "Bring your best compass to the third class."
      ),

      factor_var = structure(
        c(2L, 3L, 4L, 1L, 5L),
        levels = c(
          "Very Low", "Low", "Med", "High", "Very High"
        ),
        class = "factor"
      ),

      logical_var = c(
        TRUE, TRUE, TRUE, FALSE, FALSE
      ),

      integer_var = c(
        2L, 4L, 9L, 100L, 29L
      )
    ),

    class = "data.frame",

    row.names = c(NA, -5L)

  )
usethis::use_data(test_table, overwrite = TRUE)
