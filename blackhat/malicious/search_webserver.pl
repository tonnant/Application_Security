#!/usr/bin/perl

use IO::Socket;
use IO::Select;
use Socket;

if(!$ARGV[0]){
     print "usage: ".$0." <netid>\r\nexample: ".$0." 192.168.0.0\r\n";
     exit;
}

@xnet  = split(/\./,$ARGV[0]);
$netid = $xnet[0].".".$xnet[1].".".$xnet[2];

print "Scanning webserver in network range...\r\n";

$i=1;
while($i<255){
     $sock = '';
     $ip = $netid.".".$i;
     $sock = IO::Socket::INET->new(Proto=>"tcp",PeerAddr=>"$ip",PeerPort=>"80",Timeout=>"1");
     if($sock){
          print "[+] ".$ip.":80\r\n";
     }
     $i++;
}

exit;
