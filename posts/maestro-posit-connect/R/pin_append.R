#' Reads a pin (creates if not existing) appends new rows and
#' writes it back to the same pin
pin_append <- function(board, x, name, type = "parquet") {

  existing <- tryCatch({
    pins::pin_read(
      board,
      name
    )
  }, error = \(e) {
    warning("Pin '", name, "' does not exist. Creating.")
    return(NULL)
  })

  new <- dplyr::bind_rows(x, existing)

  tryCatch({
    pins::pin_write(
      board,
      new,
      name = name,
      type = type
    )
  }, error = \(e) {
    stop("Failed to append to pin '", name, "'")
  })
}
