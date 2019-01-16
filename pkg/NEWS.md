# logging 0.9-105 (2019-01-16)
  * Documentation generation migrated to roxygen2
  * Tests migrated to testthat, test coverage enhanced
  * Most issues reported by goodpractice fixed
  * If crayon is available console messages are in color
  * #1 fixed.
  * Basic handlers are created with NOTSET level (if not specified) so they 
    pass log records to main logger.
  * Root logger initialization changed: basicConfig is not required any more
    for loginfo to work. If you need clear logger without default handlers use
    logReset.
  
# logging 0.8-104 (2018-11-29)
  * Maintener changed to Walerian Sokolowski
