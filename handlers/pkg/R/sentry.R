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
  if (!exists('server', envir=conf))
    stop("handler with sentryAction must have a 'server' element.\n")
  if (!exists('sentry.key', envir=conf))
    stop("handler with sentryAction must have a 'sentry.key' element.\n")
  sentry.server <- with(conf, server)
  sentry.key <- with(conf, sentry.key)

  if(!all(c(require(RCurl),
            require(Ruuid),
            require(rjson))))
    stop("sentryAction depends on RCurl, Ruuid, rjson.")

  ## you install Ruuid this way (not with install.packages).
  ## source("http://bioconductor.org/biocLite.R")
  ## biocLite("Ruuid")

  if(missing(record))
    stop("sentryAction needs to receive the logging record.\n")

  functionCallStack = sys.calls()

  data <- list(level=as.numeric(record$level),
               message=msg,
               view=deparse(functionCallStack[length(functionCallStack) - 4][[1]]),
               message_id=as.character(getuuid()),
               logger=record$logger,
               data=list(sentry=""))
  if (exists('app_name', envir=conf))
    data$server_name <- with(conf, app_name)

  repr <- as.character(base64(toJSON(data)))

  url <- paste(sentry.server, "store", "", sep="/")

  postForm(url, style="POST", format="json", key=sentry.key, data=repr)
}
