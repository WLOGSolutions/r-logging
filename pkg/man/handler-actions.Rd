% File src/R/man/logging.handler-actions.Rd
% $Id$

\name{handler-actions}
\alias{handler-actions}
\alias{writeToFile}
\alias{writeToConsole}
\title{predefined handler actions}
\description{
  
  when you define a handler, you specify its name and the associated
  action.  a few predefined actions are provided and this page documents
  them.  

}
\usage{
writeToFile(msg, handler, ...)
writeToConsole(msg, handler, ...)
}
\arguments{
  \item{msg}{the final formatted message to be output}
  \item{handler}{the handler owning this action}
  \item{...}{placeholder: accept any extra future parameter.}
}
\details{

  a handler action is a function taking two parameters: the formatted
  log record and the handler to which the action is associated.  the
  second parameter is useful so you can register the same handler action
  to handlers with different properties.

}
\examples{
## define your own function and register it with a handler.
## author is planning a sentry client function.  please send 
## any interesting function you may have written!
}