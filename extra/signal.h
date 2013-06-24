typedef struct
  {
  USHORT cbSize;
  HDC hdsPS;
  USHORT usMenuStyle;
  CLRDLG stColor;
  USHORT usLastPopupItem;
  fBOOL bActive         :1;
  fBOOL fLevel          :1;
  ULONG *pulSyncIndex;
  HWND hwnd;
  HWND hwndClient;
  RECTL rcl;
  LONG lSize;
  LONG lWidth;
  LONG lHeight;
  LONG lBackgrndColor;
  LONG lForegrndColor;
  RECTL rclDisp;
  POINTL HiStartPos;
  POINTL HiEndPos;
  POINTL LoStartPos;
  POINTL LoEndPos;
  }SIGNAL;

//extern TRACKINFO stColTrack;


