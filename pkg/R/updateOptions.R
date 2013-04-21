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
## Copyright © 2009-2013 by Mario Frasca
##

## set properties of a logger or a handler
updateOptions <- function(container, ...)
  UseMethod('updateOptions')

updateOptions.character <- function(container, ...) {
  ## container is really just the name of the container
  updateOptions.environment(getLogger(container), ...)
}

updateOptions.environment <- function(container, ...) {
  ## the container is a logger
  config <- list(...);
  if (! 'level' %in% names(config))
    config[['level']] = loglevels['INFO']
  for (key in names(config))
    if(key != "") container[[key]] <- config[[key]]
  invisible()
}
