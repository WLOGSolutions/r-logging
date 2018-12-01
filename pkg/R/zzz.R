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

#' @import methods
NULL

#' A tentative logging package.
#'
#' @description
#' A logging package emulating the Python logging package.
#'
#' @description
#' What you find here behaves similarly to what you also find in Python.
#' This includes hierarchic loggers, multiple handlers at each logger,
#' the possibility to specify a formatter for each handler (one default
#' formatter is given), same levels (names and numeric values) as Python's
#' logging package, a simple logging.BasicConfig function to quickly put
#' yourself in a usable situation...
#'
#' This package owes a lot to my employer, r-forge, the stackoverflow community,
#' Brian Lee Yung Rowe's futile package (v1.1) and the documentation of
#' the Python logging package.
#'
#' @details
#' Index:
#' \describe{
#' \item{\code{basicConfig}}{bootstrapping the logging package}
#' \item{\code{addHandler}}{add a handler to a logger}
#' \item{\code{getLogger}}{set defaults and get current values for a logger}
#' \item{\code{removeHandler}}{remove a handler from a logger}
#' \item{\code{setLevel}}{set logging.level for a logger}
#' }
#'
#' To use this package, include logging instructions in your code, possibly
#' like this:
#'
#' \code{library(logging)}\cr
#' \code{basicConfig()}\cr
#' \code{addHandler(writeToFile, logger="company", file="sample.log")}\cr
#' \code{loginfo("hello world", logger="")}\cr
#' \code{logwarn("hello company", logger="company.module")}
#'
#' The \code{basicConfig} function adds a console handler to the root logger,
#' while the explicitly called \code{addHandler} adds a file handler to the
#' 'company' logger. the effect of the above example is two lines on the
#' console and just one line in the \code{sample.log} file.
#'
#' The web pages for this package on r-forge are kept decently up to date
#' and contain a usable tutorial. Check the references.
#'
#' @references
#' the python logging module: \url{http://docs.python.org/library/logging.html}\cr
#' this package at github: \url{https://github.com/WLOGSolutions/r-logging/}
#'
#' @docType package
#' @name logging-package
#' @keywords package
NULL

## create the logging environment
logging.options <- new.env()

## initialize the module
logReset()
