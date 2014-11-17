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

if( $_POST['name'] != NULL && $_POST['score'] != NULL) {

	//echo 可以在Unity 中的 Console 面板顯現
	echo 'Ranking Update';

	$name = $_POST['name'];
	$score	= (int)$_POST['score'];

	$query = "insert into $dbtablename(id, name, score) values (null, '$name', '$score')";
	$result = mysql_query($query) or die(mysql_error());
}

?>