<?php
//*********************************************************************************************
//Created by vir0e5 a.k.a banditc0de
//My blog --> http://vir0e5.blogspot.com
//Forum   --> http://indonesian-cyber.org
//Greetz  -->  Allah S.W.T , Mohammad S.A.W
//All Crew :   indonesiancoder,indonesianhacker, devilzc0de, tecon, phl, jatimcrew
//********************************************************************************************* 

echo"<title>Base 64 Encode / Decode</title>";
echo"<div align=center>Base 64 Encode / Decode";
$bandit= stripslashes($_POST['c0de']);
	if ($bandit == "")
	{
		$bandit = $_GET['c0de'];
	}

$action = $_POST['action'];
	if ($action == "")
	{
       $action = $_GET['action'];
          if ($action == "encode"){
          $action = "enc0de";
          }
          elseif ($action == "decode")
          {
          $action = "dec0de";
          }
    }

switch($action){
case "enc0de":
       $output = base64_encode($bandit);
		   if(!$output){
		   echo 'Ada yang salah!!!';
           }

echo"<center><table width='380'><td>";
echo "<p> Input: " . $bandit . "</p>";
echo "<p> Output (Base64): " . $output ."</p>";
echo "<p><a href='javascript:history.back(0);'> << Back </a></p>";
break;

case "dec0de":
$output = base64_decode($bandit);
if(!$output){
echo 'Ada yang salah!!!';
exit;
}

echo"<center><table width='380'><td>";
echo "<p> Input (Base64) : " . $bandit . "</p>";
echo "<p> Output : " . $output ."</p>";
echo "<p><a href='javascript:history.back(0);'> << Back </a></p>";
break;

default: echo '<form id="form1" name="form1" method="post" action="?encode/decode">
            <p>
               <textarea name="c0de" id="c0de" rows=8 cols=40 ></textarea>
            </p>
          
		  <p>Pilih yang mau di cari</p>
		  
		  <p><input type=radio name="action" id="action" value="enc0de">Encode</p>
          <p><input type=radio name="action" id="action" value="dec0de">Decode</p>

        <input type="submit" class = "button" name="submit" id="submit" onClick="
		if(c0de.value==\'\'){alert(\'mana teksnya kang???\'); return false;}" value="Submit" />
		<input type="reset" name="reset" class="button" value="Reset"/>

    </p>
  </form>';
  
break;
}
?>
