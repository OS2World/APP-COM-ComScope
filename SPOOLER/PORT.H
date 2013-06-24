/**************************************************************************
 *
 * SOURCE FILE NAME = PORT.H
 *
 * DESCRIPTIVE NAME =
 *
 * 
 * 
 * COPYRIGHT    Copyright (C) 1992 IBM Corporation
 * 
 * The following IBM OS/2 2.1 source code is provided to you solely for
 * the purpose of assisting you in your development of OS/2 2.x device
 * drivers. You may use this code in accordance with the IBM License
 * Agreement provided in the IBM Device Driver Source Kit for OS/2. This
 * Copyright statement may not be removed.
 * 
 * 
 *
 * VERSION = V2.0
 *
 * DATE
 *
 * DESCRIPTION
 *
 *
 * FUNCTIONS
 *
 * ENTRY POINTS:
 *
 * DEPENDENCIES:
 *
 * NOTES
 *
 *
 * STRUCTURES
 *
 * EXTERNAL REFERENCES
 *
 * EXTERNAL FUNCTIONS
 *
 ***************************************************************************/



APIRET APIENTRY SplPdEnumPort (HAB, PVOID, ULONG, PULONG, PULONG, PULONG);
APIRET APIENTRY SplPdInitPort (HFILE, PSZ);
APIRET APIENTRY SplPdInstallPort (HAB, PSZ);
BOOL   APIENTRY SplPdGetPortIcon (HAB, PULONG);
APIRET APIENTRY SplPdQueryPort (HAB, PSZ, PVOID, ULONG, PULONG);
APIRET APIENTRY SplPdSetPort (HAB, PSZ, PULONG);
APIRET APIENTRY SplPdRemovePort (HAB, PSZ);
APIRET APIENTRY SplPdTermPort (HFILE, PSZ);
