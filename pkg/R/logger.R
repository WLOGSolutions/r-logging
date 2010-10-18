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
## $Id$
##
## initial programmer :  Mario Frasca
## based on:             Brian Lee Yung Rowe's futile library
##
## initial date       :  20100105
##

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

.logrecord <- function(record, logger)
{
  ## get the logger of which we have the name.
  config <- getLogger(logger)
  
  if (record$level >= config$level) 
    for (handler in config[['handlers']])
      if (record$level >= with(handler, level)) {
        action <- with(handler, action)
        formatter <- with(handler, formatter)
        action(formatter(record), handler)
      }

  if(logger != '') {
    parts <- strsplit(logger, '.', fixed=TRUE)[[1]] # split the name on the '.'
    removed <- parts[-length(parts)] # except the last item
    parent <- paste(removed, collapse='.')
    .logrecord(record, logger=parent)
  }
  invisible(TRUE)
}

## main log function, used by all other ones
## (entry points for messages)
levellog <- function(level, msg, ..., logger='')
{
  ## does the logger just drop the record?
  config <- getLogger(logger)
  if (level < config$level) 
    return(invisible(FALSE))

  ## fine, we create the record and pass it to all handlers attached to the
  ## loggers from here up to the root.
  record <- list()

  if (length(list(...)) > 0)
    msg <- sprintf(msg, ...)
  record$msg <- msg

  record$timestamp <- sprintf("%s", Sys.time())
  record$logger <- logger
  record$level <- namedLevel(level)
  record$levelname <- names(which(loglevels == level)[1])
  if(is.na(record$levelname))
    record$levelname <- paste("NumericLevel(", level, ")", sep='')

  ## action is taken in private function.
  .logrecord(record, logger)
}

## using log
logdebug <- function(msg, ..., logger='')
{
  levellog(loglevels[['DEBUG']], msg, ..., logger=logger)
  invisible()
}

logfinest <- function(msg, ..., logger='')
{
  levellog(loglevels['FINEST'], msg, ..., logger=logger)
  invisible()
}

logfiner <- function(msg, ..., logger='')
{
  levellog(loglevels['FINER'], msg, ..., logger=logger)
  invisible()
}

logfine <- function(msg, ..., logger='')
{
  levellog(loglevels[['FINE']], msg, ..., logger=logger)
  invisible()
}

## using log
loginfo <- function(msg, ..., logger='')
{
  levellog(loglevels['INFO'], msg, ..., logger=logger)
  invisible()
}

## using log
logwarn <- function(msg, ..., logger='')
{
  levellog(loglevels['WARN'], msg, ..., logger=logger)
  invisible()
}

## using log
logerror <- function(msg, ..., logger='')
{
  levellog(loglevels['ERROR'], msg, ..., logger=logger)
  invisible()
}

## set properties of a logger or a handler
updateOptions <- function(container, ...)
  UseMethod('updateOptions')

updateOptions.character <- function(container, ...) {
  ## container is really just the name of the container
  updateOptions.environment(getLogger(container), ...)
}

updateOptions.environment <- function(container, ...) {
  ## the container is a logger
  config <- list(...);
  if (! 'level' %in% names(config))
    config$level = loglevels['INFO']
  for (key in names(config))
    container[[key]] <- config[[key]]
  invisible()
}

## Get a specific logger configuration
getLogger <- function(name='', ...)
{
  if(name=='')
    fullname <- 'logging.ROOT'
  else
    fullname <- paste('logging.ROOT', name, sep='.')

  if(!exists(fullname, envir=logging.options)) {
    logging.options[[fullname]] <- new.env()
    logging.options[[fullname]][['handlers']] <- NULL
    updateOptions.environment(logging.options[[fullname]], ...)
  }
  logging.options[[fullname]]
}

## set the level of a handler or a logger
setLevel <- function(level, container='')
  UseMethod('setLevel')

setLevel.character <- function(level, container='') {
  updateOptions(container, level=loglevels[level])
}

setLevel.numeric <- function(level, container='') {
  level <- namedLevel(level)
  updateOptions(container, level=level)
}

setLevel.default <- function(level, container='') {
  NA
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
  cat(paste(msg, '\n', sep=''))
}

writeToFile <- function(msg, handler)
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

basicConfig <- function(level=20) {
  updateOptions('', level=namedLevel(level))
  addHandler('basic.stdout', writeToConsole)
  invisible()
}

## Add a new handler to the options config
## The following values need to be provided:
##   name - the name of the logger to which the logger is to be attached
##   level - log level for new handler
##   action - the implementation for the handler. Either a function or a name of
##     a function
##   ... options to be stored as fields of new handler
addHandler <- function(handler, ..., level=20, logger='', formatter=defaultFormat)
  UseMethod('addHandler')

addHandler.default <- function(handler, ..., level=20, logger='', formatter=defaultFormat) {
  ## action <- handler # parameter 'handler' identifies the action
  ## user did not provide a name for this handler, extract it from action.
  addHandler.character(deparse(substitute(handler)), handler, ..., level=level, logger=logger, formatter=formatter)
}

addHandler.character <- function(handler, action, ..., level=20, logger='', formatter=defaultFormat)
{
  name <- handler # parameter 'handler' identifies the name
  handler <- new.env()
  updateOptions.environment(handler, ...)
  assign('level', namedLevel(level), handler)
  assign('action', action, handler)
  assign('formatter', formatter, handler)
  handlers <- with(getLogger(logger), handlers)
  handlers[[name]] <- handler
  assign('handlers', handlers, envir=getLogger(logger))

  invisible()
}

removeHandler <- function(handler, logger='')
  UseMethod('removeHandler')

removeHandler.default <- function(handler, logger='') {
  ## action <- handler # parameter 'handler' identifies the action
  removeHandler.character(deparse(substitute(handler)), logger)
}

removeHandler.character <- function(handler, logger='') {
  # parameter 'handler' identifies the name
  handlers <- with(getLogger(logger), handlers)
  to.keep <- !(names(handlers) == handler)
  assign('handlers', handlers[to.keep], envir=getLogger(logger))
  invisible()
}

## retrieve a specific handler out of a logger.  loggers are separated
## environments and handlers with the same name may be associated to
## different loggers.

getHandler <- function(handler, logger='')
  UseMethod('getHandler')

getHandler.default <- function(handler, logger='') {
  ## action <- handler # assume we got the handler by action
  getHandler.character(deparse(substitute(handler)), logger)
}

getHandler.character <- function(handler, logger='') {
  ## name <- handler # we got the handler by name
  with(getLogger(logger), handlers)[[handler]]
}

#################################################################################

logReset <- function() {
  ## reinizialize the whole logging system

  ## remove all content from the logging environment
  rm(list=ls(logging.options), envir=logging.options)

  ## create the root logger
  getLogger('', handlers=NULL, level=0)
  invisible()
}

## create the logging environment
logging.options <- new.env()

## initialize the module
logReset()
