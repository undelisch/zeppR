tagList(
  layout_column_wrap(
    width = 1/2,
    
    card(
      card_header("Personal Data"),
      card_body(
        
        layout_column_wrap(
          width = 1/2,
          
          div(
            shinyFiles::shinyDirButton(
              "data_dir",
              "Select data directory",
              "Choose your data directory"
            ),
            p(
              ""
            )
          )
        )
      )
    ),
    
    card(
      card_header("Personal Data"),
      card_body(
        layout_columns(
          col_widths = c(4, 8),
          
          "Height",
          numericInput("height", NULL, value = 160),
          
          "Gender",
          selectInput(
            "gender",
            NULL,
            choices = c("Female", "Male", "Other")
          ),
          
          "Age",
          numericInput("age", NULL, value = 30)
        )
      )
    )
  ),
  actionButton("submitButton", "Save"),
  br()
)
