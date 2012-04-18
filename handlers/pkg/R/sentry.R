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
## Copyright © 2011, 2012 by Mario Frasca
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
            require(rjson),
            require(digest))))
    stop("sentryAction depends on RCurl, Ruuid, rjson, digest.")

  ## you install Ruuid this way (not with install.packages).
  ## source("http://bioconductor.org/biocLite.R")
  ## biocLite("Ruuid")

  for(k in c("server", "sentry.private.key", "sentry.public.key", "project")) {
    if (!exists(k, envir=conf))
      stop(paste("handler with sentryAction must have a '", k, "' element.\n", sep=""))
  }

  sentry.server <- with(conf, server)
  sentry.private.key <- with(conf, sentry.private.key)
  sentry.public.key <- with(conf, sentry.public.key)
  project <-  with(conf, project)
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

  params <- list("project" = project,
               "event_id" = gsub("-", "", as.character(getuuid())),
               "culprit" = view.name,
               "timestamp" = format(record$timestamp, "%Y-%m-%dT%H:%M:%S"),
               "message" = msg,
               "level" = as.numeric(record$level),
               "logger" = record$logger,
               "server_name" = client.name)

  metadata <- list()
  metadata$call_stack <- paste(lapply(functionCallStack, deparse), collapse=" || ")
  params$extra <- metadata

  repr <- as.character(toJSON(params))

  url <- paste(sentry.server, "api", "store", "", sep="/")

  timestamp <- Sys.time()
  timestampSeconds <- format(timestamp, "%s")
  to.sign <- paste(timestampSeconds, repr, sep=' ')
  signature <- hmac(sentry.private.key, to.sign, "sha1")

  x.sentry.auth.parts <- c(paste("sentry_version", "2.0", sep="="),
                           paste("sentry_signature", signature, sep="="),
                           paste("sentry_timestamp", timestampSeconds, sep="="),
                           paste("sentry_key", sentry.public.key, sep="="),
                           paste("sentry_client", "r-logging.handler", sep="="))
  x.sentry.auth <- paste("Sentry", paste(x.sentry.auth.parts, collapse=", "))
  hdr <- c('Content-Type' = 'application/octet-stream', 'X-Sentry-Auth' = x.sentry.auth)

  httpPOST(url, httpheader = hdr, postfields = toJSON(params), verbose = TRUE)
  
}
