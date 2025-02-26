#' @maestroFrequency 3 hours
#' @maestroStartTime 2025-02-20 12:00:00
#' @maestroTz America/Halifax
get_nearby_notable_obs <- function() {

  req <- httr2::request("https://api.ebird.org/v2") |>
    httr2::req_url_path_append("data/obs/geo/recent/notable") |>
    httr2::req_url_query(
      lat = 44.88,
      lng = -63.52
    ) |>
    httr2::req_headers(
      `X-eBirdApiToken` = Sys.getenv("EBIRD_API_KEY")
    )

  resp <- req |>
    httr2::req_perform()

  obs <- resp |>
    httr2::resp_body_json(simplifyVector = TRUE) |>
    dplyr::mutate(
      insert_time = Sys.time()
    )

  # Connect to a local in-memory duckdb
  conn <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(conn))

  # Create and write to a table
  DBI::dbWriteTable(
    conn,
    name = "recent_notable_observations",
    value = obs,
    append = TRUE
  )
}
