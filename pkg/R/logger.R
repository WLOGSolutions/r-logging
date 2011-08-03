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

## main log function, used by all other ones
## (entry points for messages)
levellog <- function(level, msg, ..., logger=getLogger())
{
  if(is.character(logger))
    logger <- getLogger(logger)

  logger$log(level, msg, ...)
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

## Get a specific logger configuration
getLogger <- function(name='', ...)
{
  if(name=='')
    fullname <- 'logging.ROOT'
  else
    fullname <- paste('logging.ROOT', name, sep='.')

  if(!exists(fullname, envir=logging.options)) {
    logger <- Logger$new(name=name, handlers=list(), level=namedLevel('INFO'))
    updateOptions.environment(logger, ...)
    logging.options[[fullname]] <- logger
  }
  logging.options[[fullname]]
}

basicConfig <- function(level=20) {
  rootLogger <- getLogger()
  updateOptions(rootLogger, level=namedLevel(level))
  rootLogger$addHandler('basic.stdout', writeToConsole)
  invisible()
}

logReset <- function() {
  ## reinizialize the whole logging system

  ## remove all content from the logging environment
  rm(list=ls(logging.options), envir=logging.options)

  rootLogger <- getLogger()
  rootLogger$setLevel(0)

  invisible()
}

## handler-related

addHandler <- function(handler, ..., logger='') {
  if(is.character(logger))
    logger <- getLogger(logger)

  ## this part has to be repeated here otherwise the called function
  ## will deparse the argument to 'handler', the formal name given
  ## here to the parameter
  if(is.character(handler)) {
    params <- list(...)
    if('action' %in% names(params))
      action <- params[['action']]
    else
      action <- params[[1]]
  } else {
    action <- handler
    handler <- deparse(substitute(handler))
  }
  logger$addHandler(handler, action, ...)
}

removeHandler <- function(handler, logger='') {
  if(is.character(logger))
    logger <- getLogger(logger)
  logger$removeHandler(handler)
}

getHandler <- function(handler, logger='') {
  if(is.character(logger))
    logger <- getLogger(logger)
  logger$getHandler(handler)
}

## set the level of a logger
setLevel <- function(level, container='') {
  if(is.character(container))
    container <- getLogger(container)
  assign("level", namedLevel(level), container)
}
