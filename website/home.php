<?
/*
	This file provides a control panel if user is logged in, or
	an error screen with link to login if not.


*/

$title = "Home";
require "includes/header.php";

// user isn't logged in
if (!isset($_SESSION['username']))
{
	require "includes/blurb.php";
}

// user is logged in
else
{
	echo "<h3>Hello, ", $_SESSION['username'], "!</h3>";

	// connect to db
	$link = db_connect();

/* This allows for upload through the website, but not needed
 * right now

// should be end of php here
	Upload a deck:<br>
	<form enctype="multipart/form-data" action="home.php" method="post">
	<input type="hidden" name="MAX_FILE_SIZE" value="2000000">
	Filename: <input type="file" name="db_file">
	<br>
	Deck name: <input type="text" name="deck_name">
	<br>
	<input name="upload" type="submit" value="Upload">
	<input type="reset">
	</form>

// should be start of php here
	// a file has been uploaded. make sure size is > 0 or upload failed
	if (isset($_POST['upload']) && $_FILES['db_file']['size'] > 0 && strlen($_POST['deck_name']) > 0)
	{
		$file = fopen($_FILES['db_file']['tmp_name'], 'r');
		$content = fread($file, filesize($_FILES['db_file']['tmp_name']));

		// this might be needed for security, but check whether deck db works
		$content = addslashes($content);

		fclose($file);

		$filesize = $_FILES[db_file][size];

		$query = "insert into deckdbs (username, name, size, deckdb) " .
			"VALUES ('$_SESSION[username]', '$_POST[deck_name]', '$filesize', '$content')";

		mysqli_query($link, $query);

		// debug stuff
		/*
		//echo "Query: ", $query;
		echo "<br>Error: ", mysqli_error(), "File size: ",
			$_FILES[db_file][size], "<br>";
		// should be end of comments

		echo "<h4>Database uploaded</h4>";

	}
*/
?>
	<br>
	Decks
	<table>
	<tr>
		<td>ID</td>
		<td>Deck name</td>
		<td># cards</td>
		<td>Private</td>
		<td>File Size</td>
		<td>Date uploaded</td>
	</tr>

<?
	// get all of user's databases and display
	$query = "select * from deckdbs where username='$_SESSION[username]'";
	$result = mysqli_query($link, $query);
	
	while($row = mysqli_fetch_array($result))
	{
		echo "<tr>",
			"<td>", $row['id'], "</td>",
			"<td>", $row['name'], "</td>",
			"<td>", $row['numcards'], "</td>";
		if ($row['private'])
		{
			$private = "Yes";
		}
		else
		{
			$private = "No";
		}
		echo "<td>", $private, "</td>",
			"<td>", $row['size'], "</td><td>", $row['date'], "</td></tr>";
	}
?>

	</table>
	<br>

	<div class="clear">
	<a href="logout.php" class="button"><span>Logout</span></a>
	</div>

<?
}

@mysqli_close($link);

require "includes/footer.php";

?>
