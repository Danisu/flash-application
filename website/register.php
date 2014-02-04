<?
/*
	This file allows a user to register on the website

*/

$title = "Register";
require "includes/header.php";

/*
	Print out the form with possible error messages
*/
function show_form($username_error=false, $email_error=false, $password_error=false)
{
	if ($username_error)
		$username_msg = "Invalid username or username taken<br>";

	if ($email_error)
		$email_msg = "Invalid e-mail<br>";

	if ($password_error)
		$password_msg = "Password does not match or is not long enough<br>";

?>

	<div id="input_area">
	<form action="register.php" method="post">
	Username: <input type="text" size="20" name="username" maxlength="20" />
<?
	if (isset($username_msg))
	{
		echo "<div class=text_notify>", $username_msg, "</div><br>";
	}
?>

	E-mail (optional): <input type="text" size="30" name="email" />
<?
	if (isset($email_msg))
	{
		echo "<div class=text_notify>", $email_msg, "</div><br>";
	}
?>

	Password: <input type="password" size="30" name="password" maxlength="40" />
<?
	if (isset($password_msg))
	{
		echo "<div class=text_notify>", $password_msg, "</div><br>";
	}
?>

	Password (confirm): <input type="password" size="30" name="confirm_password" maxlength="40" />
	<div>Note: password must be between 6 and 40 characters, inclusive</div>
	<input type="submit" name="register_form" value="Register" />
	<input type="reset" value="Reset" />
	</form>
	</div>

	<br>
	<div class="button_form">
	<div class="clear">
	<a href="login.php" class="button"><span>Login</span></a></div>
	</div>
	</div>

<?
}

// if user is logged in already
if (isset($_SESSION['username']))
{
	require "includes/blurb.php";
}

else
{

	if (!isset($_POST['register_form']))
	{
		show_form();
	}

	// form has been submitted
	else
	{
		$username_error = false;
		$email_error = false;
		$password_error = false;

		$link = db_connect();

		// Store password in $hash
		$hasher = new PasswordHash(12, FALSE);
		$hash = $hasher->HashPassword($_POST['password']);

		// username checks
		if ($_POST["username"] == "")
		{
			$username_error = true;
		}

		// check if username is taken
		$user_result = mysqli_query($link, "SELECT * from users where name='$_POST[username]'");
		if (mysqli_num_rows($user_result) != 0)
		{
			$username_error = true;
		}

		// password checks
		if (strlen($_POST["password"]) < 6)
		{
			$password_error = true;
		}

		if ($_POST["password"] != $_POST["confirm_password"])
		{
			$password_error = true;
		}

		// Only if e-mail is invalid, since e-mail is optional
		if ($_POST["email"] != "" && (strlen($_POST["email"]) < 7 || !preg_match("/^[a-zA-Z0-9_\\-\\.+]+@[a-zA-Z0-9_\\-\\.+]+.[a-zA-Z]+$/", $_POST["email"])))
		{
			$email_error = true;
		}

		// if some error, show form again. don't add the user
		if ($username_error || $password_error || $email_error)
		{
			show_form($username_error, $email_error, $password_error);
		}

		// add the user to db and redirect to home
		else
		{
			// do the actual query
			$sql = "INSERT into users (name, email, password) values('$_POST[username]', '$_POST[email]', '$hash')";
			$result = mysqli_query($link, $sql);

			$_SESSION['username'] = $_POST['username'];

			require "includes/blurb.php";
		}

	}

}

@mysqli_close($link);

require "includes/footer.php";

?>
