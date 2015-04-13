.*
.*************************************************
.*   Stream Filter Dialog Box Help
.*************************************************
:h1 nosearch hide res=30018 name=HLPP_FILTER_DLG.Help for Input Stream Filtering
:p.
Select :hp2.Enable Error Replacement Character:ehp2. to cause the device driver to replace
any character received with a parity or overrun error with the currently defined
:hp2.Error Replacement Character:ehp2..
:p.
When :hp2.Enable Error Replacement Character:ehp2. is enabled you can enter an :hp2.Error Replacement Character:ehp2.
value.  This value can only be entered in Hexadecimal (base 16) format.
:p.
Select :hp2.Enable Break Replacement Character:ehp2. to cause the device driver to replace
any character received during a transition to the break condition with the currently defined
:hp2.Break Replacement Character:ehp2..
:p.
When :hp2.Enable Break Replacement Character:ehp2. is enabled you can enter a :hp2.Break Replacement Character:ehp2.
value.  This value can only be entered in Hexadecimal (base 16) format.
:p.
Select :hp2.Enable NULL Striping:ehp2. to cause device driver to :hp2.NOT:ehp2. place received NULL characters
(zeros) into the receive buffer.
.*
.*************************************************
.*   Line Protocol Dialog Box Help
.*************************************************
:h1 nosearch hide res=30016 name=HLPP_LINE_PROTOCOL_DLG.Help for Line Protocol
:p.
Select the line protocol for this device by :link refid=check reftype=fn.checking:elink.
the required buttons.
:p.
Selecting parity to be :hp2.Zero:ehp2. will cause the parity bit to be transmitted as
a zero, and cause the receiver to expect a zero in the parity bit for any character it receives.
:p.
Selecting parity to be :hp2.One:ehp2. will cause the parity bit to be transmitted as
a one, and cause the receiver to expect a one in the parity bit for any character it receives.
.*
.*************************************************
.*   FIFO Dialog Box Help
.*************************************************
.*
:h1 nosearch hide res=30019 name=HLPP_FIFO_DLG.Help for Hardware Buffer Control
:p.
Select the required :hp2.FIFO Control:ehp2. parameters by :link refid=check reftype=fn.checking:elink.
the required button.
:p.
When :hp2.Automatic Protocol Override:ehp2. is selected the device driver will automatically disable the
receive FIFO whenever :hp2.Receive Xon/Xoff:ehp2. handshaking, RTS or DTR :hp2.Input Handshaking:ehp2., or
DTR :hp2.Input Sensitivity:ehp2. are enabled, and disable the transmit FIFO whenever any :hp2.Output Handshaking:ehp2.
is enabled.
:p.
Select the required FIFO depth by :link refid=check reftype=fn.checking:elink. the required buttons.
:nt.The COMi device driver has sufficient handshanking threshold padding to accomodate bytes received
in the FIFO after a handshake signal occurs.  Unless your application MUST stop receiving and/or
transmitting on exactly the byte received and/or transmitted when a handshake signal is detected it
is recommended that :hp2.Enable FIFO:ehp2. be selected.
:ent.
.*
.*************************************************
.*   Baud Rate Dialog Box Help
.*************************************************
:h1 nosearch hide res=30015 name=HLPP_BAUD_DLG.Help for Baud Rate Selection
:p.
Select a standard baud rate from the drop down list box.
:p.
You may enter a non-standard baud rate in the entry field.  If the value you enter
is not within 1% of a baud rate the device is capable of, it will be rejected.
:p.
If you have :hp2.Explicit Baud Divisor:ehp2. selected for this port, the value you enter will be used
as the baud rate divisor for this device.
:p.
In order to use the :hp2.Explicit Baud Divisor:ehp2. feature, the device you are controlling
must be capable of non-standard UART clock rate selection in hardware.  See your serial adapter
documentation for further information.

