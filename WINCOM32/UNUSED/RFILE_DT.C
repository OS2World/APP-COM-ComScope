/**
*
*  Name   rfile_dt -- Receive a file
*
*  Synopsis ercode = rfile_dt(pname,ppack_no);
*   int    ercode   Returned status error code
*   char   *pname   File (path) name of the file to create
*         using the received file data.
*   int    *ppack_no  Last packet number received.
*
*  Description  This function receives packets of information using
*   the protocol defined in the data transmission record, and
*   writes the data to the specified file. It is the responsi-
*   bility of the calling function to have initialized the data
*   transmission structure. The file whose (path) name is
*   specified is opened in binary mode (that is, new line
*   sequences are not translated), and as each data packet is
*   received, it is written to the file.  The total number of
*   packets received is returned.
*
*   First RFILE_DT transmits the negative acknowledgment char-
*   acter using START_DT every ten seconds max_tries times.
*   If a start of data character is returned, calls to RPACK_DT
*   are made to receive the packets.  After each packet is
*   successfully received, an acknowledgment is transmitted
*   waiting for another start of data (i.e., another packet
*   will be transmitted) character or an end of transmission
*   character.
*
*  Returns  ercode      The values are:
*         0 - File successfully received (an end
*             of transmission character received).
*         1 to 255 - Standard Level 1 error codes.
*         256 to 266 - Return codes from RPACK_DT.
*         300 - The file could not be opened.
*         304 - Error writing to the file. Check
*         *ppackno to see how much of the
*         file was received and written.
*         305 - Did not receive end of transmission
*         or start of data character.
*         306 - Port set for less than 8 data bits.
*         307 - Remote or local software flow
*         control enabled.
*   ppackno     Total number of packets received.
*
*               Version 91.00   Quantum Engineering
**/
#define INCL_AVIO
#define INCL_DOS
#define INCL_DOSDEVICES

#include "wincom.h"
#include "os2_com.h"

#define FLUSH 0

int rfile_dt(THREAD *pstThd,int *pPacketCount)
  {
  WORD bytes_written;
  int pack_no;
  int ercode;
  int i;
  char ch;
  char buf[5];
  char flush_data = 0;
  char flush_cmd = 0;
  char *packet;
  DTPARM *pDT = &pstThd->stDTparms;
  THREADCTRL *pThread = &pstThd->stThread;
  WORD wAction;
  HFILE hFile;


  pack_no   = 0;
  *pPacketCount = 0;

  pDT->wCurRetries = 0;
  /*
  ** flush input and output buffers
  */
  DosDevIOCtl(&flush_data,&flush_cmd,0x0002,0x000b,pstThd->hCom);
  DosDevIOCtl(&flush_data,&flush_cmd,0x0001,0x000b,pstThd->hCom);
  /*
  ** First set up communication with the transmitter.  Send out a
  ** negative acknowledgment once every ten seconds, but at most
  ** pDT->wMaxRetries times.  Looking to receive an end of trans-
  ** mission or start of data character.
  */
  for (i = 0;(i < pDT->wMaxRetries) && !pThread->bStopThread; i++)
    {
    if ((ercode = start_dt(pstThd,pDT->crc_char,&ch)) != 0)
      {
      if(!modem_link_check(pstThd->hCom))
        return(-100);
      DosSleep(300L);
      }
    else
      if (ch == pDT->eot_char)
        return(-1);      /* Done, before we start! */
      else
        break;          /* Got the soh_char         */
    }
  if (pThread->bStopThread)
    return(0x8000);
  if (i >= pDT->wMaxRetries)
    return(SOH_EOT_ERR);
  /*
  **  allocate packet buffer
  */
  if ((packet = WinAllocMem(pstThd->hHeap,pDT->wPacketSize)) == NIL)
    return(10);         /* Heap error.          */
  /*
  ** open file - fail if not exist, for mainly sequential,
  ** deny read/write share access, for write only
  */
  if ((ercode = DosOpen(pDT->pszFileName,&hFile,&wAction,0L,0,0x0001,0x2191,0L)) != 0)
    return(FILE_OPEN_ERR);

  do
    {
    if ((ercode = rpack_dt(pstThd,packet,++pack_no)) == OK)
      {
      if ((ercode = DosWrite(hFile,packet,pDT->wPacketSize,&bytes_written)) != 0)
        {
        ercode = FILE_WRITE_ERR;
        break;
        }
      if (start_dt(pstThd,pDT->ack_char,&ch)) /* Acknowledge and see   */
        ercode = SOH_EOT_ERR;     /* if another packet is ready.  */
      }
    else
      pack_no--;
    } while ((ercode == OK) && (ch == pDT->soh_char) && !pThread->bStopThread);

  /*
  ** Now clean up: free the allocated buffer, close file
  ** and tell the sender we received the end of transmission.
  */
  WinFreeMem(pstThd->hHeap,packet,pDT->wPacketSize);
  DosClose(hFile);
  *pPacketCount = pack_no;
  if (ercode == OK)
    {
    buf[0]=pDT->ack_char;
    buf[1]='\0';
    DosWrite(pstThd->hCom,buf,1,&bytes_written);
    }
  return(ercode);
  }
