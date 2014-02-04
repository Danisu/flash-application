<?
/*
	This file provides a login form for users to log in to the website

*/

$title = "Login";
require "includes/header.php";

/*
	Output the login form
*/
function show_login()
{
?>
	<div id="input_area">
	<form action="login.php" method="post">
	Username: <input type="text" size="20" name="username" maxlength="20" />
	<br />
	Password: <input type="password" size="30" name="password" maxlength="40" />
	<br />
	<input type="submit" name="login_form" value="Login" />
	<input type="reset" value="Reset" />
	</form>
	</div>

	<br>
	<div class="button_form">
	Don't have an account?
	<div class="clear">
	<a href="register.php" class="button"><span>Register here</span></a>
	</div>
	</div>

<?
}

// user is not logged in. show login page
if (!isset($_SESSION['username']))
{
	// form hasn't been submitted yet
	if (!isset($_POST['login_form']))
	{
		show_login();
	}

	// user has submitted with some data
	else	
	{
		$link = db_connect();

		// get the row of the given username
		$query = "select name, password from users where name='$_POST[username]'";
		$result = mysqli_query($link, $query);
		$row = mysqli_fetch_array($result);

		// validate password
		$hasher = new PasswordHash(12, FALSE);
		if ($hasher->CheckPassword($_POST['password'], $row['password']))
		{
			$_SESSION["username"] = $_POST["username"];
			require "includes/blurb.php";
		}

		// Invalid username
		else
		{
?>
			<div class="text_notify">
<?
			echo "Invalid username or password</div>";
			show_login();
		}

		// Debug stuff
		/*
		echo "<br>Username: " . $_POST['username'];
		echo "<br>Password: " . $_POST['password'];
		echo "<br>Got username: " . $row['name'];
		echo "<br>Got password: " . $row['password'];
		*/

	}

}

// user is already logged in
else
{
	require "includes/blurb.php";
}

@mysqli_close($link);

require "includes/footer.php";
?>
