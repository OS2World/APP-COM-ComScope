/**
*
*  Name         erdet_db -- Transmit error detection code
*
*  Synopsis code_size = erdet_dt(ppacket,pcode);
*   int  code_size    The number of bytes in the returned
*         code string.
*   char *ppacket   The data packet for which an error
*         detection code is computed.
*
*  Description  This function computes an error detection code for
*   the passed data packet.  The data packet size and  error
*   detection code algorithm are set in the data transmission
*   structure.  Different algorithms may return a different
*   number of bytes.  The only algorithm supported by this
*   version of ERDET_DT is:
*
*   Code  Description         Code Size
*   ----  ---------------------------   ---------
*     0 Check sum     1 byte
*                 1     CRC                             2 byte
*  Returns  code_size   The size in bytes of the returned code.
*         0 is returned if the data transmission
*         has not been initialized or the specified
*         code cannot be recognized.
*   *pcode      The error detection code.
*
*  Version  2.00 (C)Copyright Blaise Computing Inc.  1985, 1987
*
**/
#define INCL_AVIO
#define INCL_VIO

#include "wincom.h"
#include "os2_com.h"

extern WORD accum;

WORD erdet_db(THREAD *pstThd,char *ppacket)
  {
  int  i;
  DTPARM *pDT = &pstThd->stDTparms;

  switch(pDT->error_detection)
    {
    case 0:                         /* Check sum.                   */
      break;
    case 1:                         /* CRC/16                       */
      accum=0x0000;
      for(i=0;i < pDT->wPacketSize;i++)
        crc_calc(*ppacket++);
      return(accum);
      break;
    default:
      break;
    }
  return(0);
  }
