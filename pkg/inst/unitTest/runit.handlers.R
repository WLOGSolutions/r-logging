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
