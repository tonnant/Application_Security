<?php

/*\
  * Class Input Filter
  * Input Filter from any injection by Get Method
  \*/

class SecuritySuite {
	public $SQLiCheatSheet;
	public $InclusionCheatSheet;
	public $XSSCheatSheet;
	public $RCECheatSheet;
	public $RegisteredRequest;
	public $DefaultInclude;
	public $HTTP_GET_VARS;
	private $SQLiChars		= array("-","_","*","/","'","\""," ","=","+","(",")","@","%20","\\","%22","%27");
	private $FileInclusion	= array("..","/","http",":","?","%00","%");
	private $XSSCheat		= array("<",">","%3C","%3E","%20","%22");
	private $StandartRCE	= array("|",";");
	private $Request;
	private $Check;
	
	function __construct(){
		error_reporting(0);
		$this->Request = $_SERVER[QUERY_STRING];
		unset($_GET);
		unset($_REQUEST);
		unset($HTTP_GET_VARS);
		unset($_SERVER[QUERY_STRING]);
	}
	
	public function Filter(){ 
		$this->AdditionalCheat();
		$this->RegisteredRequest();
		$REQUESTS = explode("&",$this->Request);
		for($i=0; $i< count($REQUESTS); $i++){		
			$get = substr($REQUESTS[$i],0,(strpos($REQUESTS[$i],"=")));
			$val = substr($REQUESTS[$i],(strpos($REQUESTS[$i],"=")+1),strlen($REQUESTS[$i]));
			if($this->RegisteredRequest && !in_array($get,$this->RegisteredRequest))continue;
			$this->Check = strip_tags($val);
			$this->CheckIt();
			$_GET[$get]=$this->Check;
		}		
		$this->SetVars();
	}
	
	private function CheckIt(){	
		$this->XSSCleaner();
		$this->SQLiCleaner();		
		$this->RCECleaner();
		$this->InclusionCleaner();
	}
	
	private function SQLiCleaner(){
		for($i = 0; $i <= strlen($this->Check); $i++){
			if(!in_array(substr($this->Check,$i,1),$this->SQLiChars)) { 
				$filtered .= substr($this->Check,$i,1);
			}		
		}
		foreach($this->SQLiChars as $Cheat){ 
			$this->Check = str_replace($Cheat,"",$filtered);
		}
	}

	private function InclusionCleaner(){
		if($this->DefaultInclude){
			foreach($this->FileInclusion as $Cheat){				
				if(eregi("/$Cheat/",$this->Check)){
					$this->Check = $this->DefaultInclude;
					return;
				}
			}
		}
		foreach($this->FileInclusion as $Cheat){
			$this->Check = str_replace($Cheat,"",$this->Check);
		}
	}

	private function XSSCleaner(){
		foreach($this->XSSCheat as $Cheat){
			$this->Check = strip_tags($this->Check);
			$this->Check = str_replace($Cheat,"",$this->Check);		
		}
	}
	
	private function RCECleaner(){
		foreach($this->StandartRCE as $Cheat){
			$this->Check = str_replace($Cheat,"",$this->Check);
		}
	}
	
	private function AdditionalCheat(){
		if($this->SQLiCheatSheet){
			$x = explode(",",$this->SQLiCheatSheet);
			foreach($x as $val){
				$this->SQLiChars[] = $val;
			}
		}
		if($this->InclusionCheatSheet){
			$x = explode(",",$this->InclusionCheatSheet);
			foreach($xs as $val){
				$this->FileInclusion[] = $val;
			}
		}
		if($this->XSSCheatSheet){
			$x = explode(",",$this->XSSCheatSheet);
			foreach($xs as $val){
				$this->XSSCheat[] = $val;
			}
		}
		if($this->RCECheatSheet){
			$x = explode(",",$this->RCECheatSheet);
			foreach($xs as $val){
				$this->StandartRCE[] = $val;
			}
		}
	}
	
	private function RegisteredRequest(){
		if(!$this->RegisteredRequest)return;
		$x = explode(",",$this->RegisteredRequest);
		$this->RegisteredRequest = $x;
	}
	
	function SetVars(){
		if($_GET){
			$_REQUEST = $_GET;
			$HTTP_GET_VARS = $_GET;
			foreach($_GET as $name => $value){
				$query .= $name."=".$value."&";
			}
			$_SERVER[QUERY_STRING] = $query;			
		}
		$this->HTTP_GET_VARS = $HTTP_GET_VARS;
	}
	
	function __destruct(){
		//do nothing
	}
	
}
?>



#[ CARA PEMAKAIAN ]#

yang pasti script ini harus di include di halaman anda.

include_once("class.security.php");


then setting-setting. Setting ini bersifat optional (bisa di setting, bisa tidak). Anda bisa melakukan configurasi di bagian ini. Jika tidak di perlukan, anda bisa mengosongkan nya, atau menghapus bagian configurasi. Berikut config yang available.

[ injection charsheet ]

secara default, script sudah memiliki charset (sudah tak set). namun jika anda merasa perlu menambahkanya, anda bisa menambahkan di bagian ini. pisahkan setiap karakter dengan tanda koma.
contoh: $Security->SQLiCheatSheet = "/,<,|";

$Security->SQLiCheatSheet		= ""; //SQL Injection CheatSheet
$Security->InclusionCheatSheet	= ""; //File Inclusion CheatSheet
$Security->XSSCheatSheet		= ""; //XSS CheatSheet 
$Security->RCECheatSheet		= ""; //RCE CheatSheet


[ registered request ]

bagian ini, mendefinisikan request variable yang di butuhkan di halaman. nama-nama variable yang di butuhkan di definisikan disini.
jika bagian ini di set, maka variable yang di perbolehkan (dan di filter tentunya) adalah hanya variable yang di set saja. variable yang lain di buang. 
untuk set bagian ini, anda perlu mengetahui semua nama variable yang dipakai di web apps anda. namun, jika anda tidak mengetahui secara pasti variable2 nya, lebih baik tidak perlu di set.
jika tidak di set, maka semua variable akan di cek dan di filter.

Pisahkan setiap variable dengan tanda koma. contoh:

$Security->RegisteredRequest = "vara,varb,varc,varx";

$Security->RegisteredRequest = "";


[ default include page ]

bagian ini berfungsi untuk memberikan halaman default yang di include. hubunganya dengan injeksi remote script atau local script.
jika bagian ini anda set, maka jika dalam variable terdapat karakteristik injeksi inclusion, maka variable tersebut nilainya di rubah dengan default page.
misal, default page anda definisikan index. maka, jika terdapat injeksi inclusion, variable valuenya berubah menjadi index. sehingga aman dari injeksi.
jika tidak di set, maka variable akan di bersihkan dari karakteristik injeksi inclusion. 

$Security->DefaultInclude = ";


selesai sudah bagian config. config yang tidak di perlukan, silahkan di kosongi atau di hapus aja.

Bagian selanjutnya adalah memulai (start) filtering. Bagian ini mutlak di perlukan. Dan letaknya tentu saja di bawah bagian config (jika config di set).

$Security->Filter();


Jika anda menggunakan $HTTP_GET_VARS untuk mengambil variable, anda bisa mengambil variable ini yang telah terfilter dengan cara:
$HTTP_GET_VARS = $Security->HTTP_GET_VARS;


OKE. Jalankan script ini di bagian atas sebelum proses aplikasi anda. Jalankan di setiap halaman, atau halaman inti yang juga di pakai di setiap halaman. Intinya adalah jalankan script ini di semua halaman, terserah bagaimana anda memakainya.

Berikut contoh jika tidak ada config tambahan yang di perlukan sama sekali.

include_once("Classes/class.security.php");
$Security = new SecuritySuite;
$Security->Filter();
$HTTP_GET_VARS = $Security->HTTP_GET_VARS;


OKE. Jika butuh bantuan atau bingung silahkan contact team kami di irc.byroe.net #Network

Script di perbolehkan untuk di edit, di manipulasi, dan di kembangkan sebaik mungkin. 

Thanks.

./ArRay
