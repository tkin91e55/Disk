<?php
//主機位址
$dbhost = 'localhost';
//資料庫名稱
$dbname = 'highscore';
//資料表名稱
$dbtablename = 'ranking';
//資料庫使用者名稱
$dbuser = 'root';

//MySQL 連接
mysql_connect( $dbhost, $dbuser) or die(mysql_error());
//資料庫連接
mysql_select_db($dbname) or die(mysql_error());

if( $_POST['name']) != NULL &&