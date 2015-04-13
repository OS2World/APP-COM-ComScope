/**
*
*  Name   parm_dt -- Set data transmission parameters
*
*  Synopsis ercode = parm_dt(pparm);
*   int    ercode   The returned error status code
*   DTPARM **pparm    Pointer to a data transmission structure.
*
*  Description  This function allocates memory for the data transmis-
*   sion structure if the pointer is NIL; otherwise it
*   assumes sufficient space allocated for the the
*   structure.  The structure is initialized to the default
*   values (the XMODEM characteristics).  A global variable
*   is set pointing to the structure so that the other
*   data transmission functions can access and update the
*   record.
*
*  Returns  ercode      The values of the returned code are:
*          0 - Record successfully initialized, and
*              allocated if the pointer was initial-
*              ly NIL.
*         11 - Memeory allocation error
*   *pparm      If *pparm is NIL, the new value is returned.
*
*  Version      91.00 (C)Copyright Quantum Engineering 1991
*
**/
#define INCL_AVIO

#include "wincom.h"
#include "os2_com.h"

void parm_dt(THREAD *pstThd)
  {
  DTPARM *pDT = &pstThd->stDTparms;

  pDT->ack_char       = ACK;
  pDT->nak_char       = NAK;
  pDT->soh_char       = SOH;
  pDT->eot_char       = EOT;
  pDT->crc_char       = CRC;      /* should be CRC */
  pDT->start_delay    = 10000;     /* 10 second delay        */
  pDT->max_tries      = 25;
  pDT->cur_tries      = 0;
  pDT->wait_period    = 500;      /* Just a .5 second delay.*/
  pDT->packet_size    = 128;  /* 64 */
  pDT->error_detection = 1;       /* 1 = CRC calculation        */
  }
