annotated sample sessions
~~~~~~~~~~~~~~~~~~~~~~~~~

this is a minimal tutorial, showing by example what you can do with and expect from this library. this text is directed to scripts authors who want to be able to log the activity of their programs.

this page is organized in sections. each section can be seen and tried out as a separate R session. at the end of the section there's a link to a R script with the R instructions tried in the section.

the basics
~~~~~~~~~~

This logging library attempts to be as compatible as possible (that is: as it was conceivable to the author) to the standard Python logging library. If you are accustomed to that logging library, this one will look familiar to you, otherwise have a look at this excerpt, then decide if you want to come back here and read further or go to the python documentation and read deeper.

In this session we work with one single logger, the root logger, and we use only console handlers.

Start up R, load the library, use the basic configuration::

  R> library(logging)
  R> basicConfig()
  R>

Let's check the effect of the above actions. Both our loggers and handlers are environments, so we can use for example ls and with to inspect them (don't worry if you get more elements than shown here, I'll come back to them later). After this basic configuration, our logger has handlers and a level and it contains one handler. This is enough for some simple logging to the console. The default logging level of the root logger is INFO (20). Anything at severity lower than INFO will not be logged::

  R> ls(getLogger())
  [1] "handlers" "level"
  R> getLogger()[['level']]
  INFO
    20
  R> getLogger()[['handlers']]
  $basic.stdout
  <environment: 0x........>
  
  R> loginfo('does it work?')
  2010-04-08 11:28:35 INFO::does it work?
  R> logwarn('my %s is %d', 'name', 5)
  2010-04-08 11:28:48 WARN::my name is 5
  R> logdebug('I am a silent child')
  R>

We add an other handler to the console, without specifying its name. It gets one automatically from the name of the function. You can add and remove handlers using their names. You can also refer to them by function, if that is the way you defined it::

  R> addHandler(writeToConsole)
  R> names(getLogger()[['handlers']])
  [1] "basic.stdout" "writeToConsole"
  R> loginfo('test')
  2010-04-07 11:31:06 INFO::test
  2010-04-07 11:31:06 INFO::test
  R> logwarn('test')
  2010-04-07 11:31:15 WARN::test
  2010-04-07 11:31:15 WARN::test
  R> removeHandler('writeToConsole')
  R> logwarn('test')
  2010-04-07 11:32:37 WARN::test
  R>

Handlers have a level associated to them. Any logging record passing through a handler and having a severity lower than the level of the handler is ignored. You can alter the level of a handler. this is what we do in the following lines: we alter the level of the default console handler 'basic.stdout' to 30 (WARN)::

  R> addHandler(writeToConsole)
  R> setLevel(30, getHandler('basic.stdout'))
  R> logwarn('test')
  2011-08-03 15:59:13 WARNING::test
  2011-08-03 15:59:13 WARNING::test
  R> loginfo('test')
  2011-08-03 15:59:18 INFO::test
  R> getHandler('basic.stdout')[['level']]
  WARN
  30
  R> getHandler('writeToConsole')[['level']]
  INFO
  20

hierarchical loggers
~~~~~~~~~~~~~~~~~~~~

in the previous section we have worked -implicitly- with one logger, the root logger. we can refer to it explicitly by specifying the 'logger' parameter in our function calls. the name of the root logger is the empty string. this also explains that "::" in the messages sent to the console, between the first and the second ":" there's the name of the logger that is associated to the log record shown. ::

  R> with(getLogger(logger=''), names(handlers))
  [1] "basic.stdout"
  R> with(getLogger('libro'), names(handlers))
  NULL

when issuing a logging record, you can specify to which logger you want to send it. loggers are created when first needed, so we can just assume all loggers we need also exist. the logger will offer it to all its attached handlers and then pass it to its parent logger. loggers are organized hierarchically, in a way that is similar to the way directories are organized.

just as directories contain files, loggers contain handlers and their name is, within the logger, unique. also similarly than to directories, all loggers have one parent, except the root logger that has none. the name of the logger specifies the location of the logger in this hierarchy. an example will hopefully clarify.

let's start from scratch, either a brand new R session or by resetting the logging system. ::

  R> logReset()
  R> addHandler(writeToConsole, logger='libro.romanzo')
  R> loginfo('Ma cos\'è questo amore?', logger='libro.romanzo.campanile')
  2010-04-08 11:18:59 INFO:libro.romanzo.campanile:Ma cos'è questo amore?
  R> loginfo('Se la luna mi porta fortuna', logger='libro.romanzo.campanile')
  2010-04-08 11:19:05 INFO:libro.romanzo.campanile:Se la luna mi porta fortuna
  R> loginfo('Giovanotti, non esageriamo!', logger='libro.romanzo.campanile')
  2010-04-08 11:19:12 INFO:libro.romanzo.campanile:Giovanotti, non esageriamo!
  R> loginfo('memories of a survivor', logger='libro.romanzo.lessing')
  2010-04-08 11:22:06 INFO:libro.romanzo.lessing:memories of a survivor
  R> logwarn('talking to a hierarchically upper logger', logger='libro')
  R> logerror('talking to an unrelated logger', logger='rivista.cucina')
  R>

notice that loggers are automatically defined by the simple action of naming them. what happened above is that the handler we created, attached to the 'libro.romanzo' logger, only saw the records going to the loggers below its logger. all records going to hierarchically upper loggers or to unrelated loggers are not logged, regardless of their severity.

also notice that the text printed doesn't contain any more that "::". between the two ":" there's the name of the logger that received the logging record in the first place.

logger objects
~~~~~~~~~~~~~~

in the last example box in the previous section we have sent logging records to the 'libro.romanzo.campanile' logger. we have done this by invoking the global loginfo function, passing it the name of the logger. this is only practical if you are logging to the root logger or if you are using many different loggers, not if you are sending, as in our example, more records to the same logger. if you are talking the whole time to the same logger, you do not want to have to repeat the name of the logger each time you send it a record.

the solution to this is in the object oriented approach taken in this logging library. the getLogger() function returns a Logger object, which, since we are using Reference Classes, is itself an environment. in the previous examples we have only used the fact that Logger objects are environments, let's now have a look at what more they offer. ::

  > class(getLogger())
  [1] "Logger"
  attr(,"package")
  [1] "logging"
  > is.environment(getLogger())
  [1] TRUE
  >

let me keep it compact, I'm just giving you the code that will produce the same logging as in the previous example. do notice that you can mix invoking object methods with usage of the global functions. ::

  R> logReset()
  R> getLogger('libro.romanzo')$addHandler(writeToConsole)
  R> lrc <- getLogger('libro.romanzo.campanile')
  R> lrc$info('Ma cos\'è questo amore?')
  2010-04-08 11:18:59 INFO:libro.romanzo.campanile:Ma cos'è questo amore?
  R> lrc$info('Se la luna mi porta fortuna')
  2010-04-08 11:19:05 INFO:libro.romanzo.campanile:Se la luna mi porta fortuna
  R> lrc$info('Giovanotti, non esageriamo!')
  2010-04-08 11:19:12 INFO:libro.romanzo.campanile:Giovanotti, non esageriamo!
  R> loginfo('memories of a survivor', logger='libro.romanzo.lessing')
  2010-04-08 11:22:06 INFO:libro.romanzo.lessing:memories of a survivor
  R> getLogger('libro')$warn('talking to a hierarchically upper logger')
  R> logerror('talking to an unrelated logger', logger='rivista.cucina')
  R>

logging to file
~~~~~~~~~~~~~~~

actually the name of this paragraph is misleading. a more correct name would be handling to file, since it's a handler and not a logger that is actually writing some representation of your logrecords to a file.

to make sure log records are sent to a file, you choose a logger and attach to it a handler with action a function that writes to your file. the logging package exports the commodity function writeToFile for this purpouse. the name of the file is given as an extra parameter in the call to addHandler.

recall that both loggers and handlers have a level. records at a specific severity are examined by loggers first; if the severity is higher than the level of the logger, they are offered to all of the attached handlers. handlers will again check the level of the record before taking action. in the following example we make sure absolutely all logrecords are examined by initializing the root logger at the FINEST level. the level of the basic_stdout console handler is not affected. ::

  R> logReset()
  R> basicConfig(level='FINEST')
  R> addHandler(writeToFile, file="~/testing.log", level='DEBUG')
  R> with(getLogger(), names(handlers))
  [1] "basic.stdout" "writeToFile"
  R> loginfo('test %d', 1)
  2010-04-07 11:31:06 INFO::test 1
  R> logdebug('test %d', 2)
  R> logwarn('test %d', 3)
  2010-04-07 11:31:15 WARN::test 3
  R> logfinest('test %d', 4)
  R>

if the file was not existing or empty, this would be its content after the above steps::

  2010-04-07 11:31:06 INFO::test 1
  2010-04-07 11:31:11 DEBUG::test 2
  2010-04-07 11:31:15 WARN::test 3

all log records have been passed to both handlers basic.stdout and writeToFile. the default console handler has handled records with severity at or above INFO, our file handler had threshold DEBUG so it handled also the second record in the example session. the fourth record was dropped by both handlers.

formatting your log records
~~~~~~~~~~~~~~~~~~~~~~~~~~~

in this session we are going to see how to generate a diagnostics file for a system that organizes logrecords in a different way than Python. let's jump into the implementation, if you can write R you surely won't need more explaination but will want to tell me how to make this function faster, more readable, shorter... ::

  formatter.fewsdiagnostics <- function(record) {
    if(record$level <= loglevels[['INFO']])
      level <- 3
    else if(record$level <= loglevels[['WARNING']])
      level <- 2
    else if(record$level <= loglevels[['ERROR']])
      level <- 1
    else
      level <- 0
  
    sprintf('  <line level="%d" description="LizardScripter :: %s :: %s"/>\n', level, record$timestamp, record$msg)
  }

notice that the field $msg of a record is already "formatted", as we have seen with logwarn('my %s is %d', 'name', 5). that part can be used but not undone any more.

when you add a handler to a logger, you can use the formatter parameter to associate to the handler a function that takes a logrecord and returns a string. the above example function is such a function.

the formatter you can associate to a handler can combine the tags in the logrecord to produce a string. the tags that are available in a logrecord are: $logger (the name of the logger which produced the record), $msg, $timestamp, $level (numeric), $levelname (character).

if you don't specify the formatter parameter, the default formatter is used, which looks like this::

  defaultFormat <- function(record) {
    text <- paste(record$timestamp, paste(record$levelname, record$logger, record$msg, sep=':'))
  }

the rest of the code, just slightly simplified, showing how we (me at my company) actually use this capability is given here.

notice that the 'diagnostics' handler we add will not handle DEBUG logrecords. ::

  setup.fewsdiagnostics <- function(filename) {
    cat('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n', file=filename, append=FALSE)
    cat('<Diag version="1.2" xmlns="..." xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="...">\n', file=filename, append=FALSE)
    addHandler('diagnostics',
              writeToFile, file=filename,
              logger='fews.diagnostics',
              formatter=formatter.fewsdiagnostics)
  }
  
  teardown.fewsdiagnostics <- function(filename) {
    cat('</Diag>\n'', file=filename, append=TRUE)
    removeHandler('diagnostics', logger='fews.diagnostics')
  }

writing your own handlers
~~~~~~~~~~~~~~~~~~~~~~~~~

differently than in the logging library in Python and in Java, handlers in this logging library aren't objects: they are environments stored in one of the loggers. the principal characteristic property of a handler is its action. a action is a function that specifies what the handler should do with a logrecord that, based on all that we have seen above, must be handled. the two commodity functions we have seen in the first two sessions, writeToConsole and writeToFile are action functions.

a look at writeToFile will help understand the idea implemented in this library. ::

  writeToFile <- function(msg, handler)
  {
    if (!exists('file', envir=handler))
      stop("handler with writeToFile 'action' must have a 'file' element.\n")
    cat(paste(msg, '\n', sep=''), file=with(handler, file), append=TRUE)
  }

an action is invoked if a record must be handled. its result code is ignored and all its output goes to the console. it receives exactly two arguments, the formatted message that must be output (the string returned by the formatter of the handler) and the handler owning the action. recall that a handler is an environment: in the action you can inspect the handler environment to perform the desired behaviour.

imagine you want a handler to send its messages to a xmlrpc server or to a password protected ftp server, you would add these properties in the call to addHandler. addHandler would store them in the new handler environment. your action function would retrieve the values from the handler and use them to connect to your hypothetical external server.

the structure of your solution might be something like this::

  sendToFtpServer <- function(msg, handler)
  {
    proxy <- connectToServer(with(handler, server), with(handler, user), with(handler, passwd))
    do_the_rest()
  }

  addHandler(sendToFptServer, user='', server='', passwd='', logger="deep.deeper.deepest")
