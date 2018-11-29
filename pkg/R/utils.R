##
## this is part of the R-logging package. the R-logging package is free
## software: you can redistribute it and/or modify it under the terms of the
## GNU General Public License as published by the Free Software Foundation,
## either version 3 of the License, or (at your option) any later version.
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
## Copyright (c) 2009-2013 by Mario Frasca
##

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
  if(length(list(...)) && 'dry' %in% names(list(...)))
    return(TRUE)
  cat(paste(msg, '\n', sep=''))
}

writeToFile <- function(msg, handler, ...)
{
  if(length(list(...)) && 'dry' %in% names(list(...)))
    return(exists('file', envir=handler))
  cat(paste(msg, '\n', sep=''), file=with(handler, file), append=TRUE)
}

#################################################################################

## the single predefined formatter

defaultFormat <- function(record) {
  ## strip leading and trailing whitespace from the final message.
  msg <- sub("[[:space:]]+$", '', record$msg)
  msg <- sub("^[[:space:]]+", '', msg)
  text <- paste(record$timestamp, paste(record$levelname, record$logger, msg, sep=':'))
}

#################################################################################

#################################################################################
