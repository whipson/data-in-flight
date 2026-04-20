
  #' @maestroFrequency hourly
  #' @maestroOutputs p3
  p1 <- function() {
    1
  }
  
  #' @maestroFrequency hourly
  #' @maestroOutputs p3
  p2 <- function() {
    2
  }
  
  #' @maestro
  p3 <- function(.input) {
    .input * 2
  }
  
