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
## Purpose    : implement a sentry logging handler
##
## Usage      : library(logging.handlers)
##
## $Id$
##
## initial programmer :  Mario Frasca
##
## initial date       :  20110426
##

sentryAction <- function(msg, conf, record, ...) {
  if(!all(c(require(RCurl),
            require(Ruuid),
            require(rjson))))
    stop("sentryAction depends on RCurl, Ruuid, rjson.")

  if (exists('psk', envir=conf)) {
    if(!require(digest))
      stop("authenticating sentryAction depends on digest.")
  }  

  ## you install Ruuid this way (not with install.packages).
  ## source("http://bioconductor.org/biocLite.R")
  ## biocLite("Ruuid")

  if (!exists('server', envir=conf))
    stop("handler with sentryAction must have a 'server' element.\n")
  if (!exists('sentry.key', envir=conf))
    stop("handler with sentryAction must have a 'sentry.key' element.\n")

  sentry.server <- with(conf, server)
  sentry.key <- with(conf, sentry.key)
  client.name <- tryCatch(with(conf, client.name), error = function(e) "r.logging")

  if(missing(record))  # needed for `level` and `timestamp` fields.
    stop("sentryAction needs to receive the logging record.\n")

  ## `view.name`: the name of the function where the log record was generated.
  functionCallStack <- sys.calls()
  view.name <- tryCatch({
    perpretator.call <- functionCallStack[length(functionCallStack) - 4][[1]]
    perpretator.name <- as.character(perpretator.call)[[1]]
    view.name <- perpretator.name
  }, error = function(e) "<interactive>")

  data <- list("level" = as.numeric(record$level),
               "message" = msg,
               "view" = view.name,
               "message_id" = as.character(getuuid()),
               "logger" = record$logger,
               "server_name" = client.name)

  metadata <- list()
  metadata$call_stack <- paste(lapply(functionCallStack, deparse), collapse=" || ")
  data$data <- metadata

  repr <- as.character(base64(toJSON(data)))

  url <- paste(sentry.server, "store", "", sep="/")

  if (exists('psk', envir=conf)) {
    ## we do not send the sentry.key but we authenticate the message
    ## with a hmac value.

    timestamp <- format(Sys.time(), "%Y-%m-%dT%X")
    to.sign <- paste(timestamp, repr, sep=' ')
    authentication <- hmac(with(conf, psk), to.sign, "SHA1")

    postForm(url, style="POST", format="json", key=sentry.key, data=repr, authentication=authentication)
  } else {
    postForm(url, style="POST", format="json", key=sentry.key, data=repr)
  }
}
