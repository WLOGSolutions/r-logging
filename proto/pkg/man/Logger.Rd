% File src/R/man/getLogger.Rd
% $Id: getLogger.Rd 11 2010-04-03 18:54:20Z mariotomo $

\name{Logger}
\alias{Logger}
\title{the `Logger` reference class}
\description{

  Logger is a quick and dirty adoption of the proto class paradigm.

}
\usage{
logger <- Logger$new(name=name)
}
\arguments{
  \item{name}{the name of the logger}
}
\examples{
basicConfig()

log <- Logger$new(name="")

log$debug("not shown, basic is INFO")
log$warn("shown and timestamped")
}