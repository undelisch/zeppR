## Dashboard Backend

# data = dtable() :           pick the dataset you want, ideally the fully cleaned and visible to the user
# N = 7, 28 :                 number of data points including the last over which to calculate the median 

# Color palette 
bluepal <- c("#3288bd", "#66c2a5", "#abdda4", "#fee08b", "#fc8d59", "#d53e4f", "#ae017e", "#49006a")

# Table Entry Numbers (# measurements)
n_utable_entries <- reactive({ nrow(dtable()) })

db_median <- function(data, N, quantity){
  
  values <- data[[quantity]] 
  n      <- length(values)
  
  median(values[(n-N+1):n]) # return median 
  
}

db_extrema <- function(data, N, quantity){
  values   <- data[[quantity]] 
  n        <- length(values)
  selected_values <- values[(n-N+1):n]
  
  extrema <- c(min(selected_values),max(selected_values))
  
  extrema
}

db_last <- function(data, quantity){
  
  values <- data[[quantity]] 
  values[length(values)] # return that last mf
  
}

# Tiny 28-day trend plot FUNCTION

db_trend <- function(data, N, quantity, col = "#3B82F6") {
  
  values <- tail(data[[quantity]], N)
  
  yrange <- range(values, na.rm = TRUE)
  padding <- diff(yrange) * 0.08
  
  # Handle completely flat data
  if (padding == 0) {
    padding <- 0.1
  }
  
  par(
    mar = c(0, 0, 0, 0),
    oma = c(0, 0, 0, 0),
    xaxs = "i",
    yaxs = "i"
  )
  
  plot(
    values,
    type = "l",
    axes = FALSE,
    ann = FALSE,
    bty = "n",
    xlim = c(1, length(values)),
    ylim = c(
      yrange[1] - padding,
      yrange[2] + padding
    ),
    lwd = 2.5,
    col = col,
    lend = "round"
  )
}

# Trend Outputs

output$weight_trend <- renderPlot({
  
  db_trend(
    data = dtable(),
    N = 28,
    quantity = "weight",
    col = bluepal[6]
  )
})

output$bodyfat_trend <- renderPlot({
  
  db_trend(
    data = dtable(),
    N = 28,
    quantity = "fat_perc",
    col = bluepal[2]
  )
})

output$muscle_trend <- renderPlot({
  
  db_trend(
    data = dtable(),
    N = 28,
    quantity = "muscle_mass",
    col = bluepal[1]
  )
})

output$water_trend <- renderPlot({
  
  db_trend(
    data = dtable(),
    N = 28,
    quantity = "water_perc",
    col = bluepal[8]
  )
})

# Deltas := max and min derivations from median

db_delta <- function(data, N, quantity){
  
  med_value       <- db_median(data = data, N = N, quantity = quantity)
  extrema_values  <- db_extrema(data = data, N = N, quantity = quantity)
  
  delta_vec <- c(
    extrema_values[1] - med_value,
    extrema_values[2] - med_value
  )
  
  delta_vec
  
}

signed <- function(x){ sprintf("%+.2f", x) }

## Calculation of various values for dashboard frontend

# Medians

  output$db_median_weight <- renderText({
    round(db_median(dtable(), 7, "weight"), 2)
  })
  
  output$db_median_bodyfat <- renderText({
    round(db_median(dtable(), 7, "fat_perc")*db_last(dtable(),"weight")/100, 2)
  })
  
  output$db_median_muscle <- renderText({
    round(db_median(dtable(), 7, "muscle_mass"), 2)
  })
  
  output$db_median_water <- renderText({
    round(db_median(dtable(), 7, "water_perc")*db_last(dtable(),"weight")/100, 2)
  })

# Last values
  
  output$db_last_weight <- renderText({
    round(db_last(dtable(), "weight"),2)
  })
  
  output$db_last_bodyfat <- renderText({
    round(db_last(dtable(), "fat_perc")*db_last(dtable(),"weight")/100, 2)
  })
  
  output$db_last_muscle <- renderText({
    round(db_last(dtable(), "muscle_mass"), 2)
  })
  
  output$last_bmi <- renderText({
    # # calculate bmi (alternative code)
    # round(db_last(dtable(), "weight") / ((owner_height()/100)**2), 1)
    # take bmi from dataset 
    round(db_last(dtable(), "bmi"), 1)
  })
  
  output$db_last_water <- renderText({
    round(
      db_last(dtable(), "water_perc")*db_last(dtable(),"weight")/100, 2
    )
  })
  
# Delta values +/- 
  
  # delta body mass
  output$db_delta_weight_min <- renderText({
    signed(
      db_delta(dtable(), 7, "weight")[1]
    )
  })
  output$db_delta_weight_max <- renderText({
    signed(
      db_delta(dtable(), 7, "weight")[2]
    )
  })
  
  #delta fat mass 
  output$db_delta_bodyfat_min <- renderText({
    signed(
      round(
        db_delta(dtable(), 7, "fat_perc")[1]*db_last(dtable(),"weight")/100, 2
      )
    )
  })
  output$db_delta_bodyfat_max <- renderText({
    signed(
      round(
        db_delta(dtable(), 7, "fat_perc")[2]*db_last(dtable(),"weight")/100, 2
      )
    )
  })
  
  #delta muscle mass 
  output$db_delta_muscle_min <- renderText({
    signed(
      db_delta(dtable(), 7, "muscle_mass")[1]
    )
  })
  output$db_delta_muscle_max <- renderText({
    signed(
      db_delta(dtable(), 7, "muscle_mass")[2]
    )
  })
  
  #delta water mass 
  output$db_delta_water_min <- renderText({
    signed(
      round(
        db_delta(dtable(), 7, "water_perc")[1]*db_last(dtable(),"weight")/100, 2
      )
    )
  })
  output$db_delta_water_max <- renderText({
    signed(
      round(
        db_delta(dtable(), 7, "water_perc")[2]*db_last(dtable(),"weight")/100, 2
      )
    )
  })
  
  
# Last average changes per 7 or 28 days (date range, not nr of data points!)
  
  delta_weight_Ndays <- reactive({ 
    if (nrow(dtable()) == 0) {
      return(NULL)
    } else {
      usable_daterange <- as.integer(tail(dtable()$date,1) - dtable()$date[1])
      
      get_recent_weightchanges <- function(N = Ndays) {
        
        last_date   <- tail(dtable()$date, 1)
        cutoff_date <- last_date - N - 1
        
        # old cutoff: from user input 
        #cutoff_date <- input$daterange[2] - N - 1 
        
        # col selected subset of data 
        recent_weight_values <- dtable()[ dtable()$date >= cutoff_date, c("weight", "date") ] 
        
        # calculate weight difference & mean 
        last_weight  <- tail(recent_weight_values$weight, 1)
        first_weight <- recent_weight_values$weight[1]    
        
        last_date  <- tail(recent_weight_values$date, 1)
        first_date <- recent_weight_values$date[1]
        
        recent_datediff   <- as.integer(last_date - first_date)
        recent_weightdiff <- last_weight - first_weight
        recent_weightdiff_perday <- recent_weightdiff/N
        
        output_weightdiff <- round(recent_weightdiff,2)
        output_weightdiff_rate <- round(recent_weightdiff/recent_datediff,3)
        
        
        return(c(
          weightdiff        = output_weightdiff,
          weightdiff_rate   = output_weightdiff_rate,
          weightdiff_perday = recent_weightdiff_perday,
          start_date        = format(first_date, "%Y-%m-%d"),
          end_date          = format(last_date, "%Y-%m-%d")
        ))
      }
      
      return(rbind(
        days_7  = get_recent_weightchanges(7),
        days_28 = get_recent_weightchanges(28)
      )) 
    }
  })
  
  # output$delta_weight_Ndays_verbatim <- renderPrint({
  #   delta_weight_Ndays()
  # })
  
  # OUTPUTs 7/28 days kg/week changes

    # 7 days delta weight diff + start + end date
    output$delta_weight_7days <- renderText({
      signed(
        as.numeric(delta_weight_Ndays()["days_7", "weightdiff"])
      )
    })
    output$delta_weight_7days_perday <- renderText({
      signed(
        as.numeric(delta_weight_Ndays()["days_7", "weightdiff_perday"])
      )
    })
    
    output$delta_weight_7days_start <- renderText({
        delta_weight_Ndays()["days_7", "start_date"]
    })
    
    output$delta_weight_7days_end <- renderText({
      delta_weight_Ndays()["days_7", "end_date"]
    })
    
    # 28 DAYS weight difference and start + end dates 
    output$delta_weight_28days <- renderText({
      signed(
        as.numeric(delta_weight_Ndays()["days_28", "weightdiff"])
      )
    })
    
    output$delta_weight_28days_perday <- renderText({
      signed(
        as.numeric(delta_weight_Ndays()["days_28", "weightdiff_perday"])
      )
    })
    
    output$delta_weight_28days_start <- renderText({
      delta_weight_Ndays()["days_28", "start_date"]
    })
    
    output$delta_weight_28days_end <- renderText({
      delta_weight_Ndays()["days_28", "end_date"]
    })
    
    # 7 DAYS daily weight change on average 
  
# BMI slider 
  
  observe({
    data <- dtable()
    req(nrow(data) > 0)
    
    updateSliderInput(
      session,
      "bmi_slider",
      value = db_last(data, "bmi")
    )
  })  
  
  # Body composition V.2
  
  # NOTA BENE: 
  # 100% = $muscle_mass/weight*100 + $fat_perc + $bonemass/$weight*100
  body_composition_values <- reactive({
    mu <- db_last(dtable(), "muscle_mass")/db_last(dtable(), "weight")*100
    fa <- db_last(dtable(), "fat_perc")
    bo <- db_last(dtable(), "bonemass")/db_last(dtable(), "weight")*100
    c(mu,fa,bo)
  })
  
  output$body_composition <- renderPlot({
    
    data <- data.frame(
      category = c("Muscle", "Fat", "Bone Mass"),
      count = body_composition_values()
    )
    
    data$fraction <- data$count / sum(data$count)
    data$ymax <- cumsum(data$fraction)
    data$ymin <- c(0, head(data$ymax, -1))
    data$labelPosition <- (data$ymax + data$ymin) / 2
    
    # labels of the donut pieces = body comp percentages 
    data$label <- paste0(round(body_composition_values()),"%")
    
    ggplot(
      data,
      aes(
        ymax = ymax,
        ymin = ymin,
        xmax = 4,
        xmin = 3.5,
        fill = category
      )
    ) +
      geom_rect() +
      geom_text(
        aes(
          x = 3,
          y = labelPosition,
          label = label
        ),
        size = 4
      ) +
      coord_polar(theta = "y") +
      xlim(c(2, 4)) +
      scale_fill_manual(
        values = c(
          "Muscle" = "#de5151",
          "Fat" = "#bace96",
          "Bone Mass" = "#7bcaa5"
        )
      ) +
      labs(fill = NULL) +
      theme_void()
  }, res=100)
  # Legend for "plot"
  
  
  output$n_measurements <- renderText({
    n_utable_entries()
  })
  
# CORRELATION data
  
  # Body Fat ↔ Weight
  output$corr_fat_weight <- renderText({
    round(
      cor(utable()$fat_perc*utable()$weight/100, utable()$weight), 2
    )
  })
  # Muscle Mass ↔ Weight
  output$corr_muscle_weight <- renderText({
    round(
      cor(utable()$muscle_mass, utable()$weight), 2
    )
  })
  # Body Water ↔ Weight
  output$corr_water_weight <- renderText({
    round(
      cor(utable()$water_perc*utable()$weight/100, utable()$weight), 2
    )
  })
  # Muscle Mass ↔ Body Water
  output$corr_muscle_water <- renderText({
    round(
      cor(utable()$muscle_mass, utable()$water_perc*utable()$weight/100), 2
    )
  })
  # Body Fat ↔ Body Water
  output$corr_fat_water <- renderText({
    round(
      cor(utable()$fat_perc*utable()$weight/100, utable()$water_perc*utable()$weight/100), 2
    )
  })
  # Muscle Mass ↔ Body Fat (-)
  output$corr_muscle_fat <- renderText({
    round(
      cor(utable()$muscle_mass, utable()$fat_perc*utable()$weight/100), 2
    )
  })
  
  # Debugging
  output$debug <- renderPrint({
    input$daterange
  })
  
  
  