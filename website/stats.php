<?
/*
	Provide simple bar graphs about website/database

	NOTE!: The graph CSS & HTML are courtesy of http://grassegger.at/xperimente/charts-daten-semantik-css/

*/

require "includes/mysql.php";

$link = db_connect();

// number of public decks
$query = "select count(*) from deckdbs where private='0'";
$result = mysqli_query($link, $query);
$row = mysqli_fetch_array($result);
$public = $row['count(*)'];

// number of private decks
$query = "select count(*) from deckdbs where private='1'";
$result = mysqli_query($link, $query);
$row = mysqli_fetch_array($result);
$private = $row['count(*)'];

// debug
//echo "Error: ", mysqli_error($link);

$total = $public + $private;
$public_percent = $public / $total * 100;
$private_percent = $private / $total * 100;

$public_percent = round($public_percent, 1);
$private_percent = round($private_percent, 1);
?>

<html>
<head>
<title>Flash Fun - Statistics</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
.chart {
	font-family: Tahoma;
	font-size: .7em;
	border: 1px solid #ccc;
	float: left;
	margin: 0;
	padding: .4em .1em;
}

.chart li {
	list-style: none;
	float: left;
	width: 5em;
	text-align: center;
	background: url(images/chart_bg.gif) center 1.6em no-repeat;
}

.chart li span {
	display: block;
	text-indent: -999em;
	padding-bottom: 90px;
	background: url(images/chart_bg_ol.gif) center -1px no-repeat;
	border-top: 5px solid #fff;
}

.chart strong {
	display: block;
	text-align: center;
	font-weight: normal;
}
</style>
</head>

<body>

<h4>Public/private deck statistics</h4>
<ul class="chart">
<li>Public<span style="background-position: center -<? echo $public_percent; ?>">: </span><strong><? echo $public_percent; ?>% (<? echo $public; ?>)</strong></li>
<li>Private<span style="background-position: center -<? echo $private_percent; ?>">: </span><strong><? echo $private_percent ?>% (<? echo $private; ?>)</strong></li>
<?
/*
<li>Crocodile<span style="background-position: center -87">: </span><strong>87%</strong></li>
<li>Dingo<span style="background-position: center -45">: </span><strong>45%</strong></li>
<li>Emu<span style="background-position: center -23">: </span><strong>23%</strong></li>
*/
?>
</ul>
<p style="clear: both"></p>
<h4>Total decks in website: <? echo $total; ?></h4>
</body>
</html>
