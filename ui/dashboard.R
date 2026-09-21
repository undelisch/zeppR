# testing dashboard with real data
tagList(
  
  layout_column_wrap(
    width = 1/4,
    
    card(
      card_header("Weight"),
      card_body(
        h2(
          textOutput("db_last_weight", inline = TRUE),
          " kg"
        ),
        # h2(textOutput("db_last_weight", inline = TRUE)),
        p(
          "7d Median: ",
          textOutput("db_median_weight", inline = TRUE)," kg"),
        p("▲",textOutput("db_delta_weight_max", inline = TRUE),"kg"),
        p("▼",textOutput("db_delta_weight_min", inline = TRUE),"kg"),
        plotOutput(
          "weight_trend",
          height = "45px"
        )
      )
    ),
    
    card(
      card_header("Body Fat"),
      card_body(
        h2(textOutput("db_last_bodyfat", inline = TRUE)," kg"),
        p(
          "7d Median: ",
          textOutput("db_median_bodyfat", inline = TRUE),
          " kg"
        ),
        p("▲",textOutput("db_delta_bodyfat_max", inline = TRUE),"kg"),
        p("▼",textOutput("db_delta_bodyfat_min", inline = TRUE),"kg"),
        plotOutput(
          "bodyfat_trend",
          height = "45px"
        )
      )
    ),
    
    card(
      card_header("Muscle Mass"),
      card_body(
        h2(textOutput("db_last_muscle", inline = TRUE)," kg"),
        p(
          "7d Median: ",
          textOutput("db_median_muscle", inline = TRUE),
          " kg"
        ),
        p("▲",textOutput("db_delta_muscle_max", inline = TRUE),"kg"),
        p("▼",textOutput("db_delta_muscle_min", inline = TRUE),"kg"),
        plotOutput(
          "muscle_trend",
          height = "45px"
        )
      )
    ),
    
    card(
      card_header("Body Water"),
      card_body(
        h2(textOutput("db_last_water", inline = TRUE)," kg"),
        p(
          "7d Median: ",
          textOutput("db_median_water", inline = TRUE),
          " kg"
        ),
        p("▲",textOutput("db_delta_water_max", inline = TRUE),"kg"),
        p("▼",textOutput("db_delta_water_min", inline = TRUE),"kg"),
        plotOutput(
          "water_trend",
          height = "45px"
        )
      )
    )
  ),
  
  
  layout_column_wrap(
    width = 1/4,
    
    card(
      card_header("Trends"),
      card_body(
        # verbatimTextOutput("delta_weight_Ndays_verbatim"),
        # verbatimTextOutput("delta_weight_7days"),
        layout_column_wrap(
          width = 1/2,

          div(
            h2(textOutput("delta_weight_7days")),
            "kg/week",
            # p(
            #   "Last 7 Days"
            # ),
            h2(textOutput("delta_weight_7days_perday")),
            "kg/day",
            p(
              "Last 7 Days"
            ),
            p("PERIOD:", br(), 
              textOutput("delta_weight_7days_start", inline = T), " — ", 
              textOutput("delta_weight_7days_end", inline = T), 
              style = "font-size: 0.75em; color: #6c757d; letter-spacing: 0.03em;"
            )
          ),

          div(
            h2(textOutput("delta_weight_28days")),
            "kg/week",
            # p(
            #   "Last 28 Days"
            # ),
            h2(textOutput("delta_weight_28days_perday")),
            "kg/day",
            p(
              "Last 28 Days"
            ),
            p("PERIOD:", br(),
              textOutput("delta_weight_28days_start", inline = T), " — ", 
              textOutput("delta_weight_28days_end", inline = T), 
              style = "font-size: 0.75em; color: #6c757d; letter-spacing: 0.03em;"
            )
          )
        )
      )
    ),
    
    card(
      card_header("Body Mass Index"),
      card_body(
        h2(textOutput("last_bmi")),
        "kg/m²", br(),
        # message to the user
        textOutput("bmi_message"),
        tags$style(HTML("
        .shiny-input-container:has(#bmi_slider) .irs-line {
          background: linear-gradient(
            to right,
            #d53e4f 0%,
            #fc8d59 20%,
            #abdda4 40%,
            #66c2a5 60%,
            #fc8d59 80%,
            #d53e4f 100%
          ) !important;
          height: 10px !important;
          top: 27px !important;
        }
      
        .shiny-input-container:has(#bmi_slider) .irs-bar {
          background: transparent !important;
          height: 10px !important;
          top: 25px !important;
        }
        
        .shiny-input-container:has(#bmi_slider) .irs-grid {
        top: 36px !important;
        }
      ")),
        div(
          style = "pointer-events: none;",
          sliderInput(
            "bmi_slider",
            NULL,
            min = 10,
            max = 30,
            value = 20
          )
        )
      )
    ),
    card(
      card_header("Body Composition"),
      card_body(
        
        plotOutput(
          "body_composition",
          height = "250px"
        )
      )
    ),
    card(
      card_header("Correlations"),
      
      layout_column_wrap(
        width = 1/2,
        
        # Left column
        div(
          class = "text-center",
          h2(textOutput("corr_fat_weight")),
          p("Fat ↔ Weight", class = "text-muted mb-0")
        ),
        
        div(
          class = "text-center",
          h2(textOutput("corr_muscle_weight")),
          p("Muscle ↔ Weight", class = "text-muted mb-0")
        ),
        
        div(
          class = "text-center",
          h2(textOutput("corr_water_weight")),
          p("Water ↔ Weight", class = "text-muted mb-0")
        ),
        
        # Right column
        div(
          class = "text-center",
          h2(textOutput("corr_muscle_water")),
          p("Muscle ↔ Water", class = "text-muted mb-0")
        ),
        
        div(
          class = "text-center",
          h2(textOutput("corr_fat_water")),
          p("Fat ↔ Water", class = "text-muted mb-0")
        ),
        
        div(
          class = "text-center",
          h2(textOutput("corr_muscle_fat")),
          p("Muscle ↔ Fat", class = "text-muted mb-0")
        )
      )
    )
  ),
  
  # card(
  #   card_header("Debugging"),
  #   card_body(
  #     verbatimTextOutput("debug")
  #   )
  # )
)
