##***********************************************************************
## this program is free software: you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## this program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the nens libraray.  If not, see
## <http://www.gnu.org/licenses/>.
##
## Library    : logging
##
## Purpose    : emulate the python standard logging package
##
## Usage      : library(logging)
##
## $Id: logger.R 9806 2010-03-09 07:49:46Z Mario $
##
## initial programmer :  Mario Frasca
## based on:             Brian Lee Yung Rowe's futile library
##
## initial date       :  20100105
##

## TODO: these constants must be exported and documented
levels <- c(0, 1, 4, 7, 10, 20, 30, 40, 50, 50)
names(levels) <- c('NOTSET', 'FINEST', 'FINER', 'FINE', 'DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL', 'FATAL')

## main log function, used by all other ones
## (entry points for messages)
levellog <- function(level, msg, ..., logger='')
{
  ## get the logger of which we have the name.
  config <- getLogger(logger)
  if (level < config$level) return(invisible())

  ## what is the record to be logged?
  record <- list()

  if (length(list(...)) > 0) msg <- sprintf(msg, ...)
  record$msg <- msg

  record$timestamp <- sprintf("%s", Sys.time())
  record$logger <- logger
  record$level <- level
  record$levelname <- names(which(levels == level)[1])
  if(is.na(record$levelname))
    record$levelname <- paste("NumericLevel(", level, ")", sep='')

  ## invoke the action of all handlers associated to logger
  for (handler in config$handlers) {
    if (level >= handler$level) {
      handler$action(handler$formatter(record), handler)
    }
  }

  ## if not at root level, check the parent logger
  if(logger != ''){
    parts <- strsplit(logger, '\\.')[[1]] # split the name on the '.'
    removed <- parts[-length(parts)] # except the last item
    parent <- paste(removed, collapse='.')
    levellog(level, msg, ..., logger=parent)
  }
  
  invisible()
}

## using log
debug <- function(msg, ..., logger='')
{
  levellog(levels['DEBUG'], msg, ..., logger=logger)
  invisible()
}

finest <- function(msg, ..., logger='')
{
  levellog(levels['FINEST'], msg, ..., logger=logger)
  invisible()
}

finer <- function(msg, ..., logger='')
{
  levellog(levels['FINER'], msg, ..., logger=logger)
  invisible()
}

fine <- function(msg, ..., logger='')
{
  levellog(levels['FINE'], msg, ..., logger=logger)
  invisible()
}

## using log
info <- function(msg, ..., logger='')
{
  levellog(levels['INFO'], msg, ..., logger=logger)
  invisible()
}

## using log
warn <- function(msg, ..., logger='')
{
  levellog(levels['WARN'], msg, ..., logger=logger)
  invisible()
}

## using log
error <- function(msg, ..., logger='')
{
  levellog(levels['ERROR'], msg, ..., logger=logger)
  invisible()
}

## set properties of a logger or a handler
updateOptions <- function(name, ...) {
  if(name=='')
    name <- 'logging.ROOT'
  else
    name <- paste('logging.ROOT', name, sep='.')

  config <- list(...)
  if (! 'level' %in% names(config))
    config$level = levels['INFO']

  # is there a logger by this name already?
  if (! exists(name, logging.options))
    logging.options[[name]] <- new.env()

  for (key in names(config))
    logging.options[[name]][[key]] <- config[[key]]
}

## Get a specific logger configuration
getLogger <- function(name='', ...)
{
  if(name=='')
    fullname <- 'logging.ROOT'
  else
    fullname <- paste('logging.ROOT', name, sep='.')

  if (! exists(fullname, envir=logging.options)){
    updateOptions(name, ...)
  }

  logging.options[[fullname]]
}

## set the level of a handler or a logger
setLevel <- function(name, level)
{
  if (level %in% names(levels))
    level <- levels[level]
  updateOptions(name, level=level)
}

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

writeToConsole <- function(msg, handler)
{
  cat(msg)
}

writeToFile <- function(msg, handler)
{
  if (! 'file' %in% names(handler))
  {
    cat("handler with writeToFile 'action' must have a 'file' element.\n")
    return()
  }
  cat(msg, file=handler$file, append=TRUE)
}

#################################################################################

## the single predefined formatter

defaultFormat <- function(record) {
  paste(record$timestamp, record$levelname, record$msg, '\n')
}

#################################################################################

basicConfig <- function() {
  updateOptions('', level=levels['INFO'])
  addHandler(writeToConsole, name='basic.stdout')
  invisible()
}

## Add a new handler to the options config
## The following values need to be provided:
##   name - the name of the logger to which the logger is to be attached
##   level - log level for new handler
##   action - the implementation for the handler. Either a function or a name of
##     a function
##   ... options to be stored as fields of new handler
addHandler <- function(name, action, ..., level=20, logger='', formatter=defaultFormat)
{
  handlers <- getLogger(logger)[['handlers']]

  handler <- list(level=level, action=action, formatter=formatter, ...)
  handlers[name] <- list(handler) # this does not alter the original list

  updateOptions(logger, handlers=handlers) # this replaces the original list
  
  invisible()
}

removeHandler <- function(name, logger='') {
  handlers <- getLogger(logger)[['handlers']]
  to.keep <- !(names(handlers) == name)
  updateOptions(logger, handlers=handlers[to.keep])
  invisible()
}

#################################################################################

## initialize the module

## The logger options manager
logging.options <- new.env()

getLogger('', handlers=NULL, level=0)
