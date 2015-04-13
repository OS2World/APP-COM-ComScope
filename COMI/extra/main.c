#define INCL_DOSDEVICES

#include "os2.h"
#include <string.h>
#include "COMDD.H"
#include "COMDCB.H"

DEVHEAD stAuxHeader;
DEVHEAD astDeviceHeader[8];
DEVHEAD astCOMscopeHeader[8];
COMDCB *pstComDCB;
ULONG ulFilePosition;
VOID *pFileBuffer;
WORD wLoadNumber;
WORD wLoadFlags;
BYTE *pbyData;
DEVHEAD stAuxHeader = {0,0,0,0,0,"OS$tools",0,0,0,0};
DEVHEAD stDummyHeader = {0,0,0,0,0,"sloot$SO",0,0,0,0};

COMDCB stInitComDCB;
#ifdef this_junk
   = {0,0,DEF_WRITE_BUFFER_LEN,DEF_READ_BUFFER_LEN,
                       DEF_MIRROR_BUFF_LEN,DEF_WRITE_TIMEOUT,
                       DEF_READ_TIMEOUT,DEF_BAUD_DIVISOR,
                       DEF_BAUD,DEF_WRITE_PKT_QUEUE,
                       DEF_READ_PKT_QUEUE,F1_DEFAULT,F2_DEFAULT,F3_DEFAULT,
                       0,0,'\x11','\x13',0,(DEF_READ_BUFFER_LEN / 2),
                       0x20,DEF_RTS_OFF_DELAY,0x3f8,4,DEF_DATA_LEN_MASK,
                       DEF_WRITE_TIMEOUT,DEF_READ_TIMEOUT,'\x11',
                       '\x13',0,0,0,0};

DEVHEAD astTestDeviceHeader[] = {{0,0,0,0,"COM1    ",0,0,0,0},
                                 {0,0,0,0,"COM2    ",0,0,0,0},
                                 {0,0,0,0,"COM3    ",0,0,0,0},
                                 {0,0,0,0,"COM4    ",0,0,0,0},
                                 {0,0,0,0,"COM5    ",0,0,0,0},
                                 {0,0,0,0,"COM6    ",0,0,0,0},
                                 {0,0,0,0,"COM7    ",0,0,0,0},
                                 {0,0,0,0,"COM8    ",0,0,0,0}};

#endif
BYTE abyFileBuffer[MAX_BUFFER];

COMDCB astComDCB[8];

BYTE abyCOMnumbers[8];
BYTE abyString[256];
WORD wLoadCount;
WORD wIntIDtable[4];
sBOOL bVerbose;
BYTE abyPath[512] = "d:\\projects\\comi\\comdd.sys Version 3.30 950101";
BYTE abyFileBuffer[MAX_BUFFER];
BYTE abyFileSpec[256];
WORD bPrintLocation;
WORD wCOMstart;
WORD wCOMlast;
WORD wIntIDregister;
BOOL bSharedInterrupts;

DEVDEF DeviceParms[16];
BYTE byOEMtype;

DEVHEAD stDefaultDevHeader = {0,0,0,0,0,"COM     ",0,0,0,0};

WORD wEndOfData;
WORD wDelayCount;
int iDataIndex;
char chFailedOpen[] = {"\x07\nFailed to open response File\n"};
char chFailedRead[] = {"\x07\nFailed to read response File\n"};
char chResponseFileBad[] = {"\nResponse file does not properly define devices.\n"};
char chProcessing[] = {"\nProcessing response file\n"};
char chFailedReadIni[] = {"\nFailed on Read from Initialization File\n"};
char chFailedWriteIni[] = {"\nFailed on Write to Initialization File\n"};
char chFailedIniCorrupt_1[] = {"\nCOMx "};
char chFailedIniCorrupt_2[] = {"\nInitialization File Corrupt\n"};
char chFailedIniNotInit_1[] = {"\nCOMx "};
char chFailedIniNotInit_2[] = {"\nInitialization File Not Initialized for this load\n"};
char chFailedBadPath[] = {"[1mBad Path Stored at Initialization[0m"};
char chFailedBadVersion_1[] = {"\nCOMx "};
char chFailedBadVersion_2[] = {"\nIncorrect version\n"};
BYTE abyNumber[10];
WORD bIsTheFirst;
char szDefaultPath[CCHMAXPATH];

sBOOL bWaitForCR;

void main(int argc,char *argv[]);
void ErrorExit(void);
void ProcessResponseFile(BYTE FAR abyFileSpec[]);
void GetIniInfo(void);
WORD MakeIniInfo(char szFileSpec[],DEVHEAD astDeviceHeader[],COMDCB astComDCB[],WORD wDCBcount);

DEVDEF *pDeviceParms;
DEVDEF DeviceParms[];
DEVHEAD *pStart;
DEVHEAD *pPrevious;
WORD wDeviceStrategy;

USHORT usDosIOdelayCount = 10;
sBOOL bBreakInitialization;
CFGHEAD stConfigInfo;
WORD wCOMscopeStrategy;
WORD wDriverLoadCount;
WORD wDCBcount;
WORD wMaxDeviceCount;
int iStartDevice;
WORD wOEMjumpEntry;
sBOOL bContinueParse;
DEVHEAD stDCBheader;
int iEndDevice;
BYTE byLoadOEMtype;
WORD wOEMjumpExit;
CFGHEAD stConfigHeader;
WORD wDeviceCount;
WORD wOEMjumpExit;

char achASCIIdigits[] = "0123456789ABCDEF";

char achASCII[14];
WORD ArgMarker;
char achDigitBuffer[14];
ULONG ulTemp;
WORD wTemp;
BYTE byTemp;

void main(int argc,char *argv[])
  {
  WORD wIndex;

  if (argc > 1)
    strcpy(abyPath,argv[1]);
//  memcpy(astDeviceHeader,astTestDeviceHeader,(sizeof(DEVHEAD) * 8));
//  memcpy(astCOMscopeHeader,&astTestDeviceHeader[8],(sizeof(DEVHEAD) * 8));
  ProcessResponseFile("p:\\comi\\comdd.cfg");
  return;
  bIsTheFirst = TRUE;
  GetIniInfo();
  bIsTheFirst = FALSE;
  GetIniInfo();
  }

void ErrorExit(void)
  {
  return;
  }
