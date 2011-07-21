% File src/R/man/getLogger.Rd
% $Id: getLogger.Rd 11 2010-04-03 18:54:20Z mariotomo $

\name{Logger}
\alias{Logger}
\alias{getLogger}
\alias{\S4method{new}{Logger}}
\alias{\S4method{log}{Logger}}
\alias{\S4method{setLevel}{Logger}}
\alias{\S4method{getLevel}{Logger}}
\alias{\S4method{addHandler}{Logger}}
\alias{\S4method{finest}{Logger}}
\alias{\S4method{finer}{Logger}}
\alias{\S4method{fine}{Logger}}
\alias{\S4method{debug}{Logger}}
\alias{\S4method{info}{Logger}}
\alias{\S4method{warn}{Logger}}
\alias{\S4method{error}{Logger}}
\title{the `Logger` reference class}
\description{

  Logger is a quick and dirty adoption of the reference class paradigm.

}
\usage{
\S4method{new}{Logger}(name)
getLogger(name="")
\S4method{log}{Logger}(...)
\S4method{setLevel}{Logger}(newLevel)
\S4method{getLevel}{Logger}()
\S4method{addHandler}{Logger}(...)
\S4method{finest}{Logger}(...)
\S4method{finer}{Logger}(...)
\S4method{fine}{Logger}(...)
\S4method{debug}{Logger}(...)
\S4method{info}{Logger}(...)
\S4method{warn}{Logger}(...)
\S4method{error}{Logger}(...)
}
\arguments{
  \item{name}{the name of the logger being created.}
  \item{newLevel}{the new logging level of this logger.}
  \item{\dots}{any extra arguments are passed further.}
}
\examples{
basicConfig()

log <- Logger$new(name="")

log$debug("not shown, basic is INFO")
log$warn("shown and timestamped")
}