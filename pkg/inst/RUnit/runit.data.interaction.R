require(RUnit)

# test functions are called in lexicographic order.

test.000.getLoggerWithoutInitializingDoesNotCrash <- function() {
  rootLogger <- getLogger("")
}

test.001.defaultLoggingLevelIsINFO <- function() {
  basicConfig()
  rootLogger <- getLogger('')
  expect <- levels['INFO']
  checkEquals(rootLogger[['level']], expect)
}

test.002.canInitializeTwice <- function() {
  basicConfig()
  rootLogger <- getLogger('')
  expect <- levels['INFO']
  checkEquals(rootLogger[['level']], expect)
}

# end of functions that must be tested first

test.canGetRootLoggerWithoutName <- function() {
  rootLogger1 <- getLogger('')
  rootLogger2 <- getLogger()
  checkEquals(rootLogger1, rootLogger2)
}

test.canFindLoggingLevels <- function() {
  checkEquals(logging::levels[['NOTSET']], 0)
  checkEquals(logging::levels[['DEBUG']], 10)
  checkEquals(logging::levels[['INFO']], 20)
  checkEquals(logging::levels[['WARN']], 30)
  checkEquals(logging::levels[['ERROR']], 40)
  checkEquals(logging::levels[['FATAL']], 50)
}

test.fineLevelsAreOrdered <- function() {
  checkEquals(logging::levels[['FINEST']] < logging::levels[['FINER']], TRUE)
  checkEquals(logging::levels[['FINER']] < logging::levels[['FINE']], TRUE)
  checkEquals(logging::levels[['FINE']] < logging::levels[['DEBUG']], TRUE)
}

test.canSetLoggerLevelByNamedValue <- function() {
  basicConfig()
  setLevel('', levels['DEBUG'])
  rootLogger <- getLogger('')
  expect <- levels['DEBUG']
  checkEquals(rootLogger[['level']], expect)
}

test.canSetLoggerLevelByName <- function() {
  basicConfig()
  setLevel('', 'DEBUG')
  rootLogger <- getLogger('')
  expect <- levels['DEBUG']
  checkEquals(rootLogger[['level']], expect)
}
