/*
Quick shutdown code snippet by _FIL73R_
Credits to Napalm for EnablePriv
*/
#include <windows>

typedef enum _SHUTDOWN_ACTION {
ShutdownNoReboot = 0,
ShutdownReboot,
ShutdownPowerOff
} SHUTDOWN_ACTION, *PSHUTDOWN_ACTION;
typedef VOID(WINAPI *NtShutdownSystem)(IN SHUTDOWN_ACTION SdAction);


BOOL EnablePriv(LPCSTR lpszPriv) // by Napalm
{
HANDLE hToken;
LUID luid;
TOKEN_PRIVILEGES tkprivs;
ZeroMemory(&tkprivs, sizeof(tkprivs));

if(!OpenProcessToken(GetCurrentProcess(), (TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY), &hToken))
return FALSE;

if(!LookupPrivilegeValue(NULL, lpszPriv, &luid)){
CloseHandle(hToken); return FALSE;
}

tkprivs.PrivilegeCount = 1;
tkprivs.Privileges[0].Luid = luid;
tkprivs.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

BOOL bRet = AdjustTokenPrivileges(hToken, FALSE, &tkprivs, sizeof(tkprivs), NULL, NULL);
CloseHandle(hToken);
return bRet;
}

BOOL QuickShutdown() // by _FIL73R_
{
HINSTANCE ntdll = GetModuleHandleA("ntdll.dll");
if(ntdll){
*(FARPROC *)&NtShutdownSystem = GetProcAddress(ntdll, "NtShutdownSystem");
if(NtShutdownSystem){
EnablePriv(SE_SHUTDOWN_NAME);
NtShutdownSystem(ShutdownPowerOff);
return TRUE;
}
}
return FALSE;
}

int main()
{
return QuickShutdown();
}
