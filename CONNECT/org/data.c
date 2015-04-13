#include <COMMON.H>
#include <UTILITY.H>
#include "conn_dlg.h"
#include "menu.h"
#include "comm.h"
#include "connect.h"

LOGON stLogon = {{"USERID"},{"PASSWORD"}};
COMADDR stAddr = {{"10.0.2.4"},{BY_ADDR}};

SUBSCRIBER astSubList[MAX_SUBSCRIBERS] = {
                                          {"Emmett","Culley",255,0,     (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE)},
                                          {"Rita","Culley",80,1,        (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE)},
                                          {"Greg","Culley",100,2,       (SUB_FLG_ACTIVATED | SUB_FLG_NUMERICPAGE)},
                                          {"Fransisco","O'Meany",200,3, (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE)},
                                          {"Roger","Pena",80,4,         (SUB_FLG_ACTIVATED | SUB_FLG_RDU)},
                                          {"Mary","Culley",80,5,        (SUB_FLG_ACTIVATED | SUB_FLG_VOICE)},
                                          {"Joy","Culley",80,6,         (SUB_FLG_ALPHAPAGE)},
                                          {"Lara","Culley",80,7,        (SUB_FLG_ALPHAPAGE)},
                                          {"Ruth","Archer",100,8,       (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE)},
                                          {"Roy","Archer",80,9,         (SUB_FLG_ACTIVATED | SUB_FLG_NUMERICPAGE)},
                                          {"Pearl","Archer",100,10,     (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE)},
                                          {"Roy","Rogers",80,11,        (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE)}
                                         };

USHORT usSubscriberListCount = 12;

GROUP astGroupList[MAX_GROUPS] = {
                                  {"Managers",0,255,255, (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE| SUB_FLG_GROUP)},
                                  {"Technicians",1,0,0,(SUB_FLG_ACTIVATED | SUB_FLG_NUMERICPAGE| SUB_FLG_GROUP)},
                                  {"Engineers",2,80,255, (SUB_FLG_ACTIVATED | SUB_FLG_ALPHAPAGE| SUB_FLG_GROUP)}
                                 };
USHORT usGroupListCount = 3;

