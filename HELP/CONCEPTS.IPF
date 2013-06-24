.*******************************************************************************
.*  Concepts
.*******************************************************************************
:h1 id=HLPC_CONCEPTS.Communications Concepts
:i1 id=HLPC_CONCEPTS.Communications Concepts
:p.
This section is a "catch-all" for any information we thought may be helpful.
:p.
Concepts&colon.
:ul compact.
:li.:link refid=HLPC_APO reftype=hd.Automatic Protocol Override:elink.
:li.:link refid=HLPC_BAUDRATE reftype=hd.Baud Rate:elink.
:li.:link refid=HLPC_FILTERS reftype=hd.I/O Stream Filtering:elink.
:li.:link refid=HLPC_HANDSHAKE reftype=hd.Communications Handshaking:elink.
:li.:link refid=HLPC_LINE reftype=hd.Line Characteristics:elink.
:li.:link refid=HLPC_TIMEOUTS reftype=hd.Device Driver Wait States:elink.
:eul.
.*
.**********************************
.* HLPC_TIMEOUTS
.**********************************
:h2 id=HLPC_TIMEOUTS.Device Driver Wait States
:i2 refid=HLPC_CONCEPTS.Device Driver Wait States
:p.
Whenever an application reads from or writes to a COM port the device driver may block the thread
that calls the DosRead or DosWrite function.
:p.
Threads can be blocked on DosRead calls whenever the number of characters requested
are not available.
:p.
Threads can be blocked on DosWrite calls whenever some handshaking processing requires that
a serial device not transmit.
:p.
Because of this, it is recommended that the main thread (in which the message queue is
executing) not be used to read from and write to a COM port.
:p.
If the thread in which a message queue is executing is blocked it can cause the entire
system to be blocked because that thread cannot return to the queue until the event that
caused the device driver to block has occurred.
:p.
The amount of time the device driver will block for any event is configurable by any application.
:p.
.*
.**********************************
.* HLPC_LINE
.**********************************
:h2 id=HLPC_LINE.Line Characteristics
:i2 refid=HLPC_CONCEPTS.Line Characteristics
:p.
The format of the data that is to be transmitted and received is configurable by any application.
:p.
The parameters that are available are&colon.
:ol compact.
:li.The number of data bits
:li.The number of stop bits
:li.The type of parity processing, if any
:eol.
:p.
From five to eight data bits can be selected.
:p.
One, one and a half, or two stop bits can be selected.
:nt.1.5 data bits is only valid when five data bits is defined and 2 stop bits is
not valid when five data bits is selected.
:ent.
:p.
There are five parity processing options&colon.
:ol compact.
:li.No parity
:li.Even parity
:li.Odd parity
:li.Zero parity
:li.One parity
:eol.
:p.
:hp2.Even:ehp2. parity causes the parity bit to be on (one) whenever the bits of a data word add up
to an even value.  For example&colon. the data value 0x55 would cause the parity bit to
be on and the data value 0x45 would cause the parity bit to be off (zero).:p.
:hp2.Odd:ehp2. parity causes the parity bit to be on (one) whenever the bits of a data word add up
to an odd value.  For example&colon. the data value 0x55 would cause the parity bit to
be off (zero) and the data value 0x45 would cause the parity bit to be on.:p.
:hp2.Zero:ehp2. parity causes the parity bit of a data word to be off (zero) at all times.
:p.
:hp2.One:ehp2. parity causes the parity bit to be on (one) at all times.
:p.
:nt text=FYI.
Zero and One parity are sometime referred to as "stick" parity because they cause the parity
bit to "stick" at some value.
:ent.
When no parity is selected no parity bit is transmitted.  This causes the data word
to be one bit shorter than a data word that requires some type of parity information.
:p.
Line characteristic settings cause the data word to have different bit lengths.  As all
data words have a start bit, line characteristics of eight data bits, one stop bit, and
no parity bit will cause a data word of ten bits to be transmitted.
:p.
Only the first stop bit is tested when a data word is received.
.*
.**********************************
.* FILTERS
.**********************************
:h2 id=HLPC_FILTERS.Receive Stream Filters
:i2 refid=HLPC_CONCEPTS.Receive Stream Filters
:p.
There are three types of stream filters available&colon.
:ol compact.
:li.Error character replacement
:li.Break character replacement
:li.NULL character stripping
:eol.
:p.
If :hp2.Error Character Replacement:ehp2. is enabled a user specified character
will be placed in the receive buffer whenever a receive error is detected, instead
of a possibly bad received character.  The default error replacement character is the NULL character (zero).
:p.
Errors that can cause the replacment character to be inserted are&colon.
:ol.
:li.Receive hardware overrun
:p.
This will happen when a new character is received at the hardware before a previously
recieved character has been removed by the device driver.
:p.This is usually a result of too high a baud rate.  Using a serial adapter with 16550 UARTs
will usually prevent this error.
:li.Parity errors
:p.
This error can be caused by mismatched line characteristics or noisy data lines.
:li.Framing errors
:p.
This error is usually caused when baud rates are not the same between this hardware
(near-end) and the hardware you are attempting to communicate with (far-end).
:li.Receive buffer overrun
:p.
This error is caused when an application does not "read" from the device driver as fast
as the data is received.
:p.
This error can be prevented by using some form of "handshaking".
:eol.
:p.
If :hp2.Break Character Replacement:ehp2. is enabled a user specified character is placed into
the receive buffer when a "break" condition is first detected at the UART.
:p.
Once the break character has been inserted in the buffer no new characters will be placed in the buffer
until the "break" condition is no longer being received.
:p.
If :hp2.NULL Stripping:ehp2. is enabled characters received that have a value
of zero will not be placed in the receive buffer.
.*
.**********************************
.* APO
.**********************************
:h2 id=HLPC_APO.Automatic Protocol Override
:i2 refid=HLPC_CONCEPTS.Automatic Protocol Override
:p.
Normally you would want to enable hardware buffers to reduce system overhead.
When handshaking is required between this hardware (near-end) and some external
hardware (far-end), it may be required that a far-end's request to stop
transmitting be acted upon immediately.
:p.
If hardware buffers are enabled it would be possible for that hardware to
transmit up to 20 characters after the device driver receives a "stop
transmitting" signal.  This is because once the device driver has filled the
hardware buffer, transmission will continue until the buffer is empty.  This may
cause a problem for some far-end equipment.
:p.
This problem can occur when any output handshaking is enabled.  This includes 
CTS, DSR, and/or DCD output handshaking and transmit Xon/Xoff handshaking.  The 
CTS, DSR, and DCD signals are "hardware" flow control signals and transmit 
Xon/Xoff handshaking is "software" flow control signaling.  
:p.
There are two output handshaking scenarios to consider.  The first is the 
hardware signaling case.  When the far-end's receive buffer is full (or nearly 
full) it may signal to the near-end by making one or more of the hardware
signals inactive.  When the near-end detects an inactive signal it should stop
transmitting.  If the transmit buffer is enabled at the near-end it could 
transmit up to 16 characters before it becomes aware of the signal to stop.  
:p.
The second case is software signaling.  When the far-end's receive buffer is 
full (or nearly full) it may signal the near-end by transmitting an Xoff 
character.  When the near-end receives the Xoff character it should stop
transmitting.  If, at the near-end, the receive buffer is enabled, it will not 
detect the request to stop transmitting until it has read the Xoff character 
from the receive buffer, and if the transmit buffer is enabled it may transmit
up to 16 bytes before it stops transmitting.  
:p.
When hardware buffers are enabled receive interrupts can be caused by two 
events.  The first is when the number of characters in the FIFO reaches the 
programmed threshold, either one, four, eight, or fourteen characters.  The 
second is when at least one character has been received and placed in the FIFO 
and then no new characters are received for four character times.  This second 
type of receive interrupt would make it possible for an Xoff character to be
received by the hardware and not be read by the device driver for up to four 
character-times after the character was received.  
:p.
The worst case would be for the Xoff character to arrive at the near-end 
hardware just as there are four characters left in the transmit buffer to be 
transmitted.  
:p.
The device would cause a transmit interrupt just as the last of the four
characters is transmitted and the device driver would refill the transmit
buffer, then the device would cause a receive FIFO time-out interrupt and the 
device driver would read, and detect, the Xoff character, preventing further
transmissions.  This case could allowup to 20 characters to be transmitted after
the far-end transmitted the Xoff character.  
:p.
All of these potential problems go away if the transmit buffer is disabled when 
any output handshaking is enabled and/or the receive buffer is disabled when 
transmit Xon/Xoff handshaking is enabled.  
:p.
When Automatic Protocol Override (APO) is enabled the device driver adjusts 
hardware buffer functionality according to handshaking requirements.  When APO is
enabled and an application requests CTS, DSR, or DCD output handshaking, the
device driver will disable the transmit buffer.  When APO is enabled and an
application requests transmitXon/Xoff handshaking the device driver will disable 
both the transmit and receive buffers.
:p.
There is one other adjustment APO can cause the device driver to make to the
hardwarebuffer functionality of a device.  When DSR input sensitivity is 
enabled, and APOis enabled, the receive buffer will be disabled by the device 
driver.  
:p.
DSR input sensitivity is designed to handle devices that may transmit garbage 
whenever DSR is in the inactive state.  In this case it would be necessary to 
ignore any characters received while DSR is inactive.  It may be possible for 
the far-end to transmit a character at the same time it activates DSR.  This
could cause the near-end to miss a valid character if its receive buffer is
enabled.
:p.
What does all this mean to you?  Probably nothing.  There are not many far-end
devices around these days that do not have some level of buffering capabilities.
We recommend that you leave APO off unless, and until, you determine that you
are communicating with some archaic equipment that requires it.
:p.
Related Information&colon.
:ul compact.
:li.:link refid=HLPC_HANDSHAKE reftype=hd.Communications Handshaking:elink.
:eul.
.*
.**********************************
.* Handshaking
.*
:h2 id=HLPC_HANDSHAKE.Communications Handshaking
:i2 refid=HLPC_CONCEPTS.Communications Handshaking
:p.
In any system it is important that all real-time activities, like serial
communications, be truly asynchronous.  Basically this means that no information
should be lost because the operating system was busy doing something else.  In
operating systems like DOS, or DOS and Windows:link refid=microsoft
reftype=fn.**:elink., there is never any guarantee the operating system will be
able to get to a real-time process in a timely manner.  Each process in these
systems owns the machine until it relinquishes control.  If a real-time process
needs service it has to wait until any current processes are finished.
:p.
In OS/2:link refid=ibm reftype=fn.*:elink. this is not normally a problem.  Its
structure is such that hardware interrupts have the highest priority and are 
serviced "almost immediately", and other processes are given a time-slice in 
which to execute.  
:p.
Problems can occur in two ways.  The first is when hardware interrupts come in 
faster than the operating system can respond.  For asynchronous serial 
communications this problem is addressed mostly by serial devices with hardware 
buffers (FIFOs).  
:p.
The second problem is that a process may not be able to read and process 
incoming information as fast as the hardware and device driver can receive and 
store information.  This problem is addressed by the handshaking features of the
serial device driver.  
:p.
When handshaking is enabled the receiving system (device driver) will signal the
transmitting system to stop transmitting when its receive buffer nears full
capacity.  The transmitting system should stop transmitting when it receives a
signal to stop.
:p.
In OS/2 a serial device driver must be capable of handshaking without
intervention or control by the controlling higher level process.  All a
controlling process needs to do is command the device driver into a handshaking
mode and the device driver must do all of the processing to be sure that the
controlling process does not lose any information.
:p.
This includes detecting when its own receive buffer is nearly full so it can
send a stop transmitting signal and then detecting when its receive buffer has
been emptied enough so that is can send a start transmitting signal.  It also
includes detecting when the device it is transmitting to has sent a stop
transmitting or start transmitting signal and act accordingly.
.*
.**********************************
.* Serial Device Baud Rate
.*
:h2 id=HLPC_BAUDRATE.Serial Device Baud Rate
:i2 refid=HLPC_CONCEPTS.Serial Device Baud Rate
:p.
Baud rate for a serial device is defined as the number of bits per second that
are transmitted and/or received over a transmission line.  A baud rate of 9600
means that 9,600 bits are communicated each second.  Another common way to
express baud rate is with the units "BPS" for Bits Per Second (i.e., 9600 BPS).
:p.
The actual number of characters communicated can be calculated by adding the
number of bits in a character to the number of stop bits specified, adding one
for the start bit, and adding one if a parity bit is required.
:p.
For example an eight bit character using no parity and one stop bit would
require ten bit times to transmit one character of information.  In this case a
baud rate of 9600 would communicate about 960 characters a second.  A seven bit
character with even parity and one stop bit would also require ten bit times to
transmit a single character.
:p.
Using COMscope you can set the baud rate for a monitored device.  Setting the
baud rate for a device will force a change to the new baud rate, preempting any
baud rate set by any application accessing that device.  Any application can
reset another baud rate at any time.
:p.
To set the baud rate for a monitored device&colon.
:ol compact.
:li.Select :hp2.Device:ehp2.
:li.Select :hp2.Protocol:ehp2.
:li.Select :hp2.Baud Rate:ehp2.
:lp.If you enter an invalid baud rate the baud rate will not be changed.
:eol.
.*
.**********************************
.* FIFO Processing
.*
:h2 id=HLPC_FIFOCTL.Serial Device FIFO Processing:
:i2 refid=HLP_CONCEPTS.16550 UART FIFO Processing
:p.
When the device being controlled by the COMi device driver is a 16550 UART, or
equivalent, COMscope can be used to set the various FIFO processing modes of
that device.  If the device does not have FIFOs the :hp2.FIFO Control...:ehp2.
menu item will be disabled.
:p.
COMi has three major FIFO modes&colon.
:ol compact.
:li.FIFOs disabled
:li.FIFOs enabled
:li.Automatic Protocol Override (APO)
:eol.
:p.
When FIFOs are enabled, this includes APO, the depth of the buffers is selectable.
:p.
For the receive FIFO the following thresholds can be selected&colon.
:ol compact.
:li.One character
:li.Four characters
:li.Eight characters
:li.Fourteen characters
:eol.
:p.
Either one character or sixteen characters can be buffered for transmission.
:p.
Related Information&colon.
:ul compact.
:li.:link refid=HLPC_APO reftype=hd.Automatic Protocol Override:elink.
:eul.

