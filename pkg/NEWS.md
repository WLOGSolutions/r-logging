# logging 0.10-108 (2019-07-14)
  * issue #4: logged do not raise exception if formatting message contains %F
    markers and not formatting arguments passed
  * sub-loggers are created by default with loglevel inheritance from parent
  * issue #4: message composer can be set directly for logger object

# logging 0.9-107 (2019-02-09)
  * issue #4: added possibility to set custom message composer for logger e.g.
    based on glue formating.

# logging 0.9-106 (2019-01-23)
  * issue #2 fixed: handling of sprintf limitation to 8192 characters in fmt.
    If no formatting parameters provided and fmt does not contain markers it
    logs message just as it is. If formatting required on msg over 8192 chars
    it raises error.

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
