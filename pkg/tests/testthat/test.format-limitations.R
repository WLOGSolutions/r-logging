library(testthat)
library(logging)

context("Testing formatting limitation handling [test.format-limitations]")

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

test_that("formatlimits/up_to_limit_w_formating", {
  env <- test_setup()

  msg0_9 <- paste(0:9, collapse = "")
  msg8190 <- paste(rep(msg0_9, 819), collapse = "")
  stopifnot(nchar(msg8190) == 8190)

  msg8190_s <- paste0(msg8190, "%s")
  stopifnot(nchar(msg8190_s) == 8192)

  loginfo(msg8190_s, paste0(".", msg0_9))

  expect_equal(env$logged, paste0("INFO::", msg8190, ".", msg0_9))
})

test_that("formatlimits/over_limit_w_formatting_fails", {
  env <- test_setup()

  msg0_9 <- paste(0:9, collapse = "")
  msg8190 <- paste(rep(msg0_9, 819), collapse = "")
  stopifnot(nchar(msg8190) == 8190)

  msg8190_sX <- paste0(msg8190, "%s", "X")
  stopifnot(nchar(msg8190_sX) == 8193)

  expect_error({
    loginfo(msg8190_sX, paste0(".", msg0_9))
  },
  regexp = "'msg' length exceeds maximal format length 8192")
})

test_that("formatlimits/over_limit_wo_format_args_fails", {
  env <- test_setup()

  msg0_9 <- paste(0:9, collapse = "")
  msg8190 <- paste(rep(msg0_9, 819), collapse = "")
  stopifnot(nchar(msg8190) == 8190)

  msg8190_sX <- paste0(msg8190, "%s", "X")
  stopifnot(nchar(msg8190_sX) == 8193)

  expect_error({
    loginfo(msg8190_sX)
  },
  regexp = "too few arguments for format")
})

test_that("formatlimits/over_limit_wo_formatting", {
  env <- test_setup()

  msg0_9 <- paste(0:9, collapse = "")
  msg8190 <- paste(rep(msg0_9, 819), collapse = "")
  stopifnot(nchar(msg8190) == 8190)

  # long message without formatting
  msg8190_x2 <- paste0(msg8190, ".", msg8190)
  stopifnot(nchar(msg8190_x2) == 2 * 8190 + 1)

  loginfo(msg8190_x2)

  expect_equal(env$logged, paste0("INFO::", msg8190_x2))
  env$logged <- c()

  # long message with %% at end
  msg8190_m_perc <- paste0(msg8190, "%%", "X")
  stopifnot(nchar(msg8190_m_perc) == 8193)

  loginfo(msg8190_m_perc)

  expect_equal(env$logged, paste0("INFO::", msg8190_m_perc))
  env$logged <- c()

  # long message with %% at start
  msg8190_perc_m <- paste0("%%", "X", msg8190)
  stopifnot(nchar(msg8190_perc_m) == 8193)

  loginfo(msg8190_perc_m)

  expect_equal(env$logged, paste0("INFO::", msg8190_perc_m))
})
