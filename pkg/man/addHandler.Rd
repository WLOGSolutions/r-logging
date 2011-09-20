% File src/R/man/addHandler.Rd
% $Id$

\name{addHandler}
\alias{addHandler}
\alias{removeHandler}
\description{
  
  use these functions to maintain the list of handlers attached to a logger.
  
}
\title{add a handler to or remove one from a logger}
\details{

  \dots may contain extra parameters that will be passed to the handler
  action.  some elements in the \dots will be interpreted here.

  a handler has a \var{name} and at least the three fields:
  \describe{
    \item{level}{all records at level lower than this are skipped.}
    \item{formatter}{a function getting a record and returning a string}
    \item{action(msg, handler)}{a function accepting two parameters: a
  formatted log record and the handler itself.}}

  further a handler may have as many fields as you think you need.  keep
  in mind the handler (and all of its fields) are passed to the action
  function.
}
\usage{
addHandler(handler, ..., logger = "")
removeHandler(handler, logger='')
}
\arguments{
  \item{handler}{the name of the handler, or its action}
  \item{...}{extra parameters for the action, to be stored in the handler list}
  \item{logger}{the name of the logger to which to attach the new
    handler, defaults to the root logger}
}
\examples{
logReset()
addHandler(writeToConsole)
names(getLogger()[['handlers']])
loginfo('test')
removeHandler('writeToConsole')
logwarn('test')
}