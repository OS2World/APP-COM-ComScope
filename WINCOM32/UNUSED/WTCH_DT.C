/**
*
*  Name   wtch_dt -- Wait for a character to be transmitted
*
*  Synopsis ercode = wtch_dt(pcheck,pchar);
*   int  ercode   Returned status code
*   char *pcheck    String (it must be null terminated)
*         against which incoming characters are
*         checked.
*
*  Description  WTCH_DT waits for one of a specified list of characters,
*   and the first one found is returned in *pchar.  The list
*   of characters used to check the incoming characters must
*   be a null terminated string, even if it is of length one.
*   The function reads a character from the input queue, and
*   then checks it agains the string.  If it is found, control
*   and the character are returned to the calling program.  If
*   it is not found, the process is contined until the maxi-
*   mum number of tries is reached (acquired from *ptr_dt, the
*   global transmission information record).  If the input
*   queue is empty, the system is put to sleep for wait_period
*   seconds.  The function updates the field cur_tries in the
*   transmission record.
*
*  Returns  ercode      The values are:
*         0   : Character found and returned.
*         1 - 255 : Standard Level 1 error codes
*         256   : Data transmission record not
*             initialized.
*         257   : Character not found
*   *pchar      Character recovered.  For nonzero values
*         of ercode, *pchar is not set (it retains
*         its current values)
*   ptr_dt->cur_tries Number of error recoveries tried.
*
*               Version 91.00 Quantum Engineering
*
**/
#define INCL_DOS
#define INCL_AVIO

#include "wincom.h"
#include "os2_com.h"

int wtch_dt(THREAD *pstThd,char *pcheck,char *pchar)
{
  WORD bytes_read;
  int i;
  char *ptemp;
  char chInByte;
  DTPARM *pDT = &pstThd->stDTparms;
  THREADCTRL *pThread = &pstThd->stThread;

  int *piTries = &pDT->wCurRetries;
  int iMaxTries = pDT->wMaxRetries;

  while (((*piTries)++ < iMaxTries) && !pThread->bStopThread)
    {
    if(!modem_link_check(pstThd->hCom))
      return(NO_MODEM_ERROR);
    if (DosRead(pstThd->hCom,&chInByte,1,&bytes_read) == 0)
      {
      if (bytes_read != 0)
        {
        ptemp = pcheck;
        while (*ptemp != NUL)
          {
          if (*ptemp++ == chInByte)
            {
            *pchar = chInByte;        /* Character was found.         */
            return(OK);
            }
          }
        }
      else
        DosSleep(pDT->wPacketDelay);
      }
    }
  return(RECEIVE_ERROR);         /* Give up after wMaxRetries      */
  }
