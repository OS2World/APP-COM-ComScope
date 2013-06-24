#ifndef CLP_H
#define CLP_H

#define OPT_0  0
#define OPT_1  1
#define OPT_2  2
#define OPT_3  3 
#define OPT_4  4
#define OPT_5  5
#define OPT_6  6
#define OPT_7  7
#define OPT_8  8
#define OPT_9  9
#define OPT_A 10
#define OPT_B 11

#define OPTFLG_0  0x001
#define OPTFLG_1  0x002
#define OPTFLG_2  0x004
#define OPTFLG_3  0x008 
#define OPTFLG_4  0x010
#define OPTFLG_5  0x020
#define OPTFLG_6  0x040
#define OPTFLG_7  0x080
#define OPTFLG_8  0x100
#define OPTFLG_9  0x200
#define OPTFLG_A  0x400
#define OPTFLG_B  0x800

#define S_COLFRM_EACH 0x00
#define S_COLFRM_2 0x10
#define S_COLFRM_4 0x20
#define S_COLFRM_8 0x30
#define S_COLFRM_16 0x40
#define S_COLFRM_32 0x50
#define S_COLFRM_64 0x60
#define S_COLFRM_128 0x70

#define P_COLFRM_EACH 0x00
#define P_COLFRM_2 0x01
#define P_COLFRM_4 0x02
#define P_COLFRM_8 0x03
#define P_COLFRM_16 0x04
#define P_COLFRM_32 0x05
#define P_COLFRM_64 0x06
#define P_COLFRM_128 0x07

#define ALERTINT_NONE  0x00
#define ALERTINT_2MIN  0x0f
#define ALERTINT_3MIN  0x17
#define ALERTINT_4MIN  0x1e
#define ALERTINT_5MIN  0x26
#define ALERTINT_10MIN 0x4b
#define ALERTINT_15MIN 0x71
#define ALERTINT_30MIN 0xe1

#define ALERTTO_NONE   0x00
#define ALERTTO_2MIN   0x0f
#define ALERTTO_3MIN   0x17
#define ALERTTO_4MIN   0x1e
#define ALERTTO_5MIN   0x26
#define ALERTTO_10MIN  0x4b
#define ALERTTO_15MIN  0x71
#define ALERTTO_30MIN  0xe1

/*****************************************************************************

    Motorola Internal Use Only
    Copyright MOTOROLA 1998 All Rights Reserved

    FILE NAME: 

    DESCRIPTION: Communication Linking Protocol (CLP) API public Defines
    typedefs, prototypes, and global externs.

    CAUTIONS:

    

******************************************************************************/

//#include "general.h"
/*** Not inclide in CLP Library
#include "sci.h"
***/

/*****************************************************************************
*
* T Y P E D E F S
*
******************************************************************************/

typedef enum
  {
  NONE_IN_PROG,  /* indicates no messages are currently being transmitted */ 
  MSG_FAILED,    /* indicates last transmission failed */
  MSG_SUCCESS,   /* indicates last transmission was successful */
  MSG_IN_PROG,   /* indicates a message transmission is in progress */
  MSG_SUSPEND    /* indicates a message has been suspended by the system */
  } CLP_TXMSGFLG_T;

typedef enum 
  {
  NO_NEW_MSG,            /* indicates no new messages have been received */
  NEW_MSG        /* indicates a new message has been received */
  } CLP_NEWMSGFLG_T;

typedef enum 
  {
  NO_MSG_UPDATE, /* indicates no new message updates have occured */
  MSG_UPDATE /* indicates no message updates have occurred */
  } CLP_MSGUPDFLG_T;

typedef enum
  {
  DIAG_EN,       /* enables diagnostics mode */
  DIAG_DIS       /* disables diagnostics mode */
  } CLP_DIAGSTATE_T;

typedef enum
  {
  DEV_OUT_OF_RANGE,   /* Transceiver is not receiving a ReFlex signal */ 
  DEV_IN_RANGE        /* Transceiver is receiving a ReFlex signal */
  } CLP_OORSTAT_T;

typedef enum
  {
  DEV_NOT_BUSY,      /* transceiver can't process a new request at this time */ 
  DEV_BUSY           /* transceiver can process any new requests */
  } CLP_DEV_BUSY_T;

typedef enum
  {
  STAT_TMIT_OFF,      /* transmitter has been turned off */ 
  STAT_TMIT_ON        /* transmitter is currently on     */
  } CLP_TMIT_STAT_T;

typedef enum
  {
  STAT_UNREG,      /* unit is currently not registered */ 
  STAT_REG         /* Unit is currently registered    */
  } CLP_REG_STAT_T;

typedef enum
  {
  PERS_MSG,           /* Indicates that this is a personal message */
  INFO_SERV_MSG       /* Indicates that this is a info. service msg */
  } CLP_INFO_PERS_T;

typedef enum
  {
  NUM_MSG,            /* Numeric Message */
  ALPHA_MSG,          /* Alpha Numeric Message */
  BINARY_MSG          /* Binary Message */
  } CLP_MSG_TYPE_T;

typedef enum
  {
  HARD_RST,           /* hard reset has occurred */
  SOFT_RST            /* soft reset has occurred */
  } CLP_RESET_T;

typedef enum
  {
  REG_INIT,           /* Initialization state */
  REG_ACQ_SYNC,       /* acquiring sync state */
  REG_ATTEMPT,        /* attempting to register state */
  REG_STATE,          /* registered state */
  REG_FADE,           /* registered fading state */
  REG_ZC_STATE,       /* zone change state */
  REG_ZC_FADE,        /* zone change fading state */
  REG_AUTO,           /* auto registration state */
  REG_ATTEMPT_ZC,     /* attempting zone change state */
  REG_PAGER_DIS,      /* pager disabled state */
  REG_UNKNOWN
  } CLP_DIAG_REG_T;

typedef enum
  {
  NEW_MSG_FLG,            /* Indicates this is a new msg */
  DUP_MSG_FLG,            /* Indicates this is a duplicate msg */
  UPDT_MSG_FLG            /* Indicates that msg update has occured */
  } CLP_DUP_FLG_T;

typedef enum
  {
  MSG_NO_ERRS,        /* No errors in the msg */
  MSG_CKSM_FAIL,      /* Msg checksum failed */
  MSG_MISS_FRAG,      /* Msg is missing fragments */
  MSG_TRUNC           /* Indicates truncated msg */
  } CLP_ERR_FLG_T;

typedef enum
  { 
  SUSPEND_MODE,   /* suspend power */
  RUNTIME_MODE,   /* runtime power */
  RXONLY_MODE     /* Received mode only */
  } CLP_MODE_T;

typedef enum
  { 
  ISSUE_HARD_RESET,   // issue hard reset 
  ISSUE_SOFT_RESET,   // issue soft reset 
  NO_RESET            // Unit is placed in specified mode W/O issuing a reset 
  } CLP_CMD_T;

typedef enum 
  {
  API_CLP_SETMODE = TRUE
  } CLP_API_CMDSET_T;

typedef struct
  { 
  BYTE setModeCmd;
  BYTE mode;
  BYTE cmd;
  } CLP_CMDMODE_T;

typedef enum
  {
  RFLX50,         /* Reflex50 protocol */
  RFLX25,         /* Reflex25 protocol */
  INFLEX          /* Inflexion protocol */
  } CLP_PROT_T;
 
typedef struct
  {
  CLP_DIAG_REG_T    regStat;   /* registration status */
  USHORT            cErr;      /* correctable error count */
  USHORT            uErr;      /* uncorrectable error count */
  } CLP_DIAGBUFF_T;

typedef struct 
  {
  BYTE minute;   // 0-59 
  BYTE hour;     // 0-23 
  BYTE day;      // 1-31 
  BYTE month;    // 1-12 
  BYTE year;     // 0-99 - it is up to the application to determine the meaning of this field
  } CLP_TDATE_T;

typedef struct
  {
  CLP_TXMSGFLG_T tmitShortMsgFlag;// status short message transmission 
  CLP_TXMSGFLG_T tmitMsgFlag; // status message transmission 
  CLP_NEWMSGFLG_T newMsgFlag; // new message indication 
  CLP_DEV_BUSY_T deviceBusy;  // device busy 
  CLP_OORSTAT_T outOfRange;   // Out of Range Status
  CLP_TMIT_STAT_T trmnStatus; // Transmitter Status 
  BYTE batStatus;             // Battery Status 
  USHORT zoneId;              // Zone Id 
  BYTE subZoneId;             // SubZone Id 
  ULONG noBytesAvail;         // Number of Bytes Available 
  USHORT totalNoMsg;          // Total #of Messages 
  USHORT numUnReadMsg;        // Total #of Unread Messages 
  CLP_REG_STAT_T regStatus;   // Registration Status 
  CLP_MSGUPDFLG_T msgUpdate;  // Message Info 
  CLP_TDATE_T dateTime;       // Data Transceiver Current Date & Time  
  } CLP_STATUS_T;

typedef struct
  {
  BYTE source;       /* source */
  BYTE subAddress;   /* Sub Address */
  BYTE msn;          /* ReFLEX Message Sequence Number */
  CLP_MSG_TYPE_T msgType;      /* message type */
  CLP_INFO_PERS_T infoMsg;      /* information service message flag */
  CLP_TDATE_T timeDate;    /* time stamp for message */
  BYTE *msgData;     /* data portion of the message */
  } CLP_MESSAGE_T;

typedef struct
  {
  BYTE   inCnNo[10];  /* inventory control number */
  BYTE   elecSerNo[4];/* electronic serial number */
  BYTE   ramVerNo;    /* RAM version number */
  BYTE   swVerNo1[4]; /* software version number (host) */
  BYTE   swVerNo2[4]; /* software version number 2 (DSP) */
  BYTE   serialNo[10];/* serial number */
  } CLP_CONFIG_T;

typedef struct
  {
  BYTE   productId;   /* the product ID */
  CLP_PROT_T   protocol;   /* protocol */
  } CLP_GETPRDINFO_T;

typedef enum 
  {            
  MSG_UNREAD,
  MSG_READ
  } CLP_MSG_READ_STATE_T;

typedef struct
  {
  BYTE source;               /* source */
  BYTE subAddress;           /* Sub Address */
  BYTE msn;                  /* ReFLEX Message Sequence Number */
  CLP_MSG_TYPE_T msgType;     /* message type */
  CLP_INFO_PERS_T infoMsg;    /* information service msg flag */
  CLP_TDATE_T timeDate;       /* time stamp for message */
  ULONG msgId;               /* message identifier */
  BYTE seqNo;                /* sequence number */
  USHORT msgLength;           /* length of data portion */
  BYTE folderNo;             /* folder number */
  CLP_DUP_FLG_T dupMsgFlag;   /* duplicate message flag */
  CLP_MSG_READ_STATE_T msgReadFlag; /* message read indication */
  CLP_ERR_FLG_T msgErrsFlag;  /* message errors */
  BYTE msgPreview[12];       /* 12 byte preview of message */
  } CLP_GETDIR_T;

typedef struct
  {
  USHORT msgLength;   /* length of message to transmit in hex */
  BYTE  *msgData;    /* pointer to data to transmit */
  } CLP_TRANSMIT_T;

typedef enum
  {
  COMMAND_SUCCESS,    /* SUCCESS status */
  COMMAND_FAILED      /* FAILURE status */
  } CLP_ERROR;

typedef enum
  {
  PAR_PORT1_ID = 1    /* Parallel port number 1 */
  } CLP_PPORTID_T;

typedef enum 
  {
  A_D_EXT1_ID,      /* Customer Analog channel A/D_EXT1 */
  A_D_EXT2_ID,      /* Customer Analog channel A/D_EXT2 */
  A_D_TEMP_ID,      /* temperature A/D channel */
  A_D_BAT_ID,       /* battery status A/D channel */
  } CLP_APORTID_T;

typedef enum
  {
  LED_ON,
  LED_OFF
  } CLP_LEDSTATE_T;

/********************************************************************************
 *
 * D E F I N E S 
 * 
 * Used for CLP_GetOption and CLP_SetOption Commands
 ********************************************************************************/
#define CLP_BAUD9600        1
#define CLP_BAUD4800        2
#define CLP_BAUD2400        3
#define AUTOREG_DIS         0
#define AUTOREG_EN          1
#define PA_POWEREN          1
#define PA_POWERDIS         0
#define BAUDRATE            0x02
#define STAT_INDICATOR      0x03
#define INDICATOR_OPTIONS   0x04
#define AUTO_REGISTRATION   0x08
#define COLLAPSE_VALUE      0x09
#define TIME_CORRECTION     0x0A
#define TIME_CORRECTION_REF 0x0B
#define IO_SELECT           0x80
#define OUTPUT_STATE        0x81
#define PA_POWER_SELECT     0x82
#define ATM_TIMER_PERIOD    0x83
#define ATM_STARTUP_TIMER   0x84

/*****************************************************************************
*
* G L O B A L S
*
******************************************************************************/
/*****************************************************************************
*
* P U B L I C  P R O T O T Y P E S 
*
******************************************************************************/
extern CLP_ERROR CLP_ConfigLED(CLP_LEDSTATE_T state);
extern CLP_ERROR CLP_DeleteMessage (ULONG msgId, BYTE seqNo);
extern CLP_ERROR CLP_DiagnosticOnOff (CLP_DIAGSTATE_T state);
extern CLP_ERROR CLP_GetConfig(CLP_CONFIG_T *getConfig);
extern CLP_ERROR CLP_GetDir(USHORT *numDirRet, CLP_GETDIR_T getDir[]);
extern CLP_ERROR CLP_GetDirectoryEntry (ULONG msgId, BYTE seqNo, CLP_GETDIR_T *getDirent);
extern CLP_ERROR CLP_GetMessage (ULONG msgId, BYTE seqNo, USHORT *numCharsRet, CLP_MESSAGE_T *getMessage);
extern CLP_ERROR CLP_GetOption (BYTE optionNum, BYTE *optionVal);
extern CLP_ERROR CLP_GetProductInfo(CLP_GETPRDINFO_T *prdInfo);
extern CLP_ERROR CLP_GetStatus (CLP_STATUS_T *statusInfo);
extern CLP_ERROR CLP_ReadAnalogPort(CLP_APORTID_T portId, float* data);
extern CLP_ERROR CLP_ReadParallelPort(CLP_PPORTID_T portId, BYTE* data);
extern CLP_ERROR CLP_RetrieveDeleteMsg (USHORT *numCharsRet, CLP_MESSAGE_T *rtrvMessage);
extern CLP_ERROR CLP_SetMode(CLP_MODE_T mode, CLP_CMD_T cmd);
extern CLP_ERROR CLP_SetOption (BYTE optionNum, BYTE optionValue);
extern CLP_ERROR CLP_SetTimeDate(CLP_TDATE_T *timedate);
extern CLP_ERROR CLP_TransmitMessage (CLP_TRANSMIT_T *trnsMsg);
extern CLP_ERROR CLP_TransmitShort (USHORT ShortMsg);
extern CLP_ERROR CLP_WriteParallelPort(CLP_PPORTID_T portId, BYTE mask, BYTE data);

/*** For backwards compatibility ***/
extern CLP_ERROR CLP_SetPower(CLP_TMIT_STAT_T txState);

extern CLP_ERROR CLP_SerialInit(HFILE hArgCom);

/* Prototypes for the platform specific serial IO opening and closing*/
extern CLP_ERROR    SerialOpen(char* port, ULONG baud);
extern CLP_ERROR    SerialClose();


/*** Not Supported in library 
extern void CLP_ApplicationInit(CLP_RESET_T);
extern void CLP_NotifyTimerExp(USHORT numTicksExp);
extern void CLP_NotifySerialEvent(SCI_EVENT_T);
extern void CLP_NotifyDiagBuff(CLP_DIAGBUFF_T *);
extern void CLP_StatusIndicator(void);
***/

#endif
