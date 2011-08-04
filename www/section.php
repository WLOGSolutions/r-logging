<html>
<?php

$pages = array(1 => "the_basics",
2 => "hierarchical_loggers",
3 => "logger_objects",
4 => "logging_to_file",
5 => "formatting_your_log_records",
6 => "writing_your_own_handlers");

?>
<head>
<title>tutorial : <?php echo $pages[(int)$_GET['page']]; ?></title>
<link href="additions.css" rel="stylesheet" type="text/css" />
</head>
<body>

<blockquote>
<p>
<a href="sample_session.php">[back to the tutorial]</a> &nbsp;
<?php if($_GET['page'] > 1) { echo "<a href=\"section.php?page="; echo (int)$_GET['page'] - 1; echo "\">"; } ?>[previous session]<?php if($_GET['page'] > 1) echo "</a>"; ?> &nbsp;
<?php if($_GET['page'] < 6) { echo "<a href=\"section.php?page="; echo (int)$_GET['page'] + 1; echo "\">"; } ?>[next session]<?php if($_GET['page'] < 6) echo "</a>"; ?> &nbsp;
</p>
</blockquote>

<?php include($pages[(int)$_GET['page']] . ".shtml"); ?> 

</body>
</html>
