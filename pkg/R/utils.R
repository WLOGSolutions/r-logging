
#################################################################################

## sample actions for handlers

## a handler is a function that accepts a logging.record and a
## configuration.

## a logging.record contains the real message, its level, the name of the
## logger that generated it, a timestamp.

## a configuration contains a formatter (a function taking a
## logging.record and returning a string), a numeric level (only records
## with level equal or higher than that are taken into account), an
## action (writing the formatted record to a stream).

writeToConsole <- function(msg, handler, ...)
{
  cat(paste(msg, '\n', sep=''))
}

writeToFile <- function(msg, handler, ...)
{
  if (!exists('file', envir=handler))
    stop("handler with writeToFile 'action' must have a 'file' element.\n")
  cat(paste(msg, '\n', sep=''), file=with(handler, file), append=TRUE)
}

#################################################################################

## the single predefined formatter

defaultFormat <- function(record) {
  text <- paste(record$timestamp, paste(record$levelname, record$logger, record$msg, sep=':'))
}

#################################################################################

#################################################################################
