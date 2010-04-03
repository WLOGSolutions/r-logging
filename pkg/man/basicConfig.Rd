% File src/R/man/basicConfig.Rd
% $Id$

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
logdebug("not shown, basic is INFO")
logwarn("shown and timestamped")
}