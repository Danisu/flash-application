<?
/*
	Provide some functions for mysql that are used repeatedly

*/

/*
	Connect to mysql server
*/
function db_connect()
{
	// connect to database
	$link = mysqli_connect('localhost', 'ttb', 'ttb', 'ttb')
		or die("Could not connect: " . mysqli_error());
	
	// select database
	/*
	mysqli_select_db($link, 'ttb')
		or die("Unable to select database");
	*/

	return $link;
}
