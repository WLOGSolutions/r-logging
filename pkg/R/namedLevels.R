
## TODO: these constants must be exported and documented
loglevels <- c(0, 1, 4, 7, 10, 20, 30, 30, 40, 50, 50)
names(loglevels) <- c('NOTSET', 'FINEST', 'FINER', 'FINE', 'DEBUG', 'INFO', 'WARNING', 'WARN', 'ERROR', 'CRITICAL', 'FATAL')

namedLevel <- function(value)
  UseMethod('namedLevel')

namedLevel.character <- function(value) {
  position <- which(names(loglevels) == value)
  if(length(position) == 1)
    loglevels[position]
}

namedLevel.numeric <- function(value) {
  if(is.null(names(value))) {
    position <- which(loglevels == value)
    if(length(position) == 1)
      value = loglevels[position]
  }
  value
}
