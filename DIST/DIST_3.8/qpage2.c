/*----------------------------------------------------------------------------*/
/*    Module Name: QPAGE2.C                                                   */
/*                                                                            */
/*    Description: QuickPage/2 product main module.                           */
/*                 This program contains all functions for the QuickPage      */
/*                 product.                                                   */
/*                                                                            */
/*         Author: Francisco J. O'Meany                                       */
/*                                                                            */
/*           Date: Jul 15, 1995                                               */
/*                                                                            */
/*      Copyright: OS/tools Incorporated 1995                                 */
/*                                                                            */
/*       Comments:                                                            */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/*----------------------------------------------------------------------------*/


#include <common.h>
#include <safepage.h>
#include "qpage.h"

/*--------------------------------------------------------------------------*/
/* Global variables                                                         */
/*--------------------------------------------------------------------------*/
int ConfigFileDefined;
int LogFileDefined;
int PinDefined;
int DisplayHelp;
int bPopUp;

char szConfigFile[65];
char szLogFile[65];

HVIO           hvio;
VIOMODEINFO    VioModeInfo;

/*----------------------------------------------------------------------------*/
/* Main routine                                                               */
/*----------------------------------------------------------------------------*/
int main(int argc, char **argv, char *envp)
{
   char           szMsg[128];
   int            Index, ReturnCode ;
   TID            tidPager;
   ULONG          ulRC;
   PAGEMSGINFO    pInfo;


   printf("QuickPage/2 - OS/2 Operating System.\n");
   printf("Version 1.0 - Aug 29 1995.\n");

   #ifdef DEMO_ONLY
      printf("*************************\n");
      printf("*    EVALUATION COPY    *\n");
      printf("*************************\n");
   #endif

   printf("Copyright (C) OS/Tools Incorporated 1995 - All Rights Reserved.\n");

   bPopUp            = FALSE;
   ConfigFileDefined = FALSE;
   LogFileDefined    = FALSE;
   PinDefined        = FALSE;
   DisplayHelp       = FALSE;

   if (argc == 1)
      DisplayHelp = TRUE;

   memset(&pInfo,        0, sizeof(PAGEMSGINFO));
   memset(&szConfigFile, 0, sizeof(szConfigFile));
   memset(&szLogFile,    0, sizeof(szLogFile));

   /*-----------------------------------------------------*/
   /* First pass of parameters passed.                    */
   /*-----------------------------------------------------*/
   for(Index = 1; Index < argc; Index++)
   {
      ProcessParameters(argv[Index],
                        &pInfo,
                        TRUE);
   }

   if( ConfigFileDefined )
   {
      ReturnCode = ProcessConfigFile(szConfigFile,
                                     &pInfo);

      if(ReturnCode)
      {
         ReportErrorMessage( (int)ReturnCode );
         exit(ReturnCode);
      }
   }


   /*-----------------------------------------------------*/
   /* Second pass of parameters passed to override        */
   /* default configuration in PAGEDEF.CFG                */
   /*-----------------------------------------------------*/
   for(Index = 1; Index < argc; Index++)
   {
      ProcessParameters(argv[Index], 
                        &pInfo,
                        FALSE);
   }


   if ( DisplayHelp )
   {
      DisplaySyntax();
      exit(ID_INCORRECT_SYNTAX);
   }


   if(pInfo.Message[0] == 0)
      strcpy(pInfo.Message, "No Text");

   /*-----------------------------------------------------*/
   /* When an individual PIN is passed as parameter and   */
   /* a CFG file is also defined, all other PINs defined  */
   /* in the CFG file are ignored.                        */
   /*-----------------------------------------------------*/
   if(PinDefined)
   {
      for(Index = 1; Index < MAX_PAGES_PER_CALL; Index++)
         memset(&pInfo.pSubscriberInfo[Index].PinID, 0,
                sizeof(pInfo.pSubscriberInfo[Index].PinID));
   }

   printf("\n");

   ReportErrorMessage( ID_BEGIN_COMMAND );




         if( LogFileDefined || szLogFile )
         {
            sprintf(szMsg, "QPI150 Page In Progress");
            if(pInfo.SinglePage)
            {
               if(atoi(pInfo.pSubscriberInfo[0].PinID) != 0)
               {
                  strcat(szMsg, " To PIN ");
                  strcat(szMsg, pInfo.pSubscriberInfo[0].PinID);
               }
            }
            else
            {
               if(pInfo.GroupName[0] != 0)
               {
                  strcat(szMsg, " To ");
                  strcat(szMsg, pInfo.GroupName);
               }
            }

            if(pInfo.ServicePNum[0] != 0)
            {
               strcat(szMsg, ".  Dialing ");
               strcat(szMsg, pInfo.ServicePNum);
            }

            strcat(szMsg, "...\n");
            printf(szMsg);

            WriteMessageToLogFile( szLogFile, szMsg );
         }





   ulRC = SendAlphaMessage((ULONG)&pInfo);

   ReportErrorMessage( (int)ulRC );

   exit(ulRC);

}

