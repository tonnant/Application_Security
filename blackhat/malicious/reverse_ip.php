<form method=post action='<?php echo $_SERVER['PHP_SELF'] ?>' >
Masukkan ipadress: <input type=text size=20 value='<?php echo $_POST['ip'] ?>' name=ip />
<input type=submit name=reverse value='Revers It!' />
</form>
<?php
if($_POST['reverse']):

echo "Reversing IP: ".$_POST['ip']."<Br>";
flush();
sleep(1);

$host = "www.ip-adress.com";
$query = "/reverse_ip/".$_POST['ip'];

$sock = fsockopen($host,"80",$errno,$errstr,30);
if ($sock) {
    $get  = "GET ".$query." HTTP/1.1\r\n".
            "Host: ".$host."\r\n".
            "Accept: */*\r\n".
            "User-Agent: HNFox/5.0\r\n".
            "Connection: Close\r\n\r\n";
    fputs($sock,$get);
    while (!feof($sock)) { 
        $output .= trim(fgets($sock, 3600))."\n";            
    }
    fclose($sock);
}
else{
    echo "Failed! Gak bisa konek ke ip-adress.com!";
    exit();
}

$browsing = explode("\n",$output);
$c = 1;
foreach($browsing as $i => $v){
    if(eregi('id="hostcount"',$v)){
        echo "Host Found: ".strip_tags($v)."<Br>";        
    }
    if(eregi('class="odd"',$v) || eregi('class="even"',$v)){
        $key = $i+3;
        echo $c.". ".strip_tags($browsing[$key])."<Br>";
        $c++;
    }
    flush();
    sleep(1);
}
echo "7Reversing Done!";

endif;

exit();

?>
