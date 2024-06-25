#' hydrometric maestro pipeline
#'
#' @maestroFrequency 20 minutes
#' @maestroStartTime 2024-06-25 00:20:00
#' @maestroTz America/Halifax
#' @maestroLogLevel INFO

hydrometric <- function() {

  last_full_day <- today() - days(1)
  last_full_day_fmt <- format(last_full_day, "%Y-%m-%dT%H:%M:%SZ")

  # Request to get climate observations for the last full hour
  req <- request("https://api.weather.gc.ca/collections/hydrometric-realtime/items") |>
    req_url_query(
      STATION_NUMBER = "01EJ001",
      datetime = paste0(last_full_day_fmt, "/.."),
      skipGeometry = TRUE
    )

  resp <- req |>
    req_perform() |>
    resp_body_json(simplifyVector = TRUE)

  df_raw <- resp$features$properties

  df_proc <- df_raw |>
    clean_names() |>
    mutate(
      insert_time = now(tzone = "UTC")
    )

  pin_append(
    board,
    df_proc,
    name = "climate_daily_transactional",
    type = "parquet"
  )
}
