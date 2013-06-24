;************************************************************************
;
; message.inc
;
;   This file contains initialization message extern statements
;
; $Revision$
;
; $Log$
;
;*************************************************************************

    EXTRN _szLogoMessage_s    :BYTE
    EXTRN _szSubLogo          :BYTE

  IFDEF DEMO
    EXTRN _szEvaluationMsg    :BYTE
  ENDIF
    EXTRN _szCreditHeader     :BYTE

    EXTRN _szVersion          :BYTE
    EXTRN _szVersionString_ss :BYTE
    EXTRN _szPath_sss         :BYTE
    EXTRN _szVerMod           :BYTE
    EXTRN _szHighlightOn      :BYTE
    EXTRN _szHighlightOff     :BYTE
    EXTRN _szBeepChar         :BYTE
    EXTRN _szWaitKeyMessage   :BYTE

    EXTRN _szCodeLocation_xxxxxxx:BYTE

    EXTRN _szClockRate_u      :BYTE

    EXTRN _szNoise            :BYTE

    EXTRN _szCR_2x            :BYTE
    EXTRN _szCR               :BYTE

    EXTRN _szCopyright        :BYTE
    EXTRN _szDebugMessage     :BYTE
    EXTRN _szCRonly           :BYTE

    EXTRN _szCOMmessage_u     :BYTE
    EXTRN _szVerboseMessage_uxu:BYTE

    EXTRN _szInputBuff_lu     :BYTE

    EXTRN _szOutputBuff_lu    :BYTE

    EXTRN _szInputQueue_u     :BYTE

    EXTRN _szOutputQueue_u    :BYTE

    EXTRN _szPeriod           :BYTE
    EXTRN _szUART_s           :BYTE
    EXTRN _szUART_is          :BYTE
    EXTRN _szAnd              :BYTE
    EXTRN _szAnd4x            :BYTE
    EXTRN _szAnd8x            :BYTE
    EXTRN _szAnd12x           :BYTE
    EXTRN _szAnd16x           :BYTE

    EXTRN _szBlankPad         :BYTE

    EXTRN _szExtended16550    :BYTE
    EXTRN _szExtended16650    :BYTE
    EXTRN _szExtended16654    :BYTE
    EXTRN _szExtended16750    :BYTE
    EXTRN _szExtendedTI16550C :BYTE

    EXTRN _szABIOSname_u      :BYTE

    EXTRN _szABIOSaddrInvalid_u:BYTE

    EXTRN _szABIOSaddrTaken_u :BYTE

    EXTRN _szABIOSowned_u     :BYTE

    EXTRN _szRMowned_u        :BYTE

    EXTRN _szSkippedPort_u    :BYTE

    EXTRN _szBadInstall       :BYTE
    EXTRN _szNoPortAvailable  :BYTE

    EXTRN _szHDWinterruptError_uu:BYTE

    EXTRN _szPCIerror_u      :BYTE
    EXTRN _szHDWerror_xu      :BYTE

    EXTRN _szInterruptError_uu:BYTE

    EXTRN _szBaseAddrError_u :BYTE

    EXTRN _szInterruptLevelError_u:BYTE

    EXTRN _szFinalError       :BYTE
    EXTRN _szInterruptIDerror_u :BYTE

    EXTRN _szAllocBuffers_ululu :BYTE
    EXTRN _szAllocError       :BYTE
    EXTRN _szMemoryError_u    :BYTE

    EXTRN _szNoStackAvailable_uu:BYTE


sprintf PROTO far C, szMsg:FAR PTR BYTE, iStart:WORD, szFormat:FAR PTR BYTE, :VARARG
PrintMessage PROTO far C,szMessage:FAR PTR BYTE,iLen:WORD
