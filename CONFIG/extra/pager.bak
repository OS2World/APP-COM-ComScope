/*
**  What has changed:
**
**  The prime open function now returns the maximum number of pager opens allowed.
**  If an EXT_ERROR_BAD_TARGET error is returned, this value should be tested to see
**  if is zero.  If it is zero then the COMi device driver that is loaded cannot be used
**  by any of our paging software and the user should be notified accordingly.
**
**  Search for !@# to see required code changes.
*/

/*
**  Francisco,
**
**  Use the following algorithm to process DEMO page requests.  This process limits
**  both the number of concurrent pager processes to a number that is in the device
**  driver, and limits the total number of successful pages to a number that is
**  hard coded into the DEMO version of the DEMO pager DLL.
**
**  In order to open the special device, the pager DLL must have the DEMO
**  signature hard coded into it.  This will prevent all DEMO versions from using
**  any GA versions of the device driver, and vice-versa.
**
**  Initialization:
**
**  #define MAX_PAGE_COUNT 10
**  ULONG ulCount = 0;
**
**  Process:
**
**  if page count less than maximum page count
**    {
**    if able to open special device (DosOpen(SPECIAL_DEVICE...))
**      {
**      if able to prime open (PrimeOpen(SPECIAL_DEVICE handle...))
**        {
**        if succssful port open (DosOpen(szPortName...))
**          {
**          process page request(s)
**
**          if page successful
**
**            page count = trigger count (ulCount = TriggerCount(SPECIAL_DEVICE handle...))
**
**          close port (DosClose(szPortName handle...))
**          {
**        {
**      close port (DosClose(SPECIAL_DEVICE handle...))
**      {
**    {
**
**  Use the following algorithm to process GA page requests.  This process limits
**  only the number of concurrent pager processes to a number that is in the device
**  driver.
**
**  In order to open the special device, the pager DLL must have the GA
**  signature hard coded into it.  This will prevent all DEMO versions from using
**  any GA versions of the device driver, and vice-versa.
**
**  Process:
**
**  if able to open special device (DosOpen(SPECIAL_DEVICE...))
**    {
**    if able to prime open trigger (PrimeOpen(SPECIAL_DEVICE handle...))
**      {
**      if succssful port open (DosOpen(szPortName...))
**        {
**        process page request (including all retries)
**
**        if page successful
**
**          successful page count = trigger count (ulCount = TriggerCount(SPECIAL_DEVICE handle...))
**
**        close port (DosClose(szPortName handle...)}
**        {
**      {
**    close port (DosClose(SPECIAL_DEVICE handle...))
**    {
**
**   You may want to count each pager ID (PIN) that is successful in a multiple page
**   request.  It is up to you.
**
**   The DEMO version of COMi will allow up to four COM ports to be defined and only
**   one PAGER port at a time to be opened.  The DEMO version will also limit the
**   total number of write requests for all COM ports, but not for PAGER ports.
**
**   GA versions of the device driver can be supplied with any combination of COM
**   port to PAGER ratios.
**
**   I am considering making a four port version of COMi as share ware.  I think I
**   need to get people to try it to believe it.  This will be a special version
**   with a special signature that will not allow it to work with either the PAGER
**   DLL, COMscope, or COMspool, but will be full featured.
**
**   Any questions?  You know where to find me.  I'll talk to you soon.
**
**   Emmett
*/

#define INCL_DOSERRORS
#define INCL_DOS

#include <OS2.H>
#include <stdio.h>
#include <stdlib.h>

#define SPECIAL_DEVICE "OS$tools"

#define DEMO_SIGNATURE 9793
#define GA_SIGNATURE   9794

#ifdef DEMO
#define SIGNATURE 9793
#else
#define SIGNATURE 9794
#endif

#define EXT_RSP_SUCCESS        0x0f00 // any other value is a negative response

#define EXT_BAD_SIGNATURE      0xf000 // a bad signature error is ORed with other errors

#define EXT_ERROR_BAD_COMMAND  0x0ffd // unknown value in wCommand field

#define EXT_ERROR_BAD_TARGET   0x0ffa // this means that the request for access was denied
                                      // either because there are no pager ports defined
                                      // or because there are no pager ports available

#define EXT_CMD_OPEN_PAGER     9   // command to make next open to any port a pager open

#define EXT_CMD_ROLL_COUNT    13   // command to increment counter and return new count
                                   // This counts pager opens globally.  It will not matter
                                   // which port is opened, counts one pager open for any
                                   // COMi port open request.  This allows you to count only the
                                   // events you want to (i.e., successful pages).
                                   // The counter is reset to zero only when the system is
                                   // rebooted


BOOL bOpenComm = TRUE;
BOOL bWaitForBreak = FALSE;
USHORT usIncrement = 1;

typedef unsigned short WORD;

/*
** When the device driver finds a signature miss match it ORs the BAD_SIGNATURE
** error code with any other error code, if any.
**
** If return code is NOT equal to RSP_SUCCESS then you must mask the return code
** to determine if both the BAD_SIGNATURE and some other error has occurred.
*/

WORD wSignature = DEMO_SIGNATURE;  // varaible used for testing purposes only
                                   // default set to DEMO

char szPort[20] = "COM3";

// pragma (PACK structures)  using byte alignment
typedef struct _stExtentionData
  {
  WORD wReturnCode;
  WORD wByteCount;
  ULONG ulData; // this structure would normally be dynamically allocated to be
                // the size of the data to be returned plus the header size
                // (two USORTS) in this case.
  }EXTDATA;

typedef struct _stExtentionParams
  {
  WORD wSignature;
  WORD wCommand;
  WORD wModifier;
  WORD wDataCount;
  }EXTPARM;

/*
**  Use this function to prime COM port for pager access
**
**  If EXT_RSP_SUCCESS is returned then it is OK to open COM port
**  to send a page.
**
**  Otherwise use the return code to explain problem to user.
**
**  Message strings here are only for debugging this program.
*/
ULONG PrimeOpen(HFILE hCom)
  {
  ULONG ulDataLen = sizeof(EXTDATA);
  ULONG ulParmLen = sizeof(EXTPARM);
  EXTPARM stParams;
  EXTDATA stData;
  APIRET rc;

  stParams.wSignature = wSignature;  // varaible used for testing purposes only
//  stParams.wSignature = SIGNATURE;
  stParams.wCommand = EXT_CMD_OPEN_PAGER;
  stParams.wModifier = 0;
  stParams.wDataCount = sizeof(USHORT);
  if ((rc = DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,&stData,sizeof(EXTDATA),&ulDataLen)) == NO_ERROR)
    {
    if (stData.wReturnCode == EXT_RSP_SUCCESS)
      {
      // Ok to issue page
      printf("\nPager Open Primed\n");
      return(stData.ulData);
      }
    else
      {
      // NOT Ok to issue page, string notes cause of error
      if ((stData.wReturnCode & 0xf000) == EXT_BAD_SIGNATURE)
        {
        // received only if app's signature does not match device driver's
        printf("\nWrong Pager Device Driver Version Loaded\n");
        }
      else
        {
        if ((stData.wReturnCode & 0x0fff)== EXT_ERROR_BAD_COMMAND)
          {
          // final version should not make this error
          printf("\nPager Device Driver Not Loaded\n");
          }
        else
          {
          if ((stData.wReturnCode & 0x0fff)== EXT_ERROR_BAD_TARGET)
            {
            if ((USHORT)stData.ulData != 0) // this new !@#
              {
              // Indicates that no pager devices are available, try later
              printf("\nAll available pager ports are in use.\n");
              }
            else
              {
              // Indicates that no pager devices are ALLOWED, get correct COMi !@#
              printf("\nThe version of COMi that is loaded does not support paging.\n");
              }
            }
          else
            // highly unlikely,unless an ealier version of COMi is being used
            printf("\nUknown error - rc = %04X\n",stData.wReturnCode);
          }
        }
      }
    }
  else
    printf("Prime DosDevIOCtl Failed - rc = %u",rc);
  return(FALSE);
  }

/*
**  Use this function to count successful pages
*/
ULONG TriggerCount(HFILE hCom,USHORT usIncrement)
  {
  ULONG ulDataLen = sizeof(EXTDATA);
  ULONG ulParmLen = sizeof(EXTPARM);
  EXTPARM stParams;
  EXTDATA stData;
  ULONG ulCount;
  APIRET rc;

  stParams.wSignature = wSignature;  // varaible used for testing purposes only
//  stParams.wSignature = SIGNATURE;
  stParams.wCommand = EXT_CMD_ROLL_COUNT;
  stParams.wModifier = usIncrement;
  stParams.wDataCount = sizeof(ULONG);
  if ((rc = DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,&stData,sizeof(EXTDATA),&ulDataLen)) == NO_ERROR)
    {
    if (stData.wReturnCode == EXT_RSP_SUCCESS)
      {
      if (stData.wByteCount != 4)
        // Unlikely error in practice, no need to process.
        // This is only here for debugging COMi.
        printf("\nBad buffer size returned\n");

      else
        {
        // This is the expected response, Ok to issue page.
        printf("\nTrigger Count Since boot = %u\n",stData.ulData);
        // return new count value
        return(stData.ulData);
        }
      }
    else
      // all of these are negative, no page should be issued if RSP_SUCCESS is not returned
      if ((stData.wReturnCode & 0xf000) == EXT_BAD_SIGNATURE)
        // received only if app's signature does not match device driver's
        printf("\nWrong Pager Device Driver Version Loaded\n");
      else
        if ((stData.wReturnCode & 0x0fff)== EXT_ERROR_BAD_COMMAND)
          // final version should not make this error
          printf("\nPager Device Driver Not Loaded\n");
        else
          // highly unlikely,unless an ealier version of COMi is being used
          printf("\nUknown error - rc = %04X\n",stData.wReturnCode);
    }
  else
    printf("Trigger DosDevIOCtl Failed - rc = %u",rc);
  // return very larger value to indicate error received and prevent any other
  // access tries.  At least for this pager session.
  return(0xffffffff);
  }

void main(int argc,char *argv[])
  {
  LONG lIndex;
  APIRET rc;
  HFILE hCom;
  HFILE hSpecial;
  ULONG ulAction;
  ULONG ulTrigCount;


  if (argc >= 2)
    {
    for (lIndex = 1;lIndex < argc;lIndex++)
      {
      if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
        {
        switch (argv[lIndex][1] & 0xdf)
          {
          case 'B':
            bWaitForBreak = TRUE;
            break;
          case 'P':
            sprintf(&szPort[3],"%s",&argv[lIndex][2]);
            break;
          case 'O':
            bOpenComm = FALSE;
            break;
          case 'I':
            usIncrement = (SHORT)atoi(&argv[lIndex][2]);
            break;
          case 'G':
            wSignature = GA_SIGNATURE;
            break;
          default:
            break;
          }
        }
      }
    }

  if (DosOpen(SPECIAL_DEVICE,&hSpecial,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
    {
    printf("\nSpecial Device open - One\n");
    /*
    ** Set Pager Open Trigger
    */
    if (PrimeOpen(hSpecial))
      {
      if (bOpenComm)
        {
        if (DosOpen(szPort,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
          {
          printf("\n%s open - One\n",szPort);
          /*
          ** Increment and test Trigger Counts since boot
          */
          ulTrigCount = TriggerCount(hSpecial,usIncrement);
          DosClose(hCom);
          printf("\n%s Closed - One\n",szPort);
          }
        else
          printf("\n%s Failed to open - One\n",szPort);
        }
      }
    else
      printf("\nPrime Failed - One\n");
    }
  else
    printf("Pager Device Driver Not Loaded - One");
  DosClose(hSpecial);
  printf("\nSpecial Device Closed - One\n");
  if (DosOpen(SPECIAL_DEVICE,&hSpecial,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
    {
    printf("\nSpecial Device open - Two\n");
    /*
    ** Set Pager Open Trigger
    */
    if (PrimeOpen(hSpecial))
      {
      if (bOpenComm)
        {
        if (DosOpen(szPort,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
          {
          printf("\n%s open - Two\n",szPort);
          if (bWaitForBreak)
            {
            printf("\nWaiting for break - Two\n");
            DosSleep(30000);
            }
          /*
          ** Increment and test Trigger Counts since boot
          */
          ulTrigCount = TriggerCount(hSpecial,usIncrement);
          DosClose(hCom);
          printf("\n%s Closed - Two\n",szPort);
          }
        else
          printf("\n%s Failed to open - Two\n",szPort);
        }
      }
    else
      printf("\nPrime Failed - Two\n");
    }
  else
    printf("Pager Device Driver Not Loaded - Two");
  DosClose(hSpecial);
  printf("\nSpecial Device Closed - Two\n");
  DosExit(ulTrigCount,0);
  }
