<?php
/* ################################################################################â€‹#
# [+] File Name : Devilzc0de Backdoor Scanner
# [+] Author : peri.carding
# [+] Thanks goes to :
# [+] Sockaddr_in, shreder.g1rl, stupiditty
################################################################################â€‹## */
putenv("TZ=Europe/Britania");
?>
<head>
<title>Devilzc0de Backdoor Scan</title>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
window.open(theURL,winName,features)
}
//-->
</script>
<style type="text/css">
<!--
body {
font-family: Tahoma;
color: #CCCCCC;
background-color: #000000;
font-size: 11px;
font-weight: bold;
}
.single{
border: 1px solid #00ff00;
padding: 5px;
}
a:visited {
color: #33333;
font-size: 11px;
font-family: tahoma;
text-decoration: none;
}

a:hover {
color: #ccff00;
text-decoration: none;
}
.abunai {
color: red;
text-decoration: none;
}
.xxx {
color: blue;
text-decoration: none;
}
a {
color: #ccff99;
font-size: 11px;
font-family: tahoma;
text-decoration: none;
}
td {
border-style: solid;
border-width: 0 0 1px 0;
font-size:11px; font-family:Tahoma,Verdana,Arial; color:#ccff99;
}
.me {
font-size:11px; font-family:Tahoma,Verdana,Arial; color:#ccff99;
border: 0px;
padding: 5px;
}
.isi:disabled{
padding: 2px;
border:1px solid #333333;
font-family: Tahoma;
color: #333333;
background-color: #000000;
font-size: 10px;
font-weight: bold;
}
.isi{
padding: 2px;
border:1px solid #666666;
font-family: Tahoma;
color: #ccff99;
background-color: #666666;
font-size: 10px;
font-weight: bold;
}
-->
</style>
<style type="text/css">
#patch {position:absolute; height:1; width:1px; top:0; left:0;}
</style>
</head>
<body>
<center><br><font color="#339900" size="14" face="arial">Backdoor Scanner</font></center><br>
<?php
if(isset($_REQUEST['edit']) && $_REQUEST['edit']=='file'){
if(isset($_POST['yes'])){
$filename = $_GET['file'];
echo "<br><br><br><font color=red size=3><b><center>".$filename." deleted...</b></font><br><br><br><br><br><br><br>";
unlink($filename);
echo "<META HTTP-EQUIV=Refresh CONTENT=\"2; URL=javascript:window.close();\">";
}else{
if($_POST['update']) {
$filename = $_POST['file'];
if(is_writable($filename)) {
$handle = fopen($filename, "w+");
$isi=$_POST['content'];
fwrite($handle, stripslashes($isi));
fclose($handle);
$stat= "<center><strong>edited successfully<br>";
} else {
$stat= "<center><font color=red><strong>Error! File may not be writable.</font></center>";
}
}
if($_POST['close']) {
echo "<META HTTP-EQUIV=Refresh CONTENT=\"0; URL=javascript:window.close();\">";
}
$filename = $_GET['file'];
if (file_exists($filename)){
$vuln = $_GET['bug'];
$handle = fopen($filename, "r");
$contents = fread($handle, filesize($filename));
?>
<center>
<table>
<tr><td align="left" class="me"><strong><?=$filename?>&nbsp;&nbsp;>> Contains :&nbsp;<?=$vuln?></strong></td></tr>
<tr><td class="me">
<form method="post" action="">
<input type="hidden" name="file" value="<?=$filename?>">
<textarea name="content" cols="80" rows="15"><?=htmlspecialchars($contents)?></textarea><br>
</td></tr>
<tr><td align="center" class="me">
<?php
if($_POST['delete']) {
echo "Are you sure to delete ".$filename." ?";
?>
<tr><td align="center" class="me">
<input type="submit" name="yes" value=" Y E S ">
<input type="submit" name="no" value=" N O ">
</td></tr>
<?php
}else{
echo $stat;
?>
</td></tr>
<tr><td align="right" class="me">
<input type="submit" name="close" value=" C l o s e ">
<input type="submit" name="delete" value=" D e l e t e ">
<input type="submit" name="update" value=" S a v e ">
</td></tr>
<?php
}
fclose($handle);
?>
</table>
</form>
<?php
}else{
echo "<br><br><br><font color=red size=3><b><center>".$filename." not exist...</b></font><br><br><br><br><br><br><br>";
echo "<META HTTP-EQUIV=Refresh CONTENT=\"4; URL=javascript:window.close();\">";
}
?>
</center>
<?php
}
}elseif(isset($_POST['Submit'])){
$ceks = array('base64_decode','system','passthru','popen','exec','shell_exec','eval','moâ€‹ve_uploaded_file');
foreach($ceks as $ceker){
if($_POST[$ceker]<>""){
$six.=$_POST[$ceker].".";
}
}
$cek = explode('.', $six);
function ListFiles($dir) {
if($dh = opendir($dir)) {
$files = Array();
$inner_files = Array();
while($file = readdir($dh)) {
if($file != "." && $file != ".." && $file[0] != '.') {
if(is_dir($dir . "/" . $file)) {
$inner_files = ListFiles($dir . "/" . $file);
if(is_array($inner_files)) $files = array_merge($files, $inner_files);
}else{
array_push($files, $dir . "/" . $file);
}
}
}
closedir($dh);
return $files;
}
}
$target=$_SERVER['DOCUMENT_ROOT'];
?>
<center>
<table border="0" width="90%" cellpadding="5">
<tr>
<td class="me" align="right" width="30"><b>No</b></td>
<td class="me" align="center" width="105"><b> T y p e </b></td>
<td class="me" align="center"><b> F i l e&nbsp;&nbsp;L o c a t i o n </b></td>
<td class="me" align="center" width="150"><b> L a s t&nbsp;&nbsp;E d i t </b></td>
<td class="me" align="right" width="80"><b>F i l e&nbsp;&nbsp;S i z e</b></td>
</tr><br>
<?php
foreach (ListFiles($target) as $key=>$file){
$nFile = substr($file, -4, 4);
if($nFile == ".php"){
if($file==$_SERVER['DOCUMENT_ROOT'].$_SERVER['PHP_SELF']){
}else{
$ops = @file_get_contents($file);
$op=strtolower($ops);
$arr = array('c99_buff_prepare' => 'c 9 9',
'abcr57' => 'r 5 7');
$sis=0;
if($op)
$size=filesize($file);
$last_modified = filemtime($file);
$last=date("M-d-Y H:i", $last_modified);
foreach($arr as $key => $val) {
if(@preg_match("/$key/", $op)) {
$sis=1;
$i++;
?>
<tr style ="background-color: Your background Color;" onmouseover="mover(this)" onmouseout="mout(this)">
<td align="right"><font color="red"><blink><?=$i?></blink></font></td>
<td align="center"><font color="red"><blink><?=$val?></blink></font></td>
<td align="left"><blink>
<a href="#" class="abunai" onclick="MM_openBrWindow('?edit=file&file=<?=$file?>&bug=<?=$val?>','File view','status=yes,scrollbars=yes,width=700,height=600')" rel="nofollow"><?=$file?></a>
</blink></td>
<td align="center"><font color="red"><blink><?=$last?> GMT+9</blink></font></td>
<td align="right"><font color="red"><blink><?=$size?> byte</blink></font></td>
<script language="javascript">
var bgcolor = "transparent";
var change_color = "#444444"
function mover(aa) {
aa.style.backgroundColor = change_color;
}
function mout(aa) {
aa.style.backgroundColor = bgcolor;
}
</script>
</tr>
<?php
}
}
if($sis<>"1"){
if((@preg_match("/system\((.*?)\)/", $op))&&(@preg_match("/<pre>/", $op))&&(@preg_match("/empty\((.*?)\)/", $op))) {
$sis="2";
$i++;
$val="hidden shell";
?>
<tr style ="background-color: Your background Color;" onmouseover="mover(this)" onmouseout="mout(this)">
<td align="right"><font color="blue"><?=$i?></font></td>
<td align="center"><font color="blue"><?=$val?></font></td>
<td align="left">
<a href="#" class="xxx" onclick="MM_openBrWindow('?edit=file&file=<?=$file?>&bug=<?=$val?>','File view','status=yes,scrollbars=yes,width=700,height=600')" rel="nofollow"><?=$file?></a>
</td>
<td align="center"><font color="blue"><?=$last?> GMT+9</font></td>
<td align="right"><font color="blue"><?=$size?> byte</font></td>
<script language="javascript">
var bgcolor = "transparent";
var change_color = "#444444"
function mover(aa) {
aa.style.backgroundColor = change_color;
}
function mout(aa) {
aa.style.backgroundColor = bgcolor;
}
</script>
</tr>
<?php
}
}
if($sis=="0"){
foreach($cek as $bugs) {
if ($bugs<>""){
if(@preg_match("/$bugs\((.*?)\)/", $op)) {
$i++;
?>
<tr style ="background-color: Your background Color;" onmouseover="mover(this)" onmouseout="mout(this)">
<td align="right"><?=$i?></td>
<td align="center"><?=$bugs?></td>
<td align="left">
<a href="#" onclick="MM_openBrWindow('?edit=file&file=<?=$file?>&bug=<?=$bugs?>','File view','status=yes,scrollbars=yes,width=700,height=600')" rel="nofollow"><?=$file?></a>
</td>
<td align="center"><?=$last?> GMT+9</td>
<td align="right"><?=$size?> byte</td>
<script language="javascript">
var bgcolor = "transparent";
var change_color = "#444444"
function mover(aa) {
aa.style.backgroundColor = change_color;
}
function mout(aa) {
aa.style.backgroundColor = bgcolor;
}
</script>
</tr>
<?php
}
}
}
}
if($_POST['textV']<>""){
$text=$_POST['textV'];
if(@preg_match("/$text/", $op)) {
$i++;
?>
<tr style ="background-color: Your background Color;" onmouseover="mover(this)" onmouseout="mout(this)">
<td align="right"><?=$i?></td>
<td align="center"><?=$text?></td>
<td align="left">
<a href="#" onclick="MM_openBrWindow('?edit=file&file=<?=$file?>&bug=<?=$text?>','File view','status=yes,scrollbars=yes,width=700,height=600')" rel="nofollow"><?=$file?></a>
</td>
<td align="center"><?=$last?> GMT+9</td>
<td align="right"><?=$size?> byte</td>
<script language="javascript">
var bgcolor = "transparent";
var change_color = "#444444"
function mover(aa) {
aa.style.backgroundColor = change_color;
}
function mout(aa) {
aa.style.backgroundColor = bgcolor;
}
</script>
</tr>
<?php
}


}
}
}
}
if($i==0){
foreach($cek as $bugs) {
if ($bugs<>""){
$x++;
?>
<tr style ="background-color: Your background Color;" onmouseover="mover(this)" onmouseout="mout(this)">
<td align="right"><?=$x?></td>
<td align="center"><?=$bugs?></td>
<td align="center"> not exist </td>
<td align="center"> no record </td>
<td align="right"> -&nbsp;&nbsp;&nbsp;&nbsp;byte </td>
</tr>
<?php
}
}
}
?>
</table>
<?php
}else{
$find = array('default','base64_decode','system','passthru','popen','exec','shell_exec',â€‹'eval','move_uploaded_file');
?>
<form id="fCheck" name="fCheck" method="post" action="" autocomplete="off">
<center>
<table class="single" width="400" border="1" cellpadding="10">
<tr><td class="me"><center>
<b>S e l e c t &nbsp;&nbsp;s c a n&nbsp;&nbsp;t y p e :</b><br>
<table class="me" width="200">
<tr><td class="me">
<script language="javascript">
function cekKlik(){
if (!document.fCheck.cekV.checked)
document.fCheck.textV.disabled=true;
else
document.fCheck.textV.disabled=false;
if(document.fCheck.cekV.checked){
om = om + 1;
}else{
if(om > 0 ){
om = om - 1;
}else{
om = om;
}
}
if(om != 0){
document.fCheck.Submit.disabled=false;
}else{
document.fCheck.Submit.disabled=true;
}
}
</script>
<?php
//dari sini
foreach($find as $bug) {
?>
<script language="javascript">
var om = 0;
function checkValue<?=$bug?>(){
if(document.fCheck.<?=$bug?>.checked){
om = om + 1;
}else{
if(om > 0 ){
om = om - 1;
}else{
om = om;
}
}
if(om != 0){
document.fCheck.Submit.disabled=false;
}else{
document.fCheck.Submit.disabled=true;
}
}
</script>
<input onclick="checkValue<?=$bug?>();" name="<?=$bug?>" type="checkbox" id="<?=$bug?>" value="<?=$bug?>" />&nbsp;<?=$bug?><br>
<?php
}
?>
<input name="cekV" type="checkbox" onClick="cekKlik();" id="cekV" value="cekV">
<input class="isi" disabled="disabled" name="textV" value="other key word" onFocus="this.select()" type="text" id="textV">
<br><br>
<input type="hidden" name="asal" value="abcd">
<input disabled="disabled" type="submit" name="Submit" value=" S t a r t&nbsp;&nbsp;S c a n " />
</td></tr>
</table>
</td></tr></table>
</form>
<?
}
?>
<br><br><hr width="300">
<center>
Backdoor Scanner BDS &copy peri.carding 2011
<br><br>
</body>
