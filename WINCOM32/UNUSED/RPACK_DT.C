/*
*
*  Name   rpack_dt -- Receive a data packet
*
*  Synopsis ercode = rpack_dt(ppacket,packet_no)
*   int  ercode   The returned error status code
*   char *ppacket   Returned data packet.
*   int  packet_no    Packet number.  Only the packet_no
*         modulo 256 is checked against the
*         received packet number.
*
*  Description  RPACK_DT receives a data packet.  The first two bytes
*   received are the packet number and its (ones) complement.
*   If these two bytes do not sum to (hex) FF, or if the
*   packet number does not match the parameter (modulo 256),
*   a retry is made (START_DT is called). Next the packet is
*   received; the error detection byte(s) are computed, and
*   received.  If the the detection bytes do not match, the
*   packet must be retransmitted.  RPACK_DT will try
*   max_tries to receive the buffer (even if cur_tries exceeds
*   max_tries).  Calls to START_DT flush the I/O queues and
*   set cur_tries to 0.
*
*  Returns  ercode      The values are:
*         0   : Packet successfully received.
*         1 - 255 : Standard Level 1 error codes
*         256   : Data transmission record not
*             initialized.
*         259   : Packet could not be received;
*             maximum retries encountered
*         260   : End of transmission encountered.
*         261   : Error reading packet number
*         262   : Packet numbers incorrect
*         263   : Error reading packet data string
*         264   : Error reading error detection code
*         265   : Error detection codes unequal
*   ptr_dt->cur_tries Number of error recoveries tried.
*
*               Version 91.00 Quantum Engineering
**/
#define INCL_DOS
#define INCL_DOSDEVICES
#define INCL_AVIO
#define INCL_VIO

#include "wincom.h"
#include "os2_com.h"

#include <stdio.h>
/*
** Internal functions
*/
int read_char(THREAD *pstThd,char *pch);
int read_str(THREAD *pstThd,char *pstr,int no_chars);
int TestRestart(THREAD *pstThd,int ercode,int iRestartError);

extern unsigned short accum;

#define CONTINUE 0x1000

int rpack_dt(THREAD *pstThd,char *ppacket,int packet_no)
  {
  int iTemp;
  int ercode;
  int i;
  WORD crc_value;
  BYTE packno;
  BYTE rpackno;
  BYTE cpackno;
  char ch;
  char code_str[2];
  char rcode_str[2];
  int code_size;
  DTPARM *pDT = &pstThd->stDTparms;
  HVPS hPS = pstThd->stVio.hpsVio;

  packno = (char)(packet_no % 256);

  for (i = 0; i < pDT->wMaxRetries; i++)
    {
    pDT->wCurRetries = 0;
    /*
    ** First get the packet number and its complement, then
    ** check to make sure the sum is 0xff and that it is equal to
    ** the passed packet number.
    */
    ercode = read_char(pstThd,&rpackno);
    if (ercode)
      if (ercode == PACK_RCV_ERROR)
        continue;
      else
        return(ercode);
    if ((ercode = read_char(pstThd,&cpackno)) != OK)
      if ((ercode = TestRestart(pstThd,ercode,ERP_RD_NUMBER)) == CONTINUE)
        continue;
      else
        return(ercode);
    /*
    ** IF invalid packet number
    ** THEN re-send sync char
    */
    if (((rpackno | cpackno) != (unsigned char) 0xff)|| (rpackno != packno))
      {
      /*
      ** send sync char
      ** IF invalid character was returned
      ** THEN return error
      */
      if (start_dt(pstThd,pDT->nak_char,&ch) != 0)
        return(ERP_BAD_PACKET_NO);
      /*
      ** IF EOT was received
      ** THEN return end of transmission
      ** ELSE SOH received - start again
      */
      if (ch == pDT->eot_char)    /* Terminate         */
        return(EOT_ENCOUNTERED);
      else
        continue;          /* Received SOH, so start again */
      }
    /*
    ** Now read the packet itself and compute the error detection
    ** value.
    */
    /*
    ** IF no characters were received
    ** THEN re-send sync
    ** ELSE return error
    */
    if ((ercode = read_str(pstThd,ppacket,pDT->wPacketSize)) != 0)
      if ((ercode = TestRestart(pstThd,ercode,ERP_RD_STRING)) == CONTINUE)
        continue;
      else
        return(ercode);
    /*
    ** calculate error detection code
    */
    code_size = erdet_dt(pstThd,ppacket,code_str);
    /*
    ** Now read the error detection code
    */
    /*
    ** IF no characters were received
    ** THEN re-send sync
    ** ELSE return error
    */
    if ((ercode = read_str(pstThd,rcode_str,code_size)) != OK)
      if ((ercode = TestRestart(pstThd,ercode,ERP_RD_ERRDET)) == CONTINUE)
        continue;
      else
        return(ercode);

    VioWrtTTY("R",1,hPS);

    crc_value=(unsigned short)(rcode_str[0]) << 8;
    crc_value=crc_value | ((unsigned short)(rcode_str[1]) & 0xff);

    if(crc_value != accum)
      {
      if (start_dt(pstThd,pDT->nak_char,&ch) != 0)
        return(ERP_ERRDET_UNEQ);
      /*
      ** IF EOT was received
      ** THEN return end of transmission
      ** ELSE SOH received - start again
      */
      if (ch == pDT->eot_char)
        return(EOT_ENCOUNTERED);
      else
        continue;
      }
    /*
    ** At this stage the entire packet has been read, and every-
    ** thing checks out OK.  We can therefore return with a code
    ** of zero.  If there is a problem, the loop is either con-
    ** tinued, or control returns to the calling function.
    */
    return(OK);
    }
  return(PACK_RCV_ERROR);        /* Maximum allowable tries has  */
  }

int TestRestart(THREAD *pstThd,int ercode,int iBadStartError)
  {
  char ch;
  int iError = ercode;
  DTPARM *pDT = &pstThd->stDTparms;
  /*
  ** IF nothing was received
  ** THEN sync again
  */
  if (ercode == PACK_RCV_ERROR)
    {
    /*
    ** send sync char
    ** IF valid character was returned
    ** THEN test which character was received
    ** ELSE return error
    */
    if (start_dt(pstThd,pDT->nak_char,&ch) == OK)
      {
      /*
      ** IF EOT was received
      ** THEN return end of transmission
      */
      if (ch == pDT->eot_char)    /* Terminate         */
        return(EOT_ENCOUNTERED);
      return(CONTINUE);
      }
    return(iBadStartError);
    }
  return(iError);
  }
/**
*
*  Name   read_char -- Read a character
*
*  Synopsis ercode = read_char(pch);
*   int  ercode   Returned error code:  The values are
*         0   : Character successfully returned.
*         1 - 255 : Standard Level 1 error codes
*         259   : Character could not be read.
*             maximum retries encountered
*             while reading the character.
*   char *pch   Character returned from the port.
*
*  Description  This utility function reads the character ch from the
*   port specified by the transmission data record.  If the
*   input buffer is empty, the read is delayed and then
*   tried again.  Each delay increments the current number
*   of tries, and if the maximum is exceeded, an error is
*   returned.
*
**/

int read_char(THREAD *pstThd,char *pch)
  {
  WORD bytes_read;
  char chInByte;
  DTPARM *pDT = &pstThd->stDTparms;
  THREADCTRL *pThread = &pstThd->stThread;
  int iTries = pDT->wCurRetries;
  int iMaxTries = pDT->wMaxRetries;

  while ((iTries++ < iMaxTries) && !pThread->bStopThread)
    {
    if (DosRead(pstThd->hCom,&chInByte,1,&bytes_read) == 0);
      {
      if(bytes_read != 0)
        {
        *pch = chInByte;
        return(OK);
        }
      DosSleep(pDT->wPacketDelay);
      }
    }
  return(PACK_RCV_ERROR);
  }

/**
*
*  Name   read_str -- Read a string
*
*  Synopsis ercode = read_str(pstr,no_chars);
*   int  ercode   Returned error code:  The values are
*         0   : String successfully read.
*         1 - 255 : Standard Level 1 error codes
*         259   : String could not be read; maxi-
*             mum retries encountered while
*             transmitting characters.
*   char *pstr    Returned characters from the port.
*   int  no_chars   Number of characters to read.
*
*  Description  This utility function reads the no_chars from the
*   port specified by the transmission data record and
*   returns them in pstr.  If no enough characters are in the
*   input buffer, the system is delayed and then the read
*   tried again.  Each delay increments the current number
*   of tries, and if the maximum is exceeded, an error is
*   returned.
*
**/

int read_str(THREAD *pstThd,char *pstr,int no_chars)
  {
  WORD bytes_read;
  WORD iq_size = 0;
  DTPARM *pDT = &pstThd->stDTparms;
  THREADCTRL *pThread = &pstThd->stThread;
  int iTries = pDT->wCurRetries;
  int iMaxTries = pDT->wMaxRetries;
  struct
    {
    WORD cch;
    WORD cb;
    }rxq;

  while ((iTries++ < iMaxTries) && !pThread->bStopThread)
    {
    DosDevIOCtl(&rxq,0L,0x0068,0x0001,pstThd->hCom);
    if(rxq.cch >= no_chars)
      {
      DosRead(pstThd->hCom,pstr,no_chars,&bytes_read);
      return(OK);
      }
    DosSleep(pDT->wPacketDelay);
    }
  return(PACK_RCV_ERROR);
  }
