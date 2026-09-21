# PLOTTING

## FUNCTIONS

### Colors
color_paleblue <- "#7e9bbf"
color_mustard  <- "#c9b322"
color_brick    <- "#b5263e"
linewidth  <- 2.2
pointwidth <- 1
pointcharacter <- 16

### set wider margins to adapt standard plots
set_plotpar <- function(){
  par(
    mar = c(10, 6, 4, 2),
    mgp = c(5, 1, 0)#,
    #pin = c(7, 5)
  )
}

check_dataset <- function(data) {
  
  if (nrow(data) == 0) {
    
    plot.new()
    
    text(
      0.5, 0.5,
      "Not enough data to plot graph.",
      cex = 1.2
    )
    
    return(FALSE)
  }
  
  TRUE
}

## FORMATTING 

### let user decide if they want discrete values to be plotted correctly (as distinct dots) or like an idiot (using lines to connect them)
plot_type <- function(input) {
  if (input$plot_lines) {
    return("b")
  } else {
    return("p")
  }
}

### format of date axis (for plots to which this applies)
draw_date_axis <- function(dates) {
  
  date_range <- as.numeric(max(dates) - min(dates))
  
  if (date_range <= 45) {
    tick_by <- "1 day"
    tick_format <- "%d %b"
  } else if (date_range <= 120) {
    tick_by <- "1 week"
    tick_format <- "%d %b"
  } else if (date_range <= 365) {
    tick_by <- "1 month"
    tick_format <- "%b %Y"
  } else {
    tick_by <- "3 months"
    tick_format <- "%b %Y"
  }
  
  ticks <- seq(min(dates), max(dates), by = tick_by)
  
  axis(
    side = 1,
    at = ticks,
    labels = FALSE
  )
  
  text(
    x = ticks,
    y = par("usr")[3] - 0.2,
    labels = format(ticks, tick_format),
    srt = 45,
    adj = 1,
    xpd = TRUE
  )
}

## Single plots for UI tabs

### Weight (kg) over Date (variable) PLOT

output$weightplot <- renderPlot({
  
  data <- utable()
  
  set_plotpar()
  
  data <- utable()
  
  if (!check_dataset(data))
    return()
  
  plot(
    x = data$date,
    y = data$weight,
    main = "Weight (kg)",
    xlab = "Date",
    ylab = "Weight (kg)",
    col  = color_paleblue,
    type = plot_type(input),
    xaxt = "n",
    lwd  = linewidth,
    cex  = pointwidth,
    pch  = pointcharacter
  )
  
  draw_date_axis(data$date)
  
})#, height = 500)

### END plotting weight

### Body Fat (% and absolute mass kg as an option)

output$bodyfatplot <- renderPlot({
  
  data <- utable()
  
  set_plotpar()
  
  data <- utable()
  
  if (!check_dataset(data))
    return()
  
  weight <- data$weight
  bodyfat_perc <- as.numeric(data$fat_perc)
  bodyfat <- weight * bodyfat_perc / 100
  
  plot(
    x = data$date,
    y = bodyfat,
    main = "Body Fat (kg)",
    xlab = "Date",
    ylab = "Body Fat (kg)",
    col  = color_mustard,
    type = plot_type(input),
    xaxt = "n"
  )
  
  draw_date_axis(data$date)
  
})

### Muscle Mass (kg) over Date

output$muscleplot <- renderPlot({
  
  data <- utable()
  
  set_plotpar()
  
  data <- utable()
  
  if (!check_dataset(data))
    return()
  
  plot(
    x = data$date,
    y = data$muscle_mass,
    main = "Muscle Mass (kg)",
    xlab = "Date",
    ylab = "Mass (kg)",
    col  = color_brick,
    type = plot_type(input),
    xaxt = "n"
  )
  
  draw_date_axis(data$date)
  
})

# Body Water Plot 

output$waterplot <- renderPlot({
  
  data <- utable()
  
  set_plotpar()
  
  data <- utable()
  
  if (!check_dataset(data))
    return()
  
  water_mass <- data$weight * as.numeric(data$water_perc) / 100
  
  plot(
    x = data$date,
    y = water_mass,
    main = "Body Water (kg)",
    xlab = "Date",
    ylab = "Mass (kg)",
    col  = color_paleblue,
    type = plot_type(input),
    xaxt = "n"
  )
  
  draw_date_axis(data$date)
  
})

### Correlation: Weight vs Body Fat

output$fatcorrplot <- renderPlot({
  
  data <- utable()
  
  set_plotpar()
  
  data <- utable()
  
  if (!check_dataset(data))
    return()
  
  bodyfat <- data$weight * as.numeric(data$fat_perc) / 100
  
  corr_value <- cor(data$weight, bodyfat)
  
  plot(
    x = data$weight,
    y = bodyfat,
    main = "Body Fat as Function of Weight",
    xlab = "Weight (kg)",
    ylab = "Body Fat (kg)",
    col  = color_paleblue,
    type = "p",
    pch  = 17
  )
  
  legend(
    "topleft",
    legend = paste0(
      "corr = ",
      round(corr_value, 3)
    ),
    bty = "n"
  )
  
})

### Correlation: Weight vs Muscle Mass

output$musclecorrplot <- renderPlot({
  
  data <- utable()
  
  set_plotpar()
  
  data <- utable()
  
  if (!check_dataset(data))
    return()
  
  corr_value <- cor(data$weight, data$muscle_mass)
  
  plot(
    x = data$weight,
    y = data$muscle_mass,
    main = "Muscle Mass as Function of Weight",
    xlab = "Weight (kg)",
    ylab = "Muscle Mass (kg)",
    col  = color_brick,
    type = "p",
    pch  = 17
  )
  
  legend(
    "topleft",
    legend = paste0(
      "corr = ",
      round(corr_value, 3)
    ),
    bty = "n"
  )
  
})

## PLOTS CORE DATA CARD output 

# WEIGHT PLOT core data

output$core_last_weight <- renderText({
  sprintf("%.2f", db_last(dtable(), "weight"))
})

output$core_mean_weight <- renderText({
  sprintf("%.2f", mean(utable()$weight))
})

output$core_median_weight <- renderText({
  sprintf("%.2f", median(utable()$weight))
})

output$core_min_weight <- renderText({
  sprintf("%.2f", min(utable()$weight))
})

output$core_max_weight <- renderText({
  sprintf("%.2f", max(utable()$weight))
})

output$core_weight_change <- renderText({
  sprintf(
    "%.2f",
    tail(utable()$weight, 1) - head(utable()$weight, 1)
  )
})

# BODYFAT PLOT core data

output$core_last_bodyfat <- renderText({
  sprintf(
    "%.2f",
    db_last(dtable(), "fat_perc") * db_last(dtable(), "weight") / 100
  )
})

output$core_mean_bodyfat <- renderText({
  sprintf(
    "%.2f",
    mean(utable()$fat_perc * utable()$weight / 100)
  )
})

output$core_median_bodyfat <- renderText({
  sprintf(
    "%.2f",
    median(utable()$fat_perc * utable()$weight / 100)
  )
})

output$core_min_bodyfat <- renderText({
  sprintf(
    "%.2f",
    min(utable()$fat_perc * utable()$weight / 100)
  )
})

output$core_max_bodyfat <- renderText({
  sprintf(
    "%.2f",
    max(utable()$fat_perc * utable()$weight / 100)
  )
})

output$core_bodyfat_change <- renderText({
  sprintf(
    "%.2f",
    tail(utable()$fat_perc * utable()$weight / 100, 1) -
      head(utable()$fat_perc * utable()$weight / 100, 1)
  )
})

# MUSCLE PLOT core data

output$core_last_muscle <- renderText({
  sprintf("%.2f", db_last(dtable(), "muscle_mass"))
})

output$core_mean_muscle <- renderText({
  sprintf("%.2f", mean(utable()$muscle_mass))
})

output$core_median_muscle <- renderText({
  sprintf("%.2f", median(utable()$muscle_mass))
})

output$core_min_muscle <- renderText({
  sprintf("%.2f", min(utable()$muscle_mass))
})

output$core_max_muscle <- renderText({
  sprintf("%.2f", max(utable()$muscle_mass))
})

output$core_muscle_change <- renderText({
  sprintf(
    "%.2f",
    tail(utable()$muscle_mass, 1) - head(utable()$muscle_mass, 1)
  )
})

# WATER MASS PLOT core data

output$core_last_water <- renderText({
  sprintf(
    "%.2f",
    db_last(dtable(), "water_perc") * db_last(dtable(), "weight") / 100
  )
})

output$core_mean_water <- renderText({
  sprintf(
    "%.2f",
    mean(utable()$water_perc * utable()$weight / 100)
  )
})

output$core_median_water <- renderText({
  sprintf(
    "%.2f",
    median(utable()$water_perc * utable()$weight / 100)
  )
})

output$core_min_water <- renderText({
  sprintf(
    "%.2f",
    min(utable()$water_perc * utable()$weight / 100)
  )
})

output$core_max_water <- renderText({
  sprintf(
    "%.2f",
    max(utable()$water_perc * utable()$weight / 100)
  )
})

output$core_water_change <- renderText({
  sprintf(
    "%.2f",
    tail(utable()$water_perc * utable()$weight / 100, 1) -
      head(utable()$water_perc * utable()$weight / 100, 1)
  )
})