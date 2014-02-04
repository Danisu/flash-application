<?
/*
	Provide a header for each page

*/

require "PasswordHash.php";
require "mysql.php";

session_start();

// some protection against session stealing
if (!isset($_SESSION['username']))
{
	session_regenerate_id();
}

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<?
	echo "<title>Flash Fun - ", $title, "</title>";
?>
	<link href="style.css" rel="stylesheet" type="text/css" />
	<meta name="description" content="Flash Fun iPhone / iPod Touch Flash Card application">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<div class="text_title">Flash Fun - 
<?
	echo $title;
?>
</div>
