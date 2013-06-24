COMscope Communications Monitoring and Control
COMscope version 4.0
Date: 2005/Sep/05
-----------------


Introduction
------------

COMi asynchronous serial device driver versions 3.83 and 4.0
COMscope Description:

COMscope is a Presentation Manager program that allows monitoring and control of OS/2 COM devices, without interfering with any application accessing any device being monitored. COMscope can take the place of a stand alone protocol analyzer to aid in troubleshooting communications sessions and to help debug communications applications.

COMscope takes advantage of extensions to the COMi device driver to allow a user to have complete control of communications devices and processes on their OS/2 machines.

Now released as Open Source under the GNU GPL License.
The OS/tools source code is now under the GNU GPL License. The Borland and IBM code keeps their own license.

Thanks to the comscope author, Emmett Culley, for turning it open source and giving it to the OS/2 open community.



COMscope Device Monitoring and Display Capabilities
---------------------------------------------------

    * Captures/traces the serial stream as written to, and received by any communications application accessing the port. There are two display modes: Lexical and Time-relational.
    * Displays device driver transmit and receive buffer utilization by displaying the number of characters currently in a buffer, and the ratio of content to size (in percent) for both the transmit and receive buffers, and the "high water" mark for the receive buffer.
    * Displays all modem input signal states; CTS, DTR, CD, and RI.
    * Displays modem output signal states; RTS and DTR, as set by an application, the COMi device driver, and/or COMscope.
    * Displays the "COM Event" word, as seen by an application. The "COM Event" word is normally cleared whenever an application reads its contents. COMscope gives you the choice of either clearing the device driver variable or leaving it for an application to read and clear.
    * Displays the "COM Error" word, as seen by an application. As with the "COM Event" word, the user can choose to clear, or not clear, this device driver variable, as a query by an application would.
    * Displays the "COM status" byte, as seen by an application.
    * Displays the "Transmit Status" byte, as seen by an application.
    * Displays the current device and device driver setup, as selected by an application accessing a device, or by COMscope.
    * Displays the current configuration and start-up defaults for all devices controlled by COMi.
    * Displays, with a click of the mouse, information for all events and application call packets to the device driver, including:
          o Modem signal states
          o DosDevIOCtl function calls
          o DosRead and DosWrite request byte counts
          o DosRead and DosWrite actual bytes read/written counts upon return to application
    * Displays the counts of characters received and transmits and displays the characters per second (CPS) rate of each stream.


COMscope Device Control Capabilities
------------------------------------

    * Sets all device driver parameters an application is able to set; including baud rate, line characteristics, read/write time-out processing, handshaking, stream filters, and FIFO function.
    * Can cause the receive and/or transmit device driver buffers to be flushed.
    * Is able to place the UART into the break state, and return it to normal.
    * Can force the defined Xoff or Xon characters to be transmitted on command.
    * Is able to force the device driver to act like an Xoff, or Xon, has been received.
    * Will transmit any keystroke, or bit pattern as requested.
    * Controls all of the UART's output signals; including DSR, RTS, OUT1, and LOOP.
    * Allows run-time control of the hardware handshaking modes of 16650, 16654, 16550C, and 16750 UARTs.
    * COMscope can be used to install and configure any COMi device.

COMscope requires OS/2 2.0 or later. 



Development Eviroment
----------------------

configuration as I remember
Move the DIST directory to W:\ 
install VisualAge CPP in F:\ibmcpp (including two system restarts)
comment out the libpath entries for F:\ibmcpp in the config.sys file then restart your system
copy the contents of the ibmcpp directory (from the archive you downloaded) to the F:\ibmcpp directory.
uncomment the libpath entries for f:\ibmcpp and restart your machine.
move all other directories to the P:\ dirrectory.
Now you can run the make.cmd files found in each directory.
There is a build all command file somewhere (probal in DIST.
You can alter whee you place the file but you will need to change the build files.
COMscope requires about six DLLs, IOCtl, OS2RTLS, Utility, Profile, Config, COMcontrol
COMi is all contained in the COMi directory.  You only need to build the base version.  The other verisons are for specific OEMs.  The base version is the version I sold to everyone but the OEMs and is able to access all adapters.
Build COMi separately, then build COMscope.
I also included WinCOM32.  THis is a VIO program that I wrote to test the driver and COMscope.

Have fum :-)


Emmett
email: emmett@relationships123.com
URL: http://www.os-tools.com/os2/index.html