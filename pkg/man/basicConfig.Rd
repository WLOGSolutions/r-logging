% File src/R/man/basicConfig.Rd
% $Id$

\name{basicConfig}
\alias{basicConfig}
\alias{logReset}
\title{bootstrapping the logging package}
\description{

  'basicConfig' and 'logReset' provide a way to put the logging package
  in a know initial state.
}
\details{
  \describe{
    
    \item{basicConfig}{creates the root logger, attaches a console
      handler to it and sets the level of the handler to logging.level
      INFO.  the level of the logger can be passed as a parameter to the
      function.}

    \item{logReset}{reinitializes the whole logging system as if the
      package had just been loaded.  typically, you would want to call
      basicConfig immediately after a call to logReset.}
    
  }  
}
\usage{
basicConfig(level)
logReset()
}
\arguments{
  \item{level}{the logging level of the root logger.  defaults to INFO.
  please do notice that this has no effect on the handling level of the
  handler that basicConfig attaches to the root logger.}
  }
\examples{
library(logging)
basicConfig()
logdebug("not shown, basic is INFO")
logwarn("shown and timestamped")
logReset()
logwarn("not shown, as no handlers are present after a reset")
}