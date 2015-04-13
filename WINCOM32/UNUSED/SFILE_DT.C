/**
*
*  Name   sfile_dt -- Transmit a file
*
*  Synopsis ercode = sfile_dt(pname,ppack_no);
*   int    ercode   Returned status error code
*   char   *pname   File (path) name of the file to be
*         transmitted.
*   int    *ppack_no  Last packet number transmitted.
*
*  Description  This function transmits the data in the specified file
*   using the data transmission protocol specified in the
*   data transmission structure.  It is the responsibility
*   of the calling function to have initialized the data
*   transmission structure. The file whose (path) name is
*   specified is opened in binary mode (that is, new line
*   sequences are not translated), and packet size bytes at
*   a time are read.  If the file size is not a multiple of
*   the packet size, the last packet is filled with nul bytes.
*
*   First SFILE_DT waits to receive a negative acknowledgment
*   from the receiver.  It tries max_tries times (as defined
*   in the transmission structure) for something to appear
*   in the input queue, and then calls WTCH_DT to determine
*   if it is the correct character.  Between each check of the
*   input queue, SFILE_DT waits wait_delay tics giving
*   the receiver time to transmit the negative acknowledgment.
*   After making connection with the receiver, the file is
*   transmitted by making calls to SPACK_DT.  The first packet
*   number is 1.
*
*  Returns  ercode      The values are:
*         0 - File successfully transmitted
*         1 to 255 - Standard Level 1 error codes.
*         256 to 258 - Return codes from SPACK_DT
*         300 - The file could not be opened.
*         301 - Error reading the file. Check
*         *ppackno to see how much of the file
*         was transmitted.
*         302 - Did not receive NAK from receiver.
*         303 - Could not terminate transmission.
*         306 - Port set for less than 8 data bits.
*         307 - Remote or local software flow
*         control enabled.
*   ppackno     Total number of packets transmitted.
*
*               Version 91.00 Quantum Engineering
*
**/
#define INCL_DOS
#define INCL_AVIO

#include "wincom.h"
#include "os2_com.h"
#include <string.h>

int sfile_dt(THREAD *pstThd,int *pPacketCount)
  {
  int ercode;
  int i;
  int count;
  char ch;
  char check[2];
  char *pfilebuf;
  int pack_no = 0;
  char flush_data = 0;
  char flush_cmd = 0;
  THREADCTRL *pThread = &pstThd->stThread;
  DTPARM *pDT = &pstThd->stDTparms;
  HFILE hFile;
  WORD wAction;
  BOOL bDone = FALSE;

  *pPacketCount = 0;

  check[0] = pDT->crc_char;
  check[1] = NUL;
  /*
  ** flush input and output buffers
  */
  DosDevIOCtl(&flush_data,&flush_cmd,0x0002,0x000b,pstThd->hCom);
  DosDevIOCtl(&flush_data,&flush_cmd,0x0001,0x000b,pstThd->hCom);

  pDT->wCurRetries = 0;
  /*
  ** First set up communication with the receiver; wait for negative
  ** acknowledgment.  Try at most pDT->wMaxRetries times.
  */
  for (i = 0; i < pDT->wMaxRetries; i++)
    {
    if ((ercode = wtch_dt(pstThd,check,&ch)) == 0)
      break;          /* NAK received...        */
    else
      pDT->wCurRetries = 0;
    }
  if (ercode)
    return(INIT_NAK_ERR);         /* NAK never received.        */
  /*
  **  allocate packet buffer
  */
  if ((pfilebuf = WinAllocMem(pstThd->hHeap,pDT->wPacketSize)) == NIL)
    return(10);         /* Heap error.          */

  if ((ercode = DosOpen(pDT->pszFileName,&hFile,&wAction,0L,0,0x0001,0x21a0,0L)) != 0)
    return(FILE_OPEN_ERR);

  ercode = OK;
  while (!bDone)
    {
    if (pThread->bStopThread)
      break;
    if (DosRead(hFile,pfilebuf,pDT->wPacketSize,&count) != 0)
      {
      ercode = FILE_READ_ERR;
      break;
      }
    /*
    ** IF byte read is less than packet size
    ** THEN fill remainder of packet buffer with NULLs
    */
    if (count < pDT->wPacketSize)
      {
      bDone = TRUE;
      memset(pfilebuf + count,NUL,pDT->wPacketSize - count);
      }
    /* IF there is data to send
    ** THEN send it
    */
    if (count != 0)
      if ((ercode = spack_dt(pstThd,pfilebuf,++pack_no)) !=OK)
        pack_no--;
    }
  /*
  ** Now clean up: free the allocated buffer, close file,
  ** and tell the receiver we are done.
  */
  WinFreeMem(pstThd->hHeap,pfilebuf,pDT->wPacketSize);
  DosClose(hFile);
  *pPacketCount = pack_no;

  if ((ercode == OK) && term_dt(pstThd))
    return(FINAL_ACK_ERR);        /* Could not terminate.         */
  else
    return(ercode);
  }
