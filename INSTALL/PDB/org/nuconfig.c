#include <COMMON.H>
#include <safepage.h>

#include "QPG_CFG.H"

/*--------------------------------------------------------------------------*/
/*  Function Name: CreateConfigFile                                         */
/*                                                                          */
/*     Processing: This function creates a QuickPage configuration file.    */
/*                                                                          */
/*     Parameters:     szLog   Pointer to a buffer containing the log file  */
/*                             name.                                        */
/*                 szMessage   Pointer to a buffer container the message    */
/*                             information.                                 */
/*                                                                          */
/*       Comments: This function adds the date and time stamp at the        */
/*                 beginning of the szMessage info as (MM-DD-YYYY HH:MM:SS) */
/*                                                                          */
/*        Returns: none.                                                    */
/*                                                                          */
/*--------------------------------------------------------------------------*/
int CreateConfigFile( char * szFile, PAGEMSGINFO * pInfo )
{

   char   szMsg[160], szTime[32];
   int    Index;
   HFILE  hFile;
   time_t tTime;
   ULONG ulStatus;
   ULONG ulCount;
   int fResult = NEW_FILE;

  if (DosOpen(szFile,&hFile,&ulStatus,0L,0,0x0011,0x1112,(PEAOP2)0L) != NO_ERROR)
    return(FILE_ERROR);
  if (ulStatus == FILE_EXISTED)
    {
    fResult = OLD_FILE;
    sprintf(szMsg,
            "%s Already Exists.\n\n"
            "Do You Want To Overwrite It?",
            szFile);
    if(MessageBox(szMsg,
                  MB_YESNOCANCEL | MB_QUERY |
                  MB_SYSTEMMODAL | MB_DEFBUTTON3) != MBID_YES)
      {
      DosClose(hFile);
      return(NO_FILE);
      }
    }
   time(&tTime);

   memset(&szMsg,  0, sizeof(szMsg));
   memset(&szTime, 0, sizeof(szTime));

   strncat(szTime, ctime(&tTime)+4,  3);
   strcat (szTime, " ");
   strncat(szTime, ctime(&tTime)+8,  2);
   strcat (szTime, ", ");
   strncat(szTime, ctime(&tTime)+20, 4);
   strcat (szTime, " at");
   strncat(szTime, ctime(&tTime)+10, 9);

   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";                                                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";    File Name: %s", szFile);
   strncat(szMsg, "                                                               ",
           62-strlen(szFile));
   strcat( szMsg, ";\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";                                                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";  Description: QuickPage Configuration file.                                 ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";                                                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";         Note: Use this configuration file as a model for other configura-   ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";               tion.                                                         ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";                                                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";   Created On: %s", szTime);
   strncat(szMsg, "                                                               ",
           62-strlen(szTime));
   strcat( szMsg, ";\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";                                                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";   Copyright (c) OS/Tools Incorporated 1995.                                 ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; Global settings configuration.   This configuration applies to selections   ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; made during installation. The default comm port used (ComPort) is COM1.     ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; Use the COM port available to your system or override this global setting   ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; by passing /COM:n parameter from the command line.                          ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "[GlobalSettings]\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "ComPort     = %d\n", pInfo->Port);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "SinglePage  = ");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   if(pInfo->SinglePage)
      sprintf(szMsg, "Y\n");
   else
      sprintf(szMsg, "N\n");

   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "GroupName   = %s\n", pInfo->GroupName);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "SenderID    = %s\n", pInfo->SenderSignature);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "DialPrefix  = %s\n", pInfo->DialPrefix);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "StampID     = ");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   if(pInfo->IDStamp)
      sprintf(szMsg, "Y\n");
   else
      sprintf(szMsg, "N\n");

   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "StampTime   = ");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   if(pInfo->TimeStamp)
      sprintf(szMsg, "Y\n");
   else
      sprintf(szMsg, "N\n");

   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "StampGroup  = ");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   if(pInfo->GrpNameStamp)
      sprintf(szMsg, "Y\n");
   else
      sprintf(szMsg, "N\n");

   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "PageRetries = %d\n", pInfo->ServicePageRetries);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "LogFile     = %s\n\n\n", pInfo->MessageID);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; Modem name and setting commands. Use Hayes Smartmodem compatible types.     ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "[Modem]\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "Name=%s\n", pInfo->pModemInfo.ModemName);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Setup=%s\n", pInfo->pModemInfo.SetupString);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Reset=%s\n", pInfo->pModemInfo.ResetString);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Escape=%s\n", pInfo->pModemInfo.EscapeString);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Disconnect=%s\n", pInfo->pModemInfo.DisconnectStr);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Busy=%s\n", pInfo->pModemInfo.CodeBusy);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "DialTone=%s\n", pInfo->pModemInfo.CodeDialTone);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Carrier=%s\n", pInfo->pModemInfo.CodeCarrier);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Answer=%s\n", pInfo->pModemInfo.CodeAnswer);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Speaker=");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   if(pInfo->ServiceModem)
      sprintf(szMsg, "On\n");
   else
      sprintf(szMsg, "Off\n");

   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, "SpeakerVolume=%s\n\n\n", pInfo->ServiceSpeaker);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; Messaging service parameters.                                               ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "[Service]\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Name=%s\n", pInfo->ServiceName);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "PrimaryNumber=%s\n", pInfo->ServicePNum);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "SecondaryNumber=%s\n", pInfo->ServiceSNum);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "BaudRate=%s\n", pInfo->ServiceBaudRate);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "WordLength=%s\n", pInfo->ServiceWordLen);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Parity=%s\n", pInfo->ServiceParity);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "StopBits=%s\n", pInfo->ServiceStopBits);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "MaxMessages=%d\n", pInfo->ServiceMaxMsgs);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "MaxBlockChars=%d\n\n\n", pInfo->ServiceBlockChars);
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; Up to 234 text characters when a message text is sent without Sender's ID,  ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; StampTime condition, and without group name.                                ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";                                                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; When Sender ID is specified and StampID is equal to 'Y':                    ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";    Substract 11 characters.                                                 ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; When StampTime is equal to 'Y':                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";    Substract 08 characters.                                                 ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; When group name is specified and StampGroup is equal to 'Y':                ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";    Substract 19 characters.                                                 ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";                                                                             ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "[Message]\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "Text=\n\n\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; Add up to 128 Pager IDs in a single call. (When supported by paging service);\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "[Subscribers]\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   for(Index = 0; Index < MAX_PAGES_PER_CALL; Index++)
   {
      sprintf(szMsg, "Pager%d=%s\n", Index+1, pInfo->pSubscriberInfo[Index].PinID);
      DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   }

   sprintf(szMsg, "\n\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, "; End of Configuration File.                                                  ;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);
   sprintf(szMsg, ";-----------------------------------------------------------------------------;\n");
   DosWrite(hFile,(PVOID)szMsg,strlen(szMsg),&ulCount);

   DosClose(hFile);

   return(fResult);
}


