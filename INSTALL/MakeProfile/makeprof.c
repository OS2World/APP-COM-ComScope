//#define INCL_NLS

//#define INCL_SUB

#define INCL_WIN
#define INCL_DOS
#define INCL_DOSERRORS
#ifdef INCL_ALL_EXP
#define INCL_DOSFILEMGR
#define INCL_DOSPROCESS
#define INCL_DOSMEMMGR
#define INCL_DOSSESMGR
#define INCL_DOSMISC
#define INCL_DOSDEVICES
#endif

#include <os2.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
//#include <malloc.h>

char szString[1024];
BYTE *pbyFileData = NULL;
ULONG cbFileSize;
char szProfilePath[CCHMAXPATH + 1];
char szMakeFilePath[CCHMAXPATH + 1];
char szSourcePath[CCHMAXPATH + 1];
char szDefaultMakeFile[] = "MAKE.PRF";
char szDefaultProfile[] = "OS_tools.ini";
char szPath[CCHMAXPATH + 1];

void SetEndOfPath(char szPath[]);

BOOL ReadFile(char szFileSpec[],BYTE **ppbyFileData,ULONG *pcbFileSize);
BOOL ParseMakeFile(BYTE *pbyFileData,char szPrifile[],LONG cbFileSize);

void main(int argc,char *argv[])
  {
  LONG lIndex;
  BOOL bDebug = FALSE;

  if (argc >= 2)
    {
    for (lIndex = 1;lIndex < argc;lIndex++)
      {
      if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
        {
        if (argv[lIndex][1] == '?')
          {
          printf("\nUsage:\nMAKEPROF /Pprofile.ini /Mmakefile.prf /Ad:\\path\n\n");
          printf("The \"A\" switch is only valid when no other parameters are given\nand refers to a path to the default input and output files\n\n");
          printf("Default make file is \"MAKE.PRF\", default profile is \"OS_tools.ini\"\n\n");
          return;
          }
        switch (argv[lIndex][1] & 0xdf)
          {
          case 'P':
            strcpy(szProfilePath,&argv[lIndex][2]);
            break;
          case 'M':
            strcpy(szMakeFilePath,&argv[lIndex][2]);
            break;
          case 'A':
            strcpy(szSourcePath,&argv[lIndex][2]);
            break;
          case 'D':
            bDebug = TRUE;
            break;
          }
        }
      }
    }
  if (szSourcePath[strlen(szSourcePath) - 1] == '\\')
    szSourcePath[strlen(szSourcePath) - 1] = 0;
  if (strlen(szMakeFilePath) == 0)
    {
    if (strlen(szProfilePath) == 0)
      {
      if (szSourcePath[0] == 0)
        strcpy(szProfilePath,szDefaultProfile);
      else
        sprintf(szProfilePath,"%s\\%s",szSourcePath,szDefaultProfile);
      printf("\nCreating default profile:\n%s\n",szProfilePath);
      }

    if (szSourcePath[0] == 0)
      strcpy(szMakeFilePath,szDefaultMakeFile);
    else
      sprintf(szMakeFilePath,"%s\\%s",szSourcePath,szDefaultMakeFile);
    printf("\nUsing default make file:\n%s\n",szMakeFilePath);
    }
  else
    if (strlen(szProfilePath) == 0)
      {
      strcpy(szPath,szMakeFilePath);
      SetEndOfPath(szPath);
      sprintf(szProfilePath,"%s\\%s",szPath,szDefaultProfile);
      printf("\nCreating default profile:\n%s\n",szProfilePath);
      }

  printf("Creating Profile %s\nfrom %s\n",szProfilePath,szMakeFilePath);
  if (bDebug)
    DosSleep(5000);
  if (!ReadFile(szMakeFilePath,&pbyFileData,&cbFileSize))
    return;
  ParseMakeFile(pbyFileData,szProfilePath,cbFileSize);
  DosFreeMem(pbyFileData);
  }

void SetEndOfPath(char szPath[])
  {
  int iIndex;

  for (iIndex = strlen(szPath);iIndex >= 0;iIndex--)
    {
    if (szPath[iIndex] == '\\')
      {
      szPath[iIndex] = 0;
      break;
      }
    if (szPath[iIndex] == ':')
      {
      szPath[iIndex + 1] = 0;
      break;
      }
    }
  }

BOOL ReadFile(char szFileSpec[],BYTE **ppbyFileData,ULONG *pcbFileSize)
  {
  HFILE hFile;
  ULONG ulAction;
  FILESTATUS3 stFileInfo;
  APIRET rc;
  ULONG ulOpenMode;
  ULONG ulOpenFlag;
  ULONG ulByteCount;

  ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_FAIL_IF_NEW);
  ulOpenMode = (OPEN_FLAGS_SEQUENTIAL | OPEN_SHARE_DENYWRITE | OPEN_ACCESS_READONLY);
  while ((rc = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
    {
    switch (rc)
      {
      case ERROR_FILE_NOT_FOUND:
        printf("Cannot find file %s.\n",szFileSpec);
        break;
      case ERROR_PATH_NOT_FOUND:
        printf("Cannot find path %s.\n",szFileSpec);
        break;
      case ERROR_ACCESS_DENIED:
        printf("Access denied for reading %s.\n",szFileSpec);
        break;
      default:
        printf("Failed to open %s. ec = %u\n",szFileSpec,rc);
        break;
      }
    return(FALSE);
    }
  DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
  if ((rc = DosAllocMem((PPVOID)ppbyFileData,stFileInfo.cbFile,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
    {
    if (rc == ERROR_NOT_ENOUGH_MEMORY)
      {
      printf("Out of Memory\n");
      printf("Unable to allocate enough memory to read file.\n");
      }
    else
      {
      printf("Memory allocation error. ec = %u\n",rc);
      printf("Unable to allocate memory to read file\n");
      }
    return(FALSE);
    }
  ulByteCount = stFileInfo.cbFile;
  if ((rc = DosRead(hFile,(PVOID)*ppbyFileData,ulByteCount,&ulByteCount)) != 0)
    printf("Read from %s failed. ec = %u\n",szFileSpec,rc);
  *pcbFileSize = ulByteCount;
  DosClose(hFile);
  return(TRUE);
  }

BOOL ParseMakeFile(BYTE *pbyFileData,char szProfile[],LONG cbFileSize)
  {
  LONG lIndex;
  HINI hProfile;
  char szApp[80];
  char szKey[80];
  ULONG ulData;
  BYTE byChar;
  BOOL bSameApp;
  LONG lFileIndex = 0;
  BYTE *pbyTestDigit;
  BOOL bLineDone;
  int iLineIndex;
  int iTemp;

  if ((hProfile = PrfOpenProfile((HAB)0,szProfile)) == 0)
    {
    printf("Unable to open Profile.\n");
    return(FALSE);
    }
  lIndex = 0;
  while (pbyFileData[lFileIndex++] != '[');
  while (lFileIndex < cbFileSize)
    {
    lIndex = 0;
    while (pbyFileData[lFileIndex] != ']')
      szApp[lIndex++] = pbyFileData[lFileIndex++];
    szApp[lIndex] = 0;
    while (!isalpha(pbyFileData[++lFileIndex]));
    bSameApp = TRUE;
    while (bSameApp)
      {
      lIndex = 0;
      while (pbyFileData[lFileIndex] != '=')
        szKey[lIndex++] = pbyFileData[lFileIndex++];
      szKey[lIndex] = 0;
      lFileIndex++;
      pbyTestDigit = &pbyFileData[lFileIndex];
      iLineIndex = 0;
      bLineDone = FALSE;
      while (!bLineDone)
        {
        while ((*pbyTestDigit != '\\') && (*pbyTestDigit != ';') && (*pbyTestDigit != '\x0a') && (*pbyTestDigit != 0))
          pbyTestDigit++;
        switch (*pbyTestDigit)
          {
          case 0:
            PrfCloseProfile(hProfile);
            return(TRUE);
          case ';':
            while (pbyFileData[lFileIndex] != ';')
              szString[iLineIndex++] = pbyFileData[lFileIndex++];
            szString[iLineIndex] = 0;
            pbyTestDigit++;
            if (*pbyTestDigit == '\x0d')
              {
              PrfWriteProfileString(hProfile,szApp,szKey,szString);
              printf("sz - %s, %s, %s\n",szApp,szKey,szString);
//              pbyTestDigit++;
              bLineDone = TRUE;
              }
            break;
          case '\\':
            while (pbyFileData[lFileIndex] != '\\')
              szString[iLineIndex++] = pbyFileData[lFileIndex++];
            lFileIndex++;
            pbyTestDigit++;
            switch (pbyFileData[lFileIndex])
              {
              case 'x':
              case 'X':
                lFileIndex++;
                pbyTestDigit++;
                if ((*pbyTestDigit >= 'a') && (*pbyTestDigit <= 'f'))
                  iTemp = (*pbyTestDigit - 'a' + 10);
                else
                  if ((*pbyTestDigit >= '0') && (*pbyTestDigit <= '9'))
                    iTemp = (*pbyTestDigit - '0');
                  else
                    if ((*pbyTestDigit >= 'A') && (*pbyTestDigit <= 'F'))
                      iTemp = (*pbyTestDigit - 'A' + 10);
                    else
                      {
                      pbyTestDigit++;
                      szString[iLineIndex++] = pbyFileData[lFileIndex++];
                      break;
                      }
                lFileIndex++;
                pbyTestDigit++;
                iTemp <<= 4;
                if ((*pbyTestDigit >= 'a') && (*pbyTestDigit <= 'f'))
                  iTemp += (*pbyTestDigit - 'a' + 10);
                else
                  if ((*pbyTestDigit >= '0') && (*pbyTestDigit <= '9'))
                    iTemp += (*pbyTestDigit - '0');
                  else
                    if ((*pbyTestDigit >= 'A') && (*pbyTestDigit <= 'F'))
                      iTemp += (*pbyTestDigit - 'A' + 10);
                    else
                      {
                      iTemp >>= 4;
                      szString[iLineIndex++] = (BYTE)iTemp;
//                      pbyTestDigit++;
                      szString[iLineIndex++] = pbyFileData[lFileIndex++];
                      break;
                      }
                szString[iLineIndex++] = (BYTE)iTemp;
                lFileIndex++;
                break;
              case 'n':
                szString[iLineIndex++] = '\x0a';
                lFileIndex++;
                break;
              case 'r':
                szString[iLineIndex++] = '\x0d';
                lFileIndex++;
                break;
              default:
                szString[iLineIndex++] = pbyFileData[lFileIndex++];
              }
            pbyTestDigit++;
            szString[iLineIndex] = 0;
            break;
          default:
            ulData = atoi(&pbyFileData[lFileIndex]);
            PrfWriteProfileData(hProfile,szApp,szKey,&ulData,4);
            printf(" # - %s, %s, %u\n",szApp,szKey,ulData);
            bLineDone = TRUE;
            break;
          }
        }
      byChar = pbyFileData[lFileIndex];
      while (!isalpha(byChar) && (byChar != '['))
        {
        if (++lFileIndex >= cbFileSize)
          {
          PrfCloseProfile(hProfile);
//          printf("Profile Complete\n");
          return(TRUE);
          }
        byChar = pbyFileData[lFileIndex];
        }
      if (byChar == '[')
        {
        bSameApp = FALSE;
        lFileIndex++;
        }
      }
    }
  PrfCloseProfile(hProfile);
//  printf("Profile Complete\n");
  return(TRUE);
  }

