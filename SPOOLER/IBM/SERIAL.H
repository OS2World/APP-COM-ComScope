/**************************************************************************
 *
 * SOURCE FILE NAME = SERIAL.H
 *
 * DESCRIPTIVE NAME = serial port driver header file
 *
 * 
 * 
 * COPYRIGHT    Copyright (C) 1992 IBM Corporation
 * 
 * The following IBM OS/2 2.1 source code is provided to you solely for
 * the purpose of assisting you in your development of OS/2 2.x device
 * drivers. You may use this code in accordance with the IBM License
 * Agreement provided in the IBM Device Driver Source Kit for OS/2. This
 * Copyright statement may not be removed.
 * 
 * 
 *
 * VERSION = V2.0
 *
 * DATE
 *
 * DESCRIPTION
 *
 *
 * FUNCTIONS
 *
 * ENTRY POINTS:
 *
 * DEPENDENCIES:
 *
 * NOTES
 *
 *
 * STRUCTURES
 *
 * EXTERNAL REFERENCES
 *
 * EXTERNAL FUNCTIONS
 *
 ***************************************************************************/



#define PRT_HELPFILE_NAME         "WPHELP.HLP"
#define SERIAL_DLL                "SERIAL.PDR"

#define NO_ERROR                  0
#define ERROR_MORE_DATA           234
#define ERROR_INSUFFICIENT_BUFFER 122

#define ID_NUMBER_OF_DESC_LINES   8000
#define ID_FIRST_DESC_LINES       8001

#define PORT_ID_1                 5001
#define PORT_DESC_1               5002
#define PORT_ID_2                 5003
#define PORT_DESC_2               5004
#define PORT_ID_3                 5005
#define PORT_DESC_3               5006
#define PORT_ID_4                 5007
#define PORT_DESC_4               5008
#define PORT_HELP_TITLE           5100
#define PORT_ERR_TITLE            7000

#define PORT_ID_FIRST             PORT_ID_1
#define PORT_ID_LAST              PORT_ID_4

#define SERIAL_ICON               7001

#define STR_LEN_PORTNAME          64
#define STR_LEN_PORTDESC          256
#define STR_LEN_DESC              81
#define PORT_ENTRY_LEN            256
#define STR_LEN_TITLE             256

   /*
   ** port defaults
   */
#define DEF_INITIALIZATION        "9600;0;8;1;1;"
#define DEF_TERMINATION           ";"
#define DEF_PORTDRIVER            "SERIAL;"
#define DEF_TIMEOUT               "45;"

#define APPNAME_LEAD_STR          "PM_"

#define KEY_DESCRIPTION           "DESCRIPTION"
#define KEY_INITIALIZATION        "INITIALIZATION"
#define KEY_TERMINATION           "TERMINATION"
#define KEY_PORTDRIVER            "PORTDRIVER"
#define KEY_TIMEOUT               "TIMEOUT"

#define APPNAME_PM_SPOOLER_PORT   "PM_SPOOLER_PORT"

#define TIMEOUT_LOWER_LIMIT       0
#define TIMEOUT_UPPER_LIMIT       655         /* 655 * 100 = 65500 (< 65536) */

#define IOCTL_TIMEOUT_UPPER_LIMIT (TIMEOUT_UPPER_LIMIT * 100)

#define DEF_TIMEOUT_VALUE         45


#define NumPorts() (((PORT_ID_LAST - PORT_ID_FIRST) >> 1) + 1)

typedef struct _SERIALDATA
{
   HAB hAB;
   HMODULE hModule;
   PSZ  pszPortName;
   PSZ  pszAppName;
   CHAR szSaveCommSetting[PORT_ENTRY_LEN+1];
   CHAR szOrgCommSetting[PORT_ENTRY_LEN+1];
   USHORT usSaveTimeOut;
   USHORT usOrgTimeOut;
   ULONG lfModified;
} SERIALDATA, *PSERIALDATA;

#pragma pack(1)

typedef struct _EXTQUERYBIT
{
   ULONG    ulCurBitRate;
   BYTE     ucCurBitRateFrac;
   ULONG    ulMinBitRate;
   BYTE     ucMinBitRateFrac;
   ULONG    ulMaxBitRate;
   BYTE     ucMaxBitRateFrac;
} EXTQUERYBIT, *PEXTQUERYBIT;         /* Return Struture for IOCtl - Func 63 */

#pragma pack()
          /*
          **    Port Settings - Serial Port
          */
#define IDD_PORTSERIAL        21300
#define IDC_PSE_BAUDRATE      (IDD_PORTSERIAL + 1)  /* Baud Rate          */
#define IDC_PSE_WORDLEN5BITS  (IDD_PORTSERIAL + 2)  /* Word Length 5 bits */
#define IDC_PSE_WORDLEN6BITS  (IDD_PORTSERIAL + 3)  /* Word Length 6 bits */
#define IDC_PSE_WORDLEN7BITS  (IDD_PORTSERIAL + 4)  /* Word Length 7 bits */
#define IDC_PSE_WORDLEN8BITS  (IDD_PORTSERIAL + 5)  /* Word Length 8 bits */
#define IDC_PSE_PARITYEVEN    (IDD_PORTSERIAL + 6)  /* Parity Even        */
#define IDC_PSE_PARITYODD     (IDD_PORTSERIAL + 7)  /* Parity Odd         */
#define IDC_PSE_PARITYNONE    (IDD_PORTSERIAL + 8)  /* Parity None        */
#define IDC_PSE_STOPBIT1      (IDD_PORTSERIAL + 9)  /* Stop Bits 1        */
#define IDC_PSE_STOPBIT1_5    (IDD_PORTSERIAL + 10) /* Stop Bits 1.5      */
#define IDC_PSE_STOPBIT2      (IDD_PORTSERIAL + 11) /* Stop Bits 2        */
#define IDC_PSE_HSNONE        (IDD_PORTSERIAL + 12) /* Hand Shake None    */
#define IDC_PSE_DESC          (IDD_PORTSERIAL + 13)
#define IDC_PSE_TIMEOUT       (IDD_PORTSERIAL + 14)
#define IDC_PSE_HSHARDW       (IDD_PORTSERIAL + 15)
#define IDC_OK           1100                       /* OK push button     */
#define IDC_CANCEL       1101                       /* Cancel push button */
#define IDC_HELP         1102                       /* Help push button   */
#define IDC_RESET        1103                       /* Help push button   */
#define IDC_DEFAULT      1104                       /* Help push button   */

#define  IDH_DLG_EXTENDED               15477
#define  IDH_PSE_BAUDRATE               15478
#define  IDH_PSE_WORDLEN5BITS           15479
#define  IDH_PSE_WORDLEN6BITS           15479
#define  IDH_PSE_WORDLEN7BITS           15479
#define  IDH_PSE_WORDLEN8BITS           15479
#define  IDH_PSE_PARITYEVEN             15480
#define  IDH_PSE_PARITYODD              15480
#define  IDH_PSE_PARITYNONE             15480
#define  IDH_PSE_STOPBIT1               15481
#define  IDH_PSE_STOPBIT1_5             15481
#define  IDH_PSE_STOPBIT2               15481
#define  IDH_PSE_HSNONE                 15482
#define  IDH_PSE_DESC                   15715
#define  IDH_PSE_TIMEOUT                15484
#define  IDH_PSE_HSHARDW                15482
#define  IDH_PSE_OK                     1090
#define  IDH_PSE_CANCEL                 1091
#define  IDH_PSE_HELP                   15477
#define  IDH_PSE_RESET                  1092
#define  IDH_PSE_DEFAULT                1093


#define DEF_BAUD     "9600"                     /* DEFINE DEFAULT CHOICES */
#define DEF_WORD     IDC_PSE_WORDLEN8BITS
#define DEF_PARITY   IDC_PSE_PARITYNONE
#define DEF_STOP     IDC_PSE_STOPBIT1
#define DEF_SHAKE    IDC_PSE_HSHARDW

#define MAX_NUM_BAUDRATE   21

PSZ szBaudRateAra[] = {"110",
                       "150",
                       "300",
                       "600",
                       "1200",
                       "1800",
                       "2400",
                       "3600",
                       "4800",
                       "7200",
                       "9600",
                       "14400",
                       "19200",
                       "38400",
                       "57600",
                       "76800",
                      "115200",
                      "138240",
                      "172800",
                      "230400",
                      "345600"};


#define DEF_BAUD_INDEX 10                       /* DEFINE DEFAULT CHOICES */

ULONG   OpenSerPortDlg (HAB, HMODULE, PSZ, PSZ);
MRESULT EXPENTRY CommDlg ( HWND, USHORT, MPARAM, MPARAM );

BOOL SaveToWin(PSERIALDATA);
BOOL WriteProfileString(HINI, PSZ, PSZ, PSZ);
VOID ScreenToSave( HWND, PSZ);
BOOL SaveFromWin(PSERIALDATA);
VOID ScreenFromSetting(HWND, PSZ);
VOID DefaultsToSave( PSZ );
VOID RemoveLeadTrailBlanks (PCH, PCH);


VOID   DE (PSZ);
VOID   DisplayMsg (PSZ);
USHORT DisplayError (HWND, HMODULE, USHORT, USHORT);

ULONG CalcBufLength (HAB, HMODULE);
ULONG CalcStructLength (HAB, HMODULE, USHORT);
ULONG NumPortsCanFit (HAB, HMODULE, ULONG);
VOID  CopyNPorts (HAB, HMODULE, PCH, ULONG);
VOID  CopyStruct (HAB, HMODULE, USHORT, PCH, PULONG, PULONG);
BOOL  IsValidPortName (HAB, HMODULE, PSZ);
BOOL  GetPortDescription (HAB, HMODULE, PSZ, PSZ);
HWND  CreateHelpInstance(HWND);

