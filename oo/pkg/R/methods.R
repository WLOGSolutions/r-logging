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
## Purpose    : emulate the python standard logging package
##
## Usage      : library(logging)
##
## $Id: logger.R 60 2011-02-02 09:47:04Z mariotomo $
##
## initial programmer :  Mario Frasca
##
## initial date       :  20110211
##

Logger <- setRefClass("Logger",
                      fields=list(
                        name = "character"),
                      methods=list(
                        log = function(...) { levellog(..., logger=name) },

                        setLevel = function(newLevel) { logging::setLevel(newLevel, container=name) },
                        getLevel = function() { logging::getLogger(name)[['level']] },
                        addHandler = function(...) { logging::addHandler(..., logger=name) },

                        finest = function(...) { log(loglevels['FINEST'], ...) },
                        finer = function(...) { log(loglevels['FINER'], ...) },
                        fine = function(...) { log(loglevels['FINE'], ...) },
                        debug = function(...) { log(loglevels['DEBUG'], ...) },
                        info = function(...) { log(loglevels["INFO"], ...) },
                        warn = function(...) { log(loglevels["WARN"], ...) },
                        error = function(...) { log(loglevels["ERROR"], ...) }))
