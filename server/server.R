server <- function(input, output, session) {
  
  shinyFiles::shinyDirChoose(
    input,
    "data_dir",
    roots = c(data = normalizePath("./data"))
  )
  
  rawtable <- reactive({
    req(input$csv)
    
    read.csv(
      input$csv$datapath,
      sep = ",",
      header = TRUE,
      na.strings = "null"
    )
  })
  
  ## find most likely owner body height 
  owner_height <- reactive({
    data <- rawtable()
    
    as.numeric(
      names(which.max(table(data$height)))
    )
  })
  
  ctable <- reactive({
    
    newcolnames <- c("datetime"     = 1, 
                     "weight"       = 2,
                     "height"       = 3,
                     "bmi"          = 4,
                     "fat_perc"     = 5,
                     "water_perc"   = 6,
                     "bonemass"     = 7,
                     "metabolism"   = 8,
                     "muscle_mass"  = 9,
                     "viscfat_perc" = 10)
    
    colselection <- c(1,2,4:8,9)
    
    data <- rawtable()
    
    names(data) <- names(newcolnames)
    
    # convert all measurements to numeric, keep datetime untouched
    data[, -1] <- lapply(data[, -1], as.numeric)
    
    # # assume the most often occuring height == data owner (cause it just makes sense, bro)
    # owner_height <- as.numeric(
    #   names(which.max(table(data$height)))
    # )
    
    # selecting by owner's assumed height + respective margin (you can choose in GUI)
    data <- data[
      abs(data$height - owner_height()) <= input$height_margin,
    ]
    
    # we don't need the height and other redundand data anymore though
    data <- data[, colselection]
    
    # Handling solely as dates
    rawdates         <- as.Date(data[,1], format = "%Y-%m-%d %H:%M:%S%z")
    data[,1]         <- rawdates
    names(data)[1]   <- "date"
    
    ctable_noNAs <- data[
      complete.cases(data) & data$fat_perc > 0.1,
    ]
    
    ctable_noNAs
    
  })
  
  # dashboard table (only restricted by last date of the user selected date range,
  # so that we have a cutoff-date as an endpoint for retrospect dashboard visuals and numbers
  dtable <- reactive({
    
    data <- ctable()
    data <- data[data$date <= input$daterange[2], ]
    
  })
  
  # main cleaned table for anaylsis, plotting and general use
  # (date range selcted by user)
  
  utable <- reactive({
    
    data <- dtable()
    data <- data[ data$date >= input$daterange[1], ]
    
  })
  
  # this needs to come here, if you do not know why, go back to uni or ask chatGPT or something
  
  source("server/dashboard_content.R", local = T)
  
  # read quicklinks date presets
  
  observeEvent(input$quickselect, {
  
    if (input$quickselect > 0) {
  
      updateDateRangeInput(
        session,
        "daterange",
        start = Sys.Date() - as.numeric(input$quickselect),
        end   = Sys.Date()
      )
    }
  }) 
    
  ## DT: data table outputs
  # message for user
   output$rawmessage <- renderUI({
    
    if (is.null(input$csv)) {
      helpText(
        "Open a Zepp body data file to display your raw data here and to process the data further."
      )
    } else {
      NULL
    }
   })
   
  output$cleanedtablemessage <- renderUI({
    
    if (is.null(input$csv)) {
      helpText(
        "Open a Zepp body data file to display your pre-cleaned data here and to process the data further."
        )
      } else {
        NULL
      }
    })
  
    output$plotdatamessage <- renderUI({
    
    if (is.null(input$csv)) {
      helpText(
        "Open a Zepp body data file to plot selected data here."
        )
      } else {
        NULL
      }
    })
  output$rawdatatable <- DT::renderDataTable({
    
    rawtable()
    
  },
  options = list(
    pageLength = 20,
    scrollX = TRUE
  ))
  
  output$userdatatable <- DT::renderDT({
    
    DT::datatable(
      utable(),
      colnames = c(
        "Date",
        "Weight (kg)",
        "BMI",
        "Body Fat (%)",
        "Body Water (%)",
        "Bone Mass (kg)",
        "Metabolism (kcal)",
        "Muscle Mass (kg)"
      ),
      options = list(
        pageLength = 20,
        scrollX = TRUE
      )
    ) |>
      DT::formatRound("weight", digits = 2) |>
      DT::formatRound("bmi", digits = 4) |>
      DT::formatRound(
        c("fat_perc",
          "water_perc",
          "bonemass",
          "metabolism",
          "muscle_mass"),
        digits = 1
      )
  })

  source("server/plots.R", local = T)
  
  ### BMI calculations 
  
  # Underweight     < 18.5
  # Healthy Weight  >= 18.5, < 25 
  # Overweight      >= 25, < 30
  # Obesity         > =30
  
  bmi_interpretation <- function(x) {
    if (x < 18.5) {
      bmi_verbal <- "underweight"
    } else if (x >= 18.5) {
      if (x >= 25) {
        if (x >= 30){
          bmi_verbal <- "obese"
        } else {
          bmi_verbal <- "overweight"
        }
      } else {
        bmi_verbal <- "healthy"
      }
    }
    bmi_verbal_output <- paste0("BMI in the ", bmi_verbal, " range.")
    return(bmi_verbal_output)
  }
  
  last_bmi <- reactive({db_last(utable(), "bmi")})
  
  output$bmi_message <- renderText({
    bmi_interpretation(last_bmi())
  })
   
}