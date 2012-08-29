<?php
	session_start();
	$crypt_pw = md5("admin"); // Login Passwort eintragen
	if(isset($_SESSION['keeper_loggedin'])){
			
	}else{
		include('include/login.php');
		die();
	}
?>
