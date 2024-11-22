#' data_engineering_books_etl maestro pipeline
#'
#' @maestroFrequency 1 day
#' @maestroStartTime 2024-10-01
#' @maestroTz UTC
#' @maestroLogLevel INFO

data_engineering_books_etl <- function(board) {

  req <- httr2::request("https://openlibrary.org/") |>
    httr2::req_url_path_append("search.json") |>
    httr2::req_url_query(
      q = "subject:data+engineering",
      sort = "new",
      lang = "eng",
      limit = 1000
    )

  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)

  docs <- resp$docs |>
    janitor::clean_names() |>
    dplyr::filter(language != "NULL") |>
    dplyr::rowwise() |>
    dplyr::mutate(
      authors = paste(author_name, collapse = ", ")
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      insert_time = lubridate::now()
    ) |>
    dplyr::select(
      title, authors, first_publish_year
    )

  # Attempt to read existing book titles
  tryCatch({
    existing_titles <- pins::pin_read(
      board,
      "data_engineering_book_titles_transactional"
    ) |>
      dplyr::pull(title)

    # Remove titles that already exist
    docs <- docs |>
      dplyr::filter(!title %in% existing_titles)
  })

  pin_append(
    board,
    docs,
    "data_engineering_book_titles_transactional"
  )
}
