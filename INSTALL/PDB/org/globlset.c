#include <COMMON.H>
#include <safepage.h>

#include "QPG_CFG.H"

/*--------------------------------------------------------------------------*/
/*  Global variables                                                        */
/*--------------------------------------------------------------------------*/
CHAR         szClientClass[25];             /* Class Name                   */
HWND         hwndClient;                    /* Client window handle         */
HWND         hwndFrame;                     /* Main Frame window handle     */
//HWND         hwndHelpInstance;              /* Help instance window handle  */
HAB          hab;                           /* anchor block for the process */
HMQ          hmq;                           /* handle to the message queue  */
HPOINTER     hInstIcon;                     /* Application ICON             */
HMODULE      hInstModule;                   /* For external resource DLL    */
HBITMAP      hInstBitmap;                   /* Application bitmap           */

/*--------------------------------------------------------------------------*/
/*      Function: DlgGlobalSet                                              */
/*                                                                          */
/*   Description: This dialog function displays the "Global Settings"       */
/*                notebook page dialog box.                                 */
/*                                                                          */
/*          Date: Aug 01, 1995                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY DlgGlobalSet( HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
{
   static PAGEMSGINFO * pInfo;
   HWND                 hwndPorts;
   char                 szPortStr[2], szRetries[3], szBuffer[17], 
                        szTmpBuff[17];
   int                  Index, bInvalidChar;


   hwndPorts = WinWindowFromID(hwnd, IDCTL_INST_COM_PORT);

   switch(msg)
   {
      case WM_INITDLG:

         pInfo = (PAGEMSGINFO *)mp2;

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_INST_COM_PORT,
                           SPBM_SETTEXTLIMIT,
                           (MPARAM)1,
                           (MPARAM)0);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_INST_COM_PORT,
                           SPBM_SETLIMITS,
                           (MPARAM)4L,
                           (MPARAM)1L);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_INST_COM_PORT,
                           SPBM_SETCURRENTVALUE,
                           (MPARAM)1L,
                           (MPARAM)0L);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_INST_RETRIES,
                           SPBM_SETTEXTLIMIT,
                           (MPARAM)2,
                           (MPARAM)0);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_INST_RETRIES,
                           SPBM_SETLIMITS,
                           (MPARAM)99L,
                           (MPARAM)3L);

         WinSendDlgItemMsg(hwnd, 
                           IDCTL_INST_RETRIES,
                           SPBM_SETCURRENTVALUE,
                           (MPARAM)3L,
                           (MPARAM)0L);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_SENDER,
                           EM_SETTEXTLIMIT,
                           (MPARAM)8L,
                           MPVOID);

         WinSetDlgItemText(hwnd, 
                           IDFLD_INST_SENDER,
                           (PSZ)"YOUR_ID");

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_GROUP,
                           EM_SETTEXTLIMIT,
                           (MPARAM)16L,
                           MPVOID);

         WinSetDlgItemText(hwnd, 
                           IDFLD_INST_GROUP,
                           (PSZ)"YOUR_GROUP_NAME");

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_PREFIX,
                           EM_SETTEXTLIMIT,
                           (MPARAM)5L,
                           MPVOID);

         WinSetDlgItemText(hwnd, 
                           IDFLD_INST_PREFIX,
                           (PSZ)"1");

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_INST_LOG_FILE,
                           EM_SETTEXTLIMIT,
                           (MPARAM)12L,
                           MPVOID);

         WinSetDlgItemText(hwnd, 
                           IDFLD_INST_LOG_FILE,
                           (PSZ)"PAGERDEF.LOG");

         WinSendDlgItemMsg(hwnd, 
                           IDBTN_INST_TIMESTAMP,
                           BM_SETCHECK,
                           (MPARAM)1L,
                           MPVOID);

         WinSendDlgItemMsg(hwnd, 
                           IDBTN_INST_SINGLE,
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
            case IDFLD_INST_SENDER:
            case IDFLD_INST_GROUP:
            case IDFLD_INST_PREFIX:
            case IDFLD_INST_LOG_FILE:
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
                           if(SHORT1FROMMP(mp1) == IDFLD_INST_SENDER ||
                              SHORT1FROMMP(mp1) == IDFLD_INST_GROUP  ||
                              SHORT1FROMMP(mp1) == IDFLD_INST_LOG_FILE)
                           {
                              if (!isalpha(szTmpBuff[Index]))
                              {
                                 if(szTmpBuff[Index] != '_'  &&
                                    szTmpBuff[Index] != '-'  &&
                                    szTmpBuff[Index] != '.')
                                    bInvalidChar = TRUE;
                                 else
                                    strncat(szBuffer, szTmpBuff+Index, 1);
                              }
                              else
                                 strncat(szBuffer, szTmpBuff+Index, 1);
                           }

                           if(SHORT1FROMMP(mp1) == IDFLD_INST_PREFIX)
                           {
                              if (!isdigit(szTmpBuff[Index]))
                              {
                                 if(szTmpBuff[Index] != ',')
                                    bInvalidChar = TRUE;
                                 else
                                    strncat(szBuffer, szTmpBuff+Index, 1);
                              }
                              else
                                 strncat(szBuffer, szTmpBuff+Index, 1);
                           }
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

         WinSendDlgItemMsg(hwnd,
                           IDCTL_INST_COM_PORT,
                           SPBM_QUERYVALUE,
                           (MPARAM)szPortStr,
                           MPFROM2SHORT((USHORT)sizeof(szPortStr),
                                        SPBQ_ALWAYSUPDATE));

         WinSendDlgItemMsg(hwnd,
                           IDCTL_INST_RETRIES,
                           SPBM_QUERYVALUE,
                           (MPARAM)szRetries,
                           MPFROM2SHORT((USHORT)sizeof(szRetries),
                                        SPBQ_ALWAYSUPDATE));

         pInfo->Port               = (BYTE)atoi(szPortStr);
         pInfo->ServicePageRetries = atoi(szRetries);

         WinQueryDlgItemText(hwnd,
                             IDFLD_INST_SENDER,
                             sizeof(pInfo->SenderSignature),
                             (PSZ)pInfo->SenderSignature);

         WinQueryDlgItemText(hwnd,
                             IDFLD_INST_GROUP,
                             sizeof(pInfo->GroupName),
                             (PSZ)pInfo->GroupName);

         WinQueryDlgItemText(hwnd,
                             IDFLD_INST_PREFIX,
                             sizeof(pInfo->DialPrefix),
                             (PSZ)pInfo->DialPrefix);

         WinQueryDlgItemText(hwnd,
                             IDFLD_INST_LOG_FILE,
                             sizeof(pInfo->MessageID),
                             (PSZ)pInfo->MessageID);

         pInfo->IDStamp = (USHORT)
         WinSendDlgItemMsg(hwnd,
                           IDBTN_INST_SENDER_ID,
                           BM_QUERYCHECK,
                           (MPARAM)0,
                           (MPARAM)0);

         pInfo->TimeStamp = (USHORT)
         WinSendDlgItemMsg(hwnd,
                           IDBTN_INST_TIMESTAMP,
                           BM_QUERYCHECK,
                           (MPARAM)0,
                           (MPARAM)0);

         pInfo->GrpNameStamp = (USHORT)
         WinSendDlgItemMsg(hwnd,
                           IDBTN_INST_GROUPSTAMP,
                           BM_QUERYCHECK,
                           (MPARAM)0,
                           (MPARAM)0);

         pInfo->SinglePage = (USHORT)
         WinSendDlgItemMsg(hwnd,
                           IDBTN_INST_SINGLE,
                           BM_QUERYCHECK,
                           (MPARAM)0,
                           (MPARAM)0);

         return (MRESULT)TRUE;



      case WM_COMMAND:

         switch (SHORT1FROMMP(mp1))
         {
            /*------------------------------------------------*/
            /* Close the dialog when the OK button is pressed */
            /*------------------------------------------------*/
            case DID_OK:

               break;


         }
         return MRFROMSHORT(FALSE);

      default:
         return(WinDefDlgProc(hwnd, msg, mp1, mp2));
   }
   return(WinDefDlgProc(hwnd, msg, mp1, mp2));
}
/*--------------------------------------------------------------------------*/
/* End DlgGlobalSet Function                                                */
/*--------------------------------------------------------------------------*/


/*--------------------------------------------------------------------------*/
/*      Function: CenterWindow                                              */
/*                                                                          */
/*   Description: This function centers a window inside its parent window.  */
/*                                                                          */
/*          Date: Jul 15, 1995                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/
VOID CenterWindow(HWND hwnd, HWND hwndParent)
{

   SHORT ix, iy;
   SHORT iwidth, idepth;
   SWP   swp;


   iwidth = (SHORT)WinQuerySysValue( hwndParent, SV_CXSCREEN );
   idepth = (SHORT)WinQuerySysValue( hwndParent, SV_CYSCREEN );

   WinQueryWindowPos( hwnd, (PSWP)&swp);

   ix = (SHORT)(( iwidth - swp.cx ) / 2);
   iy = (SHORT)(( idepth - swp.cy ) / 2);
   WinSetWindowPos( hwnd, HWND_TOP, ix, iy, 0, 0, SWP_MOVE);

}
/*--------------------------------------------------------------------------*/
/* End CenterWindow Function                                                */
/*--------------------------------------------------------------------------*/

