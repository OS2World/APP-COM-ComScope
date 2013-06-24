.*--------------------------------------------------------------------------*/
.*    Module Name: QPAGE2.IPF                                               */
.*                                                                          */
.*    Description: On-line documentation for QuickPage/2 product.           */
.*                                                                          */
.*         Author: Francisco J. O'Meany                                     */
.*                                                                          */
.*           Date: Jul 15, 1995                                             */
.*                                                                          */
.*      Copyright: OS/tools Incorporated 1995                               */
.*                                                                          */
.*                                                                          */
.*--------------------------------------------------------------------------*/
:userdoc.
:title.QuickPage/2 - Online Reference
:docprof toc=123456.
:ctrldef.
:ctrl ctrlid=QPageHelp controls='Contents Index Print Search Esc' coverpage.
:ectrldef.
.*--------------------------------------------------------------------------*/
.*        Help Item: QuickPage Product Information                          */
.*    Resource Name: PANEL_PRODUCT_INFO                                     */
.*  Resource Number: 5110                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=PRODUCT_INFO x=center y=center width=100% height=100% scroll=vertical
res=5110 name=PANEL_PRODUCT_INFO.QuickPage Product Information
:i1 id=PRODUCT_INFO.QuickPage Product Information
:p.QuickPage is a wireless communicator software package used to send
alphanumeric messages to a pager using standard telephone lines and Hayes
standard modems.
:p.
These messages are sent to paging services supporting the standard Telocator
Alphanumeric Protocol :hp2.(TAP):ehp2. anywhere in the United States.
:p.
Messages are sent to the paging service through your standard telephone line
and modem.  Then the messaging service sends your messages via satellite
transmission in a satellite uplink.  The information is then sent from the
satellite to a satellite downlink station which sends the message to a 
ground-based transmitter.  This transmitter then uses radio frequency to
send the message to a wireless device (an alphanumeric or digital pager).


.*--------------------------------------------------------------------------*/
.*        Help Item: Command Parameters                                     */
.*    Resource Name: PANEL_INSTALLATION                                     */
.*  Resource Number: 5111                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=INSTALLING x=center y=center width=100% height=100%
  scroll=vertical res=5111
  name=PANEL_INSTALLATION.QuickPage Installation
 :i1 id=INSTALLING.QuickPage Installation

:p.Installation info








.*--------------------------------------------------------------------------*/
.*        Help Item: Command Parameters                                     */
.*    Resource Name: PANEL_PARAMETERS                                       */
.*  Resource Number: 5115                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=COMMAND_PARMS x=center y=center width=100% height=100%
  scroll=vertical res=5115
  name=PANEL_PARAMETERS.Command Parameters
:i1 id=COMMAND_PARMS.Command Parameters


:h2 res=016 scroll=none clear.
List of Valid Parameters
 :link reftype=hd res=001 auto split group=10
       vpx=left vpy=top vpcx=25% vpcy=100%
       rules=border scroll=vertical.
 :link reftype=hd res=003 auto split group=11
       vpx=right vpy=top vpcx=75% vpcy=100%
       rules=border scroll=vertical.



:h2 res=001 hide nosearch noprint.Parameters List
 :p.
 Command parameters can be passed when QuickPage
 gets executed.
 :p.
 The valid parameters are:
 :sl compact.
 :li.:link reftype=hd res=003 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 /?:elink.
 :li.:link reftype=hd res=003 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 /HELP:elink.
 :li.:link reftype=hd res=004 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 /CFG&colon.configfile:elink.
 :li.:link reftype=hd res=005 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 /LOG&colon.LogFile:elink.
 :esl.




:h2 res=003 hide name=PANEL_PARM_HELP.Getting Help
:p.
 This parameter displays a list of valid
 QuickPage commands.

:h2 res=004 hide name=PANEL_PARM_CONF.Specify a Configuration File Name
:p.
 This parameter accepts a QuickPage configuration
 filename.


:h2 res=005 hide name=PANEL_PARM_LOG.Specify a Log File Name
:p.
This parameter accepts a QuickPage LogFile name.



.*--------------------------------------------------------------------------*/
.*        Help Item: Configuration File                                     */
.*    Resource Name: PANEL_CONFIG_FILE                                      */
.*  Resource Number: 5116                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=CONFIG_FILE x=center y=center width=100% height=100%
  scroll=vertical res=5116
  name=PANEL_CONFIG_FILE.QuickPage Configuration File
:i1 id=CONFIG_FILE.QuickPage Configuration File
:P.A QuickPage configuration file contains information that defines your
QuickPage environment and is used according to your needs and preferences.
When the 
:link reftype=hd res=004 split group=11
      vpx=center vpy=top vpcx=75% vpcy=100%
      rules=border scroll=vertical.
/CFG&colon.:elink.
is specifed in your commandline, the information is used
to send an alphanumeric message.
:p.A Model configuration file PAGERDEF.CFG is included with this product to
be used as a sample for your own configuration and feel free to make
as many configuration files as you need.
:p.This file contains the following lines&colon.

:p.
:lines align=left.
;-----------------------------------------------------------------------------;
;                                                                             ;
; QuickPage Model Configuration file.                                         ;
;                                                                             ;
; Use this file as a guide to your own configuration options.                 ;
;                                                                             ;
; Copyright (c) OS/tools Incorporated 1995.                                   ;
;-----------------------------------------------------------------------------;

;-----------------------------------------------------------------------------;
; Global settings configuration. . This default applies to any Hayes Smart-   ;
; modem compatible modem. The default communications port (ComPort) is COM1.  ;
; Use the COM port available to your system or override this global setting   ;
; by passing /COM&colon.n parameter from the command line.                          ;
;-----------------------------------------------------------------------------;
[GlobalSettings]
ComPort     = 1
SinglePage  = Y
GroupName   = ALL
SenderID    = OME
DialPrefix  = 9,1
StampID     = N
StampTime   = N
StampGroup  = N
PageRetries = 3
LogFile     = qpage.log


;-----------------------------------------------------------------------------;
; Modem name and setting commands. This default applies to any Hayes Smart-   ;
; modem compatible modem.                                                     ;
;-----------------------------------------------------------------------------;
[Modem]
Name=Hayes Standard
Setup=AT&amp.F
Reset=ATZ
Escape=+++
Disconnect=ATH
Busy=BUSY
DialTone=NO DIAL
Carrier=NO CARRIER
Answer=NO ANSWER
Speaker=On
SpeakerVolume = 3


;-----------------------------------------------------------------------------;
; Messaging service default parameters.                                       ;
;-----------------------------------------------------------------------------;
[Service]
Name=SkyTel
PrimaryNumber=800-759-6366
SecondaryNumber=800-759-6366
BaudRate=9600
WordLength=7
Parity=E
StopBits=1
MaxMessages=10
MaxBlockChars=40


;-----------------------------------------------------------------------------;
; Up to 234 text characters when a message text is sent without Sender's ID,  ;
; StampTime condition, and without group name.                                ;
;                                                                             ;
; When Sender ID is specified and StampID is equal to 'Y':                    ;
;    Substract 11 characters.                                                 ;
; When StampTime is equal to 'Y':                                             ;
;    Substract 08 characters.                                                 ;
; When group name is specified and StampGroup is equal to 'Y':                ;
;    Substract 19 characters.                                                 ;
;                                                                             ;
;-----------------------------------------------------------------------------;
[Message]
Text=This is a test message.

;-----------------------------------------------------------------------------;
; Add up to 128 Pager IDs in a single call. (When supported by paging service);
;-----------------------------------------------------------------------------;
[Subscribers]
Pager1=2136669
Pager2=
Pager3=
Pager4=
Pager5=
Pager6=
Pager7=
Pager8=
Pager9=
Pager10=
Pager11=
Pager12=
Pager13=
Pager14=
Pager15=
Pager16=
Pager17=
Pager18=
Pager19=
Pager20=
Pager21=
Pager22=
Pager23=
Pager24=
Pager25=
Pager26=
Pager27=
Pager28=
Pager29=
Pager30=
Pager31=
Pager32=
Pager33=
Pager34=
Pager35=
Pager36=
Pager37=
Pager38=
Pager39=
Pager40=
Pager41=
Pager42=
Pager43=
Pager44=
Pager45=
Pager46=
Pager47=
Pager48=
Pager49=
Pager50=
Pager51=
Pager52=
Pager53=
Pager54=
Pager55=
Pager56=
Pager57=
Pager58=
Pager59=
Pager60=
Pager61=
Pager62=
Pager63=
Pager64=
Pager65=
Pager66=
Pager67=
Pager68=
Pager69=
Pager70=
Pager71=
Pager72=
Pager73=
Pager74=
Pager75=
Pager76=
Pager77=
Pager78=
Pager79=
Pager80=
Pager81=
Pager82=
Pager83=
Pager84=
Pager85=
Pager86=
Pager87=
Pager88=
Pager89=
Pager90=
Pager91=
Pager92=
Pager93=
Pager94=
Pager95=
Pager96=
Pager97=
Pager98=
Pager99=
Pager100=
Pager101=
Pager102=
Pager103=
Pager104=
Pager105=
Pager106=
Pager107=
Pager108=
Pager109=
Pager110=
Pager111=
Pager112=
Pager113=
Pager114=
Pager115=
Pager116=
Pager117=
Pager118=
Pager119=
Pager120=
Pager121=
Pager122=
Pager123=
Pager124=
Pager125=
Pager126=
Pager127=
Pager128=

:elines.




.*--------------------------------------------------------------------------*/
.*        Help Item: Configuration File Format                              */
.*    Resource Name: PANEL_CONFIG_FILE_FORMAT                               */
.*  Resource Number: 5117                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=CFG_FILE_FORMAT x=center y=center width=100% height=100%
  scroll=vertical res=5117
  name=PANEL_CONFIG_FILE_FORMAT.Configuration File Format
:p.
The QuickPage configuration file is broken into logical sections.  Each
section has the following format&colon.

:p.
:lines align=left.
:link reftype=hd res=100 split group=11
      vpx=center vpy=top vpcx=75% vpcy=100%
      rules=border scroll=vertical.
[section]:elink.
keyname=value
:elines.


.*--------------------------------------------------------------------------*/
.*        Help Item: Changing Configuration File                            */
.*    Resource Name: PANEL_CONFIG_FILE_CHANGE                               */
.*  Resource Number: 5118                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=CFG_FILE_CHANGE x=center y=center width=100% height=100%
  scroll=vertical res=5118
  name=PANEL_CONFIG_FILE_CHANGE.Changing Configuration File
:p.
QuickPage creates a standard configuration file during installation and
assigns default values.  Some entries are added or changed when you select
them from the default configuration file dialog box.  You can change this
values or create other configuration files using an ASCII editor (i.e. EPM).

:warning text='Important'.
Always back up your configuration files before you make modifications to
them.  Incorrect changes can lead to unexpected results when you run
QuickPage.  Also some editors can use extended ASCII characters and
damage your configuration.  We recommend to use the standard OS/2 editor
EPM.




.*--------------------------------------------------------------------------*/
.* Configuration file format section.                                       */
.*--------------------------------------------------------------------------*/
:h2 res=100 hide name=CONFIG_FILE_SECTION.Configuration File Sections
:p.
The name of a section in a configuration file must be enclosed in brackets
:hp2.[].:ehp2.  The following are the valid section names&colon.

:ul.
:li.
:link reftype=hd res=101 split group=11
      vpx=center vpy=top vpcx=75% vpcy=100%
      rules=border scroll=vertical.
[GlobalSettings]:elink.
:ul compact.
:li.ComPort
:li.SinglePage
:li.GroupName
:li.SenderID
:li.DialPrefix
:li.StampID
:li.StampTime
:li.StampGroup
:li.PageRetries
:li.LogFile
:eul.
:li.Modem.
:ul compact.
:li.Name
:li.Setup
:li.Reset
:li.Escape
:li.Disconnect
:li.Busy
:li.DialTone
:li.Carrier
:li.Answer
:li.Speaker
:li.SpeakerVolume
:eul.
:li.Service.
:ul compact.
:li.Name
:li.PrimaryNumber
:li.SecondaryNumber
:li.BaudRate
:li.WordLength
:li.Parity
:li.StopBits
:li.MaxMessages
:li.MaxBlockChars
:eul.
:li.Message.
:ul compact.
:li.Text
:eul.
:li.Subscribers.
:ul compact.
:li.Pager1
:li.Pager2
:li.Pager3
:li.Pager4
:li.up to 128
:eul.
:eul.








.*--------------------------------------------------------------------------*/
.* GlobalSettings section.                                                  */
.*--------------------------------------------------------------------------*/
:h2 res=101 hide name=CONFIG_FILE_GLOBAL.[GlobalSettings] Section
:p.
This section contains entries for the QuickPage global settings.  The
following entries are supported&colon.
:p.
:hp2.ComPort:ehp2.
:p.
This entry specifies the communications port you are using when sending
an alphanumeric message.  The possible range is 1 to 32.  The default is 1.
:p.
:hp2.SinglePage:ehp2.
:p.
This entry is set to :hp2.Y:ehp2. when you are sending a single page or
set to :hp2.N:ehp2. when multiple pages (Group Page) are being sent.  The
possible values are Y or N.  The default is Y.
:p.
:hp2.GroupName:ehp2.
:p.
This entry specifies the name of a group name when you send a group message
and want this name to be printed at the end of the message.  The maximun
number of characters for a group name is :hp2.16:ehp2.  The name specified
in this entry will only be printed when the :hp2.StampGroup:ehp2.
entry on this section is set to :hp2.Y:ehp2.
:p.
:hp2.SenderID:ehp2.
:p.
This entry specifies the sender identification used when you send a message
and want this ID to be printed at the end of the message.  The maximun
number of characters for an ID is :hp2.8:ehp2.
:p.
:hp2.DialPrefix:ehp2.
:p.
This entry specifies the prefix used when dialing a Paging Service phone
number.  The maximum number of characters is :hp2.5.:ehp2.  The default
value is :hp2.1.:ehp2.  This dial prefix is placed in front of the phone
number you select on the :hp2.PrimaryNumber:ehp2. or the
:hp2.SecondaryNumber:ehp2. entries on the :hp2.[Service]:ehp2. section
before a dial connection is made by QuickPage.
:p.
:hp2.StampID:ehp2.
:p.
This entry is set to :hp2.Y:ehp2. when you want the sender ID to be
stamped at the end of the page message.  This is ID is taken from the
:hp2.SenderID:ehp2. entry on this section.  The possible values are
Y or N.  The default is :hp2.Y.:ehp2.  This ID is presented within
:hp2.<>:ehp2.
:p.
:hp2.StampTime:ehp2.
:p.
This entry is set to :hp2.Y:ehp2. when you want the current time
being stamped at the end of the page message.  The time is taken from
your computer's clock and is sent in a :hp2.HH&colon.MM:ehp2. format
and within :hp2.<>.:ehp2.  The possible values are Y or N.  The default is
:hp2.Y.:ehp2.
:p.
If :hp2.StampID:ehp2. and :hp2.StampTime:ehp2. entries are set to 
:hp2.Y:ehp2. specifying :hp2.JOHN:ehp2. as the :hp2.SenderID:ehp2. entry,
and the time send in your computer is :hp2.10&colon.30:ehp2., your message
will look like this at the end&colon.
:p.
:hp2.<JOHN-10&colon.30>:ehp2.
:p.
:hp2.StampGroup:ehp2.
:p.
This entry is set to :hp2.Y:ehp2. when you want a group name to be
displayed at the end of the page message.  The possible values are Y or N.
The default is :hp2.N.:ehp2.
:p.
:hp2.PageRetries:ehp2.
:p.
This entry is used to specify the number of retries you want QuickPage to
make before it returs with an ending message.  The possible values are 3
to 65535.
:p.
:hp2.LogFile:ehp2.
:p.
This entry specifies the name of a file to be used by QuickPage to write
log information.  This name must be a valid OS/2 text file name.









.*--------------------------------------------------------------------------*/
.*        Help Item: Accessing Paging Services                              */
.*    Resource Name: PANEL_ACCESS_SERVICE                                   */
.*  Resource Number: 5120                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=SERVICE_ACCESS x=center y=center width=100% height=100%
  scroll=vertical res=5120
  name=PANEL_ACCESS_SERVICE.Accessing Paging Services
:i1 id=SERVICE_ACCESS.Accessing Paging Services
:p.Paging Services access info





:euserdoc.
