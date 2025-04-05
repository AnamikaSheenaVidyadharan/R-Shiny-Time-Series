library(shiny)

ui <- fluidPage(
  titlePanel("Time Series Analysis"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV File", accept = ".csv"),
      selectInput("column", "Select Time Series Column", choices = NULL),
      selectInput("modelType", "Select Model Type", 
                  choices = c("Auto ARIMA" = "auto", "ARIMA" = "arima", "ARCH" = "arch", "GARCH" = "garch")),
      numericInput("p", "AR Order (p)", value = 1, min = 0),
      numericInput("d", "Differencing Order (d)", value = 0, min = 0),
      numericInput("q", "MA Order (q)", value = 1, min = 0),
      numericInput("forecastHorizon", "Forecast Horizon", value = 10, min = 1),
      conditionalPanel(
        condition = "input.modelType == 'garch'",
        selectInput("garchForecastType", "GARCH Forecast Type", 
                    choices = c("Unconditional" = "uncond", "Rolling" = "roll"))
      ),
      actionButton("fit", "Fit Model"),
      verbatimTextOutput("modelSuggestion")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("EDA", verbatimTextOutput("edaSummary")),
        tabPanel("Original Time Series", plotOutput("originalPlot")),
        tabPanel("Stationary Time Series", plotOutput("stationaryPlot")),
        tabPanel("ACF & PACF", plotOutput("originalACF"), plotOutput("originalPACF"),
                 plotOutput("acfPlot"), plotOutput("pacfPlot")),
        tabPanel("Model Fit", verbatimTextOutput("modelSummary")),
        tabPanel("Forecasting", plotOutput("forecastPlot")),
        tabPanel("Diagnostics", plotOutput("residualPlot"), plotOutput("residualACF"), 
                 verbatimTextOutput("diagnostics"), plotOutput("volatilityPlot"))
      )
    )
  )
)
