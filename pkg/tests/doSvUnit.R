#! /usr/bin/Rscript
require(svUnit)  # Needed if run from R CMD BATCH
require(logging)
pkg <- "logging"
unlink("report.xml")  # Make sure we generate a new report
mypkgSuite <- svSuiteList(pkg, dirs="../../pkg/inst/unitTest")  # List all our test suites
runTest(mypkgSuite, name = pkg)  # Run them...
runTest(makeTestListFromExamples(pkg, "../../pkg/man/"))
protocol(Log(), type = "junit", file = "report.xml")  # ... and write report
results <- table(stats(Log())$kind)
exitCode <- 0
if (results['**ERROR**']) exitCode <- exitCode + 1
if (results['**FAILS**']) exitCode <- exitCode + 2
if (results['DEACTIVATED']) exitCode <- exitCode + 4
quit(status=exitCode)
