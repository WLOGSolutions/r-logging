<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
<link href="additions.css" rel="stylesheet" type="text/css" />
  </head>

  <body>
<blockquote>
<p>
<a href="sample_session.php">[back to the tutorial]</a> &nbsp;
<a href="http://docs.python.org/library/logging.html">[Python logging documentation]</a>
</p>
</blockquote>
<h3>introduction</h3>
<p>This page is an exerpt from the Python logging documentation, with edits to make it apply to the R logging module.  it introduces the concepts of <tt>Logger</tt>, <tt>Handler</tt> and <tt>Formatter</tt> objects.  In Python you will also find <tt>Filter</tt> objects, but I have not implemented them in the R logging module.</p>
    <p>The logging library takes a modular approach and offers the several categories of components: loggers, handlers, and formatters. Loggers expose the interface that application code directly uses. Handlers send the log records to the appropriate destination. Formatters specify the layout of the resultant log record.</p>

    <h3>15.7.1.2. Loggers</h3>
    <p><tt>Logger</tt> objects have a threefold job. First, the library exposes several methods to application code so that applications can log messages at runtime. Second, logger objects determine which log messages to act upon based upon severity (the default filtering facility) or filter objects. Third, logger objects pass along relevant log messages to all interested log handlers.</p>
    <p>The most widely used functions on logger objects fall into two categories: configuration and message sending.  Configuration means: setting the level.</p>
<ul>
      <li><tt>setLevel(logger)</tt> specifies the lowest-severity log message a logger will handle, where debug is the lowest built-in severity level and critical is the highest built-in severity. For example, if the severity level is info, the logger will handle only info, warning, error, and critical messages and will ignore debug messages.</li>
</ul>

    <p>With the logger object configured, the following functions create log messages:</p>
<ul>
    <li><p><tt>logdebug()</tt>, <tt>loginfo()</tt>, <tt>logwarn()</tt>, and <tt>logerror()</tt> all create log records with a message and a level that corresponds to their respective method names. The message is actually a format string, which may contain the standard string substitution syntax of <tt><b>%s</b></tt>, <tt><b>%d</b></tt>, <tt><b>%f</b></tt>, and so on. The rest of their arguments is a list of objects that correspond with the substitution fields in the message.</p></li>
    <li><p><tt>loglevel()</tt> takes a log level as an explicit argument. This is a little more verbose for logging messages than using the log level convenience methods listed above, but this is how to log at custom log levels.</p></li>
</ul>
<p><tt>getLogger()</tt> returns a reference to a logger instance with the specified name if it is provided, or root if not. The names are period-separated hierarchical structures. Multiple calls to <tt>getLogger()</tt> with the same name will return a reference to the same logger object. Loggers that are further down in the hierarchical list are children of loggers higher up in the list. For example, given a logger with a name of foo, loggers with names of foo.bar, foo.bar.baz, and foo.bam are all descendants of foo. Child loggers propagate messages up to the handlers associated with their ancestor loggers. Because of this, it is unnecessary to define and configure handlers for all the loggers an application uses. It is sufficient to configure handlers for a top-level logger and create child loggers as needed.</p>

<h3>15.7.1.3. Handlers</h3>

<p><tt>Handler</tt> objects are responsible for dispatching the appropriate log messages (based on the log messages' severity) to the handler's specified destination. You can add zero or more handler objects to <tt>Logger</tt> objects with the <tt>addHandler()</tt> function. As an example scenario, an application may want to send all log messages to a log file, all log messages of error or higher to stdout, and all messages of critical to an email address. This scenario requires three individual handlers where each handler is responsible for sending messages of a specific severity to a specific location.</p>

<p>There are very few handler related functions in the logging library for application developers to concern themselves with. The only handler methods that seem relevant for application developers who are using the built-in handler objects (that is, not creating custom handlers) are the following configuration methods:</p>

<ul>
<li>The <tt>setLevel()</tt> function, just as for logger objects, specifies the lowest severity that will be dispatched to the appropriate destination.  What are the differences between the two usages of the <tt>setLevel()</tt> function? The level set in the logger determines which severity of messages it will pass to its handlers. The level set in each handler determines which messages that handler will send on.</li>
<li><tt>setFormatter()</tt> selects a Formatter object for this handler to use.</li>
</ul>

Application code should not directly instantiate and use instances of Handler. Instead, the Handler class is a base class that defines the interface that all handlers should have and establishes some default behavior that child classes can use (or override).

<h3>15.7.1.4. Formatters</h3>

<p><tt>Formatter</tt> functions configure the final order, structure, and contents of the log message. R logging formatters work in a quite differnt way than the Python formatters, so I'm not quoting this section.</p>

    <hr>
    <address><a href="mailto:mario.frasca@nelen-schuurmans.nl">Mario Frasca</a></address>
<!-- Created: Tue Feb  1 11:40:00 CET 2011 -->
<!-- hhmts start -->
Last modified: Tue Feb  1 13:30:59 CET 2011
<!-- hhmts end -->
  </body>
</html>
