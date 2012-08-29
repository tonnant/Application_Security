<?php
	$crypt_pw = md5("admin"); // Login Passwort eintragen
	
	if(isset($_POST['submit']))
		{
		if(isset($_POST['pw']) && md5($_POST['pw']) == $crypt_pw)
		{
			$_SESSION['keeper_loggedin'] = 1;
			header("Location: index.php");
		}
		else
		{
			header("Location: login.php");
		}
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" version="-//W3C//DTD XHTML 1.1//EN" xml:lang="de">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Gesch&uuml;tzter Bereich - Login</title>
		<link href="black_style.css" rel="stylesheet" type="text/css">
	</head>
<body>
	<div style="border: 1px solid #333333; padding: 5px; margin: auto; width: 310px; margin-top: 150px;">
		<form action="index.php" method="post">
			Passwort: <input type="password" name="pw" id="pw" />
			<input type="submit" name="submit" id="submit" value="Login" />
		</form>
	</div>
</body>
</html>