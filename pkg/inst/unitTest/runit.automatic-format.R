require(svUnit)

# test functions are called in lexicographic order.

## utility functions

logged <- NULL

mockAction <- function(msg, handler, ...) {
  if(length(list(...)) && 'dry' %in% names(list(...)))
    return(TRUE)
  logged <<- c(logged, msg)
}

mockFormatter <- function(record) {
  paste(record$levelname, record$logger, record$msg, sep = ":")
}

## test functions

test.autoformat.one_numeric_literal<- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo(12)
  checkEquals("INFO::12: 12", logged)
}

test.autoformat.more_numeric_literals<- function() {
  ## TODO
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo(12, 2, 4)
  checkEquals("INFO::12: 12, 2: 2, 4: 4", logged)
}

test.autoformat.one_numeric_variable<- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  a <- 1
  loginfo(a)
  checkEquals("INFO::a: 1", logged)
}

