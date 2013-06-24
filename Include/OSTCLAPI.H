/*--------------------------------------------------------------------------*/
/*    Module Name: OSTCLAPI.C                                               */
/*                                                                          */
/*    Description: Compress/Uncompress library API interface header file.   */
/*                                                                          */
/*         Author: Francisco J. O'Meany                                     */
/*                                                                          */
/*           Date: Feb 24, 1999                                             */
/*                                                                          */
/*      Copyright: OS/tools Incorporated 1999                               */
/*                                                                          */
/*       Comments:                                                          */
/*                                                                          */
/*--------------------------------------------------------------------------*/

#define OST_COMPRESS_SOURCE_FILE_MISSING           7000
#define OST_COMPRESS_LIBRARY_FILE_MISSING          7001
#define OST_COMPRESS_CREATE_DIR_ERROR              7100


int OSTMakeDirectoryPath(char * szDirName);
int OSTAddFileToLibrary(char * szFileName, char * szLibrary);
int OSTRemoveFileFromLibrary(char * szFileName, char * szLibrary);
int OSTExtractFileFromLibrary(char * szFileName,
                              char * szTargetLocation,
                              char * szLibrary,
                              int    fCreateDirs);
int OSTListLibraryFiles(char * szLibrary);



