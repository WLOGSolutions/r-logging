% File src/R/man/logging-package.Rd
% $Id$

\name{logging-package}
\Rdversion{1.1}
\alias{logging-package}
\alias{logging}
\docType{package}
\title{
a tentative logging package
}
\description{
  a logging package emulating the python logging package.

  What you find here behaves similarly to what you also find in Python.
  This includes hierarchic loggers, multiple handlers at each logger,
  the possibility to specify a formatter for each handler (one default
  formatter is given), same levels (names and numeric values) as
  Python's logging package, a simple logging.BasicConfig function to
  quickly put yourself in a usable situation...

  This package owes a lot to Brian Lee Yung Rowe's
  \code{\link[futile:futile-package]{futile}} package and the
  documentation of the Python logging package.

}
\details{
\tabular{ll}{
Package: \tab logging\cr
Version: \tab 0.2-9108\cr
Date: \tab 2010-01-14\cr
License: \tab GPL (>=2)\cr
Depends: \tab R (>= 2.9.2)\cr
Built: \tab R 2.9.2; ; 2010-01-27 12:24:58 UTC; unix\cr
}

Index:
\preformatted{
basicConfig                 bootstrapping the logging package

addHandler                  add a handler to a logger
getLogger                   set defaults and get current values for a logger
removeHandler               remove a handler from a logger
setLevel                    set logging.level for a logger
}

to use this package, include logging instructions in your code, possibly
like this:
\preformatted{
  logging::basicConfig()
  logging::addHandler(logging::writeToFile, name="company", file="sample.log")
  logging::info("hello world", logger="")
  logging::warn("hello company", logger="company.module")
}

the \code{basicConfig} function adds a console handler to the root
logger, while the explicitly called \code{addHandler} adds a file
handler to the 'company' logger.  the effect of the above example is two
lines on the console and just one line in the \code{sample.log} file.

}
\author{
  Mario Frasca <mariotomo@gmail.com>

Maintainer: Mario Frasca <mario.frasca@nelen-schuurmans.nl>
}
\references{
the python logging module, at http://docs.python.org/library/logging.html
}
\keyword{ package }
\seealso{
  \code{\link[logging @ r-forge]{http://logging.r-forge.r-project.org/}}
  
  \code{\link[futile:futile-package]{http://cran.r-project.org/web/packages/futile/index.html}}
}
