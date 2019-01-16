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
#' Entry points for logging actions
#'
#' Generate a log record and pass it to the logging system.\cr
#'
#' A log record gets timestamped and will be independently formatted by each
#' of the handlers handling it.\cr
#'
#' Leading and trailing whitespace is stripped from the final message.
#'
#' @param msg the textual message to be output, or the format for the \dots
#'  arguments
#' @param ... if present, msg is interpreted as a format and the \dots values
#'  are passed to it to form the actual message.
#' @param logger the name of the logger to which we pass the record
#'
#' @examples
#' logReset()
#' addHandler(writeToConsole)
#' loginfo('this goes to console')
#' logdebug('this stays silent')
#'
#' @name logging-entrypoints
#'
NULL

#' @rdname logging-entrypoints
#' @export
#'
logdebug <- function(msg, ..., logger = "") {
  .levellog(loglevels["DEBUG"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
#'
logfinest <- function(msg, ..., logger = "") {
  .levellog(loglevels["FINEST"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
#'
logfiner <- function(msg, ..., logger = "") {
  .levellog(loglevels["FINER"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
#'
logfine <- function(msg, ..., logger = "") {
  .levellog(loglevels["FINE"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
#'
loginfo <- function(msg, ..., logger = "") {
  .levellog(loglevels["INFO"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
#'
logwarn <- function(msg, ..., logger = "") {
  .levellog(loglevels["WARN"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
#'
logerror <- function(msg, ..., logger = "") {
  .levellog(loglevels["ERROR"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#'
#' @param level The logging level
#' @export
levellog <- function(level, msg, ..., logger = "") {
  # just calling .levellog
  # do not simplify it as call sequence sould be same
  #   as for other logX functions
  .levellog(level, msg, ..., logger = logger)
}

.levellog <- function(level, msg, ..., logger = "") {
  if (is.character(logger)) {
    logger <- getLogger(logger)
  }
  logger$log(level, msg, ...)
}



#'
#' Set defaults and get the named logger.
#'
#' Make sure a logger with a specific name exists and return it as a
#' \var{Logger} S4 object.  if not yet present, the logger will be created and
#' given the values specified in the \dots arguments.
#'
#' @param name The name of the logger
#' @param ... Any properties you may want to set in the newly created
#'    logger. These have no effect if the logger is already present.
#'
#' @return The logger retrieved or registered.
#'
#' @examples
#' getLogger()  # returns the root logger
#' getLogger('test.sub')  # constructs a new logger and returns it
#' getLogger('test.sub')  # returns it again
#'
#' @export
#'
getLogger <- function(name = "", ...) {
  if (name == "") {
    fullname <- "logging.ROOT"
  } else {
    fullname <- paste("logging.ROOT", name, sep = ".")
  }

  if (!exists(fullname, envir = logging.options)) {
    logger <- Logger$new(name = name,
                         handlers = list(),
                         level = namedLevel("INFO"))
    updateOptions.environment(logger, ...)
    logging.options[[fullname]] <- logger

    if (fullname == "logging.ROOT") {
      .basic_config(logger)
    }
  }
  logging.options[[fullname]]
}



#'
#' Bootstrapping the logging package.
#'
#' \code{basicConfig} and \code{logReset} provide a way to put the logging package
#' in a know initial state.
#'
#' @examples
#' basicConfig()
#' logdebug("not shown, basic is INFO")
#' logwarn("shown and timestamped")
#' logReset()
#' logwarn("not shown, as no handlers are present after a reset")
#'
#' @name bootstrapping
NULL

#' @rdname bootstrapping
#'
#' @details
#' \code{basicConfig} creates the root logger, attaches a console handler(by
#' \var{basic.stdout} name) to it and sets the level of the handler to
#' \code{level}. You must not call \code{basicConfig} to for logger to work any more:
#' then root logger is created it gets initialized by default the same way as
#' \code{basicConfig} does. If you need clear logger to fill with you own handlers
#' use \code{logReset} to remove all default handlers.
#'
#' @param level The logging level of the root logger. Defaults to INFO. Please do notice that
#'   this has no effect on the handling level of the handler that basicConfig attaches to the
#'   root logger.
#'
#' @export
#'
basicConfig <- function(level = 20) {
  root_logger <- getLogger()

  updateOptions(root_logger, level = namedLevel(level))
  .basic_config(root_logger)

  invisible()
}

#' Called from basicConfig and while creating rootLogger.
#' @noRd
.basic_config <- function(root_logger) {
  stopifnot(root_logger$name == "")
  root_logger$addHandler("basic.stdout", writeToConsole)
}


#' @rdname bootstrapping
#'
#' @details
#' \code{logReset} reinitializes the whole logging system as if the package had just been
#' loaded except it also removes all default handlers. Typically, you would want to call
#' \code{basicConfig} immediately after a call to \code{logReset}.
#'
#' @export
#'
logReset <- function() {
  ## reinizialize the whole logging system

  ## remove all content from the logging environment
  rm(list = ls(logging.options), envir = logging.options)

  root_logger <- getLogger(level = "INFO")
  root_logger$removeHandler("basic.stdout")

  invisible()
}



#'
#' Add a handler to or remove one from a logger.
#'
#' Use this function to maintain the list of handlers attached to a logger.\cr
#' \cr
#' \code{addHandler} and \code{removeHandler} are also offered as methods of the
#' \var{Logger} S4 class.
#'
#' @details
#' Handlers are implemented as environments. Within a logger a handler is
#' identified by its \var{name} and all handlers define at least the
#' three variables:
#' \describe{
#'   \item{level}{all records at level lower than this are skipped.}
#'   \item{formatter}{a function getting a record and returning a string}
#'   \item{\code{action(msg, handler)}}{a function accepting two parameters: a
#'      formatted log record and the handler itself. making the handler a
#'      parameter of the action allows us to have reusable action functions.}
#' }
#'
#' Being an environment, a handler may define as many variables as you
#' think you need.  keep in mind the handler is passed to the action
#' function, which can check for existence and can use all variables that
#' the handler defines.
#'
#' @param handler The name of the handler, or its action
#' @param logger the name of the logger to which to attach the new handler,
#'   defaults to the root logger.
#'
#' @examples
#' logReset()
#' addHandler(writeToConsole)
#' names(getLogger()[["handlers"]])
#' loginfo("test")
#' removeHandler("writeToConsole")
#' logwarn("test")
#'
#' @name handlers-management
NULL

#' @rdname handlers-management
#'
#' @param ... Extra parameters, to be stored in the handler list
#'
#' \dots may contain extra parameters that will be passed to the handler
#' action. Some elements in the \dots will be interpreted here.
#'
#' @export
#'
addHandler <- function(handler, ..., logger = "") {
  if (is.character(logger)) {
    logger <- getLogger(logger)
  }

  ## this part has to be repeated here otherwise the called function
  ## will deparse the argument to 'handler', the formal name given
  ## here to the parameter
  if (is.character(handler)) {
    logger$addHandler(handler, ...)
  } else {
    handler_name <- deparse(substitute(handler))
    logger$addHandler(handler = handler_name, action = handler, ...)
  }
}

#' @rdname handlers-management
#' @export
#'
removeHandler <- function(handler, logger = "") {
  if (is.character(logger)) {
    logger <- getLogger(logger)
  }
  if (!is.character(handler)) {
    # handler was passed as its action
    handler <- deparse(substitute(handler))
  }
  logger$removeHandler(handler)
}

#'
#' Retrieves a handler from a logger.
#'
#' @description
#' Handlers are not uniquely identified by their name. Only within the logger to which
#' they are attached is their name unique. This function is here to allow you grab a
#' handler from a logger so you can examine and alter it.
#'
#' @description
#' Typical use of this function is in \code{setLevel(newLevel, getHandler(...))}.
#'
#' @param handler The name of the handler, or its action.
#' @param logger Optional: the name of the logger. Defaults to the root logger.
#'
#' @return The retrieved handler object. It returns NULL if handler is not registerd.
#'
#' @examples
#' logReset()
#' addHandler(writeToConsole)
#' getHandler("basic.stdout")
#'
#' @export
#'
getHandler <- function(handler, logger = "") {
  if (is.character(logger)) {
    logger <- getLogger(logger)
  }
  if (!is.character(handler)) {
    # handler was passed as its action
    handler <- deparse(substitute(handler))
  }
  logger$getHandler(handler)
}



#'
#' Set \var{logging.level} for the object.
#'
#' Alter an existing logger or handler, setting its \var{logging.level} to a new
#' value. You can access loggers by name, while you must use \code{getHandler} to
#' get a handler.
#'
#' @param level The new level for this object. Can be numeric or character.
#' @param container a logger, its name or a handler. Default is root logger.
#'
#' @examples
#' basicConfig()
#' setLevel("FINEST")
#' setLevel("DEBUG", getHandler("basic.stdout"))
#'
#' @export
#'
setLevel <- function(level, container = "") {
  if (is.null(container)) {
    stop("NULL container provided: cannot set level for NULL container")
  }

  if (is.character(container)) {
    container <- getLogger(container)
  }
  assign("level", namedLevel(level), container)
}
