  PUBLIC _pDeviceStrategy
  PUBLIC _pCOMscopeStrategy

RES_CODE SEGMENT
    ASSUME CS:CGROUP, ES:nothing, SS:nothing

_pDeviceStrategy LABEL WORD
Strategy1:
  MOV   ax,1
  JMP   Strategy

Strategy2:
  MOV   ax,2
  JMP   Strategy

Strategy3:
  MOV   ax,3
  JMP   Strategy

Strategy4:
  MOV   ax,4
  JMP   Strategy

Strategy5:
  MOV   ax,5
  JMP   Strategy

_pCOMscopeStrategy LABEL WORD
Strategy1m:
  MOV   ax,8001
  JMP   Strategy

Strategy2m:
  MOV   ax,8002
  JMP   Strategy

Strategy3m:
  MOV   ax,8003
  JMP   Strategy

Strategy4m:
  MOV   ax,8004
  JMP   Strategy

Strategy5m:
  MOV   ax,8005

Strategy:
  INT   3

_TEXT ENDS

  END
