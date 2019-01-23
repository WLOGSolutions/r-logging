library(testthat)
library(logging)

context("Testing formatting of mess and exprs [test.automatic-format]")

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
             level = "DEBUG",
             formatter = mock_formatter)

  return(test_env)
}

## test functions

test_that("autoformat/one_numeric_literal", {
  env <- test_setup()

  loginfo(12)

  expect_equal(env$logged, "INFO::12: 12")
})

test_that("autoformat/more_numeric_literals", {
  env <- test_setup()

  loginfo(12, 1 + 1, 2 * 2)

  expect_equal(env$logged,
               c("INFO::12: 12", "INFO::1 + 1: 2", "INFO::2 * 2: 4"))
})

test_that("autoformat/one_numeric_variable", {
  env <- test_setup()

  a <- 1
  loginfo(a)

  expect_equal(env$logged, "INFO::a: 1")
})

test_that("autoformat/one_numeric_expression", {
  env <- test_setup()

  loginfo(3 + 5)

  expect_equal(env$logged, "INFO::3 + 5: 8")
})

test_that("autoformat/explicit_msg_parameter", {
  env <- test_setup()

  loginfo(logger = getLogger(), msg = 3 + 5)

  expect_equal(env$logged, "INFO::3 + 5: 8")
})

test_that("autoformat/shifted_msg_parameter", {
  env <- test_setup()

  loginfo(logger = getLogger(), 3 + 5)

  expect_equal(env$logged, "INFO::3 + 5: 8")
})

test_that("autoformat/levellog", {
  env <- test_setup()

  levellog("INFO", 3 + 5)

  expect_equal(env$logged, "INFO::3 + 5: 8")
})
