# HTML Style Decisions
infotext <- function(text) {
  tags$p(
    class = "text-muted",
    style = "font-size: 8pt;",
    text
  )
}

# Shiny User Interface 
ui <- fluidPage(
  
  theme = bslib::bs_theme(version = 5),
  
  div(
    class = "d-flex align-items-center justify-content-between px-4 py-2 mb-4",
    style = "background-color: #f8f9fa;
             border-bottom: 1px solid #dee2e6;",
    h4(
      "ZeppR · Zepp App Data Analysis",
      class = "mb-0"
    ),
    
    div(
      class = "d-flex gap-4",
      a("GitHub", href = "https://github.com/undelisch/"),
      a("Help", href = "https://github.com/undelisch/ZeppR/documentation")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      # sidebar width 25%
      width = 2,
      
      fileInput(
        inputId = "csv",
        label   = "Select CSV file:",
        accept  = ".csv"
      ),
      infotext("Select the CSV file containing your exported body data from Zepp."),
      
      # user selects date range
      ## if nothing is selected the range automatically starts at the 1st of January of the current year
      dateRangeInput(
        inputId = "daterange",
        label   = "Date range:",
        start   = as.Date(paste0(format(Sys.Date(), "%Y"), "-01-01")),
        end     = Sys.Date()
      ),
      selectInput( 
        inputId = "quickselect", 
        label   = "Date range quick-select:",
        choices =  list("Date Range" = 0, "Last 28 days" = 28, "Last 3 Months" = 84, "Last Year" = 365) 
      ), 
      infotext("Select the date range for the cleaned data table view and plotting."),
      
      # margin for height (data owner selection)
      sliderInput(
        inputId = "height_margin",
        label   = "Height tolerance (cm):",
        min     = 0,
        max     = 5,
        value   = 1
      ),
      infotext("Data owner can be identified by height. Enter a margin (+/- N cm) to adapt the tolerance of this identifying criterion, in case you have edited your height entry over time."), 
      
      bslib::input_switch(
        id    = "plot_lines",
        label = "Connect data points",
        value = TRUE)
      
      # # DEBUGGING
      # verbatimTextOutput("test") 
    ),
    
    mainPanel(
      width = 10,
      
      tabsetPanel(
        
        tabPanel(
          "Dashboard",
          div(
            style = "margin-bottom: 15px;",
            br(),
            source("ui/dashboard.R")$value # this needs to be put into a function when I have time
          ),
        ),
        
        ## MAIN TAB ## 
        tabPanel(
          "Cleaned Data",
          div(
            style = "margin-bottom: 15px;",
            uiOutput("cleanedtablemessage")
          ),
          DT::dataTableOutput("userdatatable")
        ),
        
        ## MAIN TAB ## 
        tabPanel(
          "Raw Data",
          div(
            style = "margin-bottom: 15px;",
            uiOutput("rawmessage")
          ),
          DT::dataTableOutput("rawdatatable")
        ),
        
        ## MAIN TAB ## 
        
        tabPanel(
          "Plots",
          div(
            style = "margin-bottom: 15px;",
            uiOutput("plotdatamessage"),br()
          ),
          
          tabsetPanel(
            type = "tabs",
            br(),
            
            tabPanel(
              "Weight",
              
              layout_column_wrap(
                width = 1/2,
                
                card(
                  height = "auto",
                  card_header("Body Weight Plot"),
                  plotOutput("weightplot", height = "400px")
                ),
                
                card(
                  card_header("Core Data"),
                  ### 
                  layout_column_wrap(
                    width = 1/2,
                    
                    div(
                      h5("Last weight", class = "text-muted"),
                      h3(textOutput("core_last_weight")),
                      p("kg")
                    ),
                    
                    div(
                      h5("First → last weight (difference)", class = "text-muted"),
                      h3(textOutput("core_weight_change")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Mean weight", class = "text-muted"),
                      h3(textOutput("core_mean_weight")),
                      p("kg")
                    ),

                    div(
                      h5("Median weight", class = "text-muted"),
                      h3(textOutput("core_median_weight")),
                      p("kg")
                    ),

                    div(
                      h5("Minimum", class = "text-muted"),
                      h3(textOutput("core_min_weight")),
                      p("kg")
                    ),

                    div(
                      h5("Maximum", class = "text-muted"),
                      h3(textOutput("core_max_weight")),
                      p("kg")
                    )
                    
                  )
                  ### 
                )
              )
            ),
            
            tabPanel(
              "Body Fat",
              
              layout_column_wrap(
                width = 1/2,
                
                card(
                  card_header("Body Fat Plot"),
                  plotOutput("bodyfatplot", height = "400px")
                ),
                
                card(
                  card_header("Core Data"),
                  ### 
                  layout_column_wrap(
                    width = 1/2,
                    
                    div(
                      h5("Last body fat mass", class = "text-muted"),
                      h3(textOutput("core_last_bodyfat")),
                      p("kg")
                    ),
                    
                    div(
                      h5("First → last body fat mass (difference)", class = "text-muted"),
                      h3(textOutput("core_bodyfat_change")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Mean body fat mass", class = "text-muted"),
                      h3(textOutput("core_mean_bodyfat")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Median body fat mass", class = "text-muted"),
                      h3(textOutput("core_median_bodyfat")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Minimum", class = "text-muted"),
                      h3(textOutput("core_min_bodyfat")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Maximum", class = "text-muted"),
                      h3(textOutput("core_max_bodyfat")),
                      p("kg")
                    )
                  )
                  ### 
                )
              )
            ),
            
            tabPanel(
              "Muscle Mass",
              
              layout_column_wrap(
                width = 1/2,
                
                card(
                  card_header("Muscle Mass Plot"),
                  plotOutput("muscleplot", height = "400px")
                ),
                
                card(
                  card_header("Core Data"),
                  ### 
                  layout_column_wrap(
                    width = 1/2,
                    
                    div(
                      h5("Last muscle mass", class = "text-muted"),
                      h3(textOutput("core_last_muscle")),
                      p("kg")
                    ),
                    
                    div(
                      h5("First → last muscle mass (difference)", class = "text-muted"),
                      h3(textOutput("core_muscle_change")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Mean muscle mass", class = "text-muted"),
                      h3(textOutput("core_mean_muscle")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Median muscle mass", class = "text-muted"),
                      h3(textOutput("core_median_muscle")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Minimum", class = "text-muted"),
                      h3(textOutput("core_min_muscle")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Maximum", class = "text-muted"),
                      h3(textOutput("core_max_muscle")),
                      p("kg")
                    )
                  )
                  ###
                )
              )
            ),
            
            tabPanel(
              "Water Mass",
              
              layout_column_wrap(
                width = 1/2,
                
                card(
                  card_header("Body Water Plot"),
                  plotOutput("waterplot", height = "400px")
                ),
                
                card(
                  card_header("Core Data"),
                  ### 
                  layout_column_wrap(
                    width = 1/2,
                    
                    div(
                      h5("Last water mass", class = "text-muted"),
                      h3(textOutput("core_last_water")),
                      p("kg")
                    ),
                    
                    div(
                      h5("First → last water mass (difference)", class = "text-muted"),
                      h3(textOutput("core_water_change")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Mean water mass", class = "text-muted"),
                      h3(textOutput("core_mean_water")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Median water mass", class = "text-muted"),
                      h3(textOutput("core_median_water")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Minimum", class = "text-muted"),
                      h3(textOutput("core_min_water")),
                      p("kg")
                    ),
                    
                    div(
                      h5("Maximum", class = "text-muted"),
                      h3(textOutput("core_max_water")),
                      p("kg")
                    )
                  )
                  ### 
                )
              )
            ),
            
            tabPanel(
              "Corr(Muscle,Weight)",
              
              layout_column_wrap(
                width = 1/2,
                
                card(
                  plotOutput("musclecorrplot", height = "400px")
                ),
                
                card(
                  card_header("Core Data"),
                  # metrics here
                )
              )
            ),
            
            tabPanel(
              "Corr(Fat,Weight)",
              
              layout_column_wrap(
                width = 1/2,
                
                card(
                  plotOutput("fatcorrplot", height = "400px")
                ),
                
                card(
                  card_header("Core Data"),
                  # metrics here
                )
              )
            )
          )
        ),
        
        ## MAIN TAB # 
        ## Allow to fetch last-known user data automatically on startup 
        ## Allow some personalization 
        tabPanel(
          "My Data",
          div(
            style = "margin-bottom: 15px;",
            br(),
            bslib::input_switch(
              id    = "fetch_user_config",
              label = "Customize ZeppR",
              value = TRUE)
          ),
          # SETTINGS DASHBOARD FOR USERDATA CONTROL 
          # source begin
          source("ui/mydata.R")$value
          # source end
        )
      )
    )
  )
)