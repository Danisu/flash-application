<?
/*
	Provide a listing of decks available to download (public)
	to be parsed in iPhone. Also send card data if a deck id is
	given

	Format for public deck listing: id|||deck name|||deck desc\nid|||deck name|||deck desc
	Format for cards listing: question ||| answer ||| hint ^^^ question ||| answer ||| hint

	NOTE: This is insecure code. POC only.
	Known bug: Allows fetching of non private decks if manually entered

*/

require "includes/mysql.php";

// connect to db
$link = db_connect();

// no id given for a deck; list all public decks
if (!isset($_GET['id']))
{
	// get all public databases and display
	$query = "select * from deckdbs where private='0'";
	$result = mysqli_query($link, $query);

	while($row = mysqli_fetch_array($result))
	{
		echo $row['id'], "|||", $row['name'], "|||", $row['deckdesc'], "\n";
	}
}

else
{
	$query = "select deckdb from deckdbs where id='$_GET[id]'";
	$result = mysqli_query($link, $query);
	$row = mysqli_fetch_array($result);
	$content = base64_decode($row['deckdb']);
	echo $content;
}

// debug
//echo "Query: ", $query;
//echo "Error: ", mysqli_error($link);

@mysqli_close($link);
?>
