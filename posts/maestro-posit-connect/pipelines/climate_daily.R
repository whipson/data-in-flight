box::use(
  dplyr[mutate],
  httr2[request, req_perform, req_url_query, resp_body_json],
  janitor[clean_names],
  lubridate[days, now, today]
)

box::use(
  R/pin_append[pin_append]
)

#' climate_daily maestro pipeline
#'
#' @maestroFrequency 1 day
#' @maestroStartTime 2024-06-25 01:30:00
#' @maestroTz Anerica/Halifax
#' @maestroLogLevel INFO

climate_daily <- function(board) {

  last_full_day <- today() - days(1)
  last_full_day_fmt <- format(last_full_day, "%Y-%m-%dT%H:%M:%SZ")

  # Request to get climate observations for the last full hour
  req <- request("https://api.weather.gc.ca/collections/climate-daily/items") |>
    req_url_query(
      CLIMATE_IDENTIFIER = 8202251, # corresponds with Halifax Int'l Airport
      datetime = paste0(last_full_day_fmt, "/.."),
      skipGeometry = TRUE,
      LIMIT = 1000
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
