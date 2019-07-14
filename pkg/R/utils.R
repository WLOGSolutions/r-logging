##
## this is part of the logging package. the logging package is free
## software: you can redistribute it as well as modify it under the terms of
## the GNU General Public License as published by the Free Software
## Foundation, either version 3 of the License, or (at your option) any later
## version.
##
## this program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the nens libraray.  If not, see http://www.gnu.org/licenses/.
##
## Copyright (c) 2009..2013 by Mario Frasca
##


#'
#' Predefined(sample) handler actions
#'
#' When you define a handler, you specify its name and the associated action.
#' A few predefined actions described below are provided.
#'
#' A handler action is a function that accepts a formated message and handler
#' configuration.
#'
#' Messages passed are filtered already regarding loglevel.
#'
#' \dots parameters are used by logging system to interact with the action. \dots can
#' contain \var{dry} key to inform action that it meant to initialize itself. In the case
#' action should return TRUE if initialization succeded.
#'
#' If it's not a dry run \dots contain the whole preformated \var{logging.record}.
#' A \var{logging.record} is a named list and has following structure:
#' \describe{
#'   \item{msg}{contains the real formatted message}
#'   \item{level}{message level as numeric}
#'   \item{levelname}{message level name}
#'   \item{logger}{name of the logger that generated it}
#'   \item{timestamp}{formatted message timestamp}
#' }
#'
#' @param msg A formated message to handle.
#' @param handler The handler environment containing its options. You can
#'   register the same action to handlers with different properties.
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
#'
#' @details
#' \code{writeToConsole} detects if crayon package is available and uses it
#' to color messages. The coloring can be switched off by means of configuring
#' the handler with \var{color_output} option set to FALSE.
#'
#' @export
#'
writeToConsole <- function(msg, handler, ...) {
  if (length(list(...)) && "dry" %in% names(list(...))) {
    if (!is.null(handler$color_output) && handler$color_output == FALSE) {
      handler$color_msg <- function(msg, level_name) msg
    } else {
      handler$color_msg <- .build_msg_coloring()
    }
    return(TRUE)
  }

  stopifnot(length(list(...)) > 0)

  level_name <- list(...)[[1]]$levelname
  msg <- handler$color_msg(msg, level_name)
  cat(paste0(msg, "\n"))
}

.build_msg_coloring <- function() {
  crayon_env <- tryCatch(asNamespace("crayon"),
                         error = function(e) NULL)

  default_color_msg <- function(msg, level_name) msg
  if (is.null(crayon_env)) {
    return(default_color_msg)
  }

  if (is.null(crayon_env$make_style) ||
      is.null(crayon_env$combine_styles) ||
      is.null(crayon_env$reset)) {
    return(default_color_msg)
  }

  color_msg <- function(msg, level_name) {
    style <- switch(level_name,
                    "FINEST" = crayon_env$make_style("gray80"),
                    "FINER" = crayon_env$make_style("gray60"),
                    "FINE" = crayon_env$make_style("gray60"),
                    "DEBUG" = crayon_env$make_style("deepskyblue4"),
                    "INFO" = crayon_env$reset,
                    "WARNING" = crayon_env$make_style("darkorange"),
                    "ERROR" = crayon_env$make_style("red4"),
                    "CRITICAL" =
                      crayon_env$combine_styles(crayon_env$bold,
                                                crayon_env$make_style("red1")),
                    crayon_env$make_style("gray100"))
    res <- paste0(style(msg), crayon_env$reset(""))
    return(res)
  }
  return(color_msg)
}


#' @rdname inbuilt-actions
#'
#' @details \code{writeToFile} action expects file path to write to under
#'  \var{file} key in handler options.
#'
#' @export
#'
writeToFile <- function(msg, handler, ...) {
  if (length(list(...)) && "dry" %in% names(list(...)))
    return(exists("file", envir = handler))
  cat(paste0(msg, "\n"), file = with(handler, file), append = TRUE)
}

## the single predefined formatter
defaultFormat <- function(record) {
  ## strip leading and trailing whitespace from the final message.
  msg <- trimws(record$msg)
  text <- paste(record$timestamp,
                paste(record$levelname, record$logger, msg, sep = ":"))
  return(text)
}

## default way of composing msg with parameters
defaultMsgCompose <- function(msg, ...) {
  optargs <- list(...)
  if (is.character(msg)) {
    ## invoked as ("printf format", arguments_for_format)
    if (length(optargs) > 0) {
      optargs <- lapply(optargs,
                        function(x) {
                          if (length(x) != 1)
                            x <- paste(x, collapse = ",")
                          x
                        })
    }

    # 8192 is limitation on fmt in sprintf
    if (any(nchar(msg) > 8192)) {
      if (length(optargs) > 0) {
        stop("'msg' length exceeds maximal format length 8192")
      }

      # else msg must not change in any way
      return(msg)
    }
    if (length(optargs) > 0) {
      msg <- do.call("sprintf", c(msg, optargs))
    }
    return(msg)
  }

  ## invoked as list of expressions
  ## this assumes that the function the user calls is two levels up, e.g.:
  ## loginfo -> .levellog -> logger$log -> .default_msg_composer
  ## levellog -> .levellog -> logger$log -> .default_msg_composer
  external_call <- sys.call(-3)
  external_fn <- eval(external_call[[1]])
  matched_call <- match.call(external_fn, external_call)
  matched_call <- matched_call[-1]
  matched_call_names <- names(matched_call)

  ## We are interested only in the msg and ... parameters,
  ## i.e. in msg and all parameters not explicitly declared
  ## with the function
  formal_names <- names(formals(external_fn))
  is_output_param <-
    matched_call_names == "msg" |
    !(matched_call_names %in% c(setdiff(formal_names, "...")))

  label <- lapply(matched_call[is_output_param], deparse)
  msg <- sprintf("%s: %s", label, c(msg, optargs))
  return(msg)
}
