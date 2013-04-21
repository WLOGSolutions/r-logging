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

## TODO: these constants must be exported and documented
loglevels <- c(0, 1, 4, 7, 10, 20, 30, 30, 40, 50, 50)
names(loglevels) <- c('NOTSET', 'FINEST', 'FINER', 'FINE', 'DEBUG', 'INFO', 'WARNING', 'WARN', 'ERROR', 'CRITICAL', 'FATAL')

namedLevel <- function(value)
  UseMethod('namedLevel')

namedLevel.character <- function(value) {
  position <- which(names(loglevels) == value)
  if(length(position) == 1)
    loglevels[position]
}

namedLevel.numeric <- function(value) {
  if(is.null(names(value))) {
    position <- which(loglevels == value)
    if(length(position) == 1)
      value = loglevels[position]
  }
  value
}
