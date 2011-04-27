% File man/sentry.Rd
% $Id: getLogger.Rd 11 2010-04-03 18:54:20Z mariotomo $

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
sentryAction(msg, conf, record)
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

addHandler("sentry", sentryAction, server="http://sentry.somedomain.com/")

logdebug("not sent, basic is INFO")
logwarn("sent and timestamped")
}
