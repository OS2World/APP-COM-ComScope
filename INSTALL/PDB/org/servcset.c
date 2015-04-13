#include <COMMON.H>
#include <safepage.h>

#include "QPG_CFG.H"

static BAUDRATES BaudRates[4] =
{
   { "300",     300 },
   { "1200",   1200 },
   { "2400",   2400 },
   { "9600",   9600 }
};

/*--------------------------------------------------------------------------*/
/*      Function: DlgServiceSet                                             */
/*                                                                          */
/*   Description: This dialog function displays the "Paging Services"       */
/*                notebook page dialog box.                                 */
/*                                                                          */
/*          Date: Aug 01, 1995                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY DlgServiceSet(HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
{
   ULONG                ulIndex ;
   static PAGEMSGINFO * pInfo;
   char                 szBuffer[17], szTmpBuff[17];
   int                  Index, bInvalidChar;


   switch(msg)
   {
      case WM_INITDLG:

         pInfo = (PAGEMSGINFO *)mp2;

         for(ulIndex = 0; ulIndex < 4; ulIndex++)
         {
            WinSendDlgItemMsg (hwnd, IDCTL_SVC_BAUD_RATE, SLM_SETTICKSIZE,
                               MPFROM2SHORT(SMA_SETALLTICKS, 8), 0L);

            WinSendDlgItemMsg (hwnd, IDCTL_SVC_BAUD_RATE, SLM_SETSCALETEXT,
                               MPFROMSHORT(ulIndex), MPFROMP(BaudRates[ulIndex].szText));
         }

         WinSendDlgItemMsg (hwnd, 
                            IDCTL_SVC_BAUD_RATE,
                            SLM_SETSLIDERINFO,
                            MPFROM2SHORT(SMA_SLIDERARMPOSITION, SMA_INCREMENTVALUE),
                            MPFROMSHORT(1));


         WinSendDlgItemMsg(hwnd, 
                           IDFLD_SVC_NAME,
                           EM_SETTEXTLIMIT,
                           (MPARAM)20L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_SVC_PNUM,
                           EM_SETTEXTLIMIT,
                           (MPARAM)12L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_SVC_SNUM,
                           EM_SETTEXTLIMIT,
                           (MPARAM)12L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_SVC_MESSAGES,
                           SPBM_SETLIMITS,
                           (MPARAM)MAX_PAGES_PER_CALL,
                           (MPARAM)1L);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_SVC_MESSAGES,
                           SPBM_SETCURRENTVALUE,
                           (MPARAM)10L,
                           (MPARAM)0L);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_SVC_CHARS,
                           SPBM_SETLIMITS,
                           (MPARAM)234L,
                           (MPARAM)1L);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_SVC_CHARS,
                           SPBM_SETCURRENTVALUE,
                           (MPARAM)80L,
                           (MPARAM)0L);



         WinSendDlgItemMsg(hwnd, 
                           IDBTN_SVC_7_BITS,
                           BM_SETCHECK,
                           (MPARAM)1L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDBTN_SVC_EVEN,
                           BM_SETCHECK,
                           (MPARAM)1L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDBTN_SVC_1_SBITS,
                           BM_SETCHECK,
                           (MPARAM)1L,
                           MPVOID);

         return MRFROMSHORT(FALSE);




      case WM_CONTROL:

         memset(&szBuffer,  0, sizeof(szBuffer));
         memset(&szTmpBuff, 0, sizeof(szTmpBuff));

         switch (SHORT1FROMMP(mp1))
         {
            //----------------------------------------------------------//
            // Highlight fields.                                        //
            //----------------------------------------------------------//
            case IDFLD_SVC_NAME:
            case IDFLD_SVC_PNUM:
            case IDFLD_SVC_SNUM:
            {
               switch ((USHORT) SHORT2FROMMP(mp1))
               {

                  case EN_CHANGE:
                  {
                     WinQueryDlgItemText(hwnd, SHORT1FROMMP(mp1),
                                         sizeof(szTmpBuff), (PSZ)szTmpBuff);

                     if (strlen(szTmpBuff) > 0)
                     {
                        bInvalidChar = FALSE;
                        for (Index = 0; Index < strlen(szTmpBuff);
                             ++Index)
                        {
                           if(SHORT1FROMMP(mp1) == IDFLD_SVC_PNUM ||
                              SHORT1FROMMP(mp1) == IDFLD_SVC_SNUM)
                           {
                              if (!isdigit(szTmpBuff[Index]))
                              {
                                 if(szTmpBuff[Index] != '-')
                                    bInvalidChar = TRUE;
                                 else
                                    strncat(szBuffer, szTmpBuff+Index, 1);
                              }
                              else
                                 strncat(szBuffer, szTmpBuff+Index, 1);
                           }
                           else
                              strcpy(szBuffer, szTmpBuff);
                        }

                        if (bInvalidChar)
                           WinSetDlgItemText(hwnd, SHORT1FROMMP(mp1),
                                             (PSZ)szBuffer);

                     }
                  }
                  break;


                  case EN_SETFOCUS:
                  {
                     WinSendDlgItemMsg(hwnd,
                                       SHORT1FROMMP(mp1),
                                       EM_SETSEL,
                                       MPFROM2SHORT(0, 256),
                                       (MPARAM)NULL);
                    break;
                  }
               }
            }
         }
         break;



      case WM_CHAR:

         if(SHORT2FROMMP(mp2) == VK_ESC)
            return MRFROMSHORT(FALSE);

         break;



      case WM_COLLECT_INFO:

         WinQueryDlgItemText(hwnd, 
                             IDFLD_SVC_NAME,
                             sizeof(pInfo->ServiceName),
                            (PSZ)pInfo->ServiceName);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_SVC_PNUM,
                             sizeof(pInfo->ServicePNum),
                            (PSZ)pInfo->ServicePNum);

         WinQueryDlgItemText(hwnd, 
                             IDFLD_SVC_SNUM,
                             sizeof(pInfo->ServiceSNum),
                            (PSZ)pInfo->ServiceSNum);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_SVC_MESSAGES,
                           SPBM_QUERYVALUE,
                           (MPARAM)&ulIndex,
                           MPFROM2SHORT(0, SPBQ_ALWAYSUPDATE));

         pInfo->ServiceMaxMsgs = (int)ulIndex;


         WinSendDlgItemMsg(hwnd, 
                           IDCTL_SVC_CHARS,
                           SPBM_QUERYVALUE,
                           (MPARAM)&ulIndex,
                           MPFROM2SHORT(0, SPBQ_ALWAYSUPDATE));

         pInfo->ServiceBlockChars = (int)ulIndex;

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_5_BITS,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceWordLen, "5");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_6_BITS,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceWordLen, "6");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_7_BITS,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceWordLen, "7");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_8_BITS,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceWordLen, "8");


         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_EVEN,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceParity, "E");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_ODD,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceParity, "O");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_NONE,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceParity, "N");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_1_SBITS,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceStopBits, "1");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_15_SBITS,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceStopBits, "1.5");

         if((BOOL)
            WinSendDlgItemMsg(hwnd,
                              IDBTN_SVC_2_SBITS,
                              BM_QUERYCHECK,
                              (MPARAM)0L,
                              (MPARAM)0L))
            sprintf(pInfo->ServiceStopBits, "2");


         Index = (int)
         WinSendDlgItemMsg (hwnd,
                            IDCTL_SVC_BAUD_RATE,
                            SLM_QUERYSLIDERINFO,
                            MPFROM2SHORT(SMA_SLIDERARMPOSITION, SMA_INCREMENTVALUE),
                           (MPARAM)0L);

         sprintf(pInfo->ServiceBaudRate, "%d", BaudRates[Index].BaudRate);

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
/* End DlgServiceSet Function                                               */
/*--------------------------------------------------------------------------*/

