/*DDK*************************************************************************/
/*                                                                           */
/* COPYRIGHT    Copyright (C) 1992 IBM Corporation                           */
/*                                                                           */
/*    The following IBM OS/2 source code is provided to you solely for       */
/*    the purpose of assisting you in your development of OS/2 device        */
/*    drivers. You may use this code in accordance with the IBM License      */
/*    Agreement provided in the IBM Developer Connection Device Driver       */
/*    Source Kit for OS/2. This Copyright statement may not be removed.      */
/*                                                                           */
/*****************************************************************************/
/*
*
*/
/************************** START OF SPECIFICATIONS ***************************/
/*                                                                            */
/*   SOURCE FILE NAME: COMPCI.C                                               */
/*                                                                            */
/*   DESCRIPTIVE NAME: asynchronous COMmunications device driver PCI support  */
/*                     C funtions                                             */
/*                                                                            */
/*   FUNCTION: Routines to provide PCI support in the asynchronous            */
/*             communications device driver.                                  */
/*                                                                            */
/*   NOTES:                                                                   */
/*                                                                            */
/*      DEPENDENCIES: None                                                    */
/*      RESTRICTIONS: None                                                    */
/*                                                                            */
/*   ENTRY POINTS: AddPCICOM                                                  */
/*                 FindPCInfo                                                 */
/*                                                                            */
/*   EXTERNAL REFERENCES: AccessPCIBIOS (DosDevIOCtl)                         */
/*                                                                            */
/* Change Log                                                                 */
/*                                                                            */
/*  Mark    yy/mm/dd  Programmer      Comment                                 */
/*  ----    --------  ----------      -------                                 */
/*          01/02/12  LR              PCI support                             */
/*                                                                            */
/**************************** END OF SPECIFICATIONS ***************************/

#include "compci.h"

struct   PCICOMs gPCI = {0,0};   // PCI serial communications controller info

/********************** START OF SPECIFICATIONS ***********************/
/*                                                                    */
/* SUBROUTINE NAME: AddPCICOM                                         */
/*                                                                    */
/* DESCRIPTIVE NAME: Add PCI serial COMmunications controller         */
/*                                                                    */
/* FUNCTION: This function fills in the device driver's next ComInfo  */
/*           structure with any information that was found on PCI     */
/*           serial communications controller.                        */
/*                                                                    */
/* NOTES: The OEMHLP interface (device driver) is used to access PCI  */
/*        BIOS information and functions.                             */
/*                                                                    */
/* CONTEXT: Initialization time                                       */
/*                                                                    */
/* ENTRY POINT: AddPCIPP                                              */
/*     LINKAGE: CALL FAR                                              */
/*                                                                    */
/* INPUT: none                                                        */
/*                                                                    */
/* EXIT-NORMAL: return value = next PCI COM controller i/o base       */
/*                              address                               */
/* EXIT-ERROR: return value = 0 - no more PCI COM controllers         */
/*                                                                    */
/* EFFECTS: next ComInfo structure (NextCom in ATINIT.ASM)            */
/*                                                                    */
/* INTERNAL REFERENCES: none                                          */
/*    ROUTINES:                                                       */
/*                                                                    */
/* EXTERNAL REFERENCES: none                                          */
/*    ROUTINES:                                                       */
/*                                                                    */
/************************ END OF SPECIFICATIONS ***********************/

USHORT FAR AddPCICOM (void)
  {
  if (gPCI.number - gPCI.next == 0)
    {  // no more PCI COM controllers
    return(0);
    }
  gpComInfo->ci_irqpin = gPCI.com[gPCI.next].irqpin;
  gpComInfo->ci_irq = gPCI.com[gPCI.next].irq;
  gpComInfo->ci_int_sharing = TRUE;
  gpComInfo->ci_flagx1 |= FX1_PCI_COM;   // to show this is a PCI COM controller

  return(gPCI.com[gPCI.next++].base);
  }

/********************** START OF SPECIFICATIONS ***********************/
/*                                                                    */
/* SUBROUTINE NAME: CheckCOM                                          */
/*                                                                    */
/* DESCRIPTIVE NAME: Check serial COMmunications controller           */
/*                                                                    */
/* FUNCTION: This function determines whether a serial communications */
/*           controller is present at given input/output base address.*/
/*                                                                    */
/* NOTES: Multiport PCI COM controller support.                       */
/*                                                                    */
/* CONTEXT: Initialization time                                       */
/*                                                                    */
/* ENTRY POINT: CheckCOM                                              */
/*     LINKAGE: CALL NEAR                                             */
/*                                                                    */
/* INPUT: address = PCI COM controller input/output base Address      */
/*                                                                    */
/* EXIT-NORMAL: return value = TRUE                                   */
/*                                                                    */
/* EXIT-ERROR: return value = FALSE = address is not COM controller   */
/*                                    i/o base address                */
/* EFFECTS: n/a                                                       */
/*                                                                    */
/* INTERNAL REFERENCES: none                                          */
/*    ROUTINES:                                                       */
/*                                                                    */
/* EXTERNAL REFERENCES: none                                          */
/*    ROUTINES:                                                       */
/*                                                                    */
/************************ END OF SPECIFICATIONS ***********************/

#pragma optimize("eglt", off)

static USHORT CheckCOM (USHORT address)
  {
  _asm
  {
    push  dx
      mov   dx, address
      add   dx, PCI_COM_LCREG
      in    al, dx
      or    al, PCI_COM_DLAB
      out   dx, al            // DLAB = 1
      jmp   d1                // i/o delay
      d1:   in    al, dx
      pop   dx
      test  al, PCI_COM_DLAB  // DLAB == 1 ?
      jz    nCOM              // no

      push  dx
      mov   dx, address
      add   dx, PCI_COM_LCREG
      in    al, dx
      and   al, NOT PCI_COM_DLAB
      out   dx, al               // DLAB = 0
      jmp   d0                   // i/o delay
      d0:   in    al, dx
      pop   dx
      test  al, PCI_COM_DLAB     // DLAB == 0 ?
      jnz   nCOM                 // no
  }
  return(TRUE);
  nCOM:             // address is not COM controller i/o base address
  return(FALSE);
  }
#pragma optimize("", on)

/******************* START OF SPECIFICATIONS **************************/
/*                                                                    */
/* SUBROUTINE NAME: FindPCInfo                                        */
/*                                                                    */
/* DESCRIPTIVE NAME: Find PCI serial communications controller Info   */
/*                                                                    */
/* FUNCTION: This function finds the location of PCI serial           */
/*           communications controllers and obtains information that  */
/*           is essential to the asynchronous communications DD.      */
/*                                                                    */
/* NOTES: The OEMHLP interface (device driver) is used to access PCI  */
/*        BIOS information and functions.                             */
/*        Serial communications controller class encodings are        */
/*        provided in PCI Local Bus Specification.                    */
/*                                                                    */
/* CONTEXT: Initialization Time                                       */
/*                                                                    */
/* ENTRY POINT: FindPCInfo                                            */
/*     LINKAGE: CALL FAR                                              */
/*                                                                    */
/* INPUT: handle = OEMHLP handle                                      */
/*                                                                    */
/* EXIT-NORMAL: n/a                                                   */
/*                                                                    */
/* EXIT-ERROR: n/a                                                    */
/*                                                                    */
/* EFFECTS: gPCI = PCI serial communications controller info          */
/*                                                                    */
/* INTERNAL REFERENCES:                                               */
/*    ROUTINES:         CheckCOM                                      */
/*                                                                    */
/* EXTERNAL REFERENCES:                                               */
/*    ROUTINES:         AccessPCIBIOS (DosDevIOCtl)                   */
/*                                                                    */
/******************* END  OF  SPECIFICATIONS **************************/

void FAR FindPCInfo (HFILE handle)
  {
  struct OEMHLPCIParam param;
  struct OEMHLPCIData  data;
  USHORT               baseAddr, base;
  UCHAR                confreg, subclass, interface;

  param.subfunc = OEMHLP_QUERY_PCI_BIOS;
  if (AccessPCIBIOS() || data.rc)
    {  // cannot access PCI BIOS
    return;
    }
  if (data.info.majorV < PCI_BIOS_VERSION)
    {
    return;
    }
  for (subclass  = PCI_SUBCL_SERIAL;
      subclass <= PCI_SUBCL_SERIAL + PCI_SUBCL_MSERIAL &&
      gPCI.number < PCI_COM_MAX;
      subclass += PCI_SUBCL_MSERIAL)
    {
    for (interface = PCI_INTERF_GEN;
        interface <= ((subclass == PCI_SUBCL_SERIAL)? PCI_INTERF_MAX : PCI_INTERF_GEN) &&
        gPCI.number < PCI_COM_MAX;
        interface++)
      {
      for (param.index = 0;
          param.index < PCI_COM_MAX && gPCI.number < PCI_COM_MAX;
          param.index++)
        {  // find PCI COM controller location
        param.class = MAKEULONG(MAKEUSHORT(interface,subclass),MAKEUSHORT(PCI_CLASS_COM,0));
        param.subfunc = OEMHLP_FIND_PCI_CLASS;
        if (AccessPCIBIOS() || data.rc)
          {  // not found
          break;
          }
        gPCI.com[gPCI.number].bus = data.loc.bus;
        gPCI.com[gPCI.number].devfunc = data.loc.devfunc;
        gPCI.com[gPCI.number].interface = interface;

        // read PCI Command register
        param.conf.bus = gPCI.com[gPCI.next].bus;
        param.conf.devfunc = gPCI.com[gPCI.next].devfunc;

        param.conf.reg = PCI_CONFIG_CMD;
        param.conf.size = sizeof(USHORT);
        param.subfunc = OEMHLP_READ_PCI_CONFIG;
        if (AccessPCIBIOS() || data.rc)
          {  // cannot read PCI Command register
          return;
          }
        else
          if (!(data.data & PCI_CONFIG_BASE_IO))
          {  // PCI COM controller is disabled - enable it
          param.data = PCI_CONFIG_BASE_IO;
          param.subfunc = OEMHLP_WRITE_PCI_CONFIG;
          if (AccessPCIBIOS() || data.rc)
            {  // cannot enable PCI COM controller
            return;
            }
          }
        // get PCI COM controller i/o base address
        param.subfunc = OEMHLP_READ_PCI_CONFIG;
        for (param.conf.reg  = PCI_CONFIG_BASE0;
            param.conf.reg <= PCI_CONFIG_BASE5 && gPCI.number < PCI_COM_MAX;
            param.conf.reg += sizeof(ULONG))
          {
          param.conf.size = sizeof(ULONG);
          if (AccessPCIBIOS() || data.rc)
            {  // bad PCI config register
            return;
            }
          if (data.data & PCI_CONFIG_BASE_IO &&
              (baseAddr = LOUSHORT(data.data) & (USHORT)~PCI_CONFIG_BASE_IO))
            {
            for (base  = baseAddr;
                base <= ((subclass == PCI_SUBCL_MSERIAL) ? 
                           baseAddr + PCI_MSERIAL_STEP * (PCI_COM_MAX-1) : baseAddr) &&
                gPCI.number < PCI_COM_MAX;
                base += PCI_MSERIAL_STEP)
              {
              if (CheckCOM (base) == TRUE)
                {
                gPCI.com[gPCI.number].base = base;
                }
              else
                {  // base is not COM controller i/o base address
                break;
                }
              // get information about PCI COM controller interrupts
              confreg = param.conf.reg;
              param.conf.reg = PCI_CONFIG_INTRPT;
              param.conf.size = sizeof(USHORT);
              if (AccessPCIBIOS() || data.rc)
                {  // cannot get info (bad PCI config register)
                return;
                }
              param.conf.reg = confreg;
              if ((gPCI.com[gPCI.number].irqpin = HIUCHAR(data.data)) == 0 ||
                  (gPCI.com[gPCI.number].irq = LOUCHAR(data.data)) > IRQ15)
                {  // PCI COM controller doesn't use interrupts or
                   // unknown or no connection to the interrupt controller - next index
                break;   
                }
              gPCI.number++;
              }  // for (base...
            }  // if (data.data & PCI_CONFIG_BASE_IO...
          }  // for (param.conf.reg  = PCI_CONFIG_BASE0...
        }  // for (param.index...
      }  //for (interface...
    }  // for (subclass...
  }

