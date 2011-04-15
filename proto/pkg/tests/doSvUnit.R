#! /usr/bin/Rscript
require(svUnit)  # Needed if run from R CMD BATCH
require(logging)
unlink("report.xml")  # Make sure we generate a new report
mypkgSuite <- svSuiteList("logging", dirs="../../pkg/inst/unitTest")  # List all our test suites
runTest(mypkgSuite, name = "logging")  # Run them...
protocol(Log(), type = "junit", file = "report.xml")  # ... and write report
