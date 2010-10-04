#!/usr/bin/Rscript
## unit tests will not be done if RUnit is not available
## $Id$

if(require("RUnit", quietly=TRUE)) {

  ## --- Setup ---

  pkg <- "logging"
  if(Sys.getenv("RCMDCHECK") == "FALSE") {
    ## Path to unit tests for standalone running under Makefile (not R CMD check)
    ## PKG/tests/../inst/RUnit
    path <- file.path(getwd(), "..", "inst", "RUnit")
  } else {
    ## Path to unit tests for R CMD check
    ## PKG.Rcheck/tests/../PKG/RUnit
    path <- system.file(package=pkg, "RUnit")
  }

  opt <- list(standalone=NULL)
  if(require("getopt", quietly=TRUE)) {
    ## path to unit tests may be given on command line, in which case
    ## we also want to move the cwd to this script
    opt <- getopt(matrix(c('standalone', 's', 0, "logical"),
                         ncol=4, byrow=TRUE))
    if(!is.null(opt$standalone)) {
      ## switch the cwd to the dir of this script
      args <- commandArgs()
      script.name <- substring(args[substring(args, 1, 7)=="--file="], 8, 1000)
      if(!is.null(script.name)) {
        setwd(dirname(script.name))
        path <- '../inst/RUnit/'
      }
    }
  }

  print(list(pkg=pkg, getwd=getwd(), pathToUnitTests=path, svnRevision="$Rev: 9122 $"))

  if (is.null(opt$standalone)) {
    cat("\nRunning unit tests of installed library\n")
    library(package=pkg, character.only=TRUE)
  } else {
    cat("\nRunning unit tests of uninstalled library\n")
    source(dir("../R/", pattern=".*\\.R", full.names=TRUE))
  }

  ## If desired, load the name space to allow testing of private functions
  ## if (is.element(pkg, loadedNamespaces()))
  ##     attach(loadNamespace(pkg), name=paste("namespace", pkg, sep=":"), pos=3)
  ##
  ## or simply call PKG:::myPrivateFunction() in tests

  ## --- Testing ---

  ## Define tests
  testSuite <- defineTestSuite(name=paste(pkg, "unit testing"),
                                          dirs=path)
  ## Run
  tests <- runTestSuite(testSuite)

  ## Default report name
  pathReport <- file.path(path, "report")

  ## Report to stdout and text files
  cat("------------------- UNIT TEST SUMMARY ---------------------\n\n")
  printTextProtocol(tests, showDetails=FALSE)
  printTextProtocol(tests, showDetails=FALSE,
                    fileName=paste(pathReport, "Summary.txt", sep=""))
  printTextProtocol(tests, showDetails=TRUE,
                    fileName=paste(pathReport, ".txt", sep=""))

  ## Report to HTML file
  printHTMLProtocol(tests, fileName=paste(pathReport, ".html", sep=""))

  ## Return stop() to cause R CMD check stop in case of
  ##  - failures i.e. FALSE to unit tests or
  ##  - errors i.e. R errors
  tmp <- getErrors(tests)
  if(tmp$nFail > 0 | tmp$nErr > 0) {
    stop(paste("\n\nunit testing failed (#test failures: ", tmp$nFail,
               ", #R errors: ",  tmp$nErr, ")\n\n", sep=""))
  }
} else {
  warning("cannot run unit tests -- package RUnit is not available")
}
