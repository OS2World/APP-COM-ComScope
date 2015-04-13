#define INCL_SUB
#define INCL_DOS
#define INCL_AVIO

#include "wincom.h"
#include "os2_com.h"
/*
#include <stdlib.h>
#include <process.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <direct.h>
#include <conio.h>
*/
#define CCITT_POLY 0x1021
#define DCD_ON 0x80

WORD crctable[256];
WORD comb_val;
WORD accum;

int Transfer(THREAD *pstThd)
  {
  int code;
  int num;

  if (!pstThd->stProcess.bSlave)
    return(sfile_dt(pstThd,&code));
  else
    return(rfile_dt(pstThd,&num));
  }

/***************************************************************************/
/***************************************************************************/
void ModemSetup(HFILE hCom)
  {
  int bytes_written;

  DosWrite(hCom,"ATS0=0E0Q0V0X4&D2&C1\r\n",22,&bytes_written);
  DosSleep(5000L);
  DosWrite(hCom,"ATD\r\n",5,&bytes_written);
  }
/***************************************************************************/
/***************************************************************************/
void mk_crctable(WORD *crctable)
  {
  int i;
  for(i=0;i<256;i++)
    crctable[i]=crchware(i,CCITT_POLY,0);
  }
/***************************************************************************/
/***************************************************************************/
WORD crchware(WORD data,WORD genpoly,WORD accum)
  {
  int i;

  data <<= 8;
  for(i=8; i> 0; i--)
    {
     if((data ^ accum) & 0x8000)
      accum=(accum << 1) ^ genpoly;
     else
      accum <<= 1;
     data <<= 1;
    }
  return(accum);
  }
/***************************************************************************/
/***************************************************************************/
void crc_calc(WORD data)
  {
  comb_val = (accum >> 8) ^ (data & 0xff);
  accum = ( accum << 8) ^ crctable[comb_val];
  }
/***************************************************************************/
/***************************************************************************/
int modem_link_check(HFILE hCom)
  {
/*
  BYTE ctlsig;                             out for test program
  USHORT err;

  err=DosDevIOCtl(&ctlsig,0L,0x0067,0x0001,hCom);
  if(err)
    return(1);
  if(ctlsig & DCD_ON)
    return(1);
  else
    return(0);
*/
  return(1);
  }
/************************************************************************/
/************************************************************************/
