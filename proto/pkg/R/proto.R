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
## initial date       :  20110301
##

Logger <- proto(
                new = function(self, name) {
                  self$proto(name = name) },
                log = function(self, ...) {
                  levellog(..., logger = self$name) },
                
                setLevel = function(self, newLevel) {
                  logging::setLevel(newLevel, container = self$name) },
                addHandler = function(self, ...) {
                  logging::addHandler(self, ..., logger = self$name) },
                
                finest = function(self, ...) {
                  self$log(loglevels['FINEST'], ...) },
                finer = function(self, ...) {
                  self$log(loglevels['FINER'], ...) },
                fine = function(self, ...) {
                  self$log(loglevels['FINE'], ...) },
                debug = function(self, ...) {
                  self$log(loglevels['DEBUG'], ...) },
                info = function(self, ...) {
                  self$log(loglevels["INFO"], ...) },
                warn = function(self, ...) {
                  self$log(loglevels["WARN"], ...) },
                error = function(self, ...) {
                  self$log(loglevels["ERROR"], ...) } )
