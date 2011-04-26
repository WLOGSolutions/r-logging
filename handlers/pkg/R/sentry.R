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
## $Id: logger.R 60 2011-02-02 09:47:04Z mariotomo $
##
## initial programmer :  Mario Frasca
##
## initial date       :  20110426
##

sentryAction <- function(msg, conf, record) {
  if (!exists('server', envir=conf))
    stop("handler with sentryAction must have a 'server' element.\n")

  stopifnot(require(RCurl),
            require(rjson))

  if(missing(record))
    stop("sentryAction needs to receive the logging record.\n")

  ## source("http://bioconductor.org/biocLite.R")
  ## biocLite("Ruuid")

  functionCallStack = sys.calls()
  data <- list(timestamp=record$timestamp,
               level=record$level,
               message=msg,
               view=deparse(functionCallStack[length(functionCallStack) - 1][[1]]),
               message_id=as.character(getuuid()),
               logger_name=record$logger
               metadata=list())
  repr <- as.character(base64(toJSON(data)))

  
}
