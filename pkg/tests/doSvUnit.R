#! /usr/bin/Rscript
require(svUnit)  # Needed if run from R CMD BATCH
require(logging)
pkg <- "logging"
unlink("report.xml")  # Make sure we generate a new report

# Must be ran from within the "tests" subdirectory
base_dir <- system.file(package = 'logging')
stopifnot("unitTest" %in% list.dirs(base_dir, full.names=FALSE, recursive=FALSE))

mypkgSuite <- svSuiteList(pkg, dirs=file.path(base_dir, "unitTest"))  # List all our test suites
runTest(mypkgSuite, name = pkg)  # Run them...

# Examples are not tested properly with svUnit. Commenting it out for now
# src_man_dir <- file.path(base_dir, "..", "man")
# if (dir.exists(src_man_dir)) {
#  runTest(makeTestListFromExamples(pkg, src_man_dir))
# }

protocol(Log(), type = "junit", file = "report.xml")  # ... and write report
results <- table(stats(Log())$kind)
exitCode <- 0
if (results['**ERROR**']) exitCode <- exitCode + 1
if (results['**FAILS**']) exitCode <- exitCode + 2
if (results['DEACTIVATED']) exitCode <- exitCode + 4
results

if (!interactive()) {
  quit(status=exitCode)
}
