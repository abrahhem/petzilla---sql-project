<?php
	$dbhost = "127.0.0.1";
	$dbuser = "root";
	$dbpass = "";
	$dbname = "petzilla";

	$connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
	
	if(mysqli_connect_errno()){
		die("DB connection failed: " . mysqli_connect_errno() . "(" . mysqli_connect_errno() . ")");
	}


	