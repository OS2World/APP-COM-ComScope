#define INCL_DOSDEVICES
#define INCL_VIO
#define INCL_DOS
#define building_DD

#include <os2.h>
#include <memory.h>
#include <stdlib.h>
#include "comdd.h"

#define MAX_RESPONSE_LEN 100

void vaStart(USHORT _far *pArgMarker,void *pLastArgAddr);
int vaArgValue(USHORT _far *pArgMarker,WORD wSize);
void *vaArgAddr(USHORT _far *pArgMarker,WORD wSize);

#define bTestOverflow ((iCharCount + iStartLength) < MAX_RESPONSE_LEN)
#define TotalLength (iCharCount + iStartLength)

static char achASCIIdigits[] = "0123456789ABCDEF";

int FormatConvert(void *vpBinary,int iBase,char *pBuffer,
                            int iType,BOOL bPlusSign,int iStartLength)
  {
  unsigned long ulValue;
  int iCharCount = 0;
  char *pASCII;
  int iIndex = 0;
  BOOL bMinusSign = FALSE;
  char achASCII[14];

  pASCII = &achASCII[13];
  if (iType == sizeof(long))
    ulValue = *(unsigned long *)vpBinary;
  else
    if (iBase > 0)
      ulValue = *(unsigned *)vpBinary;
    else
      ulValue = *(int *)vpBinary;
  if (iBase < 0)
    {
    iBase = -iBase;
    if ((long)ulValue < 0)
      {
      ulValue = -(long)ulValue;
      bMinusSign = TRUE;
      }
    }
  do
    {
    *(pASCII--) = achASCIIdigits[(int)(ulValue % iBase)];
    iIndex++;
    } while ((ulValue /= iBase) != 0);
  if (bMinusSign)
    {
    *(pASCII--) = '-';
    iIndex++;
    }
  else
    if (bPlusSign)
      {
      *(pASCII--) = '+';
      iIndex++;
      }
  while ((iCharCount < iIndex) && bTestOverflow)
    {
    pBuffer[iCharCount] = *(++pASCII);
    iCharCount++;
    }
  pBuffer[iCharCount] = 0;
  return(iCharCount);
  }

int sprintf(char *pDestination,int iDestinationStart,char *pFormat,...)
  {
  char chFormat;
  int iCharCount = 0;
  BOOL bRightJustify;
  BOOL bPlusSign;
  char chFill;
  int maxwidth;
  int width;
  int iBase;
  char *pchBuffer;
  char *pchString;
  char *pchDigitBuffer;
  int iType;
  int iStartLength;
  char achDigitBuffer[24];
  ULONG ulTemp;
  WORD wTemp;
  BYTE byTemp;
  USHORT *pArgMarker;

  vaStart(pArgMarker,&pFormat);

  pchBuffer = &pDestination[iDestinationStart];
  iStartLength = (int)(pchBuffer - pDestination);
  pchDigitBuffer = achDigitBuffer;
  while (((chFormat = *(pFormat++)) != 0) && bTestOverflow)
    {
    if (chFormat == '%')
      {
      bRightJustify = TRUE;
      bPlusSign = FALSE;
      chFill = ' ';
      maxwidth = 180;
      chFormat = *pFormat++;
      if (chFormat == '-')
        {
        bRightJustify = FALSE;
        chFormat = *pFormat++;
        }
      else
        if (chFormat == '+')
          {
          bPlusSign = TRUE;
          chFormat = *pFormat++;
          }
      if (chFormat == '0')
        {
        chFill = '0';
        chFormat = *pFormat++;
        }
      if (chFormat == '*')
        {
        width = (int)vaArgValue(pArgMarker,sizeof(int));
        chFormat = *pFormat++;
        }
      else
        {
        width = 0;
        while ((chFormat <= '9') && (chFormat >= '0'))
          {
          width = (width * 10) + (chFormat - '0');
          chFormat = *(pFormat++);
          }
        }
      if ( chFormat == '.' )
        {
        if ((chFormat = *pFormat++) == '*')
          {
          maxwidth = (int)vaArgValue(pArgMarker,sizeof(int));
          chFormat = *(pFormat++);
          }
        else
          {
          maxwidth = 0;
          while ((chFormat <= '9') && (chFormat >= '0'))
            {
            maxwidth = (maxwidth * 10) + (chFormat - '0');
            chFormat = *(pFormat++);
            }
          }
        }
      if (chFormat == 'l')
        {
        iType = sizeof(long);
        chFormat = *pFormat++;
        }
      else
        {
        iType = sizeof(int);
        if (chFormat == 'h')
          chFormat = *pFormat++;
        }
      switch ( chFormat )
        {
        case 'o':
          iBase = 8;
          break;
        case 'u':
          iBase = 10;
          break;
        case 'X':
        case 'x':
          iBase = 16;
          break;
        case 'd':
          iBase = -10;
          break;
        case 's':
          pchString = (char *)vaArgAddr(pArgMarker,2);
          iBase = 0;
          while ((*pchString != 0) && (iBase < maxwidth) && bTestOverflow)
            {
            iBase++;
            iCharCount++;
            *(pchBuffer++) = *(pchString++);
            }
          continue;
        case 'c':
          *(pchBuffer++) = (char)(vaArgValue(pArgMarker,sizeof(int)) & 0x00ff);
          iCharCount++;
          continue;
        default:
          *(pchBuffer++) = chFormat;
          iCharCount++;
          continue;
        }
      if (iType == sizeof(long))
        {
        ulTemp = (ULONG)vaArgValue(pArgMarker,iType);
        iType = FormatConvert(&ulTemp,iBase,pchDigitBuffer,iType,bPlusSign,TotalLength);
        }
      else
        {
        wTemp = (WORD)vaArgValue(pArgMarker,iType);
        iType = FormatConvert(&wTemp,iBase,pchDigitBuffer,iType,bPlusSign,TotalLength);
        }
      if (iType > maxwidth)
        iType = maxwidth;
      if (bRightJustify)
        {
        if (((*pchBuffer == '-') || (*pchBuffer == '+')) &&
             (chFill == '0') && bTestOverflow)
          {
          --width;
          *(pchBuffer++) = *(pchDigitBuffer++);
          iCharCount++;
          }
        while ((width-- > iType) && bTestOverflow)
          {
          iCharCount++;
          *(pchBuffer++) = chFill;
          }
        }
      iBase = 0;
      while ((*pchDigitBuffer != 0) && (iBase < maxwidth) && bTestOverflow)
        {
        *(pchBuffer++) = *(pchDigitBuffer++);
        iBase++;
        iCharCount++;
        }
      if (!bRightJustify)
        {
        while ((width-- > iType) && bTestOverflow)
          {
          iCharCount++;
          *(pchBuffer++) = (' ');
          }
        }
      }
    else
      {
      if (bTestOverflow)
        {
        *(pchBuffer++) = chFormat;
        iCharCount++;
        }
      }
    }
  *pchBuffer = 0;
  return(iCharCount);
  }
