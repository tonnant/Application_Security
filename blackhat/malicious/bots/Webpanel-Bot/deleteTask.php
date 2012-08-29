<?php
include('include/config.php');
panel_sql_request("DELETE FROM ".$sql_table['tasks']." WHERE taskID='".$_POST['taskid']."';");
panel_sql_request("DELETE FROM ".$sql_table['done']." WHERE taskID = '".$_POST['taskid']."';");
echo "Task erfolgreich entfernt! Task ID: ".$_POST['taskid'];
?>