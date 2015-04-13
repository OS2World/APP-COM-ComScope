/* REXX */

Archive = "COMsuite"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "COMscope"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "COMi"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "COMspool"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "CSdemo"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "Globetek"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "ConnectTech"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "Moxa"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
Archive = "Sealevel"
call 'MakeArchive.cmd' Archive
IF RESULT <> "OK" THEN SIGNAL MakeError
SIGNAL exit

MakeError:

SAY ''
SAY "Make all failed, RESULT = "RESULT
SAY "Failed to make "Archive
SAY ''

exit:
