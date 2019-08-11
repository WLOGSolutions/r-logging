library(testthat)
library(logging)

context("Testing message composer functionality [test.msg-composer]")

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

  return(test_env)
}

## test functions

test_that("msgcomposer/basic_funcionality", {
  env <- test_setup()

  setMsgComposer(function(msg, ...) { paste(msg, "comp") })
  loginfo("test")

  expect_equal(env$logged, "INFO::test comp")
})

test_that("msgcomposer/composer_signature_validation", {
  env <- test_setup()

  expect_error({
    setMsgComposer(function(msgX, ...) { paste(msg, "comp") })
  })
})

test_that("msgcomposer/reset_composer", {
  env <- test_setup()

  setMsgComposer(function(msg, ...) { paste(msg, "comp") })
  resetMsgComposer()
  loginfo("test")

  expect_equal(env$logged, "INFO::test")
})

test_that("msgcomposer/set_sublogger_composer", {
  env <- test_setup()

  setMsgComposer(function(msg, ...) { paste(msg, "comp") }, container = "named")
  loginfo("test")
  loginfo("test", logger = "named")

  expect_equal(env$logged, c("INFO::test", "INFO:named:test comp"))
})

test_that("msgcomposer/set_sublogger_composer_directly", {
  env <- test_setup()

  getLogger("named")$setMsgComposer(function(msg, ...) { paste(msg, "comp") })
  loginfo("test")
  loginfo("test", logger = "named")

  expect_equal(env$logged, c("INFO::test", "INFO:named:test comp"))
})

test_that("msgcomposer/composer_signature_validation_directly", {
  env <- test_setup()

  expect_error({
    getLogger("named")$setMsgComposer(function(msgX, ...) { paste(msg, "comp") })
  })
})

