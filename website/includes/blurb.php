<?
/*
	Notify user and provide links around site

*/
?>

<br>
<div class="text_announce">

<?
if (isset($_SESSION["username"]))
{
?>

	<div class="text_announce">Hello

<?
	echo $_SESSION["username"];
?>

	!<br>
	<div class="clear">
	<a href="home.php" class="button"><span>Home</span></a>
	<a href="logout.php" class="button"><span>Logout</span></a><br>
	</div>

<?
}

// not logged in
else
{
?>

	<div class="clear">
	<a href="login.php" class="button"><span>Login</span></a>
	</div>

<?
}
?>

</div>
