require(svUnit)

# test functions are called in lexicographic order.
# $Id$

test.000.getLoggerWithoutInitializingDoesNotCrash <- function() {
  rootLogger <- Logger$new("")
}

test.001.defaultLoggingLevelIsINFO <- function() {
  basicConfig()
  root <- Logger$new('')
  expect <- logging:::loglevels['INFO']
  checkEquals(root[['level']], expect)
}

test.002.canInitializeTwice <- function() {
  basicConfig()
  root <- Logger$new('')
  expect <- logging:::loglevels['INFO']
  checkEquals(root[['level']], expect)
}

# end of functions that must be tested first

test.canGetRootLoggerWithoutName <- function() {
  root1 <- Logger$new('')
  root2 <- Logger$new()
  checkEquals(root1, root2)
}

test.canSetLoggerLevelByNamedValue <- function() {
  basicConfig()
  root <- Logger$new('')
  root$setLevel(logging:::loglevels['DEBUG'])
  expect <- logging:::loglevels['DEBUG']
  checkEquals(root[['level']], expect)
}

test.canSetLoggerLevelByName <- function() {
  basicConfig()
  root <- getLogger('')
  root$setLevel('DEBUG')
  expect <- logging:::loglevels['DEBUG']
  checkEquals(root[['level']], expect)
}

logged <- NULL

mockAction <- function(msg, handler) {
  logged <<- c(logged, msg)
}

mockFormatter <- function(record) {
  paste(record$levelname, record$logger, record$msg, sep = ":")
}

test.recordIsEmitted.rootToRoot <- function() {
  logReset()
  log <- getLogger('test')
  log$addHandler(mockAction)
  logged <<- NULL
  log$debug('test')
  log$info('test')
  log$error('test')
  checkEquals(2, length(logged))
}

test.recordIsEmitted.tooDeep <- function() {
  logReset()
  root <- getLogger('')
  log2 <- getLogger('too.deep')
  log2$addHandler(mockAction)
  logged <<- NULL
  root$debug('test')
  root$info('test')
  root$error('test')
  checkEquals(0, length(logged))
}

test.recordIsEmitted.unrelated <- function() {
  logReset()
  log1 <- getLogger('other.branch')
  log2 <- getLogger('too.deep')
  log2$addHandler(mockAction)
  logged <<- NULL
  log1$debug('test', logger='other.branch')
  log1$info('test', logger='other.branch')
  log1$error('test', logger='other.branch')
  checkEquals(0, length(logged))
}

test.recordIsEmitted.deepToRoot <- function() {
  logReset()
  root <- getLogger('')
  log <- getLogger('other.branch')
  root$addHandler(mockAction)
  logged <<- NULL
  log$debug('test')
  log$info('test')
  log$error('test')
  checkEquals(2, length(logged))
}

test.recordIsEmitted.deepToRoot.DI.dropped <- function() {
  logReset()
  root <- getLogger('')
  log <- getLogger('other.branch')
  root$addHandler(mockAction, level='DEBUG')
  logged <<- NULL
  log$setLevel('INFO')
  log$debug('test')
  log$info('test')
  log$error('test')
  checkEquals(2, length(logged))
}

test.recordIsEmitted.deepToRoot.DD.passed <- function() {
  logReset()
  root <- getLogger('')
  log <- getLogger('other.branch')
  root$addHandler(mockAction, level='DEBUG')
  logged <<- NULL
  log$setLevel('DEBUG')
  root$setLevel('DEBUG')
  log$debug('test')
  log$info('test')
  log$error('test')
  checkEquals(3, length(logged))
}

test.formattingRecord.lengthZero <- function() {
  logReset()
  log <- getLogger('')
  log$addHandler(mockAction, level='DEBUG', formatter=mockFormatter)
  logged <<- NULL
  log$info("test '%s'", numeric(0))
  checkEquals("INFO::test ''", logged)
}

test.formattingRecord.lengthOne <- function() {
  logReset()
  log <- getLogger()
  log$addHandler(mockAction, level='DEBUG', formatter=mockFormatter)
  logged <<- NULL
  log$info("test '%s'", 12)
  checkEquals("INFO::test '12'", logged)
}

test.formattingRecord.lengthMore <- function() {
  logReset()
  log <- getLogger()
  addHandler(mockAction, level='DEBUG', formatter=mockFormatter)
  logged <<- NULL
  log$info("test '%s'", c(0, 1, 2))
  checkEquals("INFO::test '0,1,2'", logged)
}

test.formattingRecord.moreArguments <- function() {
  logReset()
  log <- getLogger()
  log$addHandler(mockAction, level='DEBUG', formatter=mockFormatter)
  logged <<- NULL
  log$info("%s: %d", 'name', 123)
  checkEquals("INFO::name: 123", logged)
  logged <<- NULL
  log$info("%s: %0.2f", 'name', 123.0)
  checkEquals("INFO::name: 123.00", logged)
}

test.formattingRecord.moreArguments.lengthMore <- function() {
  logReset()
  log <- getLogger()
  log$addHandler(mockAction, level='DEBUG', formatter=mockFormatter)
  logged <<- NULL
  log$info("%s '%s'", 'name', c(0, 1, 2))
  checkEquals("INFO::name '0,1,2'", logged)
}

test.formattingRecord.strips.whitespace <- function() {
  logReset()
  log <- getLogger()
  log$addHandler(mockAction, level='DEBUG', formatter=mockFormatter)
  logged <<- NULL
  log$info("a string with trailing whitespace \n")
  checkEquals("INFO::a string with trailing whitespace", logged)
  logged <<- NULL
  log$info("  this string has also leading whitespace   ")
  checkEquals("INFO::this string has also leading whitespace", logged)
}
