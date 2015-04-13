/* make profile */
'@echo off'
SubDir = 'Beta'
ToolsPath = 'w:\dist\'SubDir'\targets'
'SET BEGINLIBPATH=;w:\dist\'SubDir'\targets'
PARSE UPPER ARG DroppedFile
Drive=FILESPEC('drive',DroppedFile)
Path = FILESPEC('path',DroppedFile)
path = STRIP(path,'l','\')
DestPath = Drive'\'Path'OS_TOOLS.INI'
CommandLine = '/M'DroppedFile' /P'DestPath
mode 'co80,80'
ToolsPath'\makeprof' CommandLine

