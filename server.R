server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    df <- read.csv(input$file$datapath)
    df <- df[complete.cases(df), ]
    df <- df[!duplicated(df), ]
    output$edaSummary <- renderText({ summary(df) })
    return(df)
  })
  
  observe({ updateSelectInput(session, "column", choices = names(data())) })
  
  tsData <- reactive({ 
    req(input$column) 
    ts(data()[[input$column]]) 
  })
  
  output$originalPlot <- renderPlot({ 
    autoplot(tsData()) + ggtitle("Original Time Series") 
  })
  
  output$originalACF <- renderPlot({ 
    Acf(tsData(), main = "Original ACF") 
  })
  
  output$originalPACF <- renderPlot({ 
    Pacf(tsData(), main = "Original PACF") 
  })
  
  stationaryData <- reactive({
    diff_order <- ndiffs(tsData())
    transformed_ts <- if (diff_order > 0) diff(tsData(), differences = diff_order) else tsData()
    
    if (adf.test(transformed_ts)$p.value > 0.05) {
      transformed_ts <- diff(log(tsData() + 1), differences = diff_order)
    }
    ts(transformed_ts)  # Ensure output is a time series object
  })
  
  output$stationaryPlot <- renderPlot({ 
    autoplot(stationaryData()) + ggtitle("Stationary Time Series") 
  })
  
  output$acfPlot <- renderPlot({ 
    Acf(stationaryData(), main = "Stationary ACF") 
  })
  
  output$pacfPlot <- renderPlot({ 
    Pacf(stationaryData(), main = "Stationary PACF") 
  })
  
  suggestModel <- reactive({
    acf_vals <- sum(abs(Acf(stationaryData(), plot = FALSE)$acf[-1]))
    pacf_vals <- sum(abs(Pacf(stationaryData(), plot = FALSE)$acf[-1]))
    
    if (acf_vals > pacf_vals) {
      return("AR Model is suggested.")
    } else if (pacf_vals > acf_vals) {
      return("MA Model is suggested.")
    } else {
      return("ARMA Model is suggested.")
    }
  })
  
  output$modelSuggestion <- renderPrint({ suggestModel() })
  
  modelFit <- eventReactive(input$fit, {
    req(stationaryData())
    
    if (input$modelType == "auto") {
      return(auto.arima(stationaryData()))
    } else if (input$modelType == "arima") {
      return(Arima(stationaryData(), order = c(input$p, input$d, input$q)))
    } else if (input$modelType == "arch" || input$modelType == "garch") {
      spec <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)),
                         mean.model = list(armaOrder = c(input$p, input$q)))
      return(ugarchfit(spec, data = stationaryData(), out.sample = input$forecastHorizon))
    }
  })
  
  output$modelSummary <- renderPrint({ 
    req(modelFit()) 
    summary(modelFit()) 
  })
  
  output$forecastPlot <- renderPlot({
    req(modelFit())
    
    if (input$modelType == "arima" || input$modelType == "auto") {
      forecasted <- forecast(modelFit(), h = input$forecastHorizon)
      autoplot(forecasted)
    } else if (input$modelType == "garch") {
      # Ensure n.roll does not exceed out.sample
      n_roll_value <- min(input$forecastHorizon - 1, input$forecastHorizon)
      
      spec <- ugarchforecast(modelFit(), n.ahead = input$forecastHorizon, 
                             n.roll = n_roll_value,  # Ensuring n.roll <= out.sample
                             method = input$garchForecastType)
      plot(spec, which = "all")
    }
  })
  
  output$residualPlot <- renderPlot({ 
    req(modelFit()) 
    ggplot(data.frame(residuals = residuals(modelFit())), aes(x = residuals)) +
      geom_histogram(binwidth = 0.5, fill = "blue", alpha = 0.7) +
      ggtitle("Residual Histogram") + theme_minimal()
  })
  
  output$residualACF <- renderPlot({ 
    req(modelFit()) 
    Acf(residuals(modelFit()), main = "Residual ACF") 
  })
  
  output$volatilityPlot <- renderPlot({
    req(modelFit())
    
    # Only plot volatility for GARCH models
    if (input$modelType == "garch") {
      sigma_vals <- sigma(modelFit())
      plot(sigma_vals, type = "l", col = "blue", main = "Volatility Clustering", ylab = "Sigma", xlab = "Time")
    }
  })
}

