% File src/R/man/setLevel.Rd
% $Id$

\name{setLevel}
\alias{setLevel}
\alias{setLevel.character}
\alias{setLevel.numeric}
\alias{setLevel.default}
\title{set logging.level for the object}
\description{

  alter an existing logger or handler, setting its logging.level to a
  new value.  you can access loggers by name, while you must use
  getHandler to get hold of a handler.

}
\usage{
setLevel(level, container)
}
\arguments{
  \item{level}{the new level for this object.}
  \item{container}{a logger or a handler.}
}
