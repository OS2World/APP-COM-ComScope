/************************************************************************
**
**   MESSAGE.C
**
**   This file contains initialization messages
**
** $Revision:   1.0  $
**
** $Log:   P:/ARCHIVE/COMI/MESSAGE.c_v  $
 *
 *    Rev 1.0   01 Nov 1996 05:20:46   unknown
 * Initial Check-in
**
*************************************************************************/
char szLogoMessage_s[] = "[36mInstalling OS/tools' COMi Asynchronous Communications device driver[0m\r\n%s\r\n";

#ifdef OEM
 #ifdef Sealevel
char szVerMod[] = "SS";
char szSubLogo[] = "For Sealevel Systems Incorporated serial adapters";
 #else
  #ifdef Comtrol
char szVerMod[] = "CH";
char szSubLogo[] = "For Comtrol Hostess serial adapters";
  #else
   #ifdef Quatech
char szVerMod[] = "QT";
char szSubLogo[] = "For Quatech Incorporated serial adapters";
   #else
    #ifdef Neotech
char szVerMod[] = "NM";
char szSubLogo[] = "For Neotech Incorporated MCA serial adapters";
    #else
     #ifdef DigiBoard
char szVerMod[] = "DB";
char szSubLogo[] = "For DigiBoard PC/4, PC/8, and PC/16 serial adapters";
     #else
      #ifdef ConnecTech
char szVerMod[] = "CT";
char szSubLogo[] = "For Connect Tech DFLEX serial adapters";
      #else
       #ifdef Globetek
char szVerMod[] = "GT";
char szSubLogo[] = "For Globetek serial adapters";
       #else
         #ifdef Moxa
char szVerMod[] = "MX";
char szSubLogo[] = "For Moxa serial adapters";
         #else
          #ifdef Boca
char szVerMod[] = "BR";
char szSubLogo[] = "For Boca Research IOAT66 adapters";
         #endif // Moxa
        #endif  // Boca
       #endif   // Globetek
      #endif    // ConnecTech
     #endif     // DigiBoard
    #endif      // Neotech
   #endif       // Quatech
  #endif        // Comtrol
 #endif         // Sealevel
#else
 #ifdef Sealevel_Retail
char szVerMod[] = "SR";
char szSubLogo[] = "For all Sealevel Systems Incorporated serial adapters";
 #else
  #ifdef x16_BIT
char szVerMod[] = "1.x";
char szSubLogo[] = "[1mThis is COM/8 for OS/2 1.x, a subset of COMi, for OS/2 2.x and Warp 3.x[0m";
  #else
   #ifdef SHARE
    #ifndef SHARE_COMscope
char szVerMod[] = "P";
char szSubLogo[] = "[1mPersonal COMi is for personal use only, and is not for sale or resale.[0m";
    #else
char szVerMod[] = "P";
char szSubLogo[] = "[1mPersonal COMi is for personal use only, and is not for sale or resale.\r\n"
                   "COMscope support included[0m";
    #endif    // SHARE_COMscope
   #else
    #ifdef DEMO
char szSubLogo[] = "[31;1mUsage of his version of COMi is restricted and is for evaluation only.[0m";
char szVerMod[] = "E";
    #else
char szSubLogo[] = "";
char szVerMod[] = "";
    #endif    // DEMO
   #endif     // SHARE
  #endif      // x16_BIT
 #endif       //Sealevel_Retail
#endif       // OEM

char szCopyright[] = "\r\nOS/tools' COMi Asynchronous Communications device driver installed\r\n"
                     "Copyright (c) [36mOS/tools Incorporated[0m 1989-2002 -- All rights reserved\r\n"
                     "e-mail: support@os-tools.com, URL: http://www.os-tools.com\r\n";


char szCreditHeader[] = "Copyright (c) 1989-2002\r\n"
                        "OS/tools Incorporated\r\n"
                        "Gilroy, California\r\n"
                        "(408)847-7487\r\n"
                        "Written By Emmett S. Culley Jr.\r\n";

char szVersion[] =

 #ifndef OEM
 #ifndef OEM_GA
  #ifdef SHARE
   #ifndef x16_BIT
 "Personal "
   #endif
  #endif
 #endif
#endif


 "Version 4.00e";        //  8/24/02

char szVersionString_ss[] = "[1m%s %s[0m\r\n";

char szPath_sss[] = "%s %s %s ";

char szHighlightOn[] = "[1m";
char szHighlightOff[] = "[0m";
char szBeepChar[] = "\x07";
char szNoise[] = "\x07h.";
char szCR_2x[] = "\r\n\r\n";

char szCR[] = "\r\n";
char szCRonly[] = "\r";

char szWaitKeyMessage[] = "\r\nPress Enter to continue.\r\n";

char szDebugMessage[] = "\r\n\x07[1mHit CTRL+C to cause debug trap.[0m";

char szCodeLocation_xxxxxxx[] = "C@ %04X:%04X I-%04X\r\nD@ %04X:%04X I-%04X B-%04X\r\n";

char szClockRate_u[] = "[1mSystem clock rate expected to be %u milliseconds for this OS/2 session[0m\r\n";

#ifdef DEMO
char szEvaluationMsg[] = "[1mThis version is for [5mEVALUATION ONLY[0m[1m and has had some features disabled.\r\n"
                          "See documentation for a description of the limitations of this version.  You\r\n"
                          "may copy and distribute this version freely.  You may not modify this device\r\n"
                          "driver in any way.\r\n\r\n"
                          "For an undiminished version of this device driver contact:\r\n\r\n"
                          "OS/tools Incorporated\r\n"
                          "San Jose, California\r\n"
                          "(500)446-7257  FAX (408)847-7480[0m\r\n";
#endif
char szCOMmessage_u[] = "COM%u installed";

char szVerboseMessage_uxu[] = "COM%u installed at address 0x%X, hardware interrupt level = %u\r\n";

char szInputBuff_lu[] = "      input buffer length = %lu";

char szOutputBuff_lu[] = "      output buffer length = %lu";

char szInputQueue_u[] = "      input packet queue = %u";

char szOutputQueue_u[] = "      output packet queue = %u";

char szUART_s[] = "UART is %s";
char szUART_is[] = "UART is ";

char szAnd[] = " - ";
char szAnd4x[] = "[37;1m and 4x baud rate clock.[0m"; // bright white
char szAnd8x[] = "[37;1m and 8x baud rate clock.[0m"; // bright white
char szAnd12x[] = "[37;1m and 12x baud rate clock.[0m"; // bright white
char szAnd16x[] = "[37;1m and 16x baud rate clock.[0m"; // bright white

char szBlankPad[] = "      ";
char szPeriod[] = ".[0m";

char szExtended16550[] = "16550 with 16 byte FIFOs";   // white (normal)
char szExtended16650[] = "[33;1m16650 with 32 byte FIFOs";   // yellow
char szExtended16654[] = "[35;1m16654 with 64 byte FIFOs";   // magenta
char szExtended16750[] = "[31;1m16750 with 64 byte FIFOs";   // red
char szExtended16950[] = "[32;1m16950 with 128 byte FIFOs";   // green
char szExtendedTI16550C[] = "[34;1mTI16550C with 16 byte FIFOs";   // blue
/*
** error messages
*/
char szABIOSaddrInvalid_u[] = "[1mCOM%u not installed because a valid device was not detected at the specified base I/O address[0m\r\n";

char szABIOSaddrTaken_u[] = "[1mCOM%u not installed because a previously loaded device driver owns the device\r\nunder a different device name[0m\r\n";

char szABIOSname_u[] = "[1mCOM%u not installed because name is taken by a previously loaded device driver[0m\r\n";

char szABIOSowned_u[] = "[1mCOM%u not installed because device is owned by a previously loaded process[0m\r\n";

char szRMowned_u[] = "[1mCOM%u not installed because IRQ or I/O address resource is not available.[0m\r\n";

char szSkippedPort_u[] = "COM%u not installed at users request[0m\r\n";

char szBadInstall[] = "[1mYou must use either COMscope or Install to install the COMi device drvier.\r\nSee documentation for instructions on installation and configuration of COMi.[0m\r\n\r\n";

char szHDWinterruptError_uu[] = "[1mCOM%u device is not connected to interrupt %u as expected and was not installed[0m\r\n";

char szPCIerror_u[] = "[1mNo supported PCI device found, COM%u was not installed.[0m\r\n";

char szHDWerror_xu[] = "[1mNo supported device was found at base address 0x%X - COM%u was not installed.[0m\r\n";

char szInterruptError_uu[] = "[1mInterrupt %u is unavailable - COM%u was not intalled.[0m\r\n";

char szBaseAddrError_u[] = "[1mInvalid base I/O address was specified - COM%u was not installed.[0m\r\n";

char szInterruptLevelError_u[] = "[1mInvalid or no interrupt level was specified - COM%u was not installed.[0m\r\n";

char szInterruptIDerror_u[] = "[1mCOM%u device does not support an Interrupt Status register as configured.[0m\r\n";

char szFinalError[] = "[1mAt least one installed device was not configured correctly.  See adapter\r\nand/or COMi documentation for explanation.[0m\r\n";

char szAllocBuffers_ululu[] = "[1mAllocating %u selectors and %lu bytes RAM for device driver buffers.\r\n%lu bytes were available in device driver data segment.[0m\r\n";

char szAllocError[] = "[1mUnable to allocate memory or selectors for device driver buffers.  Your\r\nsystem is unable to support the memory requested[0m\r\n";

char szMemoryError_u[] = "[1mSegment Overflow, decrease transmit buffer sizes  - COM%u was not installed[0m\r\n";

char szNoPortAvailable[] = "[1mThere are no serial devices available for COMi access.  Either there are no\r\n"
                           "standard serial devices installed, or all standard devices are already owned\r\n"
                           "by one, or more, previously loaded device drivers (i.e., COM.SYS).[0m\r\n";

char szNoStackAvailable_uu[] = "[1mNo stack available for interrupt level %u - COM%u was not installed[0m\r\n";
