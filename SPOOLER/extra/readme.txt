Pete and John,

There are two executables: OPEN_SPL.EXE and SERIAL_T.EXE.

OPEN_SPL.EXE is the fix.  It does a DosLoadModule on the COMi_SPL.PDR
DLL and never unloads it unless you ^C it.  COMi_SPL.PDR should be in
the C:\OS2\DLL directory.  If it is not, you will have to give its
absolute path, including the file name, on the OPEN_SPL.EXE command line.

 Example:
    [C:\]OPEN_SPL D:\OS2\DLL\COMi_SPL.PDR

SERIAL_T.EXE is the program OPEN_SPL.EXE was derived from.  You can use
it to install, setup, initialize, etc., any port controlled by COMi.

Beware of the two "Recover INI" menu items in SERIAL_T.EXE.  If you select
either of these items DO NOTHING until all disk activity has stopped.  These
function copy the user and/or system INIs and write them back with our
certian errors. If you disturb the process you will probably destroy
whichever INI you are trying to "recover".  There will be NO warning,
or second chances given :-).

You should be able to cause OPEN_SPL.EXE run early in the system
initialization process and leave it running throughout the session.
The process sleep for 10 seconds at a time, so it might take a few seconds
to unload after you hit ^C.

I hope this will prevent the crashes.  I will be investigating other
"more elegant" solutions.  I will probably just drop Borland's complier
and use Visual Age C++.

The COMi_SPL.PDR that is in this zip file is a new version.  The only
thing that has changed is the error message processing and strings.

I included the SYM file for it in case you are going to use it.  I will
probably release it after the first of the year when I have a major release
planned for all of our other stuff. AN yes I will be checking it all back
into PVCS.

BTW, you can set breakpoints in COMi_SPL right after you load OPEN_PDR.

Have fun

Emmett
