#ifndef _INCL_WCOMMON_H_

#define INCL_NLS
#define INCL_PM
#define INCL_DEV
#define INCL_SUB
#define INCL_GPI
#define INCL_BASE
#define INCL_WIN

#include <os2.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
#include <malloc.h>
#include <time.h>

#include "COMDD.H"

#ifndef DEBUG
#define DEBUG 0
#endif

#define EATM_DOSOPEN     5033
#define EATM_ERRORCD     5032
#define EATM_FUNCTION    5031
#define EATM_IOCTL       5030

#include "Utility.h"
#include "IOCtl.h"
#include "Profile.h"
#include "COMcontrol.h"
#include "Config.h"

#include "WinCOM.h"

#define _INCL_WCOMMON_H_

#endif
