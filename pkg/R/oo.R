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

Logger <- setRefClass(
  "Logger",
  fields = list(
    name = "character",
    handlers = "list",
    level = "numeric",
    msg_composer = "function"),
  methods = list(
    getParent = function() {
      # split the name on the '.'
      parts <- unlist(strsplit(name, ".", fixed = TRUE))
      removed <- parts[-length(parts)] # except the last item
      parent_name <- paste(removed, collapse = ".")
      return(getLogger(parent_name))
    },

    getMsgComposer = function() {
      if (!is.null(msg_composer) && !is.null(functionBody(msg_composer))) {
        return(msg_composer)
      }
      if (name != "") {
        parent_logger <- getParent()
        return(parent_logger$getMsgComposer())
      }
      return(defaultMsgCompose)
    },

    setMsgComposer = function(composer_f) {
      if (!is.function(composer_f)
          || paste(formalArgs(composer_f), collapse = ", ") != "msg, ...") {
        stop(paste("message composer(passed as composer_f) must be function",
                   " with signature function(msg, ...)"))
      }
      msg_composer <<- composer_f
    },

    .deducelevel = function(initial_level = loglevels[["NOTSET"]]) {
      if (initial_level != loglevels[["NOTSET"]]) {
        # it's proper level (set: Not for inheritance)
        return(initial_level)
      }

      if (level != loglevels[["NOTSET"]]) {
        return(level)
      }

      if (name == "") {
        # assume it's FINEST, as root logger cannot inherit
        return(loglevels[["FINEST"]])
      }

      # ask parent for level
      parent_logger <- getParent()
      return(parent_logger$.deducelevel())
    },

    .logrecord = function(record) {
      logger_level <- .deducelevel(level)
      if (record$level >= logger_level) {
        for (handler in handlers) {
          handler_level <- .deducelevel(with(handler, level))
          if (record$level >= handler_level) {
            action <- with(handler, action)
            formatter <- with(handler, formatter)
            action(formatter(record), handler, record)
          }
        }
      }

      if (name != "") {
        parent_logger <- getParent()
        parent_logger$.logrecord(record)
      }
      invisible(TRUE)
    },

    log = function(msglevel, msg, ...) {
      msglevel <- namedLevel(msglevel)
      if (msglevel < level) {
        return(invisible(FALSE))
      }
      ## fine, we create the record and pass it to all handlers attached to the
      ## loggers from here up to the root.
      record <- list()

      composer_f <- getMsgComposer()
      record$msg <- composer_f(msg, ...)
      record$timestamp <- sprintf("%s", Sys.time())
      record$logger <- name
      record$level <- msglevel
      record$levelname <- names(which(loglevels == record$level)[1])

      ## cascade action in private method.
      .logrecord(record)
    },

    setLevel = function(new_level) {
      new_level <- namedLevel(new_level)
      level <<- new_level
    },

    getLevel = function() level,

    getHandler = function(handler) {
      if (!is.character(handler))
        handler <- deparse(substitute(handler))
      handlers[[handler]]
    },

    removeHandler = function(handler) {
      if (!is.character(handler))  # handler was passed as its action
        handler <- deparse(substitute(handler))
      handlers <<- handlers[!(names(handlers) == handler)]
    },

    addHandler = function(handler, ..., level = 0, formatter = defaultFormat) {
      handler_env <- new.env()
      if (is.character(handler)) {
        ## first parameter is handler name
        handler_name <- handler
        ## and hopefully action is in the dots
        params <- list(...)
        if ("action" %in% names(params)) {
          the_action <- params[["action"]]
        } else if (length(params) > 0 && is.null(names(params)[[1]])) {
          the_action <- params[[1]]
        } else {
          stop("No action for the handler provided")
        }

        assign("action", the_action, handler_env)
      } else {
        ## first parameter is handler action, from which we extract the name
        updateOptions.environment(handler_env, action = handler)
        handler_name <- deparse(substitute(handler))
      }
      updateOptions.environment(handler_env, ...)
      assign("level", namedLevel(level), handler_env)
      assign("formatter", formatter, handler_env)
      removeHandler(handler_name)

      if (with(handler_env, action)(NA, handler_env, dry = TRUE) == TRUE) {
        handlers[[handler_name]] <<- handler_env
      }
    },

    finest = function(...) log(loglevels["FINEST"], ...),
    finer = function(...) log(loglevels["FINER"], ...),
    fine = function(...) log(loglevels["FINE"], ...),
    debug = function(...) log(loglevels["DEBUG"], ...),
    info = function(...) log(loglevels["INFO"], ...),
    warn = function(...) log(loglevels["WARN"], ...),
    error = function(...) log(loglevels["ERROR"], ...)
    ) # methods
  ) # setRefClass
