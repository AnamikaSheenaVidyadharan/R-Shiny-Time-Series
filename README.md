# R-Shiny-Time-Series
A user-friendly Shiny dashboard for interactive time series analysis. Features include stationarity tests, ACF/PACF plots, ARIMA/ARCH/GARCH model fitting, forecast generation with custom horizons, diagnostic checks, and automated model suggestions.

# Overview
A comprehensive and interactive R Shiny dashboard designed for educational and practical time series analysis. It enables graphical exploration, stationarity checks, decomposition, model fitting (ARIMA, ARCH, GARCH), residual diagnostics, and forecasting with ease.

# Key Features
- Upload and analyze CSV time series data

- Handle missing (mean imputation) and duplicate values

- ACF/PACF plots for original and transformed series

- Automatic stationarity detection (differencing, log transformation)

- ADF Test for formal stationarity check

- Model suggestions: AR, MA, ARIMA (via auto.arima()), ARCH, GARCH

- Residual diagnostics (white noise checks, Ljung-Box test)

- Forecasting with user-defined horizon and confidence intervals

- Downloadable outputs (plots and forecast results)

# Getting Started
Install dependencies: install.packages(c("shiny", "ggplot2", "forecast", "tseries", "rugarch", "zoo", "FinTS", "TTR", "dplyr")) Run app: shiny::runApp("grp1_team_task")

# How to Use

Upload your CSV file

Select the relevant time series column

Explore data via EDA tab

View ACF/PACF plots for original and transformed series

App suggests or allows manual model selection

Generate forecasts with your chosen horizon

Download plots and forecast tables

# Interpretation Guide

EDA: Imputes missing values, removes duplicates, detects trends/seasonality

Stationarity: ADF p < 0.05 indicates stationarity; otherwise, transforms applied

ACF/PACF: Used for model order identification

Model Fitting: auto.arima() for ARIMA; ARCH/GARCH if volatility is present

Diagnostics: White noise residuals expected; Ljung-Box p > 0.05 confirms no autocorrelation

Forecasting: Custom horizon with confidence intervals

# Credits
Developed by a 5-member academic team for an advanced time series project.


