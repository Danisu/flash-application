<?
/*
	This file provides an interface for user to upload decks from
	the iphone.

	NOTE: This is fairly insecure in this implementation. Use for POC only

*/

require "includes/mysql.php";
require "includes/PasswordHash.php";

if (!isset($_POST['deck_name']))
{
	echo "Hello, ", $_GET[username];
?>

	<br>
	Upload a deck:<br>
	<form enctype="multipart/form-data" action=upload.php?username=<? echo $_GET[username]; ?>&password=<? echo $_GET[password]; ?> method="post">
<?
//	<input type="hidden" name="MAX_FILE_SIZE" value="2000000">
?>
	Card data: <input type="text" name="card_data">
	<br>
	Deck name: <input type="text" name="deck_name">
	<br>
	Cards in deck: <input type="text" name="numcards">
	<br>
	Private (0=no, 1=yes): <input type="text" name="private">
	<br>
	Deck description: <input type="text" name="deckdesc">
	<br>
	<input name="upload" type="submit" value="Upload">
	<input type="reset">
	</form>

<?
}

// a file has been uploaded. make sure size is > 0 or upload failed
//if (isset($_POST['upload']) && $_FILES['db_file']['size'] > 0 && strlen($_POST['deck_name']) > 0)
else
{
	$link = db_connect();

	// do login stuff
	// get the row of the given username
	$query = "select name, password from users where name='$_GET[username]'";
	$result = mysqli_query($link, $query);
	$row = mysqli_fetch_array($result);

	// validate password
	$hasher = new PasswordHash(12, FALSE);
	if ($hasher->CheckPassword($_GET['password'], $row['password']))
	{
		// debug stuff
		/*
		$myfile = "/tmp/testfile.txt";
		$fh = fopen($myfile, 'w');
	//	fwrite($fh, mysqli_error($link));
		fwrite($fh, "File name: ");
		fwrite($fh, $_POST['deck_name']);
		fwrite($fh, "\nFile size: ");
		fwrite($fh, $_FILES[db_file][size]);
		fwrite($fh, "\ndatabase uploaded...?\n");
		*/

/*
XXX: for file uploading
		// add the file to database
		$file = fopen($_FILES['db_file']['tmp_name'], 'r');
		$content = fread($file, filesize($_FILES['db_file']['tmp_name']));

		// encode data so it remains uncorrupted
		$content = base64_encode($content);

		fclose($file);

		$filesize = $_FILES[db_file][size];
		$query = "insert into deckdbs (username, name, size, deckdb) " .
			"VALUES ('$_GET[username]', '$_POST[deck_name]', '$filesize', 
			'$content')";
*/
		$content = base64_encode($_POST[card_data]);
		$size = strlen($content);
		$query = "insert into deckdbs (username, name, size, numcards, private, deckdesc, deckdb) " .
			"VALUES ('$_GET[username]', '$_POST[deck_name]', '$size', '$_POST[numcards]', '$_POST[private]', '$_POST[deckdesc]', 
			'$content')";
		mysqli_query($link, $query);

		// debug stuff
//		echo "Query: ", $query;
//		echo "<br>Error: ", mysqli_error($link), "<br>File size: ", $_FILES[db_file][size], "<br>";

		echo "<h4>Database successfully uploaded!</h4>";
	}

	// Invalid username
	else
	{
		echo "<h4>Invalid username or password.</h4>";
	}
}

@mysqli_close($link);
?>
