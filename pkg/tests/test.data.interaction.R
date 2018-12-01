library(testthat)
library(logging)

context("Testing data interactions [test.data.interaction]")

test_that("000/getLoggerWithoutInitializingDoesNotCrash", {
  rootLogger <- getLogger("")

  expect_true(TRUE) # getLogger not failed
})

test_that("001/defaultLoggingLevelIsINFO", {
  basicConfig()

  rootLogger <- getLogger('')
  expect <- logging:::loglevels['INFO']

  expect_equal(rootLogger[['level']], expect)
})

test_that("002/canInitializeTwice", {
  basicConfig()

  basicConfig()
  rootLogger <- getLogger('')
  expect <- logging:::loglevels['INFO']

  expect_equal(rootLogger[['level']], expect)
})

test_that("003/sameNameMeansSameObject", {
  basicConfig()

  root1 <- getLogger('abc')
  root2 <- getLogger("abc")

  expect_identical(root1, root2)
})

test_that("004/noNameMeansRoot", {
  rootLogger1 <- getLogger('')
  rootLogger2 <- getLogger()

  expect_identical(rootLogger1, rootLogger2)
})

test_that("500.basicConfigSetsLevelOfHandler", {
  logReset()
  basicConfig('DEBUG')

  rootLogger <- getLogger('')
  expect <- logging:::loglevels['DEBUG']
  current <- rootLogger$getHandler('basic.stdout')[['level']]

  expect_equal(current, expect)

  logReset()
  basicConfig('ERROR')
  rootLogger <- getLogger('')  ## needed, because `logReset` unlinked the old one
  expect <- logging:::loglevels['ERROR']
  current <- rootLogger$getHandler('basic.stdout')[['level']]

  expect_equal(current, expect)
})


test_that("canFindLoggingLevels", {
  expect_equal(logging:::loglevels[['NOTSET']], 0)
  expect_equal(logging:::loglevels[['DEBUG']], 10)
  expect_equal(logging:::loglevels[['INFO']], 20)
  expect_equal(logging:::loglevels[['WARN']], 30)
  expect_equal(logging:::loglevels[['ERROR']], 40)
  expect_equal(logging:::loglevels[['FATAL']], 50)
})

test_that("fineLevelsAreOrdered", {
  expect_true(logging:::loglevels[['FINEST']] < logging:::loglevels[['FINER']])
  expect_true(logging:::loglevels[['FINER']] < logging:::loglevels[['FINE']])
  expect_true(logging:::loglevels[['FINE']] < logging:::loglevels[['DEBUG']])
})

test_that("canSetLoggerLevelByNamedValue", {
  logReset()
  basicConfig()

  setLevel(logging:::loglevels['DEBUG'], '')

  rootLogger <- getLogger('')
  expect <- logging:::loglevels['DEBUG']
  expect_equal(rootLogger[['level']], expect)
})

test_that("canSetLoggerLevelByName", {
  logReset()
  basicConfig()

  setLevel('DEBUG', '')

  rootLogger <- getLogger('')
  expect <- logging:::loglevels['DEBUG']
  expect_equal(rootLogger[['level']], expect)
})



test_setup <- function(...) {
  test_env <- new.env(parent = emptyenv())
  test_env$logged <- NULL

  mockAction <- function(msg, handler, ...) {
    if(length(list(...)) && 'dry' %in% names(list(...)))
      return(TRUE)
    test_env$logged <- c(test_env$logged, msg)
  }
  mockFormatter <- function(record) {
    msg <- trimws(record$msg)
    paste(record$levelname, record$logger, msg, sep = ":")
  }

  logReset()
  addHandler(mockAction, formatter=mockFormatter, ...)

  return(test_env)
}


test_that("recordIsEmitted/rootToRoot", {
  env <- test_setup()

  logdebug('test')
  loginfo('test')
  logerror('test')

  expect_equal(length(env$logged), 2)
})

test_that("recordIsEmitted/tooDeep", {
  env <- test_setup(logger='too.deep')

  logdebug('test')
  loginfo('test')
  logerror('test')

  expect_equal(length(env$logged), 0)
})

test_that("recordIsEmitted/unrelated", {
  env <- test_setup(logger='too.deep')

  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')

  expect_equal(length(env$logged), 0)
})

test_that("recordIsEmitted/deepToRoot", {
  env <- test_setup(logger='')

  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')

  expect_equal(length(env$logged), 2)
})

test_that("recordIsEmitted/deepToRoot.DI.dropped", {
  env <- test_setup(level='DEBUG', logger='')

  setLevel('INFO', 'other.branch')
  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')

  expect_equal(length(env$logged), 2)
})

test_that("recordIsEmitted/deepToRoot.DD.passed", {
  env <- test_setup(level='DEBUG', logger='')

  setLevel('DEBUG', 'other.branch')
  setLevel('DEBUG', '')
  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')

  expect_equal(length(env$logged), 3)
})


test_that("formattingRecord/lengthZero", {
  env <- test_setup(level='DEBUG', logger='')

  loginfo("test '%s'", numeric(0))

  expect_equal(env$logged, "INFO::test ''")
})

test_that("formattingRecord/lengthOne", {
  env <- test_setup(level='DEBUG', logger='')

  loginfo("test '%s'", 12)

  expect_equal(env$logged, "INFO::test '12'")
})

test_that("formattingRecord/lengthMore", {
  env <- test_setup(level='DEBUG', logger='')

  loginfo("test '%s'", c(0, 1, 2))

  expect_equal(env$logged, "INFO::test '0,1,2'")
})

test_that("formattingRecord/moreArguments", {
  env <- test_setup(level='DEBUG', logger='')

  loginfo("%s: %d", 'name', 123)

  expect_equal(env$logged, "INFO::name: 123")


  env$logged <- NULL

  loginfo("%s: %0.2f", 'name', 123.0)

  expect_equal(env$logged, "INFO::name: 123.00")
})

test_that("formattingRecord/moreArguments.lengthMore", {
  env <- test_setup(level='DEBUG', logger='')

  loginfo("%s '%s'", 'name', c(0, 1, 2))

  expect_equal(env$logged, "INFO::name '0,1,2'")
})

test_that("formattingRecord/strips.whitespace", {
  env <- test_setup(level='DEBUG', logger='')

  loginfo("a string with trailing whitespace \n")

  expect_equal(env$logged, "INFO::a string with trailing whitespace")


  env$logged <- NULL

  loginfo("  this string has also leading whitespace   ")

  expect_equal(env$logged, "INFO::this string has also leading whitespace")
})
