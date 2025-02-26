#' @maestroFrequency 1 day
#' @maestroStartTime 2025-02-20 15:00:00
#' @maestroTz America/Halifax
get_species_list <- function() {

  req <- httr2::request("https://api.ebird.org/v2") |>
    httr2::req_url_path_append("product/spplist", "CA-NS") |>
    httr2::req_headers(
      `X-eBirdApiToken` = Sys.getenv("EBIRD_API_KEY")
    )

  resp <- req |>
    httr2::req_perform()

  spec_list <- resp |>
    httr2::resp_body_json(simplifyVector = TRUE)

  spec_df <- dplyr::tibble(
    speciesCode = spec_list
  ) |>
    dplyr::mutate(
      insert_time = Sys.time()
    )

  # Connect to a local in-memory duckdb
  conn <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(conn))

  # Create and write to a table
  DBI::dbWriteTable(
    conn,
    name = "species_list",
    value = spec_df,
    append = TRUE
  )
}
