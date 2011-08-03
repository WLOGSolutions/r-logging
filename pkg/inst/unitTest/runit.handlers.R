require(svUnit)

# test functions are called in lexicographic order.
# $Id: runit.data.interaction.R 86 2011-08-03 13:16:48Z mariotomo $

test.looksForHandlersInRootLogger <- function() {
  basicConfig()
  checkIdentical(getLogger()[['handlers']][[1]], getHandler('basic.stdout'))
}

test.lookingForHandlersInObject <- function() {
  basicConfig()
  checkIdentical(getLogger()[['handlers']][[1]], getLogger()$getHandler('basic.stdout'))
}
