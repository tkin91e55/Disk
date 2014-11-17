<?php
//主機位址
$dbhost = 'localhost';
//資料庫名稱
$dbname = 'highscore';
//資料表名稱
$dbtablename = 'ranking';
//資料庫使用者名稱
$dbuser = 'root';
//database password
$password = "a97077";

//MySQL 連接
mysql_connect($dbhost,$dbuser,$password) or die(mysql_error());
//資料庫連接
mysql_select_db($dbname) or die(mysql_error());

if( $_POST['download'] != NULL ) {

	$query = "select * from $dbtablename order by score desc";
	$result = mysql_query($query) or die(mysql_error());
	$rows = mysql_num_rows($result);

	for($cnt = 0; $cnt < $rows; $cnt++) {

		$row = mysql_fetch_array($result);
		echo "\nName = " . $row[1];
		echo " Score = " . $row[2];
	}
}

?>