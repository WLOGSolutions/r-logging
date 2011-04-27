require(svUnit)

# test functions are called in lexicographic order.
# $Id$

test.000.getLoggerWithoutInitializingDoesNotCrash <- function() {
  rootLogger <- getLogger("")
  checkTrue(TRUE) # this is reached if the previous does not crash.
}

test.001.defaultLoggingLevelIsINFO <- function() {
  basicConfig()
  rootLogger <- getLogger('')
  expect <- logging:::loglevels['INFO']
  checkEquals(rootLogger[['level']], expect)
}

test.002.canInitializeTwice <- function() {
  basicConfig()
  rootLogger <- getLogger('')
  expect <- logging:::loglevels['INFO']
  checkEquals(rootLogger[['level']], expect)
}

# end of functions that must be tested first

test.canGetRootLoggerWithoutName <- function() {
  rootLogger1 <- getLogger('')
  rootLogger2 <- getLogger()
  checkEquals(rootLogger1, rootLogger2)
}

test.canFindLoggingLevels <- function() {
  checkEquals(logging:::loglevels[['NOTSET']], 0)
  checkEquals(logging:::loglevels[['DEBUG']], 10)
  checkEquals(logging:::loglevels[['INFO']], 20)
  checkEquals(logging:::loglevels[['WARN']], 30)
  checkEquals(logging:::loglevels[['ERROR']], 40)
  checkEquals(logging:::loglevels[['FATAL']], 50)
}

test.fineLevelsAreOrdered <- function() {
  checkEquals(logging:::loglevels[['FINEST']] < logging:::loglevels[['FINER']], TRUE)
  checkEquals(logging:::loglevels[['FINER']] < logging:::loglevels[['FINE']], TRUE)
  checkEquals(logging:::loglevels[['FINE']] < logging:::loglevels[['DEBUG']], TRUE)
}

test.canSetLoggerLevelByNamedValue <- function() {
  basicConfig()
  setLevel(logging:::loglevels['DEBUG'], '')
  rootLogger <- getLogger('')
  expect <- logging:::loglevels['DEBUG']
  checkEquals(rootLogger[['level']], expect)
}

test.canSetLoggerLevelByName <- function() {
  basicConfig()
  setLevel('DEBUG', '')
  rootLogger <- getLogger('')
  expect <- logging:::loglevels['DEBUG']
  checkEquals(rootLogger[['level']], expect)
}

logged <- NULL
mockAction <- function(msg, handler, ...) {
  logged <<- c(logged, msg)
}

mockFormatter <- function(record) {
  paste(record$levelname, record$logger, record$msg, sep = ":")
}

test.recordIsEmitted.rootToRoot <- function() {
  logReset()
  addHandler(mockAction)
  logged <<- NULL
  logdebug('test')
  loginfo('test')
  logerror('test')
  checkEquals(2, length(logged))
}

test.recordIsEmitted.tooDeep <- function() {
  logReset()
  addHandler(mockAction, logger='too.deep')
  logged <<- NULL
  logdebug('test')
  loginfo('test')
  logerror('test')
  checkEquals(0, length(logged))
}

test.recordIsEmitted.unrelated <- function() {
  logReset()
  addHandler(mockAction, logger='too.deep')
  logged <<- NULL
  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')
  checkEquals(0, length(logged))
}

test.recordIsEmitted.deepToRoot <- function() {
  logReset()
  addHandler(mockAction, logger='')
  logged <<- NULL
  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')
  checkEquals(2, length(logged))
}

test.recordIsEmitted.deepToRoot.DI.dropped <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='')
  logged <<- NULL
  setLevel('other.branch', 'INFO')
  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')
  checkEquals(2, length(logged))
}

test.recordIsEmitted.deepToRoot.DD.passed <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='')
  logged <<- NULL
  setLevel('DEBUG', 'other.branch')
  setLevel('DEBUG', '')
  logdebug('test', logger='other.branch')
  loginfo('test', logger='other.branch')
  logerror('test', logger='other.branch')
  checkEquals(3, length(logged))
}

test.formattingRecord.lengthZero <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo("test '%s'", numeric(0))
  checkEquals("INFO::test ''", logged)
}

test.formattingRecord.lengthOne <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo("test '%s'", 12)
  checkEquals("INFO::test '12'", logged)
}

test.formattingRecord.lengthMore <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo("test '%s'", c(0, 1, 2))
  checkEquals("INFO::test '0,1,2'", logged)
}

test.formattingRecord.moreArguments <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo("%s: %d", 'name', 123)
  checkEquals("INFO::name: 123", logged)
  logged <<- NULL
  loginfo("%s: %0.2f", 'name', 123.0)
  checkEquals("INFO::name: 123.00", logged)
}

test.formattingRecord.moreArguments.lengthMore <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo("%s '%s'", 'name', c(0, 1, 2))
  checkEquals("INFO::name '0,1,2'", logged)
}

test.formattingRecord.strips.whitespace <- function() {
  logReset()
  addHandler(mockAction, level='DEBUG', logger='', formatter=mockFormatter)
  logged <<- NULL
  loginfo("a string with trailing whitespace \n")
  checkEquals("INFO::a string with trailing whitespace", logged)
  logged <<- NULL
  loginfo("  this string has also leading whitespace   ")
  checkEquals("INFO::this string has also leading whitespace", logged)
}
