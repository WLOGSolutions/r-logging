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
#' Changes settings of logger or handler.
#'
#' @param container a logger, its name or a handler.
#' @param ... options to set for the container.
#'
#' @export
#'
updateOptions <- function(container, ...)
  UseMethod('updateOptions')

#' @describeIn updateOptions Update options for logger identified
#'   by name.
#' @export
#'
updateOptions.character <- function(container, ...) {
  ## container is really just the name of the container
  updateOptions.environment(getLogger(container), ...)
}

#' @describeIn updateOptions Update options of logger or handler
#'   passed by reference.
#' @export
#'
updateOptions.environment <- function(container, ...) {
  ## the container is a logger
  config <- list(...);
  if (! ("level" %in% names(config)) ) {
    config$level <- loglevels['INFO']
  }

  for (key in names(config)) {
    if(key != "") {
      container[[key]] <- config[[key]]
    }
  }
  invisible()
}
