library(testthat)
library(logging)

context("Testing handlers management [test.handlers]")

test_that("looksForHandlersInRootLogger", {
  logReset()
  basicConfig()

  expect_identical(getHandler("basic.stdout"),
                   getLogger()[["handlers"]][[1]])
})

test_that("lookingForHandlersInObject", {
  logReset()
  basicConfig()

  expect_identical(getLogger()$getHandler("basic.stdout"),
                   getLogger()[["handlers"]][[1]])
})

test_that("addingANewHandler", {
  logReset()
  basicConfig()

  addHandler(writeToConsole)

  expect_equal(length(with(getLogger(), names(handlers))), 2)
  expect_true("writeToConsole" %in% with(getLogger(), names(handlers)))
})

test_that("gettingHandler", {
  logReset()
  basicConfig()

  addHandler(writeToConsole)

  expect_true(!is.null(getHandler("writeToConsole")))
  expect_true(!is.null(getHandler(writeToConsole)))
})

test_that("gettingHandler/oo", {
  logReset()
  basicConfig()

  log <- getLogger("testLogger")
  log$addHandler(writeToConsole)

  expect_true(!is.null(log$getHandler("writeToConsole")))
  expect_true(!is.null(log$getHandler(writeToConsole)))
})

test_that("removingOneHandlerByName", {
  logReset()
  basicConfig()

  addHandler(writeToConsole)
  removeHandler("writeToConsole")

  expect_equal(length(with(getLogger(), names(handlers))), 1)
  expect_false("writeToConsole" %in% with(getLogger(), names(handlers)))
})

test_that("removingOneHandlerByAction", {
  logReset()
  basicConfig()

  addHandler(writeToConsole)

  expect_equal(length(with(getLogger(), names(handlers))), 2)

  removeHandler(writeToConsole)

  expect_equal(length(with(getLogger(), names(handlers))), 1)
  expect_false("writeToConsole" %in% with(getLogger(), names(handlers)))
})

test_that("removingOneHandlerByAction/oo", {
  logReset()
  basicConfig()

  log <- getLogger("testLogger")
  log$addHandler(writeToConsole)

  expect_equal(length(with(log, names(handlers))), 1)

  log$removeHandler(writeToConsole)

  expect_equal(length(with(log, names(handlers))), 0)
  expect_false("writeToConsole" %in% with(log, names(handlers)))
})

test_that("setLevel verifies if container is not NULL", {
  logReset()
  basicConfig()

  expect_error(setLevel("INFO", NULL),
               "NULL container provided: cannot set level for NULL container",
               fixed = TRUE)
})

test_that("addHandler verifies if action provided", {
  logReset()
  basicConfig()

  expect_error(addHandler("handlerName"),
               "No action for the handler provided",
               fixed = TRUE)
})

test_that("setLevel verifies level value", {
  logReset()
  setLevel(150) # invalid level

  expect_equal(getLogger()$getLevel(), loglevels["NOTSET"])

  logReset()
  setLevel(TRUE) # invalid level

  expect_equal(getLogger()$getLevel(), loglevels["NOTSET"])

  logReset()
  setLevel("INVALID") # invalid level

  expect_equal(getLogger()$getLevel(), loglevels["NOTSET"])
})


test_that("setLevel verifies level value/oo", {
  logReset()
  log <- getLogger("testLogger")

  log$setLevel(150) # invalid level

  expect_equal(log$getLevel(), loglevels["NOTSET"])


  log$setLevel(TRUE) # invalid level

  expect_equal(log$getLevel(), loglevels["NOTSET"])


  log$setLevel("INVALID") # invalid level

  expect_equal(log$getLevel(), loglevels["NOTSET"])
})


test_that("setting level with updateOptions", {
  logReset()
  basicConfig()

  updateOptions("", level = "WARN")

  expect_equal(getLogger()$getLevel(), loglevels["WARN"])
})


test_file_name <- file.path(tempdir(), c("1", "2", "3"))
teardown({
  unlink(test_file_name, force = TRUE)
})

test_that("loggingToConsole", {
  logReset()
  basicConfig()

  logdebug("test %d", 2)
  loginfo("test %d", 2)

  succeed()
})

test_that("loggingToFile", {
  logReset()
  unlink(test_file_name, force = TRUE)

  getLogger()$setLevel("FINEST")
  addHandler(writeToFile, file = test_file_name[[1]], level = "DEBUG")

  expect_equal(with(getLogger(), names(handlers)), c("writeToFile"))

  logerror("test %d", 1)
  logwarn("test %d", 3)
  loginfo("test %d", 1)
  logdebug("test %d", 2)
  logfinest("test %d", 4)
  logfiner("test %d", 4)
  logfine("test %d", 4)

  succeed()
})

test_that("loggingToFile.oo", {
  logReset()
  unlink(test_file_name, force = TRUE)

  log <- getLogger()
  log$setLevel("FINEST")
  log$addHandler(writeToFile, file = test_file_name[[1]], level = "DEBUG")

  expect_equal(with(log, names(handlers)), c("writeToFile"))

  log$error("test %d", 1)
  log$warn("test %d", 3)
  log$info("test %d", 1)
  log$debug("test %d", 2)
  log$finest("test %d", 4)
  log$finer("test %d", 4)
  log$fine("test %d", 4)

  succeed()
})
