#' @maestroFrequency daily
#' @maestroStartTime 2024-11-22 09:00:00
#' @maestroOutputs process_flights
extract_flights <- function() {

  # Imagine this is from a source where the data changes
  nycflights13::flights
}

#' @maestroOutputs train_model
process_flights <- function(.input) {

  daily_flights <- .input |>
    dplyr::mutate(date = lubridate::make_date(year, month, day)) |>
    dplyr::summarise(
      n_flights = dplyr::n(), .by = date
    )

  # A simple time series
  ts(data = daily_flights$n_flights, frequency = 365)
}

#' @maestroOutputs forecast_flights
train_model <- function(.input) {

  # A simple ARIMA model (using the {forecast} package would be better)
  .input |>
    arima(order = c(1, 1, 1))
}

#' @maestro
forecast_flights <- function(.input) {

  # Forecast the next 7 days
  pred_obj <- predict(.input, n.ahead = 7)
  pred_obj$pred
}
