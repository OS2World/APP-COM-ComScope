.*
.***************************************************
.*  Footnote links
.***************************************************
:fn id=address.
 Each device to be controlled by the COMi device driver owns a set of eight contiguous I/O space
addresses.  The I/O base address is the first address in that device's address space.
See your adapter board documentation to determine what I/O base address to use.
:efn.
:fn id=int_level.
 Each device to be controlled by the COMi device driver must be connected to one, and only one,
hardware interrupt level.  See your adapter board documentation to determine what interrupt level
to select.
:p.
:nt.An exception to this rule is when you use a serial adapter that supports shared interrupts
in an :link refid=ISA reftype=fn.ISA:elink. machine.  If you are using such an adapter you must
take care not to use more than one interrupt level for each COMi :link refid=load reftype=fn.load:elink..
:p.
You may use any combination of interrupt levels :link refid=MCA reftype=fn.MCA:elink. machines.
:ent.
:efn.
:fn id=OPEN_1.
 A first level DosOpen is the first time a device is opened by any application.  Any
other DosOpen calls, without first calling DosClose, are considered second level
opens.  When all applications have closed a device then the next DosOpen for that device will,
again, be considered a first level DosOpen.  The device driver returns some device
operating parameters back to device driver defaults whenever a first level DosOpen occurs.
:p.
Device driver operating parameters that are set back to device driver defaults are&colon.
:ul compact.
:li.Handshaking Parameters
:li.Time-out Values
:li.Time-out Processing
:li.Stream Filters
:eul.
:nt.COMi start-up defaults are configurable by the user.  The parameters in the above list are
returned to defaults defined explicitly by the user or implicitly by OS/tools.  If the user has not defined
a given parameter default during configuration that parameter will be returned to the default defined by OS/tools.
:efn.
:fn id=ISA.
:hp2.I:ehp2.ndustry :hp2.S:ehp2.tandard :hp2.A:ehp2.rchitecture
:p.
Machines that are compatible with the IBM AT personal computer are of this type.
:p.
IBM and AT are registerd trademarks of International Business Machines.
:efn.
:fn id=MCA.
:hp2.M:ehp2.icro :hp2.C:ehp2.hannel :hp2.A:ehp2.rchitecture.
:p.
Machines that are compatible with the IBM PS/2 are of this type.
:p.
IBM, Micro Channel, and PS/2 are registerd tradmarks of International Business Machines.
:efn.
:fn id=active_dev.
 The active device is the device selected from the "Device | Select Device..."
menu dialog box.  The name of the currently active device is displayed in the title bar
of the COMscope main window, in the title bar of all COMscope monitor and control dialog boxes, and
is shown as the title of any visible icon when a COMscope instance has been minimized.
:efn.
:fn id=dat_stream.
 A COM device's main purpose in life is to send/receive data to/from some external
device.  All data written to a device, and/or read from a device, is considered
to be that device's I/O Data Stream.  Once a valid device has been selected COMscope can
be made to capture, and save, any data that is part of that I/O Data Stream.  The bytes of an
:hp2.I/O Data Stream:ehp2. are stored in the order in which they are transmitted and/or received.
:efn.
:fn id=compress.
 Ordinarily each byte received or transmitted is displayed in order of transfer to/from the hardware,
with each new byte is placed for viewing into the next character position on the screen.  When
:hp2.display compression:ehp2. is selected the character position is not incremented when
a received byte follows a transmitted byte.
:efn.
:fn id=load.
 Each DEVICE=comdd.SYS statement in your CONFIG.SYS file is considered
a :hp2.load:ehp2. of the COMi Asynchronous Device Driver.
:efn.
:fn id=check.
 You can check (select) a button either by clicking mouse button one
on the item or by using the TAB and/or cursor keys to move so the required item
has the focus then pressing the space bar.
:efn.
:fn id=checkmark.
 A symbol that shows that a menu choice is currently active.
:efn.
:fn id=displayable.
 In the lexical display format only characters that are :hp2.not:ehp2. excluded by the user
with display filters are displayed.
:efn.
:fn id=synchronize.
 When the lexical display format is in the "line" oriented mode the transmit and receive streams can be synchronized.  This
means that a :link refid=direction reftype=fn.stream direction:elink. being synchronized "to" is displayed starting at
the first character of that "line" and the :hp2.stream direction:ehp2. that is to be in synchronization is displayed starting at the
first character of the first "line" the begins immediately after the first character of the sync to :hp2.stream direction:ehp2..
:efn.
:fn id=direction.
 Stream direction is either into the device (receive), or out of the device (transmit).
:efn.
:fn id=int_scheme.
 Different adapter manufacturers use different schemes to allow shared interrupts in ISA machines.  Currently the COMi
device driver supports the following schemes&colon.
:ul.
:li.Interrupt ID register is at the adapter base I/O address +7 (type one)
:p.Sealevel Systems COMM+8 and Turbo COMM+4, Connect Tech DFLEX, and GlobeTeks four port
adapter use this interrupt sharing scheme.
:li.Interrupt ID register is at the adapter base I/O address +7 and the Texas Instruments
16C550B UART is used (type one).
:p.Comtrol Hostess serial adapters use this interrupt sharing scheme.
:li.Interrupt ID register is aliased at each device's base I/O address +7 (type three).
:p.Quatechs' ES-XXX and QS-XXX adapters use this scheme.
:li.Interrupt ID register address is at a user defined location for odd interrupts
ans is at the user defined address +1 for even interrupt levels (type four).
:p.DigiBoard's PC/4 and PC/8 use this interrupt sharing scheme.
:li.Interrupt ID register address is at a user defined location (type five).
:p.DigiBoard's PC/16 uses this interrupting scheme.
:eul.
:efn.
:fn id=ibm.
 IBM, OS/2, PS/2, and Micro Channel are trademarks of International Business Machines.
:efn.
:fn id=microsoft.
 Windows is a trademark of Microsoft, Incorporated.
:efn.
