library(testthat)
library(logging)

context("Testing handlers management [test.handlers]")

test_that("looksForHandlersInRootLogger", {
  logReset()
  basicConfig()

  expect_identical(getHandler('basic.stdout'), getLogger()[['handlers']][[1]])
})

test_that("lookingForHandlersInObject", {
  logReset()
  basicConfig()

  expect_identical(getLogger()$getHandler('basic.stdout'), getLogger()[['handlers']][[1]])
})

test_that("addingANewHandler", {
  logReset()
  basicConfig()

  addHandler(writeToConsole)

  expect_equal(length(with(getLogger(), names(handlers))), 2)
  expect_true('writeToConsole' %in% with(getLogger(), names(handlers)))
})

test_that("removingOneHandlerByName", {
  logReset()
  basicConfig()

  addHandler(writeToConsole)
  removeHandler('writeToConsole')

  expect_equal(length(with(getLogger(), names(handlers))), 1)
  expect_false('writeToConsole' %in% with(getLogger(), names(handlers)))
})


test.fileName <- file.path(tempdir(), c('1', '2', '3'))
teardown({
  unlink(test.fileName, force = TRUE)
})

test_that("loggingToFile", {
  logReset()
  unlink(test.fileName, force = TRUE)

  getLogger()$setLevel('FINEST')
  addHandler(writeToFile, file=test.fileName[[1]], level='DEBUG')

  expect_equal(with(getLogger(), names(handlers)), c("writeToFile"))

  loginfo('test %d', 1)
  logdebug('test %d', 2)
  logwarn('test %d', 3)
  logfinest('test %d', 4)
})

test_that("loggingToFile.oo", {
  logReset()
  unlink(test.fileName, force = TRUE)

  log <- getLogger()
  log$setLevel('FINEST')
  log$addHandler(writeToFile, file=test.fileName[[1]], level='DEBUG')

  expect_equal(with(log, names(handlers)), c("writeToFile"))

  log$info('test %d', 1)
  log$debug('test %d', 2)
  log$warn('test %d', 3)
  log$finest('test %d', 4)
})
