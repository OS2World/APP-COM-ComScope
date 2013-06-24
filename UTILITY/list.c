#include "COMMON.H"
#include "linklist.h"

LINKLIST * EXPENTRY InitializeList(void)
  {
  LINKLIST *pList;

  if ((pList = malloc(sizeof(LINKLIST))) == NULL)
    return(NULL);
  pList->pHead = NULL;
  pList->pData = NULL;
  pList->pTail = NULL;
  return(pList);
  }

LINKLIST * EXPENTRY AddListItem(LINKLIST *pList,VOID *pData,int iSize)
  {
  LINKLIST *pNewElement = NULL;
  LINKLIST *pLastElement = NULL;

  if ((pLastElement = pList) == NULL)
    return(NULL);
  if (pLastElement->pData != NULL)
    {
    while (pLastElement->pTail != NULL)
      pLastElement = pLastElement->pTail;
    pNewElement = calloc(1,sizeof(LINKLIST));
    if (pNewElement == NULL)
      return(NULL);
    pNewElement->pHead = pLastElement;
    pNewElement->pTail = NULL;
    pLastElement->pTail = pNewElement;
    }
  else
    pNewElement = pList;
  pNewElement->pData = malloc(iSize);
  if (pNewElement->pData == NULL)
    {
    if (pLastElement != pList)
      free(pNewElement);
    pLastElement->pTail = NULL;
//    pList->pData = NULL;
//    pList->pHead = NULL;
    return(NULL);
    }
  else
    memcpy(pNewElement->pData,pData,iSize);
  return(pNewElement);
  }

LINKLIST * EXPENTRY GetNextListItem(LINKLIST *pList)
  {
  if (pList->pTail != NULL)
    return(pList->pTail);
  else
    return(NULL);
  }

void EXPENTRY DestroyList(LINKLIST **ppList)
  {
  LINKLIST *pFree = NULL;
  LINKLIST *pList;
  int iIndex;

  if (*ppList == NULL)
    return;
  pList = *ppList;
  for (iIndex = 0;iIndex < 400;iIndex++)
    {
    if (pList->pTail == NULL)
      break;
    pList = pList->pTail;
    }
  while (pList->pHead != NULL)
    {
    pFree = pList;
    pList = pList->pHead;
    if (pFree->pData != NULL)
      free(pFree->pData);
    free(pFree);
    }
  if (pList->pData != NULL)
    free(pList->pData);
  if (pList != NULL)
    free(pList);
  *ppList = NULL;
  }

BOOL EXPENTRY RemoveListItem(LINKLIST *pList)
  {
  LINKLIST *pElement = NULL;
  LINKLIST *pFree = NULL;

  if ((pElement = pList) == NULL)
    return(FALSE);
  if (pElement->pHead == NULL)
    {
    free(pElement->pData);
    pElement->pData = NULL;
    if (pElement->pTail != NULL)
      {
      pElement->pData = pElement->pTail->pData;
      pFree = pElement->pTail;
      if (pElement->pTail->pTail != NULL)
        {
        pElement->pTail->pTail->pHead = pElement;
        pElement->pTail = pElement->pTail->pTail;
        }
      else
        pElement->pTail = NULL;
      free(pFree);
      }
    }
  else
    {
    if (pElement->pTail == NULL)
      pElement->pHead->pTail = NULL;
    else
      {
      pElement->pHead->pTail = pElement->pTail;
      pElement->pTail->pHead = pElement->pHead;
      }
    free(pElement->pData);
    free(pElement);
    }
  return(TRUE);
  }

LINKLIST * EXPENTRY FindListByteItem(LINKLIST *pList,BYTE byByte)
  {
  LINKLIST *pElement = NULL;
  BYTE *pByte;

  if (pList == NULL)
    return(NULL);
  if (pList->pData == NULL)
    return(NULL);
  pElement = pList;
  do
    {
    pByte = (BYTE *)pElement->pData;
    if (*pByte == byByte)
      return(pElement);
    } while ((pElement = pElement->pTail) != NULL);
  return(NULL);
  }

LINKLIST * EXPENTRY FindListLongItem(LINKLIST *pList,ULONG ulData)
  {
  LINKLIST *pElement = NULL;
  ULONG *pulData;

  if (pList == NULL)
    return(NULL);
  if (pList->pData == NULL)
    return(NULL);
  pElement = pList;
  do
    {
    pulData = (ULONG *)pElement->pData;
    if (*pulData == ulData)
      return(pElement);
    } while ((pElement = pElement->pTail) != NULL);
  return(NULL);
  }

LINKLIST * EXPENTRY FindListWordItem(LINKLIST *pList,USHORT usData)
  {
  LINKLIST *pElement = NULL;
  USHORT *pusData;

  if (pList == NULL)
    return(NULL);
  if (pList->pData == NULL)
    return(NULL);
  pElement = pList;
  do
    {
    pusData = (USHORT *)pElement->pData;
    if (*pusData == usData)
      return(pElement);
    } while ((pElement = pElement->pTail) != NULL);
  return(NULL);
  }

LINKLIST * EXPENTRY FindListStringItem(LINKLIST *pList,char szString[],int iSearchLimit,BOOL bNoCase)
  {
  LINKLIST *pElement = NULL;
  char *pString;

  if (pList == NULL)
    return(NULL);
  if (pList->pData == NULL)
    return(NULL);
  pElement = pList;
  do
    {
    pString = (char *)pElement->pData;
    if (iSearchLimit == 0)
      {
      if (!bNoCase)
        {
        if ((strcmp(pString,szString)) == 0)
          return(pElement);
        }
      else
        if ((stricmp(pString,szString)) == 0)
          return(pElement);
      }
    else
      {
      if (!bNoCase)
        {
        if ((strncmp(pString,szString,iSearchLimit)) == 0)
          return(pElement);
        }
      else
        if ((strnicmp(pString,szString,iSearchLimit)) == 0)
          return(pElement);
      }
    } while ((pElement = pElement->pTail) != NULL);
  return(NULL);
  }


