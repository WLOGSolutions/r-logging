library(testthat)
library(logging)

context("Testing data interactions [test.data.interaction]")

test_that("000/getLoggerWithoutInitializingDoesNotCrash", {
  root_logger <- getLogger("")

  succeed()
})

test_that("001/defaultLoggingLevelIsINFO", {
  basicConfig()

  root_logger <- getLogger("")
  expect <- logging:::loglevels["INFO"]

  expect_equal(root_logger[["level"]], expect)
})

test_that("002/canInitializeTwice", {
  basicConfig()

  basicConfig()
  root_logger <- getLogger("")
  expect <- logging:::loglevels["INFO"]

  expect_equal(root_logger[["level"]], expect)
})

test_that("003/sameNameMeansSameObject", {
  basicConfig()

  root1 <- getLogger("abc")
  root2 <- getLogger("abc")

  expect_identical(root1, root2)
})

test_that("004/noNameMeansRoot", {
  root_logger1 <- getLogger("")
  root_logger2 <- getLogger()

  expect_identical(root_logger1, root_logger2)
})

test_that("500.basicConfigSetsLevelOfHandler", {
  logReset()
  basicConfig("DEBUG")

  root_logger <- getLogger("")
  expect <- logging:::loglevels["NOTSET"]
  current <- root_logger$getHandler("basic.stdout")[["level"]]

  expect_equal(current, expect)

  logReset()
  basicConfig("ERROR")
  root_logger <- getLogger("")  ## needed: `logReset` unlinked the old one
  expect <- logging:::loglevels["NOTSET"]
  current <- root_logger$getHandler("basic.stdout")[["level"]]

  expect_equal(current, expect)
})


test_that("canFindLoggingLevels", {
  expect_equal(logging:::loglevels[["NOTSET"]], 0)
  expect_equal(logging:::loglevels[["DEBUG"]], 10)
  expect_equal(logging:::loglevels[["INFO"]], 20)
  expect_equal(logging:::loglevels[["WARN"]], 30)
  expect_equal(logging:::loglevels[["ERROR"]], 40)
  expect_equal(logging:::loglevels[["FATAL"]], 50)
})

test_that("fineLevelsAreOrdered", {
  expect_true(logging:::loglevels[["FINEST"]] < logging:::loglevels[["FINER"]])
  expect_true(logging:::loglevels[["FINER"]] < logging:::loglevels[["FINE"]])
  expect_true(logging:::loglevels[["FINE"]] < logging:::loglevels[["DEBUG"]])
})

test_that("canSetLoggerLevelByNamedValue", {
  logReset()
  basicConfig()

  setLevel(logging:::loglevels["DEBUG"], "")

  root_logger <- getLogger("")
  expect <- logging:::loglevels["DEBUG"]
  expect_equal(root_logger[["level"]], expect)
})

test_that("canSetLoggerLevelByName", {
  logReset()
  basicConfig()

  setLevel("DEBUG", "")

  root_logger <- getLogger("")
  expect <- logging:::loglevels["DEBUG"]
  expect_equal(root_logger[["level"]], expect)
})



test_setup <- function(...) {
  test_env <- new.env(parent = emptyenv())
  test_env$logged <- NULL

  mock_action <- function(msg, handler, ...) {
    if (length(list(...)) && "dry" %in% names(list(...)))
      return(TRUE)
    test_env$logged <- c(test_env$logged, msg)
  }
  mock_formatter <- function(record) {
    msg <- trimws(record$msg)
    paste(record$levelname, record$logger, msg, sep = ":")
  }

  logReset()
  addHandler(mock_action, formatter = mock_formatter, ...)

  return(test_env)
}


test_that("recordIsEmitted/rootToRoot", {
  env <- test_setup()

  logfinest("test")
  logfiner("test")
  logfine("test")
  logdebug("test")
  loginfo("test")
  logerror("test")

  expect_equal(length(env$logged), 2)
})

test_that("recordIsEmitted/tooDeep", {
  env <- test_setup(logger = "too.deep")

  logfinest("test")
  logfiner("test")
  logfine("test")
  logdebug("test")
  loginfo("test")
  logerror("test")

  expect_equal(length(env$logged), 0)
})

test_that("recordIsEmitted/unrelated", {
  env <- test_setup(logger = "too.deep")

  logdebug("test", logger = "other.branch")
  loginfo("test", logger = "other.branch")
  logerror("test", logger = "other.branch")

  expect_equal(length(env$logged), 0)
})

test_that("recordIsEmitted/deepToRoot", {
  env <- test_setup(logger = "")

  logdebug("test", logger = "other.branch")
  loginfo("test", logger = "other.branch")
  logerror("test", logger = "other.branch")

  expect_equal(length(env$logged), 2)
})

test_that("recordIsEmitted/deepToRoot.DI.dropped", {
  env <- test_setup(level = "DEBUG", logger = "")

  setLevel("INFO", "other.branch")
  logdebug("test", logger = "other.branch")
  loginfo("test", logger = "other.branch")
  logerror("test", logger = "other.branch")

  expect_equal(length(env$logged), 2)
})

test_that("recordIsEmitted/deepToRoot.DD.passed", {
  env <- test_setup(level = "DEBUG", logger = "")

  setLevel("DEBUG", "other.branch")
  setLevel("DEBUG", "")
  logdebug("test", logger = "other.branch")
  loginfo("test", logger = "other.branch")
  logerror("test", logger = "other.branch")

  expect_equal(length(env$logged), 3)
})


test_that("formattingRecord/lengthZero", {
  env <- test_setup(level = "DEBUG", logger = "")

  loginfo("test '%s'", numeric(0))

  expect_equal(env$logged, "INFO::test ''")
})

test_that("formattingRecord/lengthOne", {
  env <- test_setup(level = "DEBUG", logger = "")

  loginfo("test '%s'", 12)

  expect_equal(env$logged, "INFO::test '12'")
})

test_that("formattingRecord/lengthMore", {
  env <- test_setup(level = "DEBUG", logger = "")

  loginfo("test '%s'", c(0, 1, 2))

  expect_equal(env$logged, "INFO::test '0,1,2'")
})

test_that("formattingRecord/moreArguments", {
  env <- test_setup(level = "DEBUG", logger = "")

  loginfo("%s: %d", "name", 123)

  expect_equal(env$logged, "INFO::name: 123")


  env$logged <- NULL

  loginfo("%s: %0.2f", "name", 123.0)

  expect_equal(env$logged, "INFO::name: 123.00")
})

test_that("formattingRecord/moreArguments.lengthMore", {
  env <- test_setup(level = "DEBUG", logger = "")

  loginfo("%s '%s'", "name", c(0, 1, 2))

  expect_equal(env$logged, "INFO::name '0,1,2'")
})

test_that("formattingRecord/strips.whitespace", {
  env <- test_setup(level = "DEBUG", logger = "")

  loginfo("a string with trailing whitespace \n")

  expect_equal(env$logged, "INFO::a string with trailing whitespace")


  env$logged <- NULL

  loginfo("  this string has also leading whitespace   ")

  expect_equal(env$logged, "INFO::this string has also leading whitespace")
})
