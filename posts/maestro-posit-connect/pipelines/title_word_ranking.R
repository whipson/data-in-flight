#' title_word_ranking maestro pipeline
#'
#' @maestroFrequency 1 week
#' @maestroStartTime 2024-10-01
#' @maestroTz UTC
#' @maestroLogLevel INFO

title_word_ranking <- function() {

  titles <- board |>
    pins::pin_read("data_engineering_book_titles_transactional")

  tokens <- titles |>
    tidytext::unnest_tokens(output = word, input = title, drop = FALSE) |>
    dplyr::anti_join(tidytext::stop_words) |>
    dplyr::filter(!any(word %in% c("conference", "proceedings")), .by = title) |>
    dplyr::filter(!stringr::str_detect(word, "[0-9]"))

  words_ranked <- tokens |>
    dplyr::count(word, sort = TRUE) |>
    dplyr::mutate(
      insert_time = lubridate::now()
    )

  pin_append(
    board,
    words_ranked,
    "data_engineering_titles_words_ranked"
  )
}
