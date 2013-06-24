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
/*   SOURCE FILE NAME: COMPCI.H                                               */
/*                                                                            */
/*   DESCRIPTIVE NAME: asynchronous COMmunications device driver PCI support  */
/*                     Header file                                            */
/*                                                                            */
/*   FUNCTION: Header file to provide PCI support in the asynchronous         */
/*             COMmunications device driver.                                  */
/*                                                                            */
/*   NOTES:                                                                   */
/*                                                                            */
/*      DEPENDENCIES: None                                                    */
/*      RESTRICTIONS: None                                                    */
/*                                                                            */
/*   ENTRY POINTS: None                                                       */
/*                                                                            */
/*   EXTERNAL REFERENCES: None                                                */
/*                                                                            */
/* Change Log                                                                 */
/*                                                                            */
/*  Mark    yy/mm/dd  Programmer      Comment                                 */
/*  ----    --------  ----------      -------                                 */
/*          01/02/12  LR              PCI support                             */
/*                                                                            */
/**************************** END OF SPECIFICATIONS ***************************/

#define  INCL_NOPMAPI
#define  INCL_DOSDEVICES
#define  INCL_DOSDEVIOCTL
#define  INCL_NOXLATE_DOS16
#include <os2.h>

#include <rmbase.h>

#include "cominfo.h"

#define  AccessPCIBIOS()   DosDevIOCtl((&data),(&param),OEMHLP_PCI,IOCTL_OEMHLP,(handle))

#define  PCI_COM_MAX       4  // MAXimum number of PCI Parallel Ports supported
// = MAXCOMPORTS in ATCOM.INC 
#define  PCI_COM_LCREG     3  // PCI COM controller Line Control Register
#define  PCI_COM_DLAB   0x80  // Divisor Latch Address Bit

#define  IRQ15            15  // MAXimum IRQ number
/*
   OEMHLP PCI Interface Subfunctions
*/   
#define  OEMHLP_QUERY_PCI_BIOS      0x00
#define  OEMHLP_FIND_PCI_DEVICE     0x01
#define  OEMHLP_FIND_PCI_CLASS      0x02
#define  OEMHLP_READ_PCI_CONFIG     0x03
#define  OEMHLP_WRITE_PCI_CONFIG    0x04

#define  PCI_BIOS_VERSION     2
/*
         PCI Class Codes
*/
#define  PCI_CLASS_COM     0x07  // COMmunications controller
#define  PCI_SUBCL_SERIAL  0x00  // Serial communications controller
#define  PCI_SUBCL_MSERIAL 0x02  // Multiport Serial communications controller
#define  PCI_INTERF_GEN    0x00  // GENeric serial controller
#define  PCI_INTERF_16450  0x01  // 16450-compatible serial controller
#define  PCI_INTERF_16550  0x02
#define  PCI_INTERF_16650  0x03
#define  PCI_INTERF_16750  0x04
#define  PCI_INTERF_16850  0x05
#define  PCI_INTERF_16950  0x06
#define  PCI_INTERF_MAX    PCI_INTERF_16950
/*
         PCI Configuration Space Header registers
*/
#define  PCI_CONFIG_CMD    0x04  // Command
#define  PCI_CONFIG_BASE0  0x10  // Base address
#define  PCI_CONFIG_BASE5  0x24
#define  PCI_CONFIG_INTRPT 0x3C  // Interrupt

#define  PCI_CONFIG_BASE_IO   1UL // I/O Base address indicator

#define  PCI_MSERIAL_STEP     8  // Multiport Serial communications controller base Step

struct   PCICOM            // PCI serial COMmunications controller
  {                          // ====================================
  UCHAR    interface;
  UCHAR    bus;
  UCHAR    devfunc;       // device (upper 5 bits) and function (lower 3 bits)
  UCHAR    irq;           // interrupt line
  UCHAR    irqpin;        // interrupt pin
  USHORT   base;          // i/o base address
  };
struct   PCICOMs           // PCI COMmunications controllers
  {                          // ===============================
  UCHAR         number;   // of PCI communications controllers
  UCHAR         next;
  struct PCICOM com[PCI_COM_MAX];
  };
struct   OEMHLPCIParam     // OEMHLP PCI Parameter packet
  {                          // ===========================
  UCHAR subfunc;          // subfunction number
  union 
    {
    struct
      {
      USHORT device;
      USHORT vendor;
      // subfunction = OEMHLP_FIND_PCI_DEVICE 
      } id;                //  identification
    struct
      {
      UCHAR bus;        //    bus number
      UCHAR devfunc;    //    device (upper 5 bits) and function (lower 3 bits)
      UCHAR reg;        //    configuration register
      UCHAR size;       //    size in bytes (1, 2, 4)
                        // subfunction = OEMHLP_READ_PCI_CONFIG, OEMHLP_WRITE_PCI_CONFIG
      } conf;              //  configuration space
                           // subfunction = OEMHLP_FIND_PCI_CLASS
    ULONG class;         //  class code (base Class, Sub-class, Interface)
    };                      //  in lower 3 bytes (0x00CCSSII)
  union
    {
    UCHAR index;         // zero-based index to find identical devices
    ULONG data;          // data to be written to configuration register
    };
  };
struct   OEMHLPCIData   // OEMHLP PCI Data packet
  {                       // ======================
  UCHAR rc;            // return code
  union
    {
    struct
      {
      UCHAR mech;    //   hardware mechanism
      UCHAR majorV;
      UCHAR minorV;
      UCHAR bus;     //   number of last bus
                     // subfunction = OEMHLP_QUERY_PCI_BIOS
      } info;           //  information specific to the installed PCI BIOS
    struct
      {
      UCHAR bus;     //   bus number
      UCHAR devfunc; //   device (upper 5 bits) and function (lower 3 bits)
                     // subfunction = OEMHLP_FIND_PCI_DEVICE, OEMHLP_FIND_PCI_CLASS
      } loc;            //  location of device
                        // subfunction = OEMHLP_READ_PCI_CONFIG
    ULONG data;       //  data read from configuration space
    };
  };
/*
   External data declarations
*/
extern   COMINFO NEAR *gpComInfo;   // pointer to next ComInfo structure (NextCom in ATINIT.ASM)

