% File src/R/man/log.Rd
% $Id$

\name{loginfo}
\alias{logfinest}
\alias{logfiner}
\alias{logfine}
\alias{logdebug}
\alias{loginfo}
\alias{logwarn}
\alias{logwarning}
\alias{logerror}
\title{entry points for logging actions}
\description{
  generate a log record and pass it to the logging system.

  a log record gets timestamped and will be independently formatted by
  each of the handlers handling it.

  leading and trailing whitespace is stripped from the final message.

}
\usage{
logdebug(msg, ..., logger='')
loginfo(msg, ..., logger='')
logwarn(msg, ..., logger='')
logerror(msg, ..., logger='')
}
\arguments{
  \item{msg}{if character, the textual message to be output,
    or the format for the ... arguments; if of any other
    type, will be output as is prefixed by the expression
    that was used for the function call}
  \item{...}{if present, and msg is ofcharacter, msg is
    interpreted as a format and the \code{...} values are
    passed to it to form the actual message; if msg is any
    other type, all \code{...} values are output the same
    way like \code{msg}}
  \item{logger}{the name of the logger to which we pass the
    record}
}
\examples{
logReset()
addHandler(writeToConsole)
loginfo('this goes to console')
logdebug('this stays silent')
loginfo(3 + 5, 2 * 3)
}
