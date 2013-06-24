#ifndef _INCL_LINKLIST_H_

typedef struct _LinkedList
  {
  struct _LinkedList *pHead;
  struct _LinkedList *pTail;
  void *pData;
  }LINKLIST;

/*
**  LIST.C function  prototypes
BOOL EXPENTRY RemoveListItemNumber(LINKLIST *pList,int iElement);
*/
BOOL EXPENTRY RemoveListItem(LINKLIST *pList);
void EXPENTRY DestroyList(LINKLIST **pList);
LINKLIST * EXPENTRY GetNextListItem(LINKLIST *pList);
LINKLIST * EXPENTRY AddListItem(LINKLIST *pList,VOID *pData,int iSize);
LINKLIST * EXPENTRY InitializeList(void);
LINKLIST * EXPENTRY FindListByteItem(LINKLIST *pList,BYTE byData);
LINKLIST * EXPENTRY FindListWordItem(LINKLIST *pList,USHORT usData);
LINKLIST * EXPENTRY FindListLongItem(LINKLIST *pList,ULONG ulData);
LINKLIST * EXPENTRY FindListStringItem(LINKLIST *pList,char szString[],int iSearchLimit,BOOL bNoCase);

#define _INCL_LINKLIST_H_
#endif
