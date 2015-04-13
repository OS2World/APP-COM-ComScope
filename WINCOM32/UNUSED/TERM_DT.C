/**
*
*  Name   term_dt -- Terminate transmission
*
*  Synopsis ercode = term_dt();
*   int  ercode   The returned error status code.
*
*  Description  This function transmits a signoff character to the
*   receiver.  The signoff (end of transmission) character,
*   port, etc. information is acquired from the data trans-
*   mission record.
*
*  Returns  ercode      The values are:
*         0   : End of transmission character
*             transmitted and acknowledgment
*             received.
*         1 - 255 : Standard Level 1 error codes
*         256   : Data transmission record not
*             initialized.
*         257   : Character was sent but no
*             acknowledgment received.
*         258   : End of transmission character
*             could not be sent.
*
*               Version 91.00 Quantum Engineering
*
**/
#define INCL_DOS
#define INCL_AVIO

#include "wincom.h"
#include "os2_com.h"

int term_dt(THREAD *pstThd)
  {
  WORD err;
  WORD bytes_written;
  char check[2];
  char ch;
  char buf[5];
  DTPARM *pDT = &pstThd->stDTparms;

  pDT->wCurRetries = 0;
  check[0] = pDT->ack_char;
  check[1] = NUL;

  do
    {
    buf[0]=pDT->eot_char;
    buf[1]='\0';
    err = DosWrite(pstThd->hCom,buf,1,&bytes_written);
    if ((err == 0) && (bytes_written == 1))
      break;
    else
      if (bytes_written == 0)
        {
        DosSleep(100L);
        pDT->wCurRetries++;
        }
     else
      return((int)err);
    } while (pDT->wCurRetries < pDT->wMaxRetries);
  if (pDT->wCurRetries >= pDT->wMaxRetries)
    return(TRANS_ERROR + 101);
  return(wtch_dt(pstThd,check,&ch));
  }
