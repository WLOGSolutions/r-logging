% File src/R/man/basicConfig.Rd

\name{basicConfig}
\alias{basicConfig}
\title{bootstrapping the logging package}
\description{

  create the root logger, attach it a console handler, set both at
  logging.level INFO.

}
\usage{
basicConfig()
}
\examples{
library(logging)
basicConfig()
debug("not shown, basic is INFO")
warn("shown and timestamped")
}