% File src/R/man/log.Rd

\name{levellog}
\alias{levellog}
\alias{finest}
\alias{finer}
\alias{fine}
\alias{debug}
\alias{info}
\alias{warn}
\alias{warning}
\alias{error}
\title{entry points for logging actions}
\description{
  generate a log record and pass it to the logging system.

  a log record gets timestamped and will be independently formatted by
  each of the handlers handling it.

}
\usage{
debug(msg, ..., logger='')
info(msg, ..., logger='')
warn(msg, ..., logger='')
error(msg, ..., logger='')

levellog(level, msg, ..., logger='')
}
\arguments{
  \item{msg}{the textual message to be output, or the format for the
    ... arguments}
  \item{...}{if present, msg is interpreted as a format and the
    ... values are passed to it to form the actual message.}
  \item{logger}{the name of the logger to which we pass the record}

  \item{level}{the explicit numeric level of the log record}
}
