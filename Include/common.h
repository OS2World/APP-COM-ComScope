#ifndef _INCL_COMMON_H_

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


#ifndef DEBUG
#define DEBUG 0
#endif

#ifdef __BORLANDC__
#define _System EXPENTRY
#endif

#define SPECIAL_DEVICE "OS$tools"

#define DEMO_SIGNATURE 9793
#define GA_SIGNATURE   9794

#ifdef DEMO
#define SIGNATURE DEMO_SIGNATURE
#else
#define SIGNATURE GA_SIGNATURE
#endif

#define MAYBE 2
#define YES   1
#define NO    0

#define BITFIELD unsigned int

#define _INCL_COMMON_H_

#endif
