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
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo(12, 1+1, 2*2)
  checkEquals(c("INFO::12: 12", "INFO::1 + 1: 2", "INFO::2 * 2: 4"), logged)
}

test.autoformat.one_numeric_variable<- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  a <- 1
  loginfo(a)
  checkEquals("INFO::a: 1", logged)
}

test.autoformat.one_numeric_expression<- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo(3 + 5)
  checkEquals("INFO::3 + 5: 8", logged)
}

test.autoformat.explicit_msg_parameter<- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo(logger=getLogger(), msg=3 + 5)
  checkEquals("INFO::3 + 5: 8", logged)
}

test.autoformat.shifted_msg_parameter<- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo(logger=getLogger(), 3 + 5)
  checkEquals("INFO::3 + 5: 8", logged)
}

test.autoformat.levellog<- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  levellog("INFO", 3 + 5)
  checkEquals("INFO::3 + 5: 8", logged)
}
