library(testthat)
library(logging)

context("Testing loglevel inheritance [test.level-inheritance]")

test_setup <- function() {
  test_env <- new.env(parent = emptyenv())
  test_env$logged <- NULL

  mock_action <- function(msg, handler, ...) {
    if (length(list(...)) && "dry" %in% names(list(...)))
      return(TRUE)
    test_env$logged <- c(test_env$logged, msg)
  }
  mock_formatter <- function(record) {
    paste(record$levelname, record$logger, record$msg, sep = ":")
  }

  logReset()
  addHandler(mock_action,
             formatter = mock_formatter)

  test_env$mock_action <- mock_action
  return(test_env)
}

test_that("leveliherit/sublogger_default_to_inherit_parent_level", {
  env <- test_setup()

  loginfo("test", logger = "named")
  logdebug("test", logger = "named")

  expect_equal(env$logged, "INFO:named:test")
  env$logged <- c()

  setLevel("DEBUG")
  loginfo("test", logger = "named")
  logdebug("test", logger = "named")

  expect_equal(env$logged, c("INFO:named:test", "DEBUG:named:test"))
})

test_that("leveliherit/sublogger_enforced_level_used", {
  env <- test_setup()

  setLevel("DEBUG")
  setLevel("INFO", container = "named")
  loginfo("test", logger = "named")
  logdebug("test", logger = "named")

  expect_equal(env$logged, c("INFO:named:test"))
})

test_that("leveliherit/handler_default_to_inherit_parent_level", {
  env <- test_setup()

  mock_action2 <- env$mock_action
  addHandler(mock_action2, formatter = function(record) {
    paste(record$levelname, record$logger, record$msg, sep = "|")
  }, logger = "named")

  loginfo("test", logger = "named")
  logdebug("test", logger = "named")

  expect_equal(env$logged, c("INFO|named|test", "INFO:named:test"))
  env$logged <- c()

  setLevel("DEBUG")
  loginfo("test", logger = "named")
  logdebug("test", logger = "named")

  expect_equal(env$logged, c("INFO|named|test", "INFO:named:test",
                             "DEBUG|named|test", "DEBUG:named:test"))
})

test_that("leveliherit/handler_inherit_enforced_sublogger_level", {
  env <- test_setup()

  setLevel("DEBUG")
  setLevel("INFO", container = "named")

  mock_action2 <- env$mock_action
  addHandler(mock_action2, formatter = function(record) {
    paste(record$levelname, record$logger, record$msg, sep = "|")
  }, logger = "named")

  loginfo("test", logger = "named")
  logdebug("test", logger = "named")

  expect_equal(env$logged, c("INFO|named|test", "INFO:named:test"))
  env$logged <- c()

  setLevel("INFO")
  setLevel("DEBUG", container = "named")

  logdebug("test", logger = "named")

  expect_equal(env$logged, c("DEBUG|named|test"))
})

test_that("leveliherit/handler_enforced_level_used", {
  env <- test_setup()

  setLevel("DEBUG")

  mock_action2 <- env$mock_action
  addHandler(mock_action2, formatter = function(record) {
    paste(record$levelname, record$logger, record$msg, sep = "|")
  }, logger = "named", level = "INFO")

  loginfo("test", logger = "named")
  logdebug("test", logger = "named")

  expect_equal(env$logged, c("INFO|named|test", "INFO:named:test", "DEBUG:named:test"))
})
