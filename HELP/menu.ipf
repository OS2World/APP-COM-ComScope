.*
.*************************************************
.*
:h1 id=HLP_MAINMENU.Help for Menus
:i1 id=main_menu.Help for COMscope Menus
:p.
Various COMscope modes and functions are selected by using the menu bar.
:p.
The Following headings are available&colon.
:ul compact.
:li.:link refid=HLPP_FILE reftype=hd.File:elink.
:li.:link refid=HLPP_ACTION reftype=hd.Action:elink.
:li.:link refid=HLPP_OPTIONS reftype=hd.Options:elink.
:li.:link refid=HLPP_DEVICE reftype=hd.Device:elink.
:li.Help
:eul.
.*
.*************************************************
.*
:h2 res=50100 name=HLPP_FILE.Help for File
:i2 refid=main_menu.Help for File Menu
:p.
Use :hp2.File:ehp2. to load or save a previously captured :link refid=dat_stream reftype=fn.I/O data stream:elink.
or to exit COMscope.
:p.
The possible selections are&colon.
:dl compact break=all.
:dt.:hp2.Load Data:ehp2.
:dd.Load a previously saved I/O data stream capture buffer.
:dt.:hp2.Save Data:ehp2.
:dd.Save the current contents of an I/O data stream capture buffer.
:dt.:hp2.Save Data As:ehp2.
:dd.Save the current contents of an I/O data stream capture buffer under a new file name.
:dt.:hp2.Exit:ehp2.
:dd.Close this instance of COMscope and return to the OS/2 Desktop.
:edl.
.*
.*******************************************************************************
.* File | Load
.*:h3 res=50101 name=HLPP_FILE_LOAD.Help for Load
.*:i2 refid=HLPP_FILE.Help for Load
.*:p.
.*test
.*
.*************************************************
.*
:h2 res=50200 name=HLPP_ACTION.Help for Action
:i2 refid=main_menu.Help For Action Menu
:p.
Use :hp2.Action:ehp2. to select various :link refid=dat_stream reftype=fn.I/O data stream:elink. processing options
for the current :link refid=active_dev reftype=fn.active device:elink..
:p.
The possible selections are&colon.
:dl compact break=all.
:dt.:hp2.Capture Data Stream:ehp2.
:dd.Enables I/O data stream. capturing for the currently active device.
:dt.:hp2.Display Data Stream:ehp2.
:dd.Enables "real-time" display of the currently active device's data stream.
:dt.:hp2.Examine Data:ehp2.
:dd.Enables display and scrolling of the current contents of the I/O data stream capture buffer.
:dt.:hp2.Surface Sessions:ehp2.
:dd.Enables user to cause all child windows, either of this COMscope session, or all COMscope sessions,
to be brought to the top on the desktop.
:edl.
:p.

A :link refid=checkmark reftype=fn.check mark:elink. appears next to an item
that is "toggled" to the active state.
.*
.*************************************************
.*
:h2 res=50400 name=HLPP_DEVICE.Help for Device
:i2 refid=main_menu.Help For Device Menu
:p.
Use :hp2.Device:ehp2. to select, configure, and control a COM port.
:p.
The possible selections are&colon.
:dl compact break=all.
:dt.:hp2.Select Device:ehp2.
:dd.Select COM port to "activate" for monitoring and control.
:dt.:hp2.Install Device:ehp2.
:dd.Install or edit COM port initialization parameters.
:dt.:hp2.Status:ehp2.
:dd.Monitor various "active" device and device driver states.
:dt.:hp2.Control:ehp2.
:dd.Control various "active" device and device driver functions and affect various states
of the device and device driver.
:dt.:hp2.Protocol:ehp2.
:dd.Set "active" COM port online parameters (i.e., line characteristics, baud rate, etc).
:edl.
.*
.*******************************************************************************
.*
:h2 res=50300 name=HLPP_OPTIONS.Help for Options
:i2 refid=main_menu.Help For Options Menu
:p.
Use :hp2.Options:ehp2. to select or toggle various device monitoring options.
:p.
The Options are&colon.
:dl compact tsize=4 break=all.
:dt.:hp2.Capture Buffer Setup...:ehp2.
:dd.Allows you to define I/O data stream capture buffer size and processing.
:dt.:hp2.Capture Update Frequency...:ehp2.
:dd.Allows the user to specify how often COMscope reads the device driver's COMscope trace buffer.
:lp.Normally the amount of time between COMscope reads of the trace buffer is calculated by COMscope and is based
on the baud rate and the size of the COMscope buffer defined within the device driver.  The value calculated is
conservative, in that it is assumed that data will be streamed continously in both the transmit and receive
directions.
:lp.The user may be better able to judge the maximun throughput required and, therefore, be able to
select a more efficient time-out value.  In any case, if the user enables the :hp2.Display Data Stream:ehp2.
mode, the time-out will be adjusted to a maximum of 200 milliseconds.
:lp.
:dt.:hp2.Stream Display Format:ehp2.
:dd.Allows the user to switch the display between the lexical and time-relational formats.  The user can also press the
:hp2.F8:ehp2. function key to "toggle" display formats.
:dt.:hp2.Sticky Pop-up Menus:ehp2.
:dd.Allows the user to set the response attributes of all pop-up menus to:
:ol.
:li.Cause the pop-up menu to stay where it appeared when first invoked, until the user has either&colon.
:ol compact.
:li.Selected an item
:li.Clicked mouse button one somewhere other than on the menu
:li.Pressed the ESCAPE key
:eol.
:lp.
:li.Cause the pop-up menu to stay up only as long as the user holds down the mouse button
that was used to invoke the menu (mouse button two).
:nt.If this attribute is selected the user can cancel without selecting an item in the
menu by moving the pointer off the menu and releasing the mouse button.
:ent.
:eol.
:dt.:hp2.Manage Profile...:ehp2.
:dd.Opens COMscope profile management dialog.
:edl.
:p.
A :link refid=checkmark reftype=fn.check mark:elink. appears next to those items
that are "toggled" to the active state.
.*
.*******************************************************************************
.*
:h3 res=50401 name=HLPP_DEVICE_SELECT.Help for Select Device
:i2 refid=main_menu.Help For Select Device
:p.
Use the :hp2.Select Device:ehp2. menu item to bring up the COMscope device selection dialog.
:p.
The COMscope device selection dialog presents a drop down list of currently available
COMscope devices.  Only one COMscope session may access any single serial device.
.*******************************************************************************
.*   Editing COM ports
.*******************************************************************************
:h1 id=HLPI_EDIT_PORTS.Editing Serial Device Startup Parameters
:i1 id=HLPI_EDIT.Editing Serial Device Startup Parameters
:p.
To edit serial device's configuration&colon.
:ol compact.
:li.Select :hp2.Device:ehp2.
:li.Select :hp2.Install Device:ehp2.
:li.Select a device to edit.
:eol.
:p.
Various COMi device driver startup parameters can be changed from the defaults selected
by OS/tools.
:p.
The parameters that can be changed are&colon.
:ol compact.
:li.Initial baud rate
:li.Initial line characteristics
:li.Initial time-out processing
:li.Initial handshake processing
:li.Initial FIFO setup
:li.Transmit, receive, and COMscope buffer sizes
:li.Various extensions
:eol.
:p.
The parameters noted as "initial" settings can be changed at runtime by any application.  Some
of these parameters will be returned the inital value whenever a first level DosOpen is processed
for a device.
.*
.*******************************************************************************
.*   Installing COM ports
.*******************************************************************************
:h1 id=HLPI_INST_PORTS.Installing Serial Devices
:i1 id=HLPI_INSTALL.Installing Serial Devices
:p.
To install or configure a serial device&colon.
:ol compact.
:li.Select :hp2.Device:ehp2.
:li.Select :hp2.Install Device:ehp2.
:eol.
:p.
To install a device you must select at least an :link refid=address reftype=fn.I/O base address:elink.,
an :link refid=int_level reftype=fn.interrupt level:elink., and a DOS (COMx) device name.
:p.
Related Information&colon.
:p.
:link refid=HLPI_INST_ISA_PORTS reftype=hd.Installing ISA Serial Devices:elink.
.*


