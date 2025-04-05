library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "blue",  
  
  dashboardHeader(title = "Time Series Analysis"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Upload Data", tabName = "upload", icon = icon("file-upload")),
      menuItem("EDA", tabName = "eda", icon = icon("table")),
      menuItem("Time Series Plots", tabName = "tsplots", icon = icon("chart-line")),
      menuItem("Modeling", tabName = "modeling", icon = icon("cogs")),
      menuItem("Forecasting", tabName = "forecast", icon = icon("chart-bar")),
      menuItem("Diagnostics", tabName = "diagnostics", icon = icon("wrench"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Upload Data Tab
      tabItem(tabName = "upload",
              fluidRow(
                box(title = "Upload CSV File", width = 12, status = "primary", solidHeader = TRUE,
                    fileInput("file", "Choose CSV File", accept = ".csv"),
                    selectInput("column", "Select Time Series Column", choices = NULL)
                )
              )
      ),
      
      # EDA Tab
      tabItem(tabName = "eda",
              fluidRow(
                box(title = "Exploratory Data Analysis", width = 12, status = "primary", solidHeader = TRUE,
                    verbatimTextOutput("edaSummary")
                )
              )
      ),
      
      # Time Series Plots Tab
      tabItem(tabName = "tsplots",
              fluidRow(
                box(title = "Original Time Series", width = 12, status = "primary", solidHeader = TRUE, plotOutput("originalPlot"))
              ),
              fluidRow(
                box(title = "Stationary Time Series", width = 12, status = "primary", solidHeader = TRUE, plotOutput("stationaryPlot"))
              ),
              fluidRow(
                box(title = "Original ACF", width = 12, status = "primary", solidHeader = TRUE, plotOutput("originalACF"))
              ),
              fluidRow(
                box(title = "Original PACF", width = 12, status = "primary", solidHeader = TRUE, plotOutput("originalPACF"))
              ),
              fluidRow(
                box(title = "Stationary ACF", width = 12, status = "primary", solidHeader = TRUE, plotOutput("acfPlot"))
              ),
              fluidRow(
                box(title = "Stationary PACF", width = 12, status = "primary", solidHeader = TRUE, plotOutput("pacfPlot"))
              )
      ),
      
      # Modeling Tab
      tabItem(tabName = "modeling",
              fluidRow(
                box(title = "Model Selection", width = 12, status = "primary", solidHeader = TRUE,
                    selectInput("modelType", "Select Model Type", 
                                choices = c("Auto ARIMA" = "auto", "ARIMA" = "arima", 
                                            "SARIMA" = "sarima", "ARCH" = "arch", "GARCH" = "garch")),
                    
                    numericInput("p", "AR Order (p)", value = 1, min = 0),
                    numericInput("d", "Differencing Order (d)", value = 0, min = 0),
                    numericInput("q", "MA Order (q)", value = 1, min = 0),
                    
                    conditionalPanel(
                      condition = "input.modelType == 'sarima'",
                      numericInput("P", "Seasonal AR Order (P)", value = 1, min = 0),
                      numericInput("D", "Seasonal Differencing Order (D)", value = 0, min = 0),
                      numericInput("Q", "Seasonal MA Order (Q)", value = 1, min = 0),
                      numericInput("s", "Seasonal Period (s)", value = 12, min = 1)
                    ),
                    
                    actionButton("fit", "Fit Model"),
                    verbatimTextOutput("modelSuggestion")
                )
              ),
              fluidRow(
                box(title = "Model Summary", width = 12, status = "primary", solidHeader = TRUE,
                    verbatimTextOutput("modelSummary")
                )
              )
      ),
      
      # Forecasting Tab
      tabItem(tabName = "forecast",
              fluidRow(
                box(title = "Forecast Settings", width = 12, status = "primary", solidHeader = TRUE,
                    numericInput("forecastHorizon", "Forecast Horizon", value = 10, min = 1),
                    conditionalPanel(
                      condition = "input.modelType == 'garch'",
                      selectInput("garchForecastType", "GARCH Forecast Type", 
                                  choices = c("Unconditional" = "uncond", "Rolling" = "roll"))
                    )
                )
              ),
              fluidRow(
                box(title = "Forecast Plot", width = 12, status = "primary", solidHeader = TRUE, plotOutput("forecastPlot"))
              )
      ),
      
      # Diagnostics Tab
      tabItem(tabName = "diagnostics",
              fluidRow(
                box(title = "Residual Analysis", width = 12, status = "primary", solidHeader = TRUE,
                    plotOutput("residualPlot"),
                    plotOutput("residualACF")
                )
              ),
              fluidRow(
                box(title = "Volatility Plot (only for GARCH)", width = 12, status = "primary", solidHeader = TRUE,
                    plotOutput("volatilityPlot")
                )
              )
      )
    )
  )
)
