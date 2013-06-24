#ifndef _INCL_COMCONTROL_H_

#include <ioctl.h>

typedef struct
  {
  USHORT cbSize;
  char *pszPortName;
  HFILE hCom;
  HWND hwndHelpInstance;
  USHORT usHelpId;
  IOCTLINST *pstIOctl;
  PVOID pVoidPtrOne;
  PVOID pVoidPtrTwo;
  ULONG ulSpare[10];
  }COMCTL;

typedef APIRET (* EXPENTRY CTL_DIALOG)(HWND,PVOID);

#if DEBUG > 0
#define COMCTL_LIBRARY "CTL_DEB"
#else
#define COMCTL_LIBRARY "COMi_CTL"
#endif

#define _INCL_COMCONTROL_H_
#endif
