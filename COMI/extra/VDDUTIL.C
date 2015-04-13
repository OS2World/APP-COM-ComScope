/************************************************************************
**
** $Revision$
**
** $Log$
** 
************************************************************************/

#define INCL_DOSDEVICES
#define INCL_VIO
#define INCL_DOS
#define INCL_DOSERRORS
#define building_DD

#include <os2.h>
//#include <memory.h>
//#include <stdlib.h>
//#include <string.h>
#include "COMDD.H"
#include "COMDCB.H"
#include "CUTIL.H"

char szComMapFormat[] = "VDM 0x%04X to COMi's %s";
char aszComMapList[16][41];
char szPropComMap[] = "COM_VDM_TO_LOGICAL_MAPING"
