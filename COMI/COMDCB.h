/************************************************************************
**
** $Revision:   1.1  $
**
** $Log:   P:/archive/comi/COMDCB.H_v  $
 *
 *    Rev 1.1   28 Mar 1996 00:21:42   EMMETT
 * Added resource manager and began VDD support.
 *
 *    Rev 1.0   09 Mar 1996 10:04:16   EMMETT
 * Initial check-in
**
**    Rev 1.3   25 Apr 1995 22:08:54   EMMETT
** Further division of source by functionality.
**
**    Rev 1.2   11 Jun 1994 10:32:54   EMMETT
** Changed all references to "Mirror" to "COMscope".
**
**    Rev 1.1   07 Jun 1994 00:18:38   EMMETT
** Added support for DigiBoard.
** Added initialization support for OEM specific loads.
** Fixed bug in StartWriteStream and ProcessModemSignals that caused handshaking problems.
** Fixed hardware tests to set baud rate before testing interrupts.
** Fixed hardware tests off switch to work only for retail version.
**
**    Rev 1.0   16 Apr 1994 08:34:52   EMMETT
** Initial version control archive.
**
************************************************************************/

#ifdef DEBUGGO

#define SHARE 0
#define NO_COMscope 0
#define NO_ADV_UARTS 0
#define DD_level EQ 1
#define x16_BIT 0
typedef unsigned long DWORD;
typedef unsigned short WORD;
#ifndef BYTE
typedef unsigned char BYTE;
#endif
typedef struct _stDevHead
  {
  struct _stDevHead NEAR *pNextHeader;
  WORD sCodeSegment;
  WORD DevAttributes;
  WORD StrategyOffset;
  WORD IDCoffset;
  BYTE abyDeviceName[8];
  WORD wProtectCS;
  WORD wProtectDS;
  WORD wRealCS;
  WORD wRealDS;
#if DD_level > 2
  DWORD dwDevCaps;
#endif
  }DEVHEAD;

#endif

typedef struct _stDeviceParms
  {
  WORD   usSignature                ;
  WORD   usDeviceFlag1              ;
  WORD   usDeviceFlag2              ;
  WORD   usDeviceFlag3              ;

  WORD   wConfigFlags1              ;
  WORD   wConfigFlags2              ;

  WORD   wWrtBufferLength           ;
  WORD   wWrtBufferExtent           ;
  DWORD  dwReadBufferLength         ;
  DWORD  dwReadBufferExtent         ;
#ifndef NO_COMscope
  DWORD  dwCOMscopeBuffLen          ;
  DWORD  dwCOMscopeBuffExtent       ;
#endif
  WORD   wWrtTimeout                ;
  WORD   wRdTimeout                 ;
  WORD   wBaudRateDivisor           ;
  DWORD  dwBaudRate                 ;
  BYTE   byMaxWritePktCount         ;
  BYTE   byMaxReadPktCount          ;

  BYTE   byFlag1                    ;
  BYTE   byFlag2                    ;
  BYTE   byFlag3                    ;
  BYTE   byErrorChar                ;
  BYTE   byBreakChar                ;
  BYTE   byXonChar                  ;
  BYTE   byXoffChar                 ;
  BYTE   byImmediateByte            ;
  WORD   wXonThreshold              ;
  WORD   wXoffThreshold             ;
  WORD   wRTS_DTRoffDelay           ;

  WORD   wIObaseAddress             ;
  WORD   wIntIDregister             ;
  BYTE   byInterruptLevel           ;
  BYTE   byDataLengthMask           ;

  WORD   wDefWrtTimeout             ;
  WORD   wDefRdTimeout              ;
  BYTE   byDefXonChar               ;
  BYTE   byDefXoffChar              ;
  BYTE   byDefErrorChar             ;
  BYTE   byDefBreakChar             ;
  WORD   wDefXoffThreshold          ;
  WORD   wDefXonThreshold           ;
#ifndef NO_COMscope
  WORD   fCOMscopeFunction          ;
#endif
  WORD   wCOMevent                  ;
  WORD   wCOMerror                  ;
  WORD   wDeviceStatus1             ;
  WORD   wDeviceStatus2             ;
  WORD   wInterruptStatus           ;
  WORD   wOpenCount                 ;

#ifndef NO_COMscope
  WORD   wCOMscopeSelector          ;
#endif
#ifndef x16_BIT
  WORD   wRdBuffSelector            ;
#endif
  WORD   wXmitQueueCount            ;
  WORD   wXmitQueueReadPointer      ;
  WORD   oWriteBuffer               ;
  WORD   wWrtTimerCount             ;
  WORD   wWriteTimerStart           ;
  DWORD  dwRdSemaphore              ;
  DWORD  dwWrtSemaphore             ;
  DWORD  dwWriteReqPktQueueHead     ;
  DWORD  dwReadReqPktQueueHead      ;

  WORD   wTxFIFOdepth               ;
  WORD   wUserTxFIFOdepth           ;
  WORD   wRTScount                  ;
  WORD   wReadByteCount             ;
  DWORD  dwReceiveQueueWritePointer ;
  DWORD  dwReceiveQueueReadPointer  ;
  DWORD  oReadBuffer                ;
#ifndef NO_COMscope
  DWORD  dwCOMscopeQWrtPtr          ;
  DWORD  dwCOMscopeQRdPtr           ;
  DWORD  oCOMscopeBuff              ;
#endif
  WORD   wRdTimerCount              ;
  WORD   wReadTimerStart            ;
  WORD   wFIFOcontrolImage          ;
  BYTE   xBaudMultiplier            ;
  BYTE   byMSRimage                 ;
  BYTE   byReadPktQHead             ;
  BYTE   byReadPktQTail             ;
  BYTE   bySNAalertFlags            ;
  BYTE   byFlag2Mask                ;
  BYTE   byDefFlag3                 ;
  BYTE   byHSstatus                 ;
  BYTE   byWritePktQHead            ;
  BYTE   byWritePktQTail            ;
#ifndef x16_BIT
  DWORD  dwReceiveCount             ;
  DWORD  dwTransmitCount            ;
  WORD   wWrtBufferHigh             ;
  DWORD  dwReadBufferHigh           ;
  WORD   wWrtBufferLevel            ;
  DWORD  dwReadBufferLevel          ;
#ifdef VDD_support
  WORD   wVDDflags                  ;
#endif
#endif
  DEVHEAD stDeviceHeader;
#ifndef NO_COMscope
  DEVHEAD stCOMscopeHeader;
#endif
  }DEVDEF;

typedef struct _stInstallParams
  {
  WORD wLID;
  }INSTDEF;


#define DEV_FLAG2_16650_UART          0x0001
#define DEV_FLAG2_16750_UART          0x0002
#define DEV_FLAG2_16654_UART          0x0004
#define DEV_FLAG2_DEVICE_DEINSTALLED  0x4000
#define DEV_FLAG2_PCMCIA_PORT         0x8000

#define DEV_FLAG2_FIFO_AVAILABLE      0x0800

#define DEV_ST_FIFO_AVAILABLE         0x0800


