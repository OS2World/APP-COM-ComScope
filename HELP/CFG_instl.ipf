.*
.*******************************************************************************
.*  NO_INI_FILENAME
.*******************************************************************************
:h1 res=30130 hide nosearch name=HLPP_MB_NO_INI_FILENAME.Unknown Initialization File Name
:p.
The COMi device driver needs to read an initialization file during system startup to
determine the location and configuration of any serial devices it is to control.
:p.
The name of the file is the name of the device driver file (driver.SYS) with the extention :hp2..INI:ehp2.
(e.g., driver.INI).  When the device driver is loaded this configuration program can get the name
of the initialization file by querying the device driver.
:p.
If you are reading this message, and you are, then the device driver is not loaded, and you
will have to supply a path and file name for the initialization file when the file info dialog is presented (next).
:p.
You :hp2.MUST:ehp2. name the file as described above, and supply a complete path to where
the device driver file is located in order to complete COMi configuration and/or installation.
.*
.*******************************************************************************
.*  NO_TESTCFG
.*******************************************************************************
:h1 res=30129 hide nosearch name=HLPP_MB_NO_TESTCFG.TESTCFG device driver not loaded
:p.
The configuration program cannot determine the architecture of this machine because the
TESTCFG.SYS device driver is not loaded.  The line DEVICE=d&colon.\OS2\BOOT\TESTCFG.SYS is placed
in your CONFIG.SYS file during the OS/2 installation process and should not be removed.  It is
recommended that you replace the missing line before you shutdown this OS/2 session.
:p.
For this OS/2 session, you will need to indicate if this machine is an
:link refid=MCA reftype=fn.MCA:elink. machine.  If you replace the missing TESTCFG line in
your CONFIG.SYS, this configuration program will not need to bother you with this question again.
.*
.*************************************************
.*  HLPP_CONFIGSYS_BAD
.*************************************************
:h1 nosearch hide res=40102 name=HLPP_CONFIGSYS_BAD.Cannot Open CONFIG.SYS
:p.
Your system configuration file (CONFIG.SYS) may have been opened by another process.
:p.
You may either make the changes to your system configuration file maually or you can close any process
that may have the file open and try again.
:nt.After you have re-enabled access to your CONFIG.SYS file you can complete this installation/configuration by
selecting the :hp2.Device | Install Device...:ehp2. menu again and just clicking on the :hp2.OK:ehp2. push button
after the dialog box re-appears.
:p.
All of the configuration paramaters you have just entered will be remembered.  You need only to give this
process another chance to access your CONFIG.SYS file.
:ent.
.*
.*************************************************
.*  HLPP_CONFIGSYS
.*************************************************
:h1 nosearch hide res=40101 name=HLPP_CONFIGSYS hide nosearch.CONFIG.SYS Modification
:p.
Each :link refid=load reftype=fn.load:elink. defined during COMi configuration will require a :hp2.DEVICE=comdd.SYS:ehp2.
statement in your system configuration file (CONFIG.SYS).
:p.
Selecting the :hp2.Yes:ehp2. button will cause the required load statements to be added or removed automatically.
:p.
Selecting the :hp2.No:ehp2. button will cause this configuration process to leave your CONFIG.SYS file unchanged and you will
have to add or remove the required load statements manually.
:nt.If you inadvertantly select :hp2.No:ehp2. you need only enter the installation/configuration process again
and select the :hp2.OK:ehp2. button to be asked to make this chioce again.
:ent.
.*
.*************************************************
.*   Interrupt Algorithim Dialog Help
.*************************************************
:h1 nosearch hide res=50457 name=HLPP_OEM_ALGO_DLG.Help for OEM Interrupt Processing
:p.The adapter you have selected has an interrupt ID register that allows COMi to share one
interrupt request (IRQ) line with all of the UARTs on that adapter.
:p.For the adapter you selected, the interrupt ID register can be used in two different ways&colon.
:ol.
:li.To indicate that at least one device on the adapter has an interrupt to be serviced.
:li.To indicate which device, or devices, are in the interrupt state.
:eol.
:p.You can set the manner in which the ID register is used by selecting the :hp2.Interrupt
Processing Algorithim:ehp2. to be used for this COMi load.
:p.There are three choices&colon.
:ol.
:li.:hp2.Poll active devices.:ehp2.
:p.This method causes each active port to be polled upon entry to the interrupt routine.  After all
devices that have interrupts pending have been serviced, COMi tests the ID register to see if any new
interrupts have occurred on any device on that adapter.
:p.If the ID register indicates that new interrupts are pending, then each active port is polled
again.  This cycle is repeated until the ID register indicates that no device is in the
interrupt state.
:li.:hp2.Select Interrupting Device.:ehp2.
:p.This method causes the interrut ID register to be read upon entry to the interrupt
routine.  The value in the ID register is used to determine which device to service.  After
each interrupting device has been serviced the ID register is read again to determine
if there is another device that needs service.
:p.If another device needs service, the value in the ID regieter is again used to determine
which device to service.  This process continues until no device has an interrupt to service.
:li.
:hp2.Select upon entry, then poll active devices.:ehp2.
:p.This method starts out like algorithim number two, method by servicing the highest
priority device as indicated by the ID register upon entry to the interrupt routine,
then polls all active devices until no pending interrupts are indicated by the ID register.
:eol.
:p.
Currently COMi supports two different types of interrupt ID registers&colon.
:ul.
:li.
The most common type is found on Comtrol Hostess adapters, Sealevel Systems
COMM+8 and Turbo COMM+4 adapters, Quatech QS-XXX and ES-XXX adapters, Globetek's four
port adpaters, and Connect Tech's DFLEX adapters.
:p.The ID register on these adapters use each bit in the ID register to indicate which device
has an interrupt pending.  The first device (lowest I/O base address) on the adapter
will activate bit zero of the ID register when that device has an interrupt to be serviced.
The second device (second lowest I/O base address) will cause bit one to activate when
that device has an interrupt pending, and so on.
:p.Priority is determined only by bit position; the first device will have the highest
priority and the last device will have the lowest priority.  When the algorithim choice
includes "Selecting" an interrupting device (items two and three, above), the highest
priority device that has an interrupt pending will be selected and serviced each time
the ID register is used to "select" an interrupting device and indicates there is an
interrupt pending.
:li.
The second type is used by DigiBoard for their PC/x serial adapters.
:p.The ID register is assisted by a hardware state machine that polls each of the devices on
an adapter.  When a device enters the interrupt state and is polled by the state machine,
an interrupt is raised to the system interrupt controller.  The ID register value indicates
which device is in the interrupt state.  When that interrupting device has been serviced
the state machine will continue its polling cycle.
:p.When ANY device has an interrupt pending the ID register will contain a value the indicates
the next device in the polling cycle that has an interrupt pending.  This method prevents
any one device from "hogging" the interrupt by always polling the other devices (in order) on an
adapter before comming back the just serviced device.  The hardware state machine is
transparent to the device driver and is fast enough to insure that no interrupt will be lost.
:p.When a "Polling" algorithim is selected (items one and three, above) the ID register will
be used only to determine that there are NO interrupts pending before the interrupt routine
returns to the operating system, for that cycle that uses "Polling" of the ID register.
:eul.
:nt.For algorithims that include "Polling", a device is considered :hp2.active:ehp2. only
if it is currenty "open".
:ent.
Related Information&colon.
:ul compact.
:li.:link refid=HLPC_ADAPTERS reftype=hd.Serial Adapters Supported:elink.
:li.:link refid=HLPC_ADAPTER_TYPES reftype=hd.Shared Interrupt Adapter Types:elink.
:eul.
.*
.*
.*************************************************
.*   non-exclusive Message Box Help
.*************************************************
:h1 nosearch hide res=40108 name=HLPP_MB_NONEXCLUSIVE_ACCESS.Help for Non-Exclusive Access
:p.Accessing more than one device connected to the same Interrupt Request (IRQ) circuit can cause unpredictable
results.
:p.If you need simutaneous run-time access to serial devices connected to the same IRQ is recommended that you
aquire a serial adapter that supports shared interrupts on :link refid=ISA reftype=fn.ISA:elink. machines.
:p.Related Information&colon.
:p.See :link refid=HLPI_INST_ISA_PORTS reftype=hd.Installing ISA Serial Devices:elink. for information on installing
serial adapters that specifically support shared interrupts on ISA machines.
.*
.*************************************************
.*   Shared Access Message Box Help
.*************************************************
:h1 nosearch hide res=40107 name=HLPP_MB_SHARE_ACCESS.Help for Shared Access
:p.Connecting two or more devices to the same hardware Interrupt Request circuit (IRQ) can cause unpredictable results.
:p.If your hardware supports the electrical characteristics required to allow more than one device to connect
to an IRQ it will be safe to use such devices one-at-a-time.
:p.If your hardware does not support these electrical characteristics, you could cause your machine
to lock-up anytime you access any device connected in this manner.
:p.Required Electrical Characteristics&colon.
:p.In order to support interrupt connection sharing, a device must not place a load on the IRQ
unless interrupts are explicitly enabled for that device.
:p.Related Information&colon.
:p.See :link refid=HLPI_INST_ISA_PORTS reftype=hd.Installing ISA Serial Devices:elink. for information on installing
serial adapters that specifically support shared interrupts on :link refid=ISA reftype=fn.ISA:elink machines.
.*
.*************************************************
.*   Hardware Setup Dialog Box Help
.*************************************************
:h1 nosearch hide res=30011 name=HLPP_HDW_SETUP_DLG.Help for Device Hardware Setup Dialog
:p.Use :hp2.I/O Base Adderess:ehp2. to define a :link refid=address reftype=fn.base adderess:elink.
for the device.
:p.Use :hp2.Entry Base:ehp2. to select a numerical base to display and read the I/O base
address.
:ul compact.
:li.Select :hp2.Hexadecimal:ehp2. to to display/read the I/O base as a base 16 number.
:li.Select :hp2.Decimal:ehp2. to to display/read the I/O base as a base 10 number.
:eul.
:p.Use :hp2.Interrupt level:ehp2. to select the hardware :link refid=int_level reftype=fn.interrupt level:elink. to which
the device is connected.
:p.Select :hp2.FIFO Setup:ehp2. to open the hardware FIFO setup dialog box.
:nt.If you have selected a specific adpater in the :hp2.Adpter Set-up:ehp2.
dialog box, you will not be able to select a hardware interrupt level here.
:ent.
.*
.*************************************************
.*   Baud Rate Dialog Box Help
.*************************************************
:h1 nosearch hide res=30132 name=HLPP_DEF_BAUD_DLG.Help for Default Baud Rate Dialog
:p.Select a standard baud rate from the drop down list box.
:p.You may enter an unlisted baud rate in the entry field.  If the value you enter
is not within 1% of a baud rate the device is capable of, the nearest valid baud rate
will be used at system start-up.
:p.The current default baud rate will be displayed in the entry box upon entry to
the dialog.
:p.If you have the device driver extension :hp2.Explicit Baud Divisor:ehp2. selected
for this port, the value you enter will be used as the baud rate divisor for this
device and be written directly to the baud rate select registers on the UART.
:nt.In order to use the :hp2.Explicit Baud Divisor:ehp2. feature, the device you
are controlling must be capable of non-standard UART clock rate selection in
hardware.  See your serial adapter documentation for further information.
:ent.
.*************************************************
.*   Protocol Dialog Box Help
.*************************************************
:h1 nosearch hide res=30123 name=HLPP_DEF_PROTOCOL_DLG.Help for Default Protocol Dialog
:p.Select a standard baud rate from the drop down list box.
:p.You may enter an unlisted baud rate in the entry field.  If the value you enter
is not within 1% of a baud rate the device is capable of, the nearest valid baud rate
will be used at system start-up.
:p.The current default baud rate will be displayed in the entry box upon entry to
the dialog.
:p.If you have the device driver extension :hp2.Explicit Baud Divisor:ehp2. selected
for this port, the value you enter will be used as the baud rate divisor for this
device and be written directly to the baud rate select registers on the UART.
:nt.In order to use the :hp2.Explicit Baud Divisor:ehp2. feature, the device you
are controlling must be capable of non-standard UART clock rate selection in
hardware.  See your serial adapter documentation for further information.
:ent.
Select the default line protocol for this device by :link refid=check reftype=fn.checking:elink.
the required buttons.
:p.Selecting parity to be :hp2.Zero:ehp2. will cause the parity bit to be transmitted
as a zero, and cause the receiver to expect a zero in the parity bit for any character
it receives.
:p.Selecting parity to be :hp2.One:ehp2. will cause the parity bit to be transmitted
as a one, and cause the receiver to expect a one in the parity bit for any character
it receives.
.*
.*************************************************
.*   COMi Buffer Size Dialog Box Help
.*************************************************
:h1 nosearch hide res=30012 name=HLPP_BUFFER_SETUP_DLG.Help for Device Driver Buffer Setup Dialog
:p.Use the sliders or scroll buttons to select the various COMi device driver buffer
sizes.  Deselecting :hp2.Enable COMscope Access:ehp2. will disable COMscope access
to this device for the next OS/2 session.
:nt.COMscope access will not be available unless you are configuring or installing
the COMi device driver from within COMscope or from a COMscope distribution diskette.
:ent.
.*
.*************************************************
.*   Device Config Dialog Box Help
.*************************************************
:h1 nosearch hide res=30010 name=HLPP_DEVICE_SETUP_DLG.Help for Device Configuration Dialog
:p.Use :hp2.Device Configuration:ehp2. dialog box to set the following device
parameters for the device being configured&colon.
:dl break=all.
:dt.Use the :hp2.Device Name:ehp2. field&colon.
:dd.To select the DOS name for the device being configured.  This list box will only
display device names that are not already selected for use by the COMi device driver
and are available for installation.
:nt.If you select a device name used by the COM.SYS device driver, the COMi device
driver will take presedence.
:ent.
:dt.Select :hp2.Hardware...:ehp2.&colon.
:dd.To enter a device's :link refid=address reftype=fn.I/O base address:elink.,
select an :link refid=int_level reftype=fn.interrupt level:elink., and set the start-up
defaults for FIFO control (for those devices that support FIFOs).
:nt.If you have selected a hardware interrupt level for this load from the :hp2.Adpter
Set-up:ehp2. dialog box, the hardware interrupt level selection field will be disabled.
:ent.
:dt.Select :hp2.Buffers...:ehp2.&colon.
:dd.To set the size of transmit, receive, and COMscope buffers the device driver
allocates at initialization and enable or disable COMscope run-time access.  See
:link refid=HLPI_BUFFER_SIZES reftype=hd.COMi Buffer Limits:elink. for buffer size
limits.
:dt.Select :hp2.Handshaking...:ehp2.&colon.
:dd.To set startup defaults for the various handshaking protocols supported by the
device driver.
:dt.Select :hp2.Timeouts...:ehp2.&colon.
:dd.To set default time-out counts and processing for a device.
:dt.Select :hp2.Protocols...:ehp2.&colon.
:dd.To set the start-up defaults for line characteristics and baud rate.
:dt.Select :hp2.Extensions...:ehp2.&colon.
:dd.To set select various device driver extensions.
:edl.
:nt.Next to the Device Name field, in red, is a suggested (guessed) I/O base address
and interrupt level.  If you select the :hp2.OK:ehp2. push button the values shown
there will be used for the device being configured.
:ent.
.*
.*******************************************************************************
.*  Entensions help
.*******************************************************************************
:h1 id=HLPI_EXTENSION.Device Driver Extensions
:p.
COMi has evolved over the years while attempting to solve specific problems for our customers.  COMi
"extends" the functionality of the serial device driver supplied with OS/2:link refid=ibm reftype=fn.*:elink.
in the following ways&colon.
:dl break=all.
:dt.Allows extended modem controls
:dd.Allows an application to have runtime control of the OUT1 and LOOP signals of the UART.
:dt.Lets you disable modem interrupts
:dd.Modem input signals can be processed with or without interrupts.  The purpose of this
extention is to make it possible to use this device driver on some adapter boards that do not
properly terminate all of the modem signal input pins of a UART.  Modem signals are still monitored
when this item is selected, just not as efficiently.
:dt.Lets an application supply an explicit baud divisor
:dd.This extension takes advantage of those adapter boards that allow a user to select
non-standard clocks for the UART baud rate generator.
:dt.Allows an application to disable startup UART tests
:dd.This feature can disable extensive testing of the UART and its connections at
initialization, including hardware interrupt connection, and interrupt ID register functionality.
:dt.Allows enabling of application specific extensions
:dd.An application can use COMi extensions designed for that application.  These extensions
are specific to some specialized applications.  If you are using an application supported
by one or more of these extensions, that application's documentation will explain its usage
of these extensions.
:dt.Allows activation of the OUT1 signal on startup
:dd.This feature forces the OUT1 output signal to the active state during initialization at
system startup.
:nt.Unless you turn off OUT1 via a DosDevIOCtl call when the COMi extention :hp2.Enable Modem Extensions:ehp2.
is enabled, OUT1 will remain active throughout the life of that OS/2 session.
:ent.
:dt.Supports special processing for the Texas Instruments 16C550A/B UART&colon.
:dd.This feature allows you to specify that the device you are configuring COMi for is a Texas
Instruments 16C550A or 16C550B UART.  These UARTs require some special processing when
the receive FIFO is enabled.  If the item is not checked when the device is a TI 16C550A or
16C550B your system WILL lock-up if this device is used with receive FIFOs enabled.
:dt.Allows multiple devices to be connected to a single interrupt&colon.
:dd.This feature will allow more than one device to share an Interrupt Request (IRQ) connection.
:nt.When this item has been selected you can also select to allow more than one device
connected to an interrupt level to be open at the same time by disabling exclusive
access tests at run-time.
:p.
Disabling exclusive access tests and opening two ports connected to the same interrupt
level is not recommended, as it is possible for your system to stop responding to an
interrupt level shared in this manner under certain conditions that may, or may not, be
under your control.
:ent.
:edl.
:nt.
When you are using an adapter that supports shared interrupts you MUST use the :hp2.Adpter Set-up:ehp2.
button in the :hp2.Device Install...:ehp2. dialog box to configure this
COMi load for that specific interrupt adapter.
:ent.
.*
.*******************************************************************************
.*  Entensions dialog box help
.*******************************************************************************
:h1 nosearch hide res=30028 name=HLPP_EXT_DLG.Help for Device Driver Extensions Dialog
:p.
Use the :hp2.Extensions:ehp2. dialog box to select the following extensions for the
device being configured&colon.
:dl break=all.
:dt.Select :hp2.Accept Extended Modem Controls:ehp2.&colon.
:dd.To allow an application to have runtime control of the OUT1 and LOOP signals of the UART.
:dt.Select :hp2.Disable Modem Interrupts:ehp2.&colon.
:dd.To process modem input signals without interrupts.  The purpose of this extention
is to make it possible to use this device driver on some adapter boards that do not
properly terminate all of the modem signal input pins of a UART.  Modem signals are still monitored
when this item is selected, just not as efficiently.
:dt.Select :hp2.Use Explicit Baud Divisor:ehp2.&colon.
:dd.To take advantage of those adapter boards that allow a user to select non-standard clocks
for the UART baud rate generator.
:dt.Select :hp2.Disable Startup UART tests:ehp2.&colon.
:dd.To disable extensive testing of the UART and its connections at initialization, including
hardware interrupt connection, and interrupt ID register functionality.
:dt.Select :hp2.Enable Device Driver Extensions:ehp2.&colon.
:dd.To enable application specific COMi extensions.  These extensions are specific to some specialized
applications.  If you are using an application supported by one or more of these extensions,
that application's documentation will explain its usage of these extensions.
:dt.Select :hp2.Activate OUT1 on Startup:ehp2.&colon.
:dd.To force the OUT1 output pin active at initialization.
:nt.Unless you turn off OUT1 via a DosDevIOCtl call when the COMi extention :hp2.Enable Modem Extensions:ehp2.
is enabled, OUT1 will remain active throughout the life of that OS/2 session.
:ent.
:dt.Select :hp2.Texas Instruments 16C550A/B:ehp2.&colon.
:dd.If the device you are configuring is a Texas Instruments 16C550A or 16C550B UART.  These
UARTs require some special processing when the FIFOs are enabled.
:dt.Select :hp2.Shared Interrupt Connection:ehp2.&colon.
:dd.To allow more than one device to share an Interrupt Request (IRQ) connection.
:nt.When this item has been selected you can also select to allow more than one device
connected to an interrupt level to be open at the same time by deselecting the :hp2.Exclusive
Access:ehp2. check box.
:p.
Deselecting :hp2.Exclusive Access:ehp2. and opening two ports connected to the same interrupt
level is not recommended, as it is possible for your system to stop responding to an
interrupt level shared in this manner under certain conditions that may, or may not, be
under your control.
:ent.
:edl.
:warning.
Unless a serial adapter has specialized hardware it will not be possible to share interrupts
in any way.  For this feature to be useful your hardware MUST not load its interrupt request
(IRQ) line unless, and until, it has an interupput to be processed.  If the device loads
the IRQ when not in the interrupt state then any other device connected to that IRQ will
not be able to signal an interrupt to the system interrupt controller.
:ewarning.
:nt.
When you are using an adapter that specifically supports shared interrupts you MUST use
the :hp2.Adpter Set-up:ehp2. button in the :hp2.Device Install...:ehp2. dialog box
to configure this COMi load for that specific interrupt adapter.
:ent.
.*
.*************************************************
.*   Device Driver Adpter Set-up Dialog Box Help
.*************************************************
:h1 nosearch hide res=30029 name=HLPP_OEM_DLG.Help for Adapter Configuration Dialog
:p.
The :hp2.Adapter Type:ehp2. group is used to select the type of serial adapter for which you are
configuring the device driver.
:nt.Select :hp2.Not Interrupt Sharing:ehp2. if your are configuring the device driver for any
serial adapter that does not support interrupt sharing in hardware.  Selecting this
item disables hardware supported interrupt sharing for this device driver load, and
will allow you to select a different interrupt for each device you define for this load.
:ent.
Use the :hp2.Interrupt Status/ID Address:ehp2. field to define an interrpt ID register address for
the device driver load you are configuring.
:p.
Use :hp2.Entry Base:ehp2. to select a numerical base to display and read the interrupt ID
register address.
:ul compact.
:li.Select :hp2.Hexadecimal:ehp2. to to display/read the interrupt ID register address as
a base 16 number.
:li.Select :hp2.Decimal:ehp2. to to display/read the interrupt ID register address as
a base 10 number.
:eul.
:p.
Use :hp2.Interrupt Level:ehp2. to select the hardware Interrupt level to which the adapter
is connected.
:p.
Select the :hp2.Interrupt Processing Algorithim:ehp2. button to select the manner in
which the interrupt Status/ID register will be used to process adapter interrupts.
:sl compact.
:li.Related Information&colon.
:ul compact.
:li.:link refid=HLPC_ADAPTERS reftype=hd.Serial Adapters Supported:elink.
:li.:link refid=HLPC_ADAPTER_TYPES reftype=hd.Shared Interrupt Adapter Types:elink.
:eul.
:esl.
.*************************************************************************
.*  Adapter Types
.*************************************************************************
:h1 id=HLPC_ADAPTER_TYPES.Shared Interrupt Adapter Types
:p.
In order for COMi to support shared interrupts on an :link refid=ISA reftype=fn.ISA:elink.
machine, an adapter of one of the types described below must be used.
:p.
:hp2.Type One:ehp2.&colon.
:ol compact.
:li.All devices on an adapter can be connected to a single IRQ.
:li.The adapter has an interrupt ID register at adapter base I/O address +7.
:li.Each bit in the interrupt ID register represents one, and only one, serial device.
:li.When there is no device with a pending interrupt, the ID register will be read as a zero.
:eol.
:p.
:hp2.Type Two:ehp2.&colon.
:ol compact.
:li.A Texas Instruments 16C550B UARTs are installed on the adapter.
:li.All devices on an adapter can be connected to a single IRQ.
:li.The adapter has an interrupt ID register at adapter base I/O address +7.
:li.Each bit in the interrupt ID register represents one, and only one, serial device.
:li.When there is no device with a pending interrupt, the ID register will be read as a zero.
:eol.
:p.
:hp2.Type Three:ehp2.&colon.
:ol compact.
:li.All devices on an adapter can be connected to a single IRQ.
:li.The adapter has an interrupt ID register at a fixed or user defined address.
:li.Each bit in the interrupt ID register represents one, and only one, serial device.
:li.When there is no device with a pending interrupt, the ID register will be read as a zero.
:eol.
:p.
:hp2.Type Four:ehp2.&colon.
:ol compact.
:li.The adapter has an interrupt ID register at a user definable address.
:li.The address of the interrupt ID register is as defined by the user for odd interrupts (3, 5, 7, 9, 11, 13, 15) and
is at the user defined address +1 for even interrupts (2, 4, 6, 8, 10, 12, 14).
:li.The value read from the interrupt ID register indicates the highest priority device that
has an interrupt pending.
:li.When there is no device with a pending interrupt, the ID register will be read as all ones (0xFF).
:p.:hp8.This adapter type should be used to support DigiBoard's PC/4 and PC/8 serial adapters, only.:ehp8.
:eol.
:p.
:hp2.Type Five:ehp2.&colon.
:ol compact.
:li.The adapter has an interrupt ID register at a fixed address that is based on which
of four available PALs is installed on the adapter.
:li.The value read from the interrupt ID register indicates the highest priority device that
has an interrupt pending.
:li.When there is no device with a pending interrupt, the ID register will be read as all ones (0xFF).
:p.:hp8.This adapter type should be used to support DigiBoard's PC/16 serial adapters, only.:ehp8.
:eol.
:sl compact.
:li.Related Information&colon.
:ul compact.
:li.:link refid=HLPC_ADAPTERS reftype=hd.Serial Adapters Supported:elink.
:eul.
:esl.
.*
.**************************************************************************
.*     Adapters supported
.**************************************************************************
:h1 id=HLPC_ADAPTERS.Serial Adapters Supported
:p.
COMi has been tested with the following serial adapters.
:table cols='5 18 12'.
:row.
:c.Type
:c.Manufacturer
:c.Model
:row.
:c.One
:c.Sealevel Systems
:c.COMM+4
:row.
:c.
:c.
:c.TURBOCOMM+8
:row.
:c.
:c.Globetek
:c.Four Port
:row.
:c.
:c.Quatech
:c.ES-xxx
:row.
:c.
:c.
:c.QS-xxx
:row.
:c.Two
:c.Comtrol
:c.Hostess RJ45
:row.
:c.
:c.
:c.Hostess RJ11
:row.
:c.Three
:c.Connect Tech
:c.DFLEX
:row.
:c.Four
:c.DigiBoard
:c.PC/4
:row.
:c.
:c.
:c.PC/8
:row.
:c.Five
:c.DigiBoard
:c.PC/16
:etable.
COMi will support shared interrupt with all of the adapters listed above and any other
adapter that uses one of the interrupt sharing schemes described under
:link refid=HLPC_ADAPTER_TYPES reftype=hd.COMi Adapter Types:elink..
.*
.*************************************************
.*   Device Driver Config Dialog Box Help
.*************************************************
:h1 nosearch hide res=30023 name=HLPP_INSTALL_DLG.Help for Device Driver Configuration
:p.
The :hp2.COMi Load:ehp2. group is used to select the following parameters&colon.
:dl break=all.
:dt.:artwork name='P:\CONFIG\OEM_NORM.BMP' runin align=left.
:dd.This button will open the adapter set-up dialog box.  Use this button to configure
the COMi device driver for your serial adapter.  This button appears only for
:link refid=ISA reftype=fn.ISA:elink. serial adapters and is not required for
:link refid=MCA reftype=fn.MCA:elink. adapter configuration.
:dt.:hp2.Device Driver Load Number:ehp2.
:dd.This field is used to select the device driver :link refid=load reftype=fn.load:elink. number to configure.
:dt.:hp2.Add Load:ehp2.
:dd.This button will cause another device driver load to be opened for device installation.
:dt.:hp2.Remove Load:ehp2.
:dd.This button will cause the currently selected device driver load to be deleted.
:nt.You will not be allowed to delete load number one.  If you want to remove all COMi
loads and remove all DEVICE=comdd.SYS statements from your CONFIG.SYS file you will
have to delete each device from the :hp2.Device Definitions:ehp2. list box for load
number one.
:ent.
:edl.
:p.
The :hp2.Initialization Report:ehp2. group allows the user to select for additional information to be displayed at initialization&colon.
:dl compact break=all.
:dt.:hp2.Verbose Sign-on:ehp2.
:dd.This parameter, when selected, causes the device driver to display extended information
during initialization.
:p.
:dt.:hp2.Wait for Keystroke or Timeout...:ehp2.
:dd.This parameter, when selected, causes the device driver to wait until either the user
presses the ENTER key or the timeout defined in the next parameter occurs.  This is to allow a user
time to read the extended information displayed when :hp2.Verbose Sign-on:ehp2. is selected.
:edl.
:p.
The list box in the :hp2.Device Definitions:ehp2. group shows a list of any installed devices for
the currently selected device driver load.  Each device driver load can have up to eight serial
devices under its control.
:p.
Each installed device will have the following information&colon.
:ul compact.
:li.Device's logical name (COM1 through COM99)
:li.Device's hardware base I/O address
:li.Device's hardware interrupt level
:li.Indicators for any device driver extensions selected for that device
:eul.
:p.
You can edit a defined device's configuration either by double clicking the mouse
button one on that list item or selecting that device in the list and selecting the
:hp2.Edit Device:ehp2. button.
:p.
If there are less than eight devices defined you can install a new device by selecting
the :hp2.Add Device:ehp2. button.  If you are installing a sixteen port adapter (i.e., DigiBoards
PC/16) the :hp2.Add Device:ehp2. button will remain enabled until you have installed all sixteen
serial devices.
:p.
You can delete any defined device by selecting that device from the list and selecting
the :hp2.Remove Device:ehp2. button.
:p.
Click on the :hp2.OK:ehp2. button to close the dialog box and save the changes just made.
:p.
Click on the :hp2.CANCEL:ehp2. button to close the dialog box without saving any changes.
.*
.*******************************************************************************
.* Buffer limits
.*******************************************************************************
:h1 id=HLPI_BUFFER_SIZES.COMi Buffer Size Limits
:i2 refid=HLPI_INSTALL.Comi Buffer Limits
COMi buffer sizes can be set to the following&colon.
:table cols='8 7 7 7'.
:row.
:c.Buffer
:c.minimun
:c.default
:c.maximum
:row.
:c.Receive
:c.1024
:c.4096
:c.64k
:row.
:c.COMscope
:c.1024*
:c.4096
:c.32k
:row.
:c.Transmit
:c.128
:c.256
:c.8k**
:etable.
:dl tsize=4.
:dt.&asterisk.
:dd.If COMscope access is disabled no COMscope buffer will be allocated.
:dt.&asterisk.&asterisk.
:dd.A total of about 63k is available for all transmit buffers for each COMi load.
:edl.
.*
.*******************************************************************************
.*   Installing ISA COM ports
.*******************************************************************************
:h1 id=HLPI_INST_ISA_PORTS.Installing ISA Serial Devices
:i2 refid=HLPI_INSTALL.Installing ISA Serial Devices
:p.
If you are installing a serial support in an ISA machine and you intend to connect multiple devices
to a single hardware interrupt level you need to be aware of the following&colon.
:ol.
:li.Your adapter must have special features to support interrupt sharing.
:li.The adapter's special features that allow interrupt sharing must be enabled and configured correctly.
:li.You must know the hardware address of your adapter's interrupt status or ID register.
:li.You must open the adapter set-up dialog by clicking on the :hp2.Adpter Set-up:ehp2. button from the
:hp2.COMi Configuration:ehp2. dialog to specify the adapter type, hardware interrupt level,
and address of the interrupt status/ID register in order to define more than one device
to a hardware interrupt level.
:eol.
:nt.
Sharing interrupts on an :link refid=MCA reftype=fn.MCA:elink. machine requires no special
configuation.  Please note, though, that it is not recommended that you connect more than
eight devices to any one hardware interrupt level.
:ent.
Related Information&colon.
:ul compact.
:li.:link refid=HLPC_ADAPTERS reftype=hd.Serial Adapters Supported:elink.
:li.:link refid=HLPC_ADAPTER_TYPES reftype=hd.Shared Interrupt Adapter Types:elink.
:eul.
.*
.*************************************************
.*  COMi Spooler Help
.*************************************************
:h1 id=HLPI_INST_SPOOL.COMi Print Spooler Support
:i2 refid=HLPI_INSTALL.COMi Print Spooler Support
:p.
To install and configure COMi Print Spooler support you must have selected
to transfer the spooler support files while installing COMi by selecting
the "Print Spooler Utilities" check box in the "Install Options" dialog, and
you must have re-booted your machine since that install session.
:p.
Once you have completed installing COMspool and configuring COMi you will need to do
the following&colon.
:ol.
:li.Click mouse button two (usually the right button) on a local printer object.
If you have not created a local printer object yet then you will need to
drag a non-network printer object from the "Templates" folder onto your
desktop.
:note.
If you will be creating a printer object as part of this installation
then skip to item three, as the printer object's settings notebook will have
been presented immediately after you dragged the object from the
"Templates" folder.  You will also have to select a printer driver and
possibly need to set other parameters in the printer's settings notebook.
:li.Select the "Settings" menu item.
:li.Click on the "Output" tab.
:li.Click mouse button two on any port icon in the container window.
:li.Select the "Install" menu item.
:li.In the "Directory" entry field enter the following (without the quotes):
"\OS2\DLL", then press the <ENTER> key, or select the "Refresh"
button.
:li.The OS/2:link refid=IBM reftype=fn.**:elink. Spooler software (PMSPOOL) will read each
spooler support library in that directory, including the COMi spooler support library
and display an icon in the container area for each device the spooler support libraries
support.
:li.Select one, or more, of the COMi Spooler ports, then select the "Install"
button.
:li.When the PMSPOOL is finished installing the ports you have selected it will display
a message box indicating that the ports you selected have been installed.  Click on
the "OK" button to continue.
:li.When you are through installing Spooler Ports, click on the "Cancel" button.
:li.Set the port parameters to match the requirements of the printer to be connected by
clicking mouse button two on an icon in the "Ouptut" page container area and selecting
the "Settings" menu item.  Help for setting port parameters will be available once you
have entered the setup
dialog.
:eol.
:nt text=IMPORTANT.
After installing COMspool, as described above, you will have to shutdown your system
and re-boot before PMSPOOL will be able to initialize COMspool supported ports.
:ent.
:nt.
Configuration of spooler ports for printer initialization will always have to be done
from a printer object's settings notebook.
:ent.
.*
.*************************************************
.*   Timeout Dialog Box Help
.*************************************************
:h1 nosearch hide res=30017 name=HLPP_TIMEOUT_DLG.Help for Timeout Processing
:p.
Use the :hp2.Read Timeout Processing:ehp2. group to select the type of read time-out
processing you need, and to set the read time-out count.
:p.
Select &colon.
:dl break=all.
:dt.:hp2.Normal:ehp2. read time-out processing:
:dd.
Causes the device driver to wait up to the designated read time-out count after each character received
before returning to the calling application.
:p.Upon reception of a read request packet the device driver will first try to fill the request from
the receive buffer.  If all of the bytes requested are available in the buffer, the device driver
will return immediately.  If all of the requested bytes are not in the buffer, the device driver will wait
for incomming bytes until either the request is filled (all requested bytes have been placed into the receive buffer
by the hardware) or until more than the time represented by the read time-out count passes between bytes received by
the hardware.
:dt.:hp2.Wait for Something:ehp2. read time-out processing:
:dd.
Causes the device driver to act like :hp2.No Wait:ehp2. read time-out processing only if there are characters available in
the buffer when the read request packet arrives.  In this case the device driver will return to the calling process,
immedialely, with any characters that are available, up to the number of characters requested.  If there is nothing in the receive
queue when the request packet arrives the device driver enters :hp2.Normal:ehp2. read time-out processing and
returns only after either the request is filled (all requested bytes have been placed into the receive buffer by the hardware)
or until more than the time represented by the read time-out count passes between bytes received by the hardware.
:dt.:hp2.No Wait:ehp2. read time-out processing:
:dd.Causes the device driver to transfer up to the requested number of bytes from the receive buffer and return
immediately.  The read time-out count is ignored.
:p.Upon reception of a read request packet, if no bytes are available the device driver still
returns immediately.
:edl.
:p.
Use the :hp2.Write Timeout Processing:ehp2. group to select the type of write time-out
processing you need, and to set the write time-out count.
:p.
:dl compact break=all.
:dt.:hp2.Normal:ehp2. write time-out processing:
:dd.
Causes the device driver to wait up to the designated write time-out count for any output
handshaking request that caused the device driver to stop transmitting .
:p.
Upon reception of a write request packet the device driver will try to begin transmitting.
If some output handshaking signal (CTS, DSR, DCD, or reception of an Xoff character)
indicates that the device driver should not be transmitting the device driver will wait up to
the write time-out count for all signals to indicate it is OK to start transmitting again and
all bytes remaining to be transmitted are transmitted, before returning to the calling application.
:p.
:dt.:hp2.Infinite:ehp2. write time-out processing:
:dd.
Causes the device driver to wait forever for a handshaking signal to indicate that it is
OK to transmit.  "Forever" can be limited by sending a "flush output buffer" command.
:p.
Upon reception of a write request packet the device driver will try to begin transmitting.
If some output handshaking signal (CTS, DSR, DCD, or reception of an Xoff character)
indicates that the device driver should not transmit, the device driver will wait
until it has been signaled to start transmitting again and all bytes remaining to be
transmitted are transmitted, before returning to the calling application.
:edl.
:p.
:hp2.Timeout Counts:ehp2.
:p.
Both time-out counts represent the number of ten millisecond intervals to wait, zero based.  For example:
a count of 99 will cause the device driver to wait up to one second before returning.
.*
.*************************************************
.*   Handshaking Dialog Box Help
.*************************************************
:h1 nosearch hide res=30020 name=HLPP_HANDSHAKE_DLG.Help for Handshaking
:p.
Selecting :hp2.Transmit Xon/Xoff:ehp2. handshaking will cause the device driver to stop
transmitting characters when an Xoff character is received and to start transmitting
again when an Xon character is received.
:p.
Selecting :hp2.Receive Xon/Xoff:ehp2. handshaking will cause the device driver to transmit
an Xoff character when the receive buffer is close to full (off threshold) and to transmit
an Xon character when the receive buffer is less than half full (on threshold).
:p.
Selecting :hp2.Full Duplex:ehp2. will allow the device driver to continue transmitting after
transmitting an Xoff character.  Otherwise the device driver will stop transmitting after transmitting
an Xoff character and will begin transmitting againg after it sends an Xon character.
:p.
When either of the :hp2.ASCII Handshaking:ehp2. protocols are selected you will be able
to enter values for the :hp2.Xon Character:ehp2. and the :hp2.Xoff Character:ehp2..
These characters have standard values and should only be changed if you have special
requirements.  These values are displayed, and can only be entered, in Hexadecimal
(base 16) format.
:p.
Selecting any of the :hp2.Output Handshaking:ehp2. signals will cause the device driver to stop
transmitting when that signal is detected to be in the inactive, or off, state.
:p.
Selecting :hp2.DSR Input Sensitivity:ehp2. will cause the device driver to ignore any bytes received
while the DSR signal is detected to be inactive.
:p.
Selecting RTS or DTR :hp2.Input Handshaking:ehp2. will cause the device driver to make those
respective signals inactive when the receive buffer is close to full (off threshold) and to
make them active when the receive buffer is less than half full (on threshold).
:p.
Selecting RTS:hp2. Toggling on Transmit:ehp2. will cause the device driver to make RTS
active whenever it begins transmitting.  When transmitting has been stopped for approximately
30 milliseconds the device driver will make RTS inactive.
:p.
Selecting Enable or Disable RTS or DTR will cause those respective signals to be
enabled or disabled.
:p.
Make the required selection by :link refid=check reftype=fn.checking:elink.
the required buttons.
.*******************************************************************************
