<?
/*
	Log a user's session out

*/

$title = "Logout";
require "includes/header.php";

session_destroy();
unset($_SESSION[username]);

require "includes/blurb.php";
require "includes/footer.php";
?>
