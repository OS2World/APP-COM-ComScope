#define COL_READ_WIN 6000
#define COL_WRITE_WIN 6001

typedef struct
  {
  USHORT cbSize;
  fBOOL bActive         :1;
  fBOOL bTestNewLine    :1;
  fBOOL bSkipBlankLines :1;
  fBOOL bWrap           :1;
  fBOOL bSync           :1;
  fBOOL bFilter         :1;
  BYTE byNewLineChar;
  BYTE byDisplayMask;
  WORD wDirection;
  LONG fFilterMask;
  HWND hwnd;
  HWND hwndClient;
  RECTL rcl;
  LONG lCharSize;
  LONG lCharWidth;
  LONG lCharHeight;
  LONG lHeight;
  LONG lWidth;
  LONG lBackgrndColor;
  LONG lForegrndColor;
  RECTL rclDisp;
  POINTL Pos;
  LONG lCursorReadRow;
  LONG lCursorWriteRow;
  HWND hwndScroll;
  LONG lScrollEndIndex;
  LONG lScrollRowCount;
  LONG lScrollRow;
  LONG lScrollIndex;
//  LONG lStartIndex;
  LONG lLeadIndex;
  LONG lLeadWriteRow;
  LONG lLeadReadRow;
  }SCREEN;

#define RETAIN_INDEX TRUE
#define RESET_INDEX FALSE
#define FROM_START FALSE
#define FROM_LAST TRUE

extern BOOL CharPrintable(BYTE *pbyChar,SCREEN *pstScreen);
extern void CreateColumnWindows(void);

extern TRACKINFO stColTrack;
extern SCREEN stRead;
extern SCREEN stWrite;
//extern LONG lColumnOffset;


