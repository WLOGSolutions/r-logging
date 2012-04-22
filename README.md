r-logging
=========

R port of the popular log4j logging module.

it implements hierarchical logging, multiple handlers at a single logger, formattable log records...

What you find here behaves similarly to what you also find in Python's standard logging module.

Far from being comparable to a Python standard module, this tiny logging module does include

- hierarchic loggers,
- multiple handlers at each logger,
- the possibility to specify a formatter for each handler (one default formatter is given),
- same levels (names and numeric values) as Python's logging package,
- a simple basicConfig function to quickly put yourself in a usable situation...

- some sample handlers, sending log records
 - to the console, 
 - to a file, 
 - to a sentry server.

for more information, have a look at the [online
tutorial] (http://logging.r-forge.r-project.org/sample_session.php) on
[r-forge] (http://r-forge.r-project.org/).