% File src/R/man/getHandler.Rd
% $Id$

\name{getHandler}
\alias{getHandler}
\alias{getHandler.character}
\alias{getHandler.default}
\title{retrieves a handler from a logger.}
\description{

  handlers are not uniquely identified by their name.  only within the
  logger to which they are attached is their name unique.  this function
  is here to allow you grab a handler from a logger so you can examine
  and alter it.

  typical use of this function is in setLevel(newLevel, getHandler(...)).

}
\usage{
getHandler(handler, logger='')
}
\arguments{
  \item{handler}{the name of the handler, or its action.}
  \item{logger}{optional: the name of the logger.  defaults to the root logger.}
}
\examples{
logReset()
addHandler(writeToConsole)
getHandler('writeToConsole')
}