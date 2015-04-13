#include <COMMON.H>

char szModuleName[CCHMAXPATH] = "C:\\OS2\\DLL\\COMi_SPL.PDR";
HMODULE hMod;
HMODULE hModRTL;

void cdecl main(int argc,char *argv[])
  {
  LONG lIndex;

  if (argc >= 2)
    {
    for (lIndex = 1;lIndex < argc;lIndex++)
      {
      if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
        {
        switch (argv[lIndex][1] & 0xdf)
          {
          case 'L':
            strcpy(szModuleName,&argv[lIndex][2]);
            break;
          }
        }
      }
    }

  if (DosLoadModule(0,0,"C215MT",&hModRTL) != NO_ERROR)
    {
    hModRTL = 0;
    printf("\x07\nC215MT.DLL is not accessable\n");
    }
  if (DosLoadModule(0,0,szModuleName,&hMod) != NO_ERROR)
    {
    hMod = 0;
    printf("\x07\nCOMi_SPL.PDR is not accessable\n");
    }

  if ((hModRTL == 0) && (hMod == 0))
    return;

  while(1)
    DosSleep(10000);

  if (hMod != 0)
    DosFreeModule(hMod);
  if (hModRTL != 0)
    DosFreeModule(hModRTL);
  }


