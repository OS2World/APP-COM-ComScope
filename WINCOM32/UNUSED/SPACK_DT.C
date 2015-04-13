/**
*
*  Name   spack_dt -- Send a data packet
*
*  Synopsis ercode = spack_dt(ppacket,packet_no);
*   int  ercode   The returned error status code
*   char *ppacket   Data packet to transmit
*   int  packet_no    Packet number.  Only the packet_no
*         modulo 256 is transmitted.
*
*  Description  SPACK_DT transmits a data packet as specified by the
*   data transmission record.  First the output buffer is
*   flushed, then the header character, followed by the packet
*   number and complement are transmitted.  Then the entire
*   packet is transmitted and finally the error detection
*   code.  If an error is encountered during transmission,
*   the number of retries is incremented, the buffer flushed
*   and the process is attempted again (until either
*   successful or the maximum retries has been reached).
*
*  Returns  ercode      The values are:
*         0   : Packet successfully sent.
*         1 - 255 : Standard Level 1 error codes
*         256   : Data transmission record not
*             initialized.
*         257   : Packet was sent but no acknow-
*             ledgment received.
*         258   : Packet could not be sent; maxi-
*             mum retries encountered while
*             transmitting characters.
*
*   ptr_dt->cur_tries Number of error recoveries tried.
*
*               Version 91.00 Quantum Engineering
*
**/
#define INCL_AVIO
#define INCL_VIO
#define INCL_DOS
#define INCL_DOSDEVICES

#include "wincom.h"
#include "os2_com.h"

#include <stdio.h>

#define FLUSH 0

/*
** Internal functions
*/
static int write_str(THREAD *pstThd,char *pstr,int no_chars);
static int write_char(THREAD *pstThd,char ch);

int spack_dt(THREAD *pstThd,char *ppacket,int packet_no)
  {
  int iTemp;
  int ercode;
  int packno;
  char code_str[3];
  char check[3];
  char ch;
  char flush_data = 0;
  char flush_cmd = 0;
  int  code_size;
  WORD temp_short;
  DTPARM *pDT = &pstThd->stDTparms;
  THREADCTRL *pThread = &pstThd->stThread;
  HVPS hPS = pstThd->stVio.hpsVio;

  packno   = (packet_no % 256);    /* Modulo 256         */
  check[0] = pDT->ack_char;    /* Possible acknowledgment  */
  check[1] = pDT->nak_char;
  check[2] = NUL;
  pDT->wCurRetries = 0;

  while ((pDT->wCurRetries < pDT->wMaxRetries) && !pThread->bStopThread)
    {
    /* flush output here */
    DosDevIOCtl(&flush_data,&flush_cmd,0x0002,0x000b,pstThd->hCom);
    /* Now write out the start of text character, and the block     */
    /* count and its complement.  If the output queue is full,      */
    /* write_char will try again.  A nonzero code requires that     */
    /* the function terminate.              */

    if ((ercode = write_char(pstThd,pDT->soh_char)) != 0)
      return(ercode);
    if ((ercode = write_char(pstThd,(char)packno)) != 0)
      return(ercode);
    if ((ercode = write_char(pstThd,(char)~packno)) != 0)
      return(ercode);

       /* Now transmit the packet and the error detection byte(s).     */
       /* If the output queue fills, write_str will try again.         */
       /* Like write_char, a nonzero ercode requires immediate return. */

    if ((ercode = write_str(pstThd,ppacket,pDT->wPacketSize)) != 0)
      return(ercode);

    VioWrtTTY("S",1,hPS);

    code_size  = 2;
    temp_short = erdet_db(pstThd,ppacket);
    code_str[0]=(char)((temp_short & 0xff00) >> 8);
    code_str[1]=(char)(temp_short & 0xff);
    if ((ercode = write_str(pstThd,code_str,code_size)) != 0)
      return(ercode);

     /* Now wait for the acknowledgment from the receiver.         */

    if ((ercode = wtch_dt(pstThd,check,&ch)) != 0)
      return(ercode);         /* Neither ACK or NAK    */
    else
      if (ch == pDT->nak_char)       /* NAK received         */
        pDT->wCurRetries++;
      else
        return(OK);           /* ACK received...done.  */
    }
  return(TRANS_ERROR + 102);
  }

   /**
   *
   *  Name     write_str -- Write a string
   *
   *  Synopsis     ercode = write_str(pstr,no_chars);
   *       int  ercode       Returned error code:  The values are
   *             0       : String successfully sent.
   *             1 - 255 : Standard Level 1 error codes
   *             258     : String could not be sent;
   *                 maximum retries encountered
   *                 whiletransmitting characters.
   *       char *pstr      Buffer to write to the port
   *       int  no_chars     Number of characters to write
   *
   *  Description  This utility function writes the string pstr to the
   *       port specified by the transmission data record.  If the
   *       output buffer fills, transmission is delayed and then
   *       tried again.  Each delay increments the current number
   *       of tries, and if the maximum is exceeded, an error is
   *       returned.
   *
   **/

static int write_str(THREAD *pstThd,char *pstr,int no_chars)
  {
  int  ercode;
  char *ptemp;
  USHORT err,bytes_written;
  DTPARM *pDT = &pstThd->stDTparms;
  THREADCTRL *pThread = &pstThd->stThread;

  bytes_written = 0;
  ptemp   = pstr;
  while ((no_chars > 0) && !pThread->bStopThread)
    {
    err = DosWrite(pstThd->hCom,ptemp,no_chars,&bytes_written);
    if(err)
      {
      ercode=(int)err;
      return(ercode);
      }
    no_chars -= bytes_written;         /* Characters left to write.    */
    ptemp    += bytes_written;         /* Which characters to write.   */
    if (no_chars > 0)        /* Give time for port to clear. */
      {
      DosSleep(pDT->wPacketDelay);
      pDT->wCurRetries++;
      if (pDT->wCurRetries >= pDT->wMaxRetries)
        return(TRANS_ERROR + 103);
      }
    }
  return(OK);
  }

/**
*
*  Name   write_char -- Write a character
*
*  Synopsis ercode = write_char(ch);
*   int  ercode   Returned error code:  The values are
*         0   : Character successfully sent.
*         1 - 255 : Standard Level 1 error codes
*         258   : Character could not be sent;
*             maximum retries encountered
*             while transmitting characters.
*   char ch     Character to write to the port
*
*  Description  This utility function writes the character ch to the
*   port specified by the transmission data record.  If the
*   output buffer fills, transmission is delayed and then
*   tried again.  Each delay increments the current number
*   of tries, and if the maximum is exceeded, an error is
*   returned.
*
**/

static int write_char(THREAD *pstThd,char ch)
  {
  USHORT err,bytes_written;
  char pstr[2];
  DTPARM *pDT = &pstThd->stDTparms;
  THREADCTRL *pThread = &pstThd->stThread;

  pstr[0]=ch;
  pstr[1]='\0';

  do
    {
    err = DosWrite(pstThd->hCom,pstr,1,&bytes_written);
    if (err == 0)
      return(0);
    else
      if (bytes_written == 0)
        {
        DosSleep(pDT->wPacketDelay);
        pDT->wCurRetries++;
        }
      else
        return((int)err);
    } while ((pDT->wCurRetries < pDT->wMaxRetries)
             && !pThread->bStopThread);
  return(TRANS_ERROR + 104);
  }
