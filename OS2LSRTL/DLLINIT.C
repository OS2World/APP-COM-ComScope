#include <os2bc.h>
#include <_startup.h>

/*
 *      C/C++ Run Time Library - Version 1.5
 *
 *      Copyright (c) 1991, 1994 by Borland International
 *      All Rights Reserved.
 *
 */

/*-----------------------------------------------------------------------*

Name            getpid - gets the process ID of a program

Usage           unsigned getpid(void);

Prototype in    process.h

Description     A process ID uniquely identifies a program. The concept
                is borrowed from multitasking operating systems like UNIX,
                where each process is associated with a unique process
                number.

                Note: this function is named _getpid for use within
                the library.  The user-visible entry point is getpid,
                and is found in getpid.asm.

Return value    if success it returns the value of process ID.
                Otherwise it returns -1.
*------------------------------------------------------------------------*/

static int _getpid(void)
{
    PTIB  ptib;
    PPIB  ppib;

    if (DosGetInfoBlocks(&ptib, &ppib) != 0)
        return(-1);
    else
        return (unsigned)(ppib->pib_ulpid);
}


/*---------------------------------------------------------------------*

Name            make_shname - construct name of shared memory region

Usage           chare *make_shname(void);

Description     This function modifies sharename[] so that it contains
                a unique name for a shared memory region.  This is
                done by overwriting the eight 'x' character with a
                mangled process ID.

Return value    The address of the name of the shared memory region.

*---------------------------------------------------------------------*/

static char *make_shname(void)
{
    static char sharename[] = "\\SHAREMEM\\xxxxxxxx.c2i";

#define x_offset 10     /* offset of the first 'x' in sharename[] */

    static int  modified = 0;
    int pid, i;

    if (!modified)
    {
        pid = _getpid();
        for (i = x_offset; i < x_offset + 8; i++)
        {
            sharename[i] = (pid & 0x0f) + 'A';
            pid >>= 4;
        }
        modified = 1;
    }
    return sharename;
}

/*---------------------------------------------------------------------*

Name            _create_shmem - create shared memory region

Usage           static MULTI_INIT *_create_shmem(void);

Description     This function creates or opens the shared memory region
                used to store the addresses of _INIT_ and
                _EXIT_ segments for each DLL.  If the region already
                exists, it is not created.

Return value    The address of the shared memory region, or NULL if
                it cannot be created.

*---------------------------------------------------------------------*/

static MULTI_INIT *_create_shmem(void)
{
    MULTI_INIT *base;
    PSZ sharename;
    int i;

    /* If the shared memory region already exists, return its address.
     */
    sharename = (PSZ)make_shname();
    if (DosGetNamedSharedMem((PPVOID)&base, sharename,
                             PAG_READ|PAG_WRITE) == 0)
        return base;

    /* Create the shared memory region, and zero it.  One page
     * should be plenty, since that can hold information for
     * hundreds of DLLs.
     */
    if (DosAllocSharedMem((PPVOID)&base, sharename, 4096,
                          PAG_READ|PAG_WRITE|PAG_COMMIT) != 0)
        return (NULL);
    for (i=0; i < 1024; i++)
        *((unsigned *)base+i) = 0;
    return base;
}

/*---------------------------------------------------------------------*

Name            open_shmem - return address of shared memory region

Usage           static MULTI_INIT *open_shmem(void);

Description     This function returns the address of the shared memory
                region used to store the addresses of _INIT_ and
                _EXIT_ segments for each DLL.

Return value    The address of the shared memory region, or NULL if
                it does not exist.

*---------------------------------------------------------------------*/

static MULTI_INIT *open_shmem(void)
{
    MULTI_INIT *base;

    if (DosGetNamedSharedMem((PPVOID)&base, (PSZ)make_shname(),
                             PAG_READ|PAG_WRITE) != 0)
        return NULL;
    else
        return base;
}

/*---------------------------------------------------------------------*

Name            _init_exit_proc - return address of next _INIT_ function

Usage           VOIDFUNC _init_exit_proc(MULTI_INIT *init_table, int is_exit);

Description     This function returns the address of the next function
                to call in the _INIT_ segments listed in the MULTI_INIT
                table pointed to by init_table.

                The is_exit flag is zero if this a startup table, and 1
                if this is an exit table. this affects whether the _INIT_
                functions are to be called in high-to-low or
                low-to-high priority order.

Return value    The address of the next function to call, or NULL if
                all INIT functions have been called.

*---------------------------------------------------------------------*/

static VOIDFUNC _init_exit_proc(MULTI_INIT *init_table, int is_exit)
{
    INIT *init_start, *init_end, *ip, *save;
    MODULE_DATA *modtable;
    unsigned short prior;
    int i;

    prior = is_exit ? 0 : 0xffff;
    save = NULL;
    for (i = 0; i < init_table->ntables; i++)       /* for each _INIT_ table */
    {
        modtable = init_table->table[i];
        init_start = is_exit ? modtable->exit_start : modtable->init_start;
        init_end   = is_exit ? modtable->exit_end   : modtable->init_end;

        /* Scan through one table, looking in priority order for the next
         * entry that hasn't been called yet.  Priority 0 is highest.
         * If this is an INIT table, start with highest priority entries.
         * If this is an EXIT table, start with lowest priority entries.
         * The reserved field in each init record is used as the 'called'
         * flag.
         */
        for (ip = init_start; ip < init_end && ip->func != NULLFUNC; ip++)
        {
            if (ip->reserved == 0 && is_exit == (ip->priority >= prior))
            {
                prior = ip->priority;
                save = ip;
            }
        }
    }

    /* If we scanned through all tables without finding an
     * un-called record, return NULL.
     */
    if (save == NULL)
        return (NULL);

    /* Mark the highest priority function as called and return
     * its address.  The caller should call this function immediately.
     */
    save->reserved = 1;
    return (save->func);
}


void _init_Borland_dlls(void)
{
    MULTI_INIT *share_dll_table;        /* module tables for DLLS */
    VOIDFUNC func;
    int i;

    /* Call initialization functions for any DLLs that might have
     * been loaded.  Then call each DLL's pseudo-entry point,
     * which simply calls that DLL's _dllmain().
     */
    if ((share_dll_table = _create_shmem()) != NULL)
    {
        /* Put a -1 marker at the end of the list of DLL module tables.
         * This forces any DLLs that are loaded dynamically later to
         * call their initialization functions themselves.
         */
        share_dll_table->table[share_dll_table->ntables] = (MODULE_DATA *)-1;

        /* Call _INIT_ functions
         */
        while ((func = _init_exit_proc(share_dll_table, 0)) != NULLFUNC)
            func();

        /* Call _dllmain.
         */
        for (i = 0; i < share_dll_table->ntables; i++)
#pragma warn -pro
            share_dll_table->table[i]->main(0, share_dll_table->table[i]->hmod);
#pragma warn .pro
    }
}

