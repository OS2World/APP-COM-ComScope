/**
*
*  Name   start_dt -- Signal ready to receive data
*
*  Synopsis ercode = start_dt(synch_ch,pch);
*   int  ercode   Returned error status code
*   char synch_ch   Synchronization character.  Character
*         which is transmitted to indicate that
*         data can now be sent.
*   char *pch   Returned character acknowledging the
*         synchronization character.
*
*  Description  START_DT is used to signal the transmitter that it may
*   begin sending data packets, or that a packet was received
*   and a new packet can now be sent.  The acknowledgment
*   character from the transmitter indicates whether a new
*   packet will be shipped (start of text character) or
*   transmission is to terminate (end of transmission).
*   As usual, information on error retries, characters to
*   send and receive is contained in the data transmission
*   structure.
*
*   START_DT begins by flushing the input and output buffers,
*   because calling this function synchronizes the communication
*   between the transmitter and receiver.  The synch character
*   is then transmitted, and then WTCH_DT is called to wait
*   for the receipt of either an end of transmission or start
*   of data character.
*
*  Returns  ercode      The values are:
*         0   : Synch character sent and a
*             character received.
*         1 - 255 : Standard Level 1 error codes
*         256   : Data transmission record not
*             initialized.
*         257   : Synch character was sent but
*             but no acknowledgment received.
*
*   ptr_dt->cur_tries Number of error recoveries tried.
*
*               Version 91.00 Quantum Engineering
*
**/
#define INCL_DOSDEVICES
#define INCL_DOS
#define INCL_AVIO

#include "wincom.h"
#include "os2_com.h"

#define FLUSH 0

int start_dt(THREAD *pstThd,char synch_ch,char *pch)
  {
  WORD err;
  WORD bytes_written;
  char check[3];
  char buf[3];
  char flush_data = 0;
  char flush_cmd = 0;
  DTPARM *pDT = &pstThd->stDTparms;

  check[0] = pDT->soh_char;    /* Possible acknowledgment  */
  check[1] = pDT->eot_char;
  check[2] = NUL;
  pDT->wCurRetries = 0;

  /*
  ** Flush both queues, send the synch character and wait for the
  ** correct response.
  */
  DosDevIOCtl(&flush_data,&flush_cmd,0x0001,0x000b,pstThd->hCom);
  DosDevIOCtl(&flush_data,&flush_cmd,0x0002,0x000b,pstThd->hCom);

  buf[0]=synch_ch;
  buf[1]='\0';

  err = DosWrite(pstThd->hCom,buf,1,&bytes_written);
  if (err != 0)
    return((int)err);

  return(wtch_dt(pstThd,check,pch));
  }
