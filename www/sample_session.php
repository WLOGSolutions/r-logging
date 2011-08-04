<html>
<head>
  <title>sample sessions</title>
  <link href="additions.css" rel="stylesheet" type="text/css" />
</head>
<body>

<blockquote>
<p><a href="index.php">[project home]</a> &nbsp;</p>
</blockquote>

<h3>annotated sample sessions</h3>


<p>this is a minimal tutorial, showing by example what you can do with
and expect from this library.  this text is directed to scripts
authors who want to be able to log the activity of their programs.</p>

<p>this page is organized in sections.  each section can be seen and
tried out as a separate R session.  at the end of the section there's
a link to a R script with the R instructions tried in the section.</p>

<p>the same information, one page at a time:
<a href="section.php?page=1">[the basics]</a>
<a href="section.php?page=2">[hierarchical loggers]</a>
<a href="section.php?page=3">[logger objects]</a>
<a href="section.php?page=4">[logging to file]</a>
<a href="section.php?page=5">[formatting your log records]</a>
<a href="section.php?page=6">[writing your own handlers]</a>
</p>

<?php include("the_basics.shtml"); ?> 
<?php include("hierarchical_loggers.shtml"); ?> 
<?php include("logger_objects.shtml"); ?> 
<?php include("logging_to_file.shtml"); ?> 
<?php include("formatting_your_log_records.shtml"); ?> 
<?php include("writing_your_own_handlers.shtml"); ?> 

</body>
</html>
