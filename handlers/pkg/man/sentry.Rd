% File man/sentry.Rd
% $Id$

\name{sentry}
\alias{sentryAction}
\title{the `sentryAction action function}
\description{

  the `sentryAction function can be registered as action to a
  handler.  it sends formatted records to a sentry
  server.

}
\details{
  you do not call this function directly, you register it as action for
  a handler.  the handler environment needs to contain the URL of the
  sentry server.
}
\usage{
sentryAction(msg, conf, record, ...)
}
\arguments{
  \item{msg}{the formatted record}
  \item{conf}{the handler environment}
  \item{record}{the full unformatted record}
  \item{...}{left open for future enhancements}
}
\examples{
library(logging)
library(logging.handlers)

basicConfig()

addHandler("sentry", sentryAction, server="http://sentry.lizardsystem.nl/", sentry.key="ben niet gek")

\dontrun{logdebug("not sent, basic is INFO")}
\dontrun{logwarn("sent and timestamped")}
}
