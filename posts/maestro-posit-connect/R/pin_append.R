box::use(
  dplyr[bind_rows],
  pins[pin_read, pin_write]
)

pin_append <- function(board, x, name, type = "parquet") {

  existing <- tryCatch({
    pin_read(
      board,
      name
    )
  }, error = \(e) {
    warning("Pin '", name, "' does not exist. Creating.")
    return(NULL)
  })

  new <- bind_rows(x, existing)

  tryCatch({
    pin_write(
      board,
      new,
      name = name,
      type = type
    )
  }, error = \(e) {
    stop("Failed to append to pin '", name, "'")
  })
}
