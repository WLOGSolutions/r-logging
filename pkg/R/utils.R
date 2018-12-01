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


#'
#' Predefined(sample) handler actions
#'
#' When you define a handler, you specify its name and the associated action.
#' A few predefined actions described below are provided.
#'
#' A handler is a function that accepts a \var{logging.record} and handler
#' configuration.
#'
#' A \var{logging.record} is a named list and has following structure:
#' \describe{
#'   \item{msg}{contains the real formatted message}
#'   \item{levelname}{message level name}
#'   \item{logger}{name of the logger that generated it}
#'   \item{timestamp}{formatted message timestamp}
#' }
#' Messages passed are filtered already regarding loglevel.
#'
#' \dots parameters are used by logging system to interact with the action. \dots can
#' contain \var{dry} key to inform action that it meant to initialize itself. In the case
#' action sould return TRUE if initialization succeded.
#'
#' @param msg A \var{logging.record} to handle
#' @param handler The handler environment containing its options. You can register the
#'   same action to handlers with different properties.
#' @param ... parameters provided by logger system to interact with the action.
#'
#' @examples
#' ## define your own function and register it with a handler.
#' ## author is planning a sentry client function.  please send
#' ## any interesting function you may have written!
#'
#' @name inbuilt-actions
NULL

#' @rdname inbuilt-actions
#' @export
#'
writeToConsole <- function(msg, handler, ...) {
  if(length(list(...)) && 'dry' %in% names(list(...)))
    return(TRUE)
  cat(paste(msg, '\n', sep=''))
}

#' @rdname inbuilt-actions
#'
#' @details \code{writeToFile} action expects file path to write to under
#'  \var{file} key in handler options.
#'
#' @export
#'
writeToFile <- function(msg, handler, ...) {
  if(length(list(...)) && 'dry' %in% names(list(...)))
    return(exists('file', envir=handler))
  cat(paste(msg, '\n', sep=''), file=with(handler, file), append=TRUE)
}

## the single predefined formatter
defaultFormat <- function(record) {
  ## strip leading and trailing whitespace from the final message.
  msg <- sub("[[:space:]]+$", '', record$msg)
  msg <- sub("^[[:space:]]+", '', msg)
  text <- paste(record$timestamp, paste(record$levelname, record$logger, msg, sep=':'))
}
