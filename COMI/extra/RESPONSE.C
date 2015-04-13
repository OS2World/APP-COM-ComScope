/************************************************************************
**
** $Revision:   1.2  $
**
** $Log:   P:/archive/comi/RESPONSE.C_V  $
** 
**    Rev 1.2   28 Mar 1996 00:19:36   EMMETT
** Added resource manager.  Began work on VDD support.
** 
**    Rev 1.1   19 Feb 1996 11:39:18   EMMETT
** Removed most user selectable variable parsing to fit
** reduced feature set of 16 bit version of COMi.
** 
**    Rev 1.0   16 Apr 1994 08:35:42   EMMETT
** Initial version control archive.
**
************************************************************************/

#define INCL_DOSDEVICES
#define INCL_VIO
#define building_DD

#include <os2.h>
//#include <string.h>
#include "COMDD.H"
#include "COMDCB.H"
#include "CUTIL.H"

extern WORD StringLength(BYTE abyString[]);

int FindDigit(void);
void ParseResponseData(void);
void ProcessResponseFile(BYTE FAR abyFileSpec[]);
int ProcessDriverParams(void);
void ProcessDeviceParams(void);
int FindToken(BYTE byToken,sBOOL bSkipEOL);
BYTE FindAnyToken(void);
sBOOL BypassComment(void);
BYTE FindDelimiter(void);
LONG ASCIItoBin(int iRadix);
void ProcessBufferCommand(void);
void ParseParms(void);
LONG GetValue(void);
void SkipWords(BYTE byByte);
sBOOL IsAlphaNumeric(BYTE byByte);
sBOOL IsXdigit(BYTE byByte);
sBOOL IsDigit(BYTE byByte);
BYTE ToLowerCase(BYTE byByte);

void ErrorExit(void);

extern USHORT usDosIOdelayCount;
extern WORD wIntIDregister;
extern WORD wDCBcount;
extern BYTE abyCOMnumbers[9];
extern WORD wEndOfData;

extern WORD wCOMstart;
extern WORD wCOMlast;
extern int iStartDevice;
extern int iEndDevice;

extern bWaitForCR;

extern WORD wOEMjumpExit;
extern DEVDEF *pDeviceParms;
extern DEVDEF DeviceParms[];
extern DEVHEAD *pStart;
extern DEVHEAD *pPrevious;
extern WORD wDeviceStrategy;
extern VOID NEAR *pDeviceStrategy;
extern DEVHEAD stDummyHeader;
extern WORD wLoadCount;
extern WORD wLoadNumber;
extern WORD wLoadFlags;


#ifndef RTEST
void ErrorExit(void)
  {
  response_file_error_return();
  }
#endif

BYTE ToLowerCase(BYTE byByte)
  {
  if (byByte < 'A')
    return(byByte);
  if (byByte > 'Z')
    return(byByte);
  return(byByte | (BYTE)'\x20');
  }

void SkipWords(BYTE byByte)
  {
  while (1)
    {
    while (IsAlphaNumeric(byByte));
    if ((byByte != '_') && (byByte != ' ') && (byByte != '\t'))
      return;
    }
  }

sBOOL IsAlphaNumeric(BYTE byByte)
  {
  if ((byByte >= 'a') && (byByte <= 'z'))
    return(TRUE);
  if ((byByte >= '0') && (byByte <= '9'))
    return(TRUE);
  if (byByte == '_')
    return(TRUE);
  return(FALSE);
  }

sBOOL IsXdigit(BYTE byByte)
  {
  if ((byByte >= '0') && (byByte <= '9'))
    return(TRUE);
  if ((byByte >= 'a') && (byByte <= 'f'))
    return(TRUE);
  return(FALSE);
  }

sBOOL IsDigit(BYTE byByte)
  {
  if ((byByte >= '0') && (byByte <= '9'))
    return(TRUE);
  return(FALSE);
  }

void ProcessResponseFile(BYTE FAR abyFileSpec[])
  {
  WORD wStatus = 0;
  WORD wCount;
  WORD Error;
  HFILE hFile;
  WORD wPathIndex;
  WORD wNameIndex;
  sBOOL bUseDefaultPath = TRUE;
  BYTE byChar;
  BYTE *pbyName;

  wPathIndex = 0;
  byChar = abyPath[wPathIndex];
  while ((byChar != ' ') && (byChar != 0))
    {
    szDefaultPath[wPathIndex++] = byChar;
    byChar = abyPath[wPathIndex];
    }
  szDefaultPath[wPathIndex] = 0;
  bContinueParse = FALSE;
  /*
  ** test if file spec includes explicit path
  */
  wPathIndex = 0;
  while ((abyFileSpec[wPathIndex] != 0) &&
         (abyFileSpec[wPathIndex] != ' ') &&
         (abyFileSpec[wPathIndex] != '/'))
    {
    if ((abyFileSpec[wPathIndex] == '\\') || (abyFileSpec[wPathIndex] == ':'))
      {
      bUseDefaultPath = FALSE;
      break;
      }
    wPathIndex++;
    }
  if (wPathIndex == 0)
    return;
  wPathIndex = 0;
  wNameIndex = 0;
  /*
  ** if no explicit path was supplied then append file name to device
  ** driver absolute path.
  */
  if (bUseDefaultPath)
    {
    while (szDefaultPath[wPathIndex++] != 0);
    while ((szDefaultPath[wPathIndex] != '\\') && (szDefaultPath[wPathIndex] != ':'))
      wPathIndex--;
    wPathIndex++;
    }
  while ((abyFileSpec[wNameIndex] != 0) &&
         (abyFileSpec[wNameIndex] != ' ') &&
         (abyFileSpec[wNameIndex] != '/'))
    szDefaultPath[wPathIndex++] = abyFileSpec[wNameIndex++];
  szDefaultPath[wPathIndex] = 0;
  if (abyFileSpec[wNameIndex] != 0)
    bContinueParse = TRUE;
  if ((Error = DosOpen(szDefaultPath,(PHFILE)&hFile,(PUSHORT)&wStatus,0L,0,1,0x4190,0L)) != 0)
    {
    VioWrtTTY(chFailedOpen,StringLength(chFailedOpen),0);
    return;
    }
  if ((Error = DosRead(hFile,&abyFileBuffer,(MAX_BUFFER - 1),&wCount)) != 0)
    {
    VioWrtTTY(chFailedRead,StringLength(chFailedRead),0);
    return;
    }
  DosClose(hFile);
  abyFileBuffer[wCount] = 0;
  ParseResponseData();
  wDCBcount = ((wCOMlast - wCOMstart) + 1);
  if (wDCBcount > 8)
    wDCBcount = 8;
  wEndOfData = ((WORD)DeviceParms + (wDCBcount * sizeof(DEVDEF)));
  pDeviceParms = (DEVDEF *)DeviceParms;
  wDeviceStrategy = (WORD)&pDeviceStrategy;
  pPrevious = NULL;
  for (wNameIndex = 0;wNameIndex < wDCBcount;wNameIndex++)
    {
    /*
    ** if starting header address is not defined then define it
    ** and set dummy header to point to it
    */
    if (pStart == NULL)
      pStart = &pDeviceParms->stDeviceHeader;
    /*
    **  Transfer load flag interrupt status/ID bits to device flags
    */
    astComDCB[wNameIndex].wDeviceFlags1 |= (wLoadFlags & CFG_FLAG1_INT_ID_LOAD_MASK);
    /*
    ** Initialized device header
    */
    pDeviceParms->stDeviceHeader.StrategyOffset = wDeviceStrategy;
    abyCOMnumbers[wNameIndex] = (BYTE)wCOMstart;
    pbyName = pDeviceParms->stDeviceHeader.abyDeviceName;
//    pbyName[0] = 'C';
//    pbyName[1] = 'O';
//    pbyName[2] = 'M';
    if (wCOMstart > 9)
      {
      pbyName[3] = (BYTE)((wCOMstart / 10) + '0');
      pbyName[4] = (BYTE)((wCOMstart % 10) + '0');
      }
    else
      {
      pbyName[3] = ((wCOMstart & 0x0f) + '0');
      pbyName[4] = ' ';
      }
    pbyName[5] = ' ';
    pbyName[6] = ' ';
    pbyName[7] = ' ';
    wCOMstart++;
    if (pPrevious != NULL)
      pPrevious->pNextHeader = &pDeviceParms->stDeviceHeader;
    pPrevious = &pDeviceParms->stDeviceHeader;
    pPrevious->pNextHeader = (VOID *)(-1);
    pDeviceParms++;
    wDeviceStrategy += 6;
    wLoadCount++;
    }
  if (wLoadCount > 0)
    {
    pDeviceParms--;
    stDummyHeader.pNextHeader = pStart;
//    stDummyHeader.sCodeSegment = pDeviceParms->stDeviceHeader.sCodeSegment;
    pDeviceParms->stDeviceHeader.sCodeSegment = 0xffff;
    wLoadNumber = 1;
    }
  else
    {
//    VioWrtTTY(chResponseFileBad,StringLength(chResponseFileBad),0);
    wLoadNumber = NO_DEFINED_DEVICES;
    }
  }

sBOOL BypassComment(void)
  {
  if (abyFileBuffer[iDataIndex + 1] == '*')
    {
    iDataIndex += 2;
    while (1)
      {
      while (abyFileBuffer[iDataIndex] != '*')
        if (abyFileBuffer[iDataIndex++] == 0)
          ErrorExit();
      if (abyFileBuffer[iDataIndex + 1] == '/')
        {
        iDataIndex += 2;
        return(TRUE);
        }
      else
        iDataIndex++;
      }
    }
  return(FALSE);
  }

/*
** search for "byToken" until token is found or until the end of the line
*/
int FindToken(BYTE byToken,sBOOL bSkipEOL)
  {
  while (abyFileBuffer[iDataIndex] != byToken)
    {
    if (abyFileBuffer[iDataIndex] == 0)
      ErrorExit();
    if ((abyFileBuffer[iDataIndex] == '\n') && !bSkipEOL)
      return(FALSE);
    if (abyFileBuffer[iDataIndex] == '/')
      {
      if (!BypassComment())
        iDataIndex++;
      }
    else
      iDataIndex++;
    }
  iDataIndex++;
  return(FOUND_TOKEN);
  }

/*
** search for white space up to the end of the line or up to beginning
** of parameter ('').
*/
BYTE FindDelimiter(void)
  {
  while (abyFileBuffer[iDataIndex] != 0)
    {
    if ((abyFileBuffer[iDataIndex] == '\r') ||
        (abyFileBuffer[iDataIndex] == '\n') ||
        (abyFileBuffer[iDataIndex] == '\t') ||
        (abyFileBuffer[iDataIndex] == '(')  ||
        (abyFileBuffer[iDataIndex] == '{')  ||
        (abyFileBuffer[iDataIndex] == ')')  ||
        (abyFileBuffer[iDataIndex] == '}')  ||
        (abyFileBuffer[iDataIndex] == '-')  ||
        (abyFileBuffer[iDataIndex] == ','))
      return(abyFileBuffer[iDataIndex++]);
    if (abyFileBuffer[iDataIndex] == '/')
      if (!BypassComment())
        return(abyFileBuffer[iDataIndex++]);
    iDataIndex++;
    }
  ErrorExit();
  }

int FindDigit(void)
  {
  while (!IsXdigit(abyFileBuffer[iDataIndex]))
    {
    if (abyFileBuffer[iDataIndex] == 0)
      ErrorExit();
    if (abyFileBuffer[iDataIndex] == '\n')
      return(FALSE);
    if (abyFileBuffer[iDataIndex] == '/')
      {
      if (!BypassComment())
        iDataIndex++;
      }
    else
      iDataIndex++;
    }
  return(FOUND_TOKEN);
  }

BYTE FindAnyToken(void)
  {
  while (!IsAlphaNumeric(abyFileBuffer[iDataIndex]))
    {
    if (abyFileBuffer[iDataIndex] == 0)
      ErrorExit();
    if (abyFileBuffer[iDataIndex] == '(')
      {
      iDataIndex++;
      return('(');
      }
    if (abyFileBuffer[iDataIndex] == '}')
      return('}');
    if (abyFileBuffer[iDataIndex] == '/')
      {
      if (!BypassComment())
        iDataIndex++;
      }
    else
      iDataIndex++;
    }
  return(abyFileBuffer[iDataIndex]);
  }

void ParseResponseData(void)
  {
  /*
  ** convert all alpha characters to lower case
  */
  iDataIndex = 0;
  while (abyFileBuffer[iDataIndex] != 0)
    {
    if (abyFileBuffer[iDataIndex] == '\"')
      {
      iDataIndex++;
      while (abyFileBuffer[iDataIndex] != '\"')
        {
        if (abyFileBuffer[iDataIndex] == '\\')
          iDataIndex++;
        iDataIndex++;
        }
      }
    abyFileBuffer[iDataIndex] = ToLowerCase(abyFileBuffer[iDataIndex]);
    iDataIndex++;
    }
  iDataIndex = 0;
  wCOMstart = 3;
  wCOMlast = 10;
  /*
  ** all keywords and their parameters must begin on a line of their own
  */
  while (FindAnyToken() != 'e')
    {
    switch (abyFileBuffer[iDataIndex])
      {
      case 'i':
        if (!FindToken('(',TO_EOL))
          break;
        if (!FindDigit())
          break;
        usDosIOdelayCount = (WORD)GetValue();
        if (usDosIOdelayCount == 0)
          usDosIOdelayCount = 1;
        break;
      case 'v':
        VioWrtTTY(chProcessing,StringLength(chProcessing),0);
        bVerbose = TRUE;
        break;
      case 'c':
        /*
        ** COMx name designation
        **
        ** requires "()" pair for parameter
        ** parameter must be present or COM1 through COM8 will be selected
        */
        if (!FindToken('(',TO_EOL))
          break;
        if (!FindDigit())
          break;
        wCOMstart = (WORD)GetValue();
        if (wCOMstart == 0)
          {
          wCOMstart = 1;
          wCOMlast = 8;
          break;
          }
        while (!IsDigit(abyFileBuffer[iDataIndex]))
          {
          if (abyFileBuffer[iDataIndex] == ')')
            break;
          iDataIndex++;
          }
        if (!IsDigit(abyFileBuffer[iDataIndex]))
          wCOMlast = (wCOMstart + 7);
        else
          wCOMlast = (WORD)GetValue();
        break;
      case 'd':
        ProcessDeviceParams();
        break;
      case 't':
        if (!FindToken('(',TO_EOL))
          break;
        if (!FindDigit())
          break;
        wDelayCount = (WORD)GetValue();
        if (wDelayCount == 0)
          wDelayCount = 20;
        bWaitForCR = TRUE;
        break;
      }
    FindToken('\n',TO_EOL);
    }
  }

void ProcessDeviceParams(void)
  {
  if (!FindToken('(',TO_EOL))
    {
    iStartDevice = 1;
    iEndDevice = 8;
    }
  else
    {
    if (!FindDigit())
      return;
    iStartDevice = (int)GetValue();
    while (!IsDigit(abyFileBuffer[iDataIndex]))
      {
      if (abyFileBuffer[iDataIndex] == ')')
        break;
      iDataIndex++;
      }
    if (!IsDigit(abyFileBuffer[iDataIndex]))
      iEndDevice = iStartDevice;
    else
      iEndDevice = (int)GetValue();
    }
  if (!FindToken('{',SKIP_EOL))
    return;
  ParseParms();
  }

void ParseParms()
  {
  int iIndex;
  WORD wTemp;
  LONG lTemp;

  /*
  ** All keywords and their parameters must be on a line of their own
  ** with the exception of keywords that require a "{}" pair.
  **
  ** The "{" and subsequent keywords and parameters can either be on the
  ** same line or on different lines (newlines are not considered delimiters).
  */
  while (FindAnyToken() != '}')
    {
    switch (abyFileBuffer[iDataIndex])
      {
      case 'm':
        /*
        ** A double quote (") begins and ends the string to be output.
        **
        ** The "\" character is an escape character and the following
        ** characters have special meaning when immediately following the
        ** escape character:
        **
        **  "n" means insert line feed and carraige return (newline)
        **  "r" means insert a carraige return
        **  "t" means insert a tab
        **  "x" means to translate the following two characters as a
        **      base 16 (hexidecimal) value (byte)
        **
        **  If a line feed (0x0d) or a carraige return (0x0a) character
        **  follow the escape character then all characters up to the next
        **  escape character are ignored.
        **
        **  Any other character following the escape character is taken
        **  literally (including a "\") and place in the string to putput.
        **
        ** The maximum length of the string is 255 bytes.
        */
        if(!FindToken('\"',TO_EOL))
          break;
        iIndex = 0;
        while ((abyFileBuffer[iDataIndex] != '\"') && (iIndex < 255))
          {
          if (abyFileBuffer[iDataIndex] == '\\')
            {
            iDataIndex++;
            switch (abyFileBuffer[iDataIndex])
              {
              case 'n':
                iDataIndex++;
                abyString[iIndex++] = '\n';
                abyString[iIndex++] = '\r';
                break;
              case 'r':
                iDataIndex++;
                abyString[iIndex++] = '\r';
                break;
              case 't':
                iDataIndex++;
                abyString[iIndex++] = '\t';
                break;
              case '\x0d':
              case '\x0a':
                while (abyFileBuffer[iDataIndex++] != '\\');
                break;
              case 'x':
                iDataIndex++;
                if (IsXdigit(abyFileBuffer[iDataIndex]))
                  {
                  abyNumber[0] = abyFileBuffer[iDataIndex++];
                  abyNumber[1] = 0;
                  if (IsXdigit(abyFileBuffer[iDataIndex]))
                    {
                    abyNumber[1] = abyFileBuffer[iDataIndex++];
                    abyNumber[2] = 0;
                    }
                  abyString[iIndex++] = (BYTE)ASCIItoBin(16);
                  }
                else
                  abyString[iIndex++] = 'x';
                break;
              default:
                abyString[iIndex++] = abyFileBuffer[iDataIndex++];
                break;
              }
            }
          else
            {
            if (abyFileBuffer[iDataIndex] == '\n')
              while (abyFileBuffer[iDataIndex++] != '\\');
            abyString[iIndex++] = abyFileBuffer[iDataIndex++];
            }
          }
        VioWrtTTY(abyString,iIndex,0);
        break;
      case 's':
        if (!FindToken('(',TO_EOL))
          break;
        while (!IsDigit(abyFileBuffer[iDataIndex]))
          {
          if (abyFileBuffer[iDataIndex] == ')')
            break;
          iDataIndex++;
          }
        if (!IsDigit(abyFileBuffer[iDataIndex]))
          {
          astComDCB[iIndex].wDeviceFlags1 &= ~CFG_FLAG1_SCRATCH_IS_INT_ID;
          wOEMjumpExit = 0;
          wIntIDregister = 0;
          }
        else
          {
          wIntIDregister = (WORD)GetValue();
          for (iIndex = (iStartDevice - 1);iIndex < iEndDevice;iIndex++)
            astComDCB[iIndex].wDeviceFlags1 |= CFG_FLAG1_SCRATCH_IS_INT_ID;
          wOEMjumpExit = 6;
          }
        break;
      case 'a':
        if (!FindToken('(',TO_EOL))
          break;
        if (!FindDigit())
          break;
        wTemp = (WORD)GetValue();
        for (iIndex = (iStartDevice - 1);iIndex < iEndDevice;iIndex++)
          {
          astComDCB[iIndex].wIObaseAddress = wTemp;
          wTemp += 8;
          }
        break;
      case 'b':
        if (abyFileBuffer[iDataIndex + 1] == 'u')
          {
          if (!FindToken('{',SKIP_EOL))
            break;
          ProcessBufferCommand();
          }
        break;
      case 'i':
        if (!FindToken('(',TO_EOL))
          break;
        if (!FindDigit())
          break;
        lTemp = GetValue();
        for (iIndex = (iStartDevice - 1);iIndex < iEndDevice;iIndex++)
          astComDCB[iIndex].byInterruptLevel = (BYTE)lTemp;
        break;
      }
    if (FindToken('}',TO_EOL))
      return;
    }
  iDataIndex++;
  }

LONG GetValue(void)
  {
  int iIndex = 0;
  int iRadix = 10;

  while (abyFileBuffer[iDataIndex] != 0)
    {
    if (IsXdigit(abyFileBuffer[iDataIndex]))
      {
      if (abyFileBuffer[iDataIndex + 1] == 'x')
        {
        iRadix = 16;
        iDataIndex += 2;
        }
      while (IsXdigit(abyFileBuffer[iDataIndex]))
        {
        abyNumber[iIndex++] = abyFileBuffer[iDataIndex++];
        if (iIndex >= 9)
          break;
        }
      if (iIndex > 0)
        {
        abyNumber[iIndex] = 0;
        if (abyFileBuffer[iDataIndex] == 'h')
          iRadix = 16;
        return(ASCIItoBin(iRadix));
        }
      }
    iDataIndex++;
    }
  ErrorExit();
  }

LONG ASCIItoBin(int iRadix)
  {
  int iIndex = 0;
  LONG lMulIndex;
  LONG lValue = 0;
  LONG lTemp;
  LONG lMultiplier = 1;

  while (abyNumber[iIndex++] != 0);
  for (iIndex -= 2;iIndex >= 0;iIndex--)
    {
    if (abyNumber[iIndex] >= 'a')
      {
      if (iRadix != 16)
        return(0);
      lTemp = (WORD)(abyNumber[iIndex] - 0x57);
      }
    else
      lTemp = (WORD)(abyNumber[iIndex] - 0x30);
    if (lTemp > 0)
      {
      for (lMulIndex = 0;lMulIndex < lMultiplier;lMulIndex++)
        lValue += lTemp;
      }
    if (iIndex == 0)
      return(lValue);
    lTemp = lMultiplier;
    for (lMulIndex = 1;lMulIndex < (LONG)iRadix;lMulIndex++)
      lMultiplier += lTemp;
    }
  }

void ProcessBufferCommand(void)
  {
  int iIndex;
  WORD wTemp;
  WORD *pWord;

  while (FindAnyToken() != '}')
    {
    switch (abyFileBuffer[iDataIndex])
      {
      case 'r':
        pWord = &astComDCB[iStartDevice - 1].wReadBufferLength;
        break;
      case 'w':
        pWord = &astComDCB[iStartDevice - 1].wWrtBufferLength;
        break;
      default:
        return;
      }
    if (FindToken('(',TO_EOL) && FindDigit())
      {
      wTemp = (WORD)GetValue();
      for (iIndex = (iStartDevice - 1);iIndex < iEndDevice;iIndex++)
        {
        *pWord = wTemp;
        pWord += (sizeof(COMDCB) / 2);
        }
      }
    }
  iDataIndex++;
  }
