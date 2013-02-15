require(svUnit)

# test functions are called in lexicographic order.
# $Id: runit.data.interaction.R 86 2011-08-03 13:16:48Z mariotomo $

test.looksForHandlersInRootLogger <- function() {
  logReset()
  basicConfig()
  checkIdentical(getLogger()[['handlers']][[1]], getHandler('basic.stdout'))
}

test.lookingForHandlersInObject <- function() {
  logReset()
  basicConfig()
  checkIdentical(getLogger()[['handlers']][[1]], getLogger()$getHandler('basic.stdout'))
}

test.addingANewHandler <- function() {
  logReset()
  basicConfig()
  addHandler(writeToConsole)
  checkEquals(2, length(with(getLogger(), names(handlers))))
  checkTrue('writeToConsole' %in% with(getLogger(), names(handlers)))
}

test.removingOneHandlerByName <- function() {
  logReset()
  basicConfig()
  addHandler(writeToConsole)
  removeHandler('writeToConsole')
  checkEquals(1, length(with(getLogger(), names(handlers))))
  checkTrue(!'writeToConsole' %in% with(getLogger(), names(handlers)))
}

test.fileName <- file.path(tempdir(), c('1', '2', '3'))

.setUp <- function() {
}

.tearDown <- function() {
  file.remove(test.fileName)
}

test.loggingToFile <- function() {
  logReset()
  file.remove(test.fileName)

  getLogger()$setLevel('FINEST')
  addHandler(writeToFile, file=test.fileName[[1]], level='DEBUG')
  checkEquals(c("writeToFile"), with(getLogger(), names(handlers)))
  loginfo('test %d', 1)
  logdebug('test %d', 2)
  logwarn('test %d', 3)
  logfinest('test %d', 4)
}

test.loggingToFile.oo <- function() {
  logReset()
  file.remove(test.fileName)

  log <- getLogger()
  log$setLevel('FINEST')
  log$addHandler(writeToFile, file=test.fileName[[1]], level='DEBUG')
  checkEquals(c("writeToFile"), with(log, names(handlers)))
  log$info('test %d', 1)
  log$debug('test %d', 2)
  log$warn('test %d', 3)
  log$finest('test %d', 4)
}
