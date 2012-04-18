% File src/R/man/addHandler.Rd
% $Id$

\name{addHandler}
\alias{addHandler}
\alias{removeHandler}
\description{
  
  use these functions to maintain the list of handlers attached to a
  logger.

  addHandler and removeHandler are also offered as methods of the
  \var{Logger} S4 class. in that case there is no \var{logger} argument.
  
}
\title{add a handler to or remove one from a logger}
\usage{
addHandler(handler, ..., logger = "")
removeHandler(handler, logger='')
}
\arguments{
  \item{handler}{the name of the handler, or its action}
  \item{...}{extra parameters for the action, to be stored in the handler list}
  \item{logger}{character parameter for the functional form: the name of
    the logger to which to attach the new handler, defaults to the root
    logger}
}
\details{

  \dots may contain extra parameters that will be passed to the handler
  action.  some elements in the \dots will be interpreted here.

  handler are implemented as environments. within a logger a handler is
  identified by its \var{name} and all handlers define at least the
  three variables:
  \describe{
    \item{level}{all records at level lower than this are skipped.}
    \item{formatter}{a function getting a record and returning a string}
    \item{action(msg, handler)}{a function accepting two parameters: a
  formatted log record and the handler itself. making the handler a
  parameter of the action allows us to have reusable action functions.}}

  being an environment, a handler may define as many variables as you
  think you need.  keep in mind the handler is passed to the action
  function, which can check for existence and can use all variables that
  the handler defines.
  
}
\examples{
logReset()
addHandler(writeToConsole)
names(getLogger()[['handlers']])
loginfo('test')
removeHandler('writeToConsole')
logwarn('test')
}