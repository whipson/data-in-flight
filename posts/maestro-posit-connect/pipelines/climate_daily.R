#' climate_daily maestro pipeline
#'
#' @maestroFrequency 1 day
#' @maestroStartTime 2024-06-25 01:30:00
#' @maestroTz America/Halifax
#' @maestroLogLevel INFO
climate_daily <- function(board) {

  last_full_day <- lubridate::today() - lubridate::days(1)
  last_full_day_fmt <- format(last_full_day, "%Y-%m-%dT%H:%M:%SZ")

  # Request to get climate observations for the last full hour
  req <- httr2::request("https://api.weather.gc.ca/collections/climate-daily/items") |>
    httr2::req_url_query(
      CLIMATE_IDENTIFIER = 8202251, # corresponds with Halifax Int'l Airport
      datetime = paste0(last_full_day_fmt, "/.."),
      skipGeometry = TRUE,
      LIMIT = 1000
    )

  resp <- req |>
    httr2::req_perform() |>
    resp_body_json(simplifyVector = TRUE)

  df_raw <- resp$features$properties

  df_proc <- df_raw |>
    janitor::clean_names() |>
    dplyr::mutate(
      insert_time = lubridate::now(tzone = "UTC")
    )

  pin_append(
    board,
    df_proc,
    name = "climate_daily_transactional",
    type = "parquet"
  )
}
