#' @maestroFrequency 1 day
#' @maestroStartTime 2025-02-20 18:00:00
#' @maestroTz America/Halifax
get_region_stats <- function() {

  now <- Sys.time()
  cur_year <- lubridate::year(now)
  cur_month <- lubridate::month(now)
  cur_day <- lubridate::day(now)

  req <- httr2::request("https://api.ebird.org/v2") |>
    httr2::req_url_path_append("product/stats", "CA-NS", cur_year, cur_month, cur_day) |>
    httr2::req_headers(
      `X-eBirdApiToken` = Sys.getenv("EBIRD_API_KEY")
    )

  resp <- req |>
    httr2::req_perform()

  stats <- resp |>
    httr2::resp_body_json(simplifyVector = TRUE) |>
    dplyr::as_tibble()

  # Connect to a local in-memory duckdb
  conn <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(conn))

  # Create and write to a table
  DBI::dbWriteTable(
    conn,
    name = "region_stats",
    value = stats,
    append = TRUE
  )
}
