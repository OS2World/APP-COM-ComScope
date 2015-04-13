/*--------------------------------------------------------------------------*/
/*           Name: SAFEPAGE.H                                               */
/*                                                                          */
/*    Description: Global header file definitions for Telocator             */
/*                 Alphanumeric Protocol (TAP) to access paging services.   */
/*                                                                          */
/*                                                                          */
/*           Date: Jul 15, 1995                                             */
/*                                                                          */
/*      Copyright: OS/tools Incorporated 1995.                              */
/*                                                                          */
/*       Comments:                                                          */
/*                                                                          */
/*           OS/2: This header file can be include on PM and non-PM         */
/*                 applications.  It can also be used in a multi-threaded   */
/*                 application, however the calling application should      */
/*                 provide the semaphore mechanisms.                        */
/*--------------------------------------------------------------------------*/

#define  INCL_WIN
#define  INCL_BASE
#define  INCL_WINWINDOWMGR
#define  INCL_WINMESSAGEMGR
#define  INCL_DOSDATETIME
#define  INCL_DOSFILEMGR
#define  INCL_DOSDEVICES
#define  INCL_DOSDEVIOCTL
#define  INCL_DOSEXCEPTIONS

#include <os2.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

/*--------------------------------------------------------------------------*/
/* Return code defines                                                      */
/*--------------------------------------------------------------------------*/
#define ID_PAGE_SUCCESS                                         0
#define ID_PAGE_INVALID_PORT                                    1
#define ID_PAGE_BAUD_RATE_NOT_SUPPORTED                         6
#define ID_PAGE_CARRIER_DETECTED                               14
#define ID_PAGE_NAK_OR_REJECTED                                15
#define ID_PAGE_RS_RECEIVED                                    16
#define ID_PAGE_OK                                             ID_PAGE_SUCCESS
#define ID_PAGE_BUSY_SIGNAL                                    17
#define ID_PAGE_NO_DIALTONE                                    18
#define ID_PAGE_NO_CARRIER                                     19
#define ID_PAGE_NO_ANSWER                                      20
#define ID_PAGE_MODEM_NOT_RESPONDING                           21
#define ID_PAGE_REQ_PARMS_MISSING                              22
#define ID_PAGE_DISCONNECTED                                   23
#define ID_PAGE_INVALID_PIN                                    24
#define ID_PAGE_PORT_OUT_OF_RANGE                              25
#define ID_PAGE_PIN_NOT_SPECIFIED                              26

#define ID_PAGE_DEVICE_DRIVER_WRONG_VERSION                    27
#define ID_PAGE_DEVICE_DRIVER_NOT_LOADED                       28
#define ID_PAGE_DEVICE_DRIVER_IN_USE                           29
#define ID_PAGE_DEVICE_DRIVER_UNKNOWN                          30
#define ID_PAGE_DEVICE_DRIVER_IOCTL_ERROR                      31
#define ID_PAGE_MAX_DEMO_USE_REACHED                           32

/*--------------------------------------------------------------------------*/
/* General defines                                                          */
/*--------------------------------------------------------------------------*/
#define TEXT_MESSAGE_LENGTH                                   234
#define MIN_PAGE_RETRIES                                        3
#define MAX_CHARACTERS_PER_BLOCK                               80
#define MAX_PAGES_PER_CALL                                    128
#define MODEM_CODE_SIZE                                        16
#define MODEM_NAME_SIZE                                        50
#define MODEM_SETUP_SIZE                                       40
#define SUBSCRIBER_PIN_SIZE                                    20
#define PRE_MSG_SIZE                                            8
#define MSG_ID_SIZE                                            15
#define GROUP_NAME_SIZE                                        16
#define SND_ID_SIZE                                             8
#define PREFIX_SIZE                                             5
#define SVC_ID_SIZE                                             8
#define SVC_NAME_SIZE                                          20
#define SVC_PHONE_SIZE                                         12
#define SVC_PWD_SIZE                                           16
#define SVC_BAUDSIZE                                            4
#define SVC_WLENSIZE                                            1
#define SVC_PRTYSIZE                                            1
#define SVC_SBITSIZE                                            3

/*--------------------------------------------------------------------------*/
/* Communication port defines                                               */
/*--------------------------------------------------------------------------*/
#define COM_1                                                   0
#define COM_2                                                   1
#define COM_3                                                   2
#define COM_4                                                   3
#define COM_5                                                   4
#define COM_6                                                   5
#define COM_7                                                   6
#define COM_8                                                   7
#define COM_9                                                   8
#define COM_10                                                  9
#define COM_11                                                 10
#define COM_12                                                 11
#define COM_13                                                 12
#define COM_14                                                 13
#define COM_15                                                 14
#define COM_16                                                 15
#define COM_17                                                 16
#define COM_18                                                 17
#define COM_19                                                 18
#define COM_20                                                 19
#define COM_21                                                 20
#define COM_22                                                 21
#define COM_23                                                 22
#define COM_24                                                 23
#define COM_25                                                 24
#define COM_26                                                 25
#define COM_27                                                 26
#define COM_28                                                 27
#define COM_29                                                 28
#define COM_30                                                 29
#define COM_31                                                 30
#define COM_32                                                 31
#define MAX_COM                                                32

/*--------------------------------------------------------------------------*/
/* Modem information structure                                              */
/*--------------------------------------------------------------------------*/
typedef struct _MODEMINFO
{
   char ModemName[MODEM_NAME_SIZE+1];     /* Modem name                     */
   char SetupString[MODEM_SETUP_SIZE+1];  /* Setup string                   */
   char ResetString[MODEM_CODE_SIZE+1];   /* Reset string                   */
   char EscapeString[MODEM_CODE_SIZE+1];  /* Escape string sequence         */
   char DisconnectStr[MODEM_CODE_SIZE+1]; /* Disconnect string              */
   char CodeBusy[MODEM_CODE_SIZE+1];      /* Busy code                      */
   char CodeDialTone[MODEM_CODE_SIZE+1];  /* Dial Tone code                 */
   char CodeCarrier[MODEM_CODE_SIZE+1];   /* No Carrier code                */
   char CodeAnswer[MODEM_CODE_SIZE+1];    /* No Answer code                 */
}
MODEMINFO, *PMODEMINFO;

/*--------------------------------------------------------------------------*/
/* Subscriber information structure                                         */
/*--------------------------------------------------------------------------*/
typedef struct _PINF
{
   char PinID[SUBSCRIBER_PIN_SIZE+1];    /* Subscriber's pager ID           */
   char Pager_Type[2];                   /* (A)lphanumeric or (D)igital     */
   char Page_Status;                     /* Page status (ACK, NAK, RS, etc) */
   char Page_Preprocess[PRE_MSG_SIZE+1]; /* Reserved                        */
   int  SkipMsg;                         /* To skip message (default FALSE) */
}
PINF, *PPINF;

/*--------------------------------------------------------------------------*/
/* Page information structure                                               */
/*--------------------------------------------------------------------------*/
typedef struct _PAGEMSGINFO
{
   BYTE  Port;                           /* Serial port assigned            */
   int   SinglePage;                     /* TRUE if single, FALSE if group  */
   char  MessageID[MSG_ID_SIZE+1];       /* Provided to track messages      */
   char  GroupName[GROUP_NAME_SIZE+1];   /* Group Name to be paged          */
   char  SenderSignature[SND_ID_SIZE+1]; /* Sender Identity                 */
   char  DialPrefix[PREFIX_SIZE+1];      /* Dial prefix default = "1"       */
   int   IDStamp;                        /* Sender ID stamped  if TRUE      */
   int   TimeStamp;                      /* Time stamped HH:MM if TRUE      */
   int   GrpNameStamp;                   /* Group Name stamped if TRUE      */
   char  Message[TEXT_MESSAGE_LENGTH+1]; /* Max characters per message      */
   HMQ   hmqProcess;                     /* Message queue process           */
   ULONG ulMsgId;                        /* Message ID                      */

   char ServiceId[SVC_ID_SIZE+1];        /* Reserved.                       */
   char ServiceName[SVC_NAME_SIZE+1];    /* Messaging Service's Name        */
   char ServicePNum[SVC_PHONE_SIZE+1];   /* Service's primary phone #       */
   char ServiceSNum[SVC_PHONE_SIZE+1];   /* Service's secondary phone #     */
   char ServicePassword[SVC_PWD_SIZE+1]; /* Service's access password       */
   char ServiceBaudRate[SVC_BAUDSIZE+1]; /* Service's Baud Rate             */
   char ServiceWordLen[SVC_WLENSIZE+1];  /* Word Length                     */
   char ServiceParity[SVC_PRTYSIZE+1];   /* Parity (E)ven, (O)dd (N)one     */
   char ServiceStopBits[SVC_SBITSIZE+1]; /* StopBits 1, 1.5, or 2           */
   char ServiceSpeaker[1];               /* 1=Low, 2=Medium, 3=High         */
   int  ServiceMultiPage;                /* Reserved.                       */
   int  ServicePageRetries;              /* # of retries when page fails    */
   int  ServiceModem;                    /* TRUE turns modem speaker ON     */
   int  ServicePageLength;               /* Reserved.                       */
   int  ServiceMaxMsgs;                  /* Max msgs per call default 128   */
   int  ServiceBlockChars;               /* Max chars per block default 80  */
   MODEMINFO pModemInfo;                 /* Modem info structure            */
   PINF 
   pSubscriberInfo[MAX_PAGES_PER_CALL];  /* Subscribers info                */
}
PAGEMSGINFO, *PPAGEMSGINFO;

/*--------------------------------------------------------------------------*/
/* Exported Functions                                                       */
/*--------------------------------------------------------------------------*/
ULONG EXPENTRY SendAlphaMessage( ULONG ulParms );
int   EXPENTRY IsComPortAvailable( int Port );

/*--------------------------------------------------------------------------*/
/* End of SafePage header file                                              */
/*--------------------------------------------------------------------------*/
