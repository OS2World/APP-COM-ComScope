#include <COMMON.H>
#include <safepage.h>

#include "QPG_CFG.H"

extern HMODULE hThisModule;

/*--------------------------------------------------------------------------*/
/*      Function: DlgPinsList                                               */
/*                                                                          */
/*   Description: This dialog function displays the "PIN Definitions"       */
/*                notebook page dialog box.                                 */
/*                                                                          */
/*          Date: Aug 01, 1995                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY DlgPinsList(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
{
   static PAGEMSGINFO * pInfo;
   static char          szBuffer[21], szPinSelected[21] ;
   static int           bDefining = FALSE;
   HWND                 hwndPinList ;
   int                  Index, IndexNew, NumberOfItems, bNewPin ;


   hwndPinList = WinWindowFromID(hwnd, IDBOX_DEFINE_PIN);

   switch(msg)
   {
      case WM_INITDLG:

         pInfo = (PAGEMSGINFO *)mp2;

         WinInsertLboxItem(hwndPinList,
                           LIT_END,
                           ID_NEW_PIN_TEXT);

         WinSelectLboxItem(hwndPinList,
                           0,
                           TRUE);

         CenterWindow(hwnd, HWND_DESKTOP);

         return MRFROMSHORT(FALSE);



      case WM_COLLECT_INFO:

         NumberOfItems =
         WinQueryLboxCount(hwndPinList);

         for(Index = 0; Index < NumberOfItems; Index++)
         {
            WinQueryLboxItemText(hwndPinList,
                                 Index,
                                 szBuffer,
                                 sizeof(szBuffer));

            if(stricmp(szBuffer, ID_NEW_PIN_TEXT))
               strcpy(pInfo->pSubscriberInfo[Index].PinID, szBuffer);
         }

         return (MRESULT)TRUE;

#ifdef thsi_junk

      case WM_CHAR:

         if(SHORT2FROMMP(mp2) == VK_ESC)
            return MRFROMSHORT(FALSE);

         if(SHORT2FROMMP(mp2) == VK_HOME ||
            SHORT2FROMMP(mp2) == VK_END)
            WinPostMsg(hwndPinList,
                       CBM_SHOWLIST,
                       (MPARAM)FALSE,
                       (MPARAM)0);

         break;

#endif

      case WM_ADD_NEW_PIN:


         memset(&szPinSelected,  0, sizeof(szPinSelected));

         if(!mp1)
            break;

         strcpy(szPinSelected, (char *)mp1);

         Index   = SHORT1FROMMP(mp2);
         bNewPin = SHORT2FROMMP(mp2);

         if(WinDlgBox(HWND_DESKTOP,
                      hwnd,
                      (PFNWP)DlgCollPins,
                      hThisModule,
                      ID_DLG_COLLECT_PIN,
                      (PVOID)&szPinSelected) == DID_OK)
         {
            if(strlen(szPinSelected) > 0)
            {
               if(bNewPin)
               {
                  Index =
                  WinInsertLboxItem(hwndPinList,
                                    LIT_SORTASCENDING,
                                    szPinSelected);

                  if(WinQueryLboxCount(hwndPinList) > MAX_PAGES_PER_CALL)
                  {
                     IndexNew = Index;
                     WinDeleteLboxItem(hwndPinList,
                                       WinQueryLboxCount(hwndPinList)-1);
                  }
                  else
                     IndexNew = WinQueryLboxCount(hwndPinList)-1;

                  WinSelectLboxItem(hwndPinList,
                                    IndexNew,
                                    TRUE);

                  WinScrollLboxItemToTop(hwndPinList, IndexNew);
               }
               else
               {
                  WinSetLboxItemText(hwndPinList,
                                     Index,
                                     szPinSelected);

                  WinSelectLboxItem(hwndPinList,
                                    Index,
                                    TRUE);

                  WinScrollLboxItemToTop(hwndPinList, Index);
               }

               WinPostMsg(hwndPinList,
                          CBM_SHOWLIST,
                          (MPARAM)TRUE,
                          (MPARAM)0);
            }
         }

         bDefining = FALSE;

         break;



      case WM_CHECK_PINS_LIST:

         bDefining = FALSE;

         Index = WinQueryLboxSelectedItem(hwndPinList);

         if(Index != -1)
         {
            WinQueryLboxItemText(hwndPinList,
                                 Index,
                                 szBuffer,
                                 sizeof(szBuffer));

            bNewPin =
            !stricmp(szBuffer, ID_NEW_PIN_TEXT);

            bDefining = TRUE;
            WinPostMsg(hwnd,
                       WM_ADD_NEW_PIN,
                       (MPARAM)&szBuffer,
                       MPFROM2SHORT(Index, bNewPin));
         }

         break;




      case WM_CONTROL:

         memset(&szBuffer,  0, sizeof(szBuffer));

         switch (SHORT1FROMMP(mp1))
         {
            //----------------------------------------------------------//
            // PINs List Box                                            //
            //----------------------------------------------------------//
            case IDBOX_DEFINE_PIN:
            {
               switch ((USHORT) SHORT2FROMMP(mp1))
               {
                  case CBN_ENTER:
                  {
                     if(bDefining)
                        break;

                     WinPostMsg(hwnd,
                                WM_CHECK_PINS_LIST,
                                (MPARAM)0,
                                (MPARAM)0);
                  }
               }

               Index = WinQueryLboxCount(hwndPinList);
               if( Index < MAX_PAGES_PER_CALL)
                  WinEnableControl(hwnd, IDBTN_DEFINE_ADD, TRUE);
               else
                  WinEnableControl(hwnd, IDBTN_DEFINE_ADD, FALSE);



               if(Index > 1)
                  WinEnableControl(hwnd, IDBTN_DEFINE_REMOVE_ALL, TRUE);
               else
                  WinEnableControl(hwnd, IDBTN_DEFINE_REMOVE_ALL, FALSE);


               Index = WinQueryLboxSelectedItem(hwndPinList);

               if(Index != -1)
               {
                  WinQueryLboxItemText(hwndPinList,
                                       Index,
                                       szBuffer,
                                       sizeof(szBuffer));

                  if(!stricmp(szBuffer, ID_NEW_PIN_TEXT))
                  {
                     WinEnableControl(hwnd, IDBTN_DEFINE_EDIT,   FALSE);
                     WinEnableControl(hwnd, IDBTN_DEFINE_REMOVE, FALSE);
                  }
                  else
                  {
                     WinEnableControl(hwnd, IDBTN_DEFINE_EDIT,   TRUE);
                     WinEnableControl(hwnd, IDBTN_DEFINE_REMOVE, TRUE);
                  }
               }
            }
         }

         break;



      case WM_COMMAND:

         switch (SHORT1FROMMP(mp1))
         {
            /*------------------------------------------------*/
            /* Close the dialog when the OK button is pressed */
            /*------------------------------------------------*/
            case IDBTN_DEFINE_ADD:

               if(bDefining)
                  break;

               WinSelectLboxItem(hwndPinList,
                                 WinQueryLboxCount(hwndPinList)-1,
                                 TRUE);

               WinPostMsg(hwnd,
                          WM_CHECK_PINS_LIST,
                          (MPARAM)0,
                          (MPARAM)0);

               break;


            case IDBTN_DEFINE_EDIT:

               WinPostMsg(hwnd,
                          WM_CHECK_PINS_LIST,
                          (MPARAM)0,
                          (MPARAM)0);

               break;


            case IDBTN_DEFINE_REMOVE:

               NumberOfItems = WinQueryLboxCount(hwndPinList);
               Index = WinQueryLboxSelectedItem(hwndPinList);

               if(Index != -1)
               {
                  WinDeleteLboxItem(hwndPinList, Index);

                  if(Index > 0)
                     Index--;

                  WinSelectLboxItem(hwndPinList,
                                    Index,
                                    TRUE);
                  WinScrollLboxItemToTop(hwndPinList, Index);


                  bNewPin       = FALSE;
                  NumberOfItems =
                  WinQueryLboxCount(hwndPinList);

                  for(Index = 0; Index < NumberOfItems; Index++)
                  {
                     WinQueryLboxItemText(hwndPinList,
                                          Index,
                                          szBuffer,
                                          sizeof(szBuffer));

                     if(!stricmp(szBuffer, ID_NEW_PIN_TEXT))
                        bNewPin = TRUE;
                  }

                  if(!bNewPin)
                     WinInsertLboxItem(hwndPinList,
                                       LIT_END,
                                       ID_NEW_PIN_TEXT);
               }

               WinPostMsg(hwndPinList,
                          CBM_SHOWLIST,
                          (MPARAM)TRUE,
                          (MPARAM)0);

               break;


            case IDBTN_DEFINE_REMOVE_ALL:

               WinDeleteLboxAll(hwndPinList);

               WinInsertLboxItem(hwndPinList,
                                 LIT_END,
                                 ID_NEW_PIN_TEXT);

               WinSelectLboxItem(hwndPinList,
                                 0,
                                 TRUE);
               WinScrollLboxItemToTop(hwndPinList, 0);

               WinPostMsg(hwndPinList,
                          CBM_SHOWLIST,
                          (MPARAM)TRUE,
                          (MPARAM)0);

               break;

         }
         return MRFROMSHORT(FALSE);


      default:
         return(WinDefDlgProc(hwnd, msg, mp1, mp2));
   }
   return(WinDefDlgProc(hwnd, msg, mp1, mp2));
}
/*--------------------------------------------------------------------------*/
/* End DlgPinsList Function                                                 */
/*--------------------------------------------------------------------------*/




/*--------------------------------------------------------------------------*/
/*      Function: DlgCollPins                                               */
/*                                                                          */
/*   Description: This dialog function displays the "PIN Definitions"       */
/*                dialog box.                                               */
/*                                                                          */
/*          Date: Aug 01, 1995                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY DlgCollPins(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
{
   char          szBuffer[21], szTmpBuff[21] ;
   static char * szPin ;
   int           Index, bInvalidChar ;

   switch(msg)
   {
      case WM_INITDLG:

         szPin = (char *)mp2;

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_COLLECT_PIN,
                           EM_SETTEXTLIMIT,
                           (MPARAM)20L,
                           MPVOID);

         if(!stricmp(szPin, ID_NEW_PIN_TEXT))
            memset(szPin, 0, sizeof(szPin));
         else
            WinSetWindowText(hwnd, "Modify PIN Number");

         WinSetDlgItemText(hwnd, 
                           IDFLD_COLLECT_PIN,
                           szPin);

         WinSendDlgItemMsg(hwnd, 
                           IDFLD_COLLECT_PIN,
                           EM_SETSEL,
                           MPFROM2SHORT(0, 256),
                           (MPARAM)NULL);

         CenterWindow(hwnd, HWND_DESKTOP);


         return MRFROMSHORT(FALSE);



      case WM_CONTROL:

         memset(&szBuffer,  0, sizeof(szBuffer));
         memset(&szTmpBuff, 0, sizeof(szTmpBuff));

         switch (SHORT1FROMMP(mp1))
         {
            //----------------------------------------------------------//
            // Validate fields.                                         //
            //----------------------------------------------------------//
            case IDFLD_COLLECT_PIN:
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
                           if (!isdigit(szTmpBuff[Index]))
                              bInvalidChar = TRUE;
                           else
                              strncat(szBuffer, szTmpBuff+Index, 1);
                        }

                        if (bInvalidChar)
                           WinSetDlgItemText(hwnd, SHORT1FROMMP(mp1),
                                             (PSZ)szBuffer);

                     }
                  }
               }
            }
         }

         WinQueryDlgItemText(hwnd, IDFLD_COLLECT_PIN,
                             sizeof(szBuffer),
                             (PSZ)szBuffer);

         if(strlen(szBuffer) != 0)
            WinEnableControl(hwnd, DID_OK, TRUE);
         else
            WinEnableControl(hwnd, DID_OK, FALSE);

         break;



      case WM_COMMAND:

         switch (SHORT1FROMMP(mp1))
         {
            /*------------------------------------------------*/
            /* Close the dialog when the OK button is pressed */
            /*------------------------------------------------*/
            case DID_OK:

               WinQueryDlgItemText(hwnd, 
                                   IDFLD_COLLECT_PIN,
                                   sizeof(szBuffer),
                                   szBuffer);

               memset(szPin, 0, sizeof(szPin));
               strcpy(szPin, szBuffer);

               WinDismissDlg(hwnd, DID_OK);
               break;

            case DID_CANCEL:

               WinDismissDlg(hwnd, DID_CANCEL);
               break;

         }
         break;


      default:
         return(WinDefDlgProc(hwnd, msg, mp1, mp2));
   }
   return(WinDefDlgProc(hwnd, msg, mp1, mp2));
}
/*--------------------------------------------------------------------------*/
/* End DlgCollPins Function                                                 */
/*--------------------------------------------------------------------------*/

