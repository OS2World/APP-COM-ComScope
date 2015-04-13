/*--------------------------------------------------------------------------*/
/*    Module Name: DEMOPM.H                                                 */
/*                                                                          */
/*    Description: SafePage Library Demo global header file.                */
/*                                                                          */
/*           Date: Jul 15, 1995                                             */
/*                                                                          */
/*      Copyright: OS/Tools Incorporated 1995.                              */
/*                                                                          */
/*       Comments: For SafePage Library demo.                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

#include "INSTPAGE.H"

typedef struct tagMODEMSPEAKER
{
   char  szText[7];
   int   Speaker;
} MODEMSPEAKER;


typedef struct tagBAUDRATE
{
   char  szText[5];
   int   BaudRate;
} BAUDRATES;

#define FILE_ERROR 0
#define NEW_FILE   1
#define OLD_FILE   2
#define NO_FILE    3

/*--------------------------------------------------------*/
/* ID defines                                             */
/*--------------------------------------------------------*/
#define ID_APPLICATION       "QuickPage Installation"
#define ID_HELP_FILE         "QPINSTAL.HLP"
#define ID_NEW_PIN_TEXT      "<New PIN Number>"
#define MAX_MODEM_DEF                       318

#define WM_CONFIG_FILE              (WM_USER+1)
#define WM_COLLECT_INFO             (WM_USER+2)
#define WM_MODEM_DEF_FILE           (WM_USER+3)
#define WM_ADD_NEW_PIN              (WM_USER+4)
#define WM_CHECK_PINS_LIST          (WM_USER+5)

#define ID_INSTALL_ICON                     101
#define ID_INSTALL_RESOURCE                 102
#define IDM_FILE                            103
#define IDM_FILE_INSTALL                    104
#define IDM_FILE_ABOUT                      109
#define IDM_FILE_EXIT                       110
#define IDM_HELP                            115
#define IDM_HELP_INDEX                      116
#define IDM_HELP_GENERAL                    117
#define IDM_HELP_USING                      118
#define IDM_HELP_KEYS                       119
#define IDM_HELP_PRODUCT                    120

#define IDBTN_HELP                          125

/*--------------------------------------------------------*/
/* Standard Dialog box ids                                */
/*--------------------------------------------------------*/
#define ID_DLG_ABOUT                        100

#define ID_DLG_INSTALL                      200
#define IDBK_INSTALL_NOTEBOOK               201
#define IDBTN_INSTALL_FILENAME              202

#define ID_DLG_GLOBAL_SETTINGS              300
#define IDGRP_INST_SETTINGS                 301
#define IDTXT_INST_COM_PORT                 302
#define IDCTL_INST_COM_PORT                 303
#define IDTXT_INST_SENDER                   304
#define IDFLD_INST_SENDER                   305
#define IDTXT_INST_GROUP                    306
#define IDFLD_INST_GROUP                    307
#define IDTXT_INST_PREFIX                   308
#define IDFLD_INST_PREFIX                   309
#define IDTXT_INST_RETRIES                  310
#define IDCTL_INST_RETRIES                  311
#define IDTXT_INST_LOG_FILE                 312
#define IDFLD_INST_LOG_FILE                 313
#define IDGRP_INST_MSG_FORMAT               314
#define IDBTN_INST_SENDER_ID                315
#define IDBTN_INST_TIMESTAMP                316
#define IDBTN_INST_GROUPSTAMP               317
#define IDGRP_INST_MSG_TYPE                 318
#define IDBTN_INST_SINGLE                   319
#define IDBTN_INST_GROUP                    320


#define ID_DLG_MODEM_SETTINGS               400
#define IDGRP_INST_MODEM                    401
#define IDTXT_INST_MODEM                    402
#define IDBOX_INST_MODEM                    403
#define IDTXT_INST_SETUP                    404
#define IDFLD_INST_SETUP                    405
#define IDTXT_INST_RESET                    406
#define IDFLD_INST_RESET                    407
#define IDTXT_INST_ESCAPE                   408
#define IDFLD_INST_ESCAPE                   409
#define IDTXT_INST_DISCONNECT               410
#define IDFLD_INST_DISCONNECT               411
#define IDTXT_INST_BUSY                     412
#define IDFLD_INST_BUSY                     413
#define IDTXT_INST_DIALTONE                 414
#define IDFLD_INST_DIALTONE                 415
#define IDTXT_INST_CARRIER                  416
#define IDFLD_INST_CARRIER                  417
#define IDTXT_INST_ANSWER                   418
#define IDFLD_INST_ANSWER                   419
#define IDGRP_INST_SPEAKER                  420
#define IDBTN_INST_SPEAKER_ON               421
#define IDBTN_INST_SPEAKER_OFF              422
#define IDGRP_INST_VOLUME                   423
#define IDCTL_INST_VOLUME                   424


#define ID_DLG_SERVICES                     500
#define IDGRP_SVC_INFO                      501
#define IDTXT_SVC_NAME                      502
#define IDFLD_SVC_NAME                      503
#define IDTXT_SVC_PNUM                      504
#define IDFLD_SVC_PNUM                      505
#define IDTXT_SVC_SNUM                      506
#define IDFLD_SVC_SNUM                      507
#define IDTXT_SVC_MESSAGES                  508
#define IDCTL_SVC_MESSAGES                  509
#define IDTXT_SVC_CHARS                     510
#define IDCTL_SVC_CHARS                     511
#define IDGRP_SVC_PARMS                     512
#define IDGRP_SVC_WLENGTH                   513
#define IDBTN_SVC_5_BITS                    514
#define IDBTN_SVC_6_BITS                    515
#define IDBTN_SVC_7_BITS                    516
#define IDBTN_SVC_8_BITS                    517
#define IDGRP_SVC_PARITY                    518
#define IDBTN_SVC_EVEN                      519
#define IDBTN_SVC_ODD                       520
#define IDBTN_SVC_NONE                      521
#define IDGRP_SVC_STOP_BITS                 522
#define IDBTN_SVC_1_SBITS                   523
#define IDBTN_SVC_15_SBITS                  524
#define IDBTN_SVC_2_SBITS                   525
#define IDGRP_SVC_BAUD_RATE                 526
#define IDCTL_SVC_BAUD_RATE                 527

#define ID_DLG_CONFIG_FILE                  600
#define IDGRP_CONFIG_NAME                   601
#define IDFLD_CONFIG_NAME                   602

#define ID_DLG_DEFINE_PIN                   700
#define IDGRP_DEFINE_PIN                    701
#define IDBOX_DEFINE_PIN                    702
#define IDBTN_DEFINE_ADD                    703
#define IDBTN_DEFINE_EDIT                   704
#define IDBTN_DEFINE_REMOVE                 705
#define IDBTN_DEFINE_REMOVE_ALL             706

#define ID_DLG_COLLECT_PIN                  800
#define IDGRP_COLLECT_PIN                   801
#define IDFLD_COLLECT_PIN                   802



/*--------------------------------------------------------*/
/* Strings                                                */
/*--------------------------------------------------------*/
#define IDS_INSTALL_CLASS                   900

/*--------------------------------------------------------*/
/* Definitions                                            */
/*--------------------------------------------------------*/
#define BEEP_FREQUENCY                      500
#define BEEP_DURATION                       250

#define ParentOf(hwnd)                      WinQueryWindow ((hwnd), QW_PARENT)
#define OwnerOf(hwnd)                       WinQueryWindow ((hwnd), QW_OWNER)

/*--------------------------------------------------------------------------*/
/*  Entry point procedure declarations                                      */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY QuickPageProc(HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY DlgAbout(     HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY QPageInstall( HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY DlgGlobalSet( HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY DlgModemSet(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY DlgServiceSet(HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY DlgFileName(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY DlgPinsList(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY DlgCollPins(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);

/*--------------------------------------------------------------------------*/
/*  Function prototypes                                                     */
/*--------------------------------------------------------------------------*/
void CenterWindow(HWND hwnd, HWND hwndParent);
int  CreateConfigFile( char * szFile, PAGEMSGINFO * pInfo );
BOOL CreateHelpInstance(HWND hwndMainFrame, PSZ ApplicationName, PSZ HelpFile);

/*------------------------------------------*/
/* Macro definitions                        */
/*------------------------------------------*/
#define MessageBox(Message, Flags)          \
                                            \
           WinMessageBox(                   \
              HWND_DESKTOP,                 \
              HWND_DESKTOP,                 \
              (PSZ) Message,                \
              (PSZ)"QuickPage Install",     \
              40,                           \
              MB_MOVEABLE | Flags)


#define WinDeleteLboxAll(hwndLbox)          \
    ((BOOL)WinSendMsg((hwndLbox),           \
                      LM_DELETEALL,         \
                      NULL,                 \
                      NULL))

#define WinSelectLboxItem(hwndLbox,         \
                          index,            \
                          fSelect)          \
    ((USHORT)WinSendMsg((hwndLbox),         \
                        LM_SELECTITEM,      \
                        (MPARAM) (index),   \
                        (MPARAM) (fSelect)))

#define WinScrollLboxItemToTop(hwndLbox,    \
                               index)       \
    ((BOOL)WinSendMsg((hwndLbox),           \
                      LM_SETTOPINDEX,       \
                      MPFROMSHORT (index),  \
                      NULL))

/*--------------------------------------------------------*/
/* Install Help table and subtables                       */
/*--------------------------------------------------------*/
#define INSTALL_HELP_TABLE                  5000

#define PANEL_PRODUCT_INFO                  5110
#define PANEL_INSTALLATION                  5111
#define PANEL_PARAMETERS                    5115
#define PANEL_VALID_PARMS                   5120



/*--------------------------------------------------------*/
/* Message Table IDs                                      */
/*--------------------------------------------------------*/
#define IDMSG_INITFAILED                    1000
#define IDMSG_MAINWINCREATEFAILED           1001
#define IDMSG_CANNOTOPENINPUTFILE           1002
#define IDMSG_CANNOTOPENOUTPUTFILE          1003
#define IDMSG_INVALID_DRIVE                 1004
#define IDMSG_DRIVE_NOT_READY               1005

/*--------------------------------------------------------*/
/* Return values for main routine                         */
/*--------------------------------------------------------*/
#define RETURN_SUCCESS                      FALSE /* successful return in DosExit   */
#define RETURN_ERROR                        TRUE  /* error return in DosExit        */

