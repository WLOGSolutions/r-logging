% File man/sentry.Rd
% $Id: getLogger.Rd 11 2010-04-03 18:54:20Z mariotomo $

\name{sentry}
\alias{sentryHandler}
\title{the `sentryHandler` action function}
\description{

  the `sentryHandler` function can be registered as action to a
  handler.  it sends formatted records to a sentry
  server.

}
\details{
  the handler environment needs to contain the URL of the sentry server.
}
\usage{
logger <- Logger$new(name=name)
logger$addHandler(some_name, sentryHandler, server=some_url)
}
\arguments{
  \item{msg}{the formatted record}
  \item{conf}{the handler environment}
  \item{record}{the full unformatted record}
}
\examples{
library(logging)
library(logging.handlers)

basicConfig()

log <- Logger$new(name="")
log$addHandler("sentry", sentryHandler, server="http://sentry.somedomain.com/")

log$debug("not sent, basic is INFO")
log$warn("sent and timestamped")
}
