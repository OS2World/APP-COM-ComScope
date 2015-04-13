#include <COMMON.H>
#include <safepage.h>

#include "QPG_CFG.H"

static MODEMSPEAKER ModemSpeaker[3] =
{
   { "Low",      0 },
   { "Medium",   2 },
   { "High",     3 }
};

/*--------------------------------------------------------------------------*/
/*      Function: DlgModemSet                                               */
/*                                                                          */
/*   Description: This dialog function displays the "Modem Settings"        */
/*                notebook page dialog box.                                 */
/*                                                                          */
/*          Date: Aug 01, 1995                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY DlgModemSet(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
{
   HWND                 hwndModemName;
   ULONG                ulIndex;
   static PAGEMSGINFO * pInfo;
   static MODEMINFO     pModemInfo[MAX_MODEM_DEF];
   static FILE        * pInFile, * pOutFile;
   static char          szLine[256], *Token;
   static int           Counter, Index;


   hwndModemName = WinWindowFromID(hwnd, IDBOX_INST_MODEM);


   switch(msg)
   {
      case WM_INITDLG:

         pInfo = (PAGEMSGINFO *)mp2;

         for(ulIndex = 0; ulIndex < 3; ulIndex++)
         {
            WinSendDlgItemMsg (hwnd, IDCTL_INST_VOLUME, SLM_SETTICKSIZE,
                               MPFROM2SHORT(SMA_SETALLTICKS, 8), 0L);

            WinSendDlgItemMsg (hwnd, IDCTL_INST_VOLUME, SLM_SETSCALETEXT,
                               MPFROMSHORT(ulIndex), MPFROMP(ModemSpeaker[ulIndex].szText));
         }

         WinSendDlgItemMsg(hwnd, 
                           IDBTN_INST_SPEAKER_OFF,
                           BM_SETCHECK,
                           (MPARAM)1L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_SETUP,
                           EM_SETTEXTLIMIT,
                           (MPARAM)40L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_RESET,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_ESCAPE,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_DISCONNECT,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_BUSY,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_DIALTONE,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_CARRIER,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_ANSWER,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinPostMsg(hwnd, WM_MODEM_DEF_FILE, 0, 0);

         return MRFROMSHORT(FALSE);





      case WM_COLLECT_INFO:

         Index = WinQueryLboxSelectedItem(hwndModemName);
         WinQueryLboxItemText(hwndModemName,
                              Index,
                              pInfo->pModemInfo.ModemName,
                              sizeof(pInfo->pModemInfo.ModemName));

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_SETUP,
                             sizeof(pInfo->pModemInfo.SetupString),
                             (PSZ)pInfo->pModemInfo.SetupString);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_RESET,
                             sizeof(pInfo->pModemInfo.ResetString),
                             (PSZ)pInfo->pModemInfo.ResetString);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_ESCAPE,
                             sizeof(pInfo->pModemInfo.EscapeString),
                             (PSZ)pInfo->pModemInfo.EscapeString);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_DISCONNECT,
                             sizeof(pInfo->pModemInfo.DisconnectStr),
                             (PSZ)pInfo->pModemInfo.DisconnectStr);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_BUSY,
                             sizeof(pInfo->pModemInfo.CodeBusy),
                             (PSZ)pInfo->pModemInfo.CodeBusy);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_DIALTONE,
                             sizeof(pInfo->pModemInfo.CodeDialTone),
                             (PSZ)pInfo->pModemInfo.CodeDialTone);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_CARRIER,
                             sizeof(pInfo->pModemInfo.CodeCarrier),
                             (PSZ)pInfo->pModemInfo.CodeCarrier);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_INST_ANSWER,
                             sizeof(pInfo->pModemInfo.CodeAnswer),
                             (PSZ)pInfo->pModemInfo.CodeAnswer);

         pInfo->ServiceModem =
         (int)WinSendDlgItemMsg(hwnd,
                           IDBTN_INST_SPEAKER_ON,
                           BM_QUERYCHECK,
                           (MPARAM)0L,
                           (MPARAM)0L);

         sprintf(pInfo->ServiceSpeaker, "%d",
         (int) WinSendDlgItemMsg (hwnd,
                                  IDCTL_INST_VOLUME,
                                  SLM_QUERYSLIDERINFO,
                                  MPFROM2SHORT(SMA_SLIDERARMPOSITION, SMA_INCREMENTVALUE),
                                 (MPARAM)0L)+1);

         return (MRESULT)TRUE;



      case WM_CONTROL:


         switch (SHORT1FROMMP(mp1))
         {
            //----------------------------------------------------------//
            // Modems List Box                                          //
            //----------------------------------------------------------//
            case IDBOX_INST_MODEM:
            {
               switch ((USHORT) SHORT2FROMMP(mp1))
               {
                  case CBN_LBSELECT:
                  case CBN_ENTER:
                  {
                     Index = WinQueryLboxSelectedItem(hwndModemName);

                     if(Index != -1)
                     {
                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_SETUP,
                                          pModemInfo[Index].SetupString);

                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_RESET,
                                          pModemInfo[Index].ResetString);

                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_ESCAPE,
                                          pModemInfo[Index].EscapeString);

                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_DISCONNECT,
                                          pModemInfo[Index].DisconnectStr);

                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_BUSY,
                                          pModemInfo[Index].CodeBusy);

                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_DIALTONE,
                                          pModemInfo[Index].CodeDialTone);

                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_CARRIER,
                                          pModemInfo[Index].CodeCarrier);

                        WinSetDlgItemText(hwnd, 
                                          IDFLD_INST_ANSWER,
                                          pModemInfo[Index].CodeAnswer);

                     }
                  }
               }
            }
         }

         break;





      case WM_CHAR:

         if(SHORT2FROMMP(mp2) == VK_ESC)
            return MRFROMSHORT(FALSE);

         if(SHORT2FROMMP(mp2) == VK_HOME ||
            SHORT2FROMMP(mp2) == VK_END)
            WinPostMsg(hwndModemName,
                       CBM_SHOWLIST,
                       (MPARAM)FALSE,
                       (MPARAM)0);

         break;



      case WM_MODEM_DEF_FILE:

         if((pInFile = fopen("MODEMDEF.DAT", "rb")) == NULL)
            break;

         Counter = 0;

         while(!feof(pInFile))
         {
            memset(&szLine, 0, sizeof(szLine));
            if(fgets(szLine, 256, pInFile))
            {
               Token = strtok(szLine, "{");
               while( Token != NULL)
               {
                  strcpy(pModemInfo[Counter].ModemName, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].SetupString, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].ResetString, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].EscapeString, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].DisconnectStr, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].CodeBusy, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].CodeDialTone, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].CodeCarrier, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
                  strcpy(pModemInfo[Counter].CodeAnswer, Token);
                  Token = strtok(NULL, "{");
                  Token = strtok(NULL, "{");
               }
            }
            Counter++;
            if(Counter == MAX_MODEM_DEF)
               break;
         }

         for(Counter = 0; Counter < MAX_MODEM_DEF; Counter++)
         {
            WinInsertLboxItem(hwndModemName,
                              LIT_END,
                              pModemInfo[Counter].ModemName);
         }

         WinSelectLboxItem(hwndModemName,
                           0,
                           TRUE);

         fclose(pInFile);

         return (MRESULT)TRUE;



      case WM_COMMAND:

         switch (SHORT1FROMMP(mp1))
         {
            /*------------------------------------------------*/
            /* Close the dialog when the OK button is pressed */
            /*------------------------------------------------*/
            case DID_OK:

               WinDismissDlg(hwnd, TRUE);
               break;


         }
         return MRFROMSHORT(FALSE);


      default:
         return(WinDefDlgProc(hwnd, msg, mp1, mp2));
   }
   return(WinDefDlgProc(hwnd, msg, mp1, mp2));
}
/*--------------------------------------------------------------------------*/
/* End DlgModemSet Function                                                 */
/*--------------------------------------------------------------------------*/

