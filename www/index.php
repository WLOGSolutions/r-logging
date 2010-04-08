<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->
<!-- $Id$ -->

<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='http://r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">

  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $group_name; ?></title>
	<link href="<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
	<link href="additions.css" rel="stylesheet" type="text/css" />
  </head>

<body>

<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="/"><img src="<?php echo $themeroot; ?>/images/logo.png" border="0" alt="R-Forge Logo" /> </a> </td> </tr>
</table>


<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->

<?php if ($handle=fopen('http://'.$domain.'/export/projtitl.php?group_name='.$group_name,'r')){
$contents = '';
while (!feof($handle)) {
	$contents .= fread($handle, 8192);
}
fclose($handle);
echo $contents; } ?>

<!-- end of project description -->

<p>What you find here behaves similarly to what you also find in Python's standard logging module.</p>

<p>Far from being comparable to a Python standard module, this tiny logging module does include
<ul>
<li>hierarchic loggers, </li>
<li>multiple handlers at each logger, </li>
<li>the possibility to specify a formatter for each handler (one default formatter is given), </li>
<li>same levels (names and numeric values) as Python's logging package, </li>
<li>a simple basicConfig function to quickly put yourself in a usable situation...</li>
</ul></p>

<p>have a look at a short introductory <a href="sample_session.html">sample session</a>.</p>

<p>This package owes a lot to 
<ul>
<li>Brian Lee Yung Rowe's futile package, </li>
<li>the stackoverflow community </li>
<li>and the documentation of the Python logging package.</li>
</ul></p>

<p>The <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. </p>

</body>
</html>
