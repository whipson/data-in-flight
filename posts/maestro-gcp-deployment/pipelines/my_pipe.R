#' Located in ./pipelines/my_pipe.R
#' @maestroFrequency 1 day
#' @maestroStartTime 2024-06-03
geomet_stations <- function() {

  # Formulate the request
  req <- httr2::request(
    "https://api.weather.gc.ca/collections/climate-stations/items"
  ) |>
    httr2::req_url_query(
      limit = 1000,
      skipGeometry = TRUE
    )

  # Send the request and interpret the response
  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)

  # Get the properties element where the rectangular data is located
  stations_dat <- resp$features$properties

  # Clean the names
  stations_clean <- stations_dat |>
    janitor::clean_names() |>
    janitor::remove_empty(which = c("rows", "cols")) |>
    dplyr::mutate(
      insert_time = lubridate::now(tzone = "UTC")
    )

  write.csv(
    stations_clean,
    "geomet_stations_transactional.csv"
  )
}
