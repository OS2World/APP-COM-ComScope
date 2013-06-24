/*-----------------------------------------------------------------------*
 * filename - dllmain.c
 *
 * function(s)
 *      _dllmain     - default DLL user initialization
 *-----------------------------------------------------------------------*/

/*
 *      C/C++ Run Time Library - Version 1.5
 *
 *      Copyright (c) 1991, 1994 by Borland International
 *      All Rights Reserved.
 *
 */

#include <os2bc.h>

/*---------------------------------------------------------------------*

Name            _dllmain - default DLL user initialization

Usage           ULONG _dllmain (ULONG termflag, HMODULE modhandle);

Prototype in    none

Description     _dllmain is called by the startup code when a DLL is
                is initialized, after all other RTL initialization
                is performed.  This is the default version, which
                is linked if the user does not provide one.

Return value    If it is successful, _dllmain returns 1; if an error occurs,
                it returns 0.

*---------------------------------------------------------------------*/

#pragma warn -par

ULONG _dllmain (ULONG termflag, HMODULE modhandle)
{
    return 1;
}

#pragma warn .par
