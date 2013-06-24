.*--------------------------------------------------------------------------*/
.*    Module Name: QPINSTAL.IPF                                             */
.*                                                                          */
.*    Description: On-line documentation for QuickPage/2 installation.      */
.*                                                                          */
.*         Author: Francisco J. O'Meany                                     */
.*                                                                          */
.*           Date: Aug 10, 1995                                             */
.*                                                                          */
.*      Copyright: OS/tools Incorporated 1995                               */
.*                                                                          */
.*                                                                          */
.*--------------------------------------------------------------------------*/
:userdoc.
:title.QuickPage Installation - Online Reference
:docprof toc=123456.
:ctrldef.
:ctrl ctrlid=QPageHelp controls='Contents Index Print Search Esc' coverpage.
:ectrldef.
.*--------------------------------------------------------------------------*/
.*        Help Item: QuickPage Product Information                          */
.*    Resource Name: PANEL_PRODUCT_INFO                                     */
.*  Resource Number: 5100                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=PRODUCT_INFO x=center y=center width=100% height=100% scroll=vertical
res=5100 name=PANEL_PRODUCT_INFO.QuickPage Product Description
:i1 id=PRODUCT_INFO.QuickPage Product Description
:p.
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. is a wireless communicator software package used to send
alphanumeric messages to a pager using standard telephone lines and Hayes
standard modems.
:p.
These messages are sent to paging services supporting the standard Telocator
Alphanumeric Protocol :hp2.(TAP).:ehp2.
:p.
Messages are sent through your standard telephone line and modem to
paging services.  Then the messaging service sends your messages via satellite
transmission in a satellite uplink.  The information is then sent from the
satellite to a satellite downlink station which sends the message to a 
ground-based transmitter.  This transmitter then uses radio frequency to
send the message to a wireless device (an alphanumeric or digital pager).


.*--------------------------------------------------------------------------*/
.*        Help Item: Command Parameters                                     */
.*    Resource Name: PANEL_INSTALLATION                                     */
.*  Resource Number: 5101                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=INSTALLING x=center y=center width=100% height=100%
  scroll=vertical res=5101
  name=PANEL_INSTALLATION.QuickPage Installation
 :i1 id=INSTALLING.QuickPage Installation

:p.
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. installation allows you to configure your environment and your
paging service.



.*--------------------------------------------------------------------------*/
.*        Help Item: Global Settings                                        */
.*    Resource Name: PANEL_GLOBAL_SETTINGS                                  */
.*  Resource Number: 5102                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=GLOBAL_SETTINGS x=center y=center width=100% height=100%
  scroll=vertical res=5102
  name=PANEL_GLOBAL_SETTINGS.Global Settings Configuration
 :i1 id=GLOBAL_SETTINGS.Global Settings Configuration

:p.The following picture shows the items presented by the global settings
notebook page&colon.
:p.

:artwork name='GLOBAL.BMP' runin.

:p.The items on this page are placed on the
:link reftype=hd res=5118.[GlobalSettings]:elink. section of your
configuration file.

:p.
:p.Related Information:
:ul compact.
:li.
:link reftype=hd res=5151.Global Setttings Section:elink.
:eul.



.*--------------------------------------------------------------------------*/
.*        Help Item: Modem Definition                                       */
.*    Resource Name: PANEL_MODEM_DEFINITION                                 */
.*  Resource Number: 5103                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=MODEM_DEFINITION x=center y=center width=100% height=100%
  scroll=vertical res=5103
  name=PANEL_MODEM_DEFINITION.Modem Definition
 :i1 id=MODEM_DEFINTION.Modem Definition

:p.The following picture shows the items presented by the Modem Definition
notebook page&colon.
:p.

:artwork name='MODEM.BMP' runin.

:p.The items on this page are placed on the
:link reftype=hd res=5118.[Modem]:elink. section of your
configuration file.

:p.
:p.Related Information:
:ul compact.
:li.
:link reftype=hd res=5151.Modem Setttings Section:elink.
:eul.


.*--------------------------------------------------------------------------*/
.*        Help Item: Paging Service                                         */
.*    Resource Name: PANEL_PAGING_SERVICE                                   */
.*  Resource Number: 5104                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=PAGING_SERVICE x=center y=center width=100% height=100%
  scroll=vertical res=5104
  name=PANEL_PAGING_SERVICE.Paging Service
 :i1 id=PAGING_SERVICE.Paging Service

:p.The following picture shows the items presented by the Paging Service
notebook page&colon.
:p.

:artwork name='SERVICE.BMP' runin.

:p.The items on this page are placed on the
:link reftype=hd res=5118.[Service]:elink. section of your
configuration file.

:p.
:p.Related Information:
:ul compact.
:li.
:link reftype=hd res=5151.Service Setttings Section:elink.
:eul.





.*--------------------------------------------------------------------------*/
.*        Help Item: PIN Definitions                                        */
.*    Resource Name: PANEL_PIN_DEFINITION                                   */
.*  Resource Number: 5105                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=PIN_DEFINITION x=center y=center width=100% height=100%
  scroll=vertical res=5105
  name=PANEL_PIN_DEFINITION.PIN Definitions
 :i1 id=PIN_DEFINITION.PIN Definitions

:p.The following picture shows the items presented by the PIN Definitions
notebook page&colon.
:p.

:artwork name='PINDEF.BMP' runin.

:p.The items on this page are placed on the
:link reftype=hd res=5118.[Subscribers]:elink. section of your
configuration file.

:p.
:p.Related Information:
:ul compact.
:li.
:link reftype=hd res=5151.Subscribers Setttings Section:elink.
:eul.


.*--------------------------------------------------------------------------*/
.*        Help Item: Configuration File                                     */
.*    Resource Name: PANEL_CONFIG_FILE                                      */
.*  Resource Number: 5200                                                   */
.*--------------------------------------------------------------------------*/
:h1 id=CONFIG_FILE x=center y=center width=100% height=100%
  scroll=vertical res=5200
  name=PANEL_CONFIG_FILE.QuickPage Configuration File
:i1 id=CONFIG_FILE.QuickPage Configuration File

:p.A 
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. configuration file contains information that defines your
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. environment and is used according to your needs and preferences.

:p.A default configuration file can be created during installation to be
used as your main page definition file.  Feel free to create
as many configuration files as you need.

:p.The created file (depending on your configuration selections) may look
like the following sample&colon.

:p.
:xmp.

;-----------------------------------------------------------------------------;
;                                                                             ;
;    File Name: PAGERDEF.PAG                                                  ;
;                                                                             ;
;  Description&colon. :link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.QuickPage:elink. Configuration file.                                 ;
;                                                                             ;
;         Note: Use this configuration file as a model for other configura-   ;
;               tion.                                                         ;
;                                                                             ;
;   Created On: Aug 10, 1995 at 12&colon.00&colon.00                                      ;
;                                                                             ;
;   Copyright (c) OS/Tools Incorporated 1995.                                 ;
;-----------------------------------------------------------------------------;

;-----------------------------------------------------------------------------;
; Global settings configuration.   This configuration applies to selections   ;
; made during installation. The default comm port used (ComPort) is COM1.     ;
; Use the COM port available to your system or override this global setting   ;
; by passing /COM&colon.n parameter from the command line.                          ;
;-----------------------------------------------------------------------------;
:link reftype=hd res=5118
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
[GlobalSettings]:elink.
:link reftype=hd res=5153
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
ComPort:elink.     = 1
:link reftype=hd res=5154
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
SinglePage:elink.  = Y
:link reftype=hd res=5155
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
GroupName:elink.   = YOUR_GROUP_NAME
:link reftype=hd res=5156
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
SenderID:elink.    = YOUR_ID
:link reftype=hd res=5157
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
DialPrefix:elink.  = 1
:link reftype=hd res=5158
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
StampID:elink.     = N
:link reftype=hd res=5159
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
StampTime:elink.   = Y
:link reftype=hd res=5160
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
StampGroup:elink.  = N
:link reftype=hd res=5161
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
PageRetries:elink. = 3
:link reftype=hd res=5162
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
LogFile:elink.     = PAGERDEF.LOG


;-----------------------------------------------------------------------------;
; Modem name and setting commands. Use Hayes Smartmodem compatible types.     ;
;-----------------------------------------------------------------------------;
:link reftype=hd res=5119
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
[Modem]:elink.
:link reftype=hd res=5163
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Name:elink.=Hayes Smartmodem Standard 1
:link reftype=hd res=5164
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Setup:elink.=ATE1V1&amp.C1&amp.D2
:link reftype=hd res=5165
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Reset:elink.=ATZ
:link reftype=hd res=5166
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Escape:elink.=+++
:link reftype=hd res=5167
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Disconnect:elink.=ATH0
:link reftype=hd res=5168
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Busy:elink.=BUSY
:link reftype=hd res=5169
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
DialTone:elink.=NO DIAL
:link reftype=hd res=5170
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Carrier:elink.=NO CARRIER
:link reftype=hd res=5171
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Answer:elink.=NO ANSWER
:link reftype=hd res=5172
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Speaker:elink.=Off
:link reftype=hd res=5173
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
SpeakerVolume:elink.=1


;-----------------------------------------------------------------------------;
; Messaging service parameters.                                               ;
;-----------------------------------------------------------------------------;
:link reftype=hd res=5120
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
[Service]:elink.
:link reftype=hd res=5174
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Name:elink.=PageMasters
:link reftype=hd res=5175
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
PrimaryNumber:elink.=800-123-4567
:link reftype=hd res=5176
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
SecondaryNumber:elink.=800-123-0000
:link reftype=hd res=5177
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
BaudRate:elink.=2400
:link reftype=hd res=5178
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
WordLength:elink.=7
:link reftype=hd res=5179
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Parity:elink.=E
:link reftype=hd res=5180
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
StopBits:elink.=1
:link reftype=hd res=5181
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
MaxMessages:elink.=10
:link reftype=hd res=5182
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
MaxBlockChars:elink.=80


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
:link reftype=hd res=5121
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
[Message]:elink.
:link reftype=hd res=5183
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Text:elink.=


;-----------------------------------------------------------------------------;
; Add up to 128 Pager IDs in a single call. (When supported by paging service);
;-----------------------------------------------------------------------------;
:link reftype=hd res=5122
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
[Subscribers]:elink.
:link reftype=hd res=5184
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Pager1:elink.=1234567
Pager2=2005000
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


;-----------------------------------------------------------------------------;
; End of Configuration File.                                                  ;
;-----------------------------------------------------------------------------;

:exmp.


.*--------------------------------------------------------------------------*/
.*        Help Item: Configuration File Format                              */
.*    Resource Name: PANEL_CONFIG_FILE_FORMAT                               */
.*  Resource Number: 5201                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=CFG_FILE_FORMAT x=center y=center width=100% height=100%
  scroll=vertical res=5201
  name=PANEL_CONFIG_FILE_FORMAT.Configuration File Format
:p.
The 
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. configuration file is broken into logical sections.  Each
section has the following format&colon.

:lines align=left.
:link reftype=hd res=5116.
[section]:elink.
:link reftype=hd res=5151.
keyname:elink.=value
:elines.

:p.
For example, to configure your communications port COM2
you may enter the following lines&colon.
:p.
:hp2.[GlobalSettings]:ehp2.
:p.
:hp2.ComPort=2:ehp2.


.*--------------------------------------------------------------------------*/
.*        Help Item: Configuration File Table                               */
.*    Resource Name: PANEL_CONFIG_FILE_TABLE                                */
.*  Resource Number: 5195                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=CFG_FILE_TABLE x=center y=center width=100% height=100%
  scroll=vertical res=5195
  name=PANEL_CONFIG_FILE_TABLE.Quick Reference Table
:p.The following quick reference tables describes the valid sections
and keynames used in a 
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. configuration file&colon.

:p.Global Settings table&colon.

:table cols='15 15 40'.
:row.
:c.Section
:c.Key Names
:c.Description
:row.
:c.
:link reftype=hd res=5118
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
GlobalSettings:elink.
:c.ComPort
:c.
:lines.
Communication port used by
QuickPage.
:elines.
:row.
:c.
:c.SinglePage
:c.
:lines.
Defines a single or group page.
:elines.

:row.
:c.
:c.GroupName
:c.
:lines.
Describes a group name.
:elines.

:row.
:c.
:c.SenderID
:c.
:lines.
Identifies a Sender.
:elines.

:row.
:c.
:c.DialPrefix
:c.
:lines.
Defines a dial prefix.
:elines.

:row.
:c.
:c.StampID
:c.
:lines.
A logical parameter to include/exclude
a Sender ID.
:elines.

:row.
:c.
:c.StampTime
:c.
:lines.
A logical parameter to include/exclude
the time a page wase sent.
:elines.

:row.
:c.
:c.StampGroup
:c.
:lines.
A logical parameter to include/exclude
a group name.
:elines.

:row.
:c.
:c.PageRetries
:c.
:lines.
The number of retries when a page
message fails.
:elines.

:row.
:c.
:c.LogFile
:c.
:lines.
Defines a QuickPage log file name.
:elines.
:etable.




:p.Modem Settings table&colon.

:table cols='15 15 40'.
:row.
:c.Section
:c.Key Names
:c.Description
:row.
:c.
:link reftype=hd res=5119
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Modem:elink.
:c.Name
:c.
:lines.
The name of the configured modem.
:elines.

:row.
:c.
:c.Setup
:c.
:lines.
Modem setup command.
:elines.

:row.
:c.
:c.Reset
:c.
:lines.
Modem reset command.
:elines.

:row.
:c.
:c.Escape
:c.
:lines.
Modem reset command.
:elines.

:row.
:c.
:c.Disconnect
:c.
:lines.
Modem disconnect command.
:elines.

:row.
:c.
:c.Busy
:c.
:lines.
Modem busy command.
:elines.

:row.
:c.
:c.DialTone
:c.
:lines.
Modem dialTone command.
:elines.

:row.
:c.
:c.Carrier
:c.
:lines.
Modem carrier command.
:elines.

:row.
:c.
:c.Answer
:c.
:lines.
Modem answer command.
:elines.

:row.
:c.
:c.Speaker
:c.
:lines.
Modem speaker On or Off.
:elines.

:row.
:c.
:c.SpeakerVolume
:c.
:lines.
Modem speaker volume 
(L)ow (M)edium (H)igh.
:elines.

:etable.




:p.Paging Service Settings table&colon.

:table cols='15 15 40'.
:row.
:c.Section
:c.Key Names
:c.Description
:row.
:c.
:link reftype=hd res=5120
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Service:elink.
:c.Name
:c.
:lines.
The name of the Paging Service.
:elines.

:row.
:c.
:c.PrimaryNumber
:c.
:lines.
Service primary dial-up phone number.
:elines.

:row.
:c.
:c.SecondaryNumber
:c.
:lines.
Service secondary dial-up phone number.
:elines.


:row.
:c.
:c.BaudRate
:c.
:lines.
Baud rate accepted by paging service.
:elines.

:row.
:c.
:c.WordLength
:c.
:lines.
Word length accepted by paging service.
:elines.

:row.
:c.
:c.Parity
:c.
:lines.
Parity accepted by paging service.
:elines.

:row.
:c.
:c.StopBits
:c.
:lines.
Stop bits accepted by paging service.
:elines.

:row.
:c.
:c.MaxMessages
:c.
:lines.
Maximum # of messages sent in a 
single call.
:elines.

:row.
:c.
:c.MaxBlockChars
:c.
:lines.
Maximum # of characters per block 
sent at one time.
:elines.

:etable.






:p.Message text settings table&colon.

:table cols='15 15 40'.
:row.
:c.Section
:c.Key Names
:c.Description
:row.
:c.
:link reftype=hd res=5121
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Message:elink.
:c.Text
:c.
:lines.
Alphanumeric text to be sent.
:elines.
:etable.


:p.Message text settings table&colon.

:table cols='15 15 40'.
:row.
:c.Section
:c.Key Names
:c.Description
:row.
:c.
:link reftype=hd res=5122
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
Subscribers:elink.
:c.Pager1... Pager128
:c.
:lines.
Pager PIN numbers.
:elines.
:etable.


.*--------------------------------------------------------------------------*/
.*        Help Item: Changing Configuration File                            */
.*    Resource Name: PANEL_CONFIG_FILE_CHANGE                               */
.*  Resource Number: 5250                                                   */
.*--------------------------------------------------------------------------*/
:h2 id=CFG_FILE_CHANGE x=center y=center width=100% height=100%
  scroll=vertical res=5250
  name=PANEL_CONFIG_FILE_CHANGE.Changing Configuration File
:p.
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. allows you to create a configuration file during installation and
assigns default values for missing parameter items.  Some entries are added
or changed when you select them from the default configuration notebook.  You
can change this values or create other configuration files using an ASCII
editor (i.e. EPM) or the 
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. Installation program.

:warning text='Important'.
Always back up your configuration files before you make modifications to
them.  Incorrect changes can lead to unexpected results when you run
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage.:elink.  Also some editors can use extended ASCII characters and
damage your configuration.  We recommend to use the standard OS/2 editor
EPM.


.*--------------------------------------------------------------------------*/
.*        Help Item: Configuration file sections                            */
.*    Resource Name: PANEL_CONFIG_FILE_SECTIONS                             */
.*  Resource Number: 5115                                                   */
.*--------------------------------------------------------------------------*/
.* :h1 id=FILE_SECTIONS x=center y=center width=100% height=100%
.*   scroll=vertical res=5115
.*   name=PANEL_CONFIG_FILE_SECTIONS.File Sections
.* :i1 id=FILE_SECTIONS.File Sections

:h2 res=5116 x=center y=center width=100% height=100% scroll=none clear.
Valid Sections
 :link reftype=hd res=5117 auto split group=10
       vpx=left vpy=top vpcx=25% vpcy=100%
       rules=border scroll=vertical.
 :link reftype=hd res=5118 auto split group=11
       vpx=right vpy=top vpcx=75% vpcy=100%
       rules=border scroll=vertical.


:h2 res=5117 hide nosearch noprint.Sections
 :p.
 :link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. configuration files are divided in
 several sections.
 :p.
 The valid section tags are&colon.
 :sl compact.
 :li.:link reftype=hd res=5118 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 [GlobalSettings]:elink.
 :li.:link reftype=hd res=5119 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 [Modem]:elink.
 :li.:link reftype=hd res=5120 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 [Service]:elink.
 :li.:link reftype=hd res=5121 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 [Message]:elink.
 :li.:link reftype=hd res=5122 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 [Subscribers]:elink.
 :esl.




:h2 res=5118 hide name=PANEL_SECTION_GLOBAL.[GlobalSettings]
:p.
This sections is used to configure your global
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. setting commands.


:h2 res=5119 hide name=PANEL_SECTION_MODEM.[Modem]
:p.
 This section is used to describe your modem and modem
 commands used during initialization.


:h2 res=5120 hide name=PANEL_SECTION_SERVICE.[Service]
:p.
This section describes the parameters accepted by your paging
service and it includes the name, primary phone number and
secondary phone number.


:h2 res=5121 hide name=PANEL_SECTION_MESSAGE.[Message]
:p.
There are sometimes when you want to pre-define a message text
and keep that message inside your configuration file, this
section allows you just to do that.


:h2 res=5122 hide name=PANEL_SECTION_SUBSCRIBERS.[Subscribers]
:p.
In this section you specify the subscribers (recipients) of your
messages.  You can define up to 128 PIN numbers using the prefix
:hp2.Pager:ehp2. and adding an ordinal number (i.e. 1,2,3, etc.).
The limitation of messages per call is set by your paging service.


.*--------------------------------------------------------------------------*/
.*        Help Item: Configuration file keynames                            */
.*    Resource Name: PANEL_CONFIG_FILE_KEYNAMES                             */
.*  Resource Number: 5150                                                   */
.*--------------------------------------------------------------------------*/
.* :h2 id=FILE_KEYNAMES x=center y=center width=100% height=100%
.*   scroll=vertical res=5150
.*   name=PANEL_CONFIG_FILE_KEYNAMES.File KeyNames
.* :i1 id=FILE_KEYNAMES.File KeyNames

:h2 res=5151 x=center y=center width=100% height=100% scroll=none clear.
Valid KeyNames
 :link reftype=hd res=5152 auto split group=10
       vpx=left vpy=top vpcx=25% vpcy=100%
       rules=border scroll=vertical.
 :link reftype=hd res=5153 auto split group=11
       vpx=right vpy=top vpcx=75% vpcy=100%
       rules=border scroll=vertical.


:h2 res=5152 hide nosearch noprint.KeyNames
 :p.
 The 'keyname' in a 
:link reftype=hd res=5300
      vpx=center vpy=center vpcx=75% vpcy=75%
      rules=sizeborder scroll=vertical group=1.
QuickPage:elink. configuration file
 consist of any combination of letters and digits.
 These keynames are followed by an equal sign (=).

 :p.
 The valid keynames in a configuration file are&colon.
 :p.
 :hp2.[GlobalSettings]:ehp2.
 :sl compact.
 :li.:link reftype=hd res=5153 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 ComPort:elink.
 :li.:link reftype=hd res=5154 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 SinglePage:elink.
 :li.:link reftype=hd res=5155 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 GroupName:elink.
 :li.:link reftype=hd res=5156 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 SenderID:elink.
 :li.:link reftype=hd res=5157 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 DialPrefix:elink.
 :li.:link reftype=hd res=5158 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 StampID:elink.
 :li.:link reftype=hd res=5159 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 StampTime:elink.
 :li.:link reftype=hd res=5160 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 StampGroup:elink.
 :li.:link reftype=hd res=5161 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 PageRetries:elink.
 :li.:link reftype=hd res=5162 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 LogFile:elink.
 :esl.



 :p.
 :hp2.[Modem]:ehp2.
 :sl compact.
 :li.:link reftype=hd res=5163 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Name:elink.
 :li.:link reftype=hd res=5164 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Setup:elink.
 :li.:link reftype=hd res=5165 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Reset:elink.
 :li.:link reftype=hd res=5166 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Escape:elink.
 :li.:link reftype=hd res=5167 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Disconnect:elink.
 :li.:link reftype=hd res=5168 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Busy:elink.
 :li.:link reftype=hd res=5169 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 DialTone:elink.
 :li.:link reftype=hd res=5170 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Carrier:elink.
 :li.:link reftype=hd res=5171 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Answer:elink.
 :li.:link reftype=hd res=5172 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Speaker:elink.
 :li.:link reftype=hd res=5173 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Volume:elink.
 :esl.



 :p.
 :hp2.[Service]:ehp2.
 :sl compact.
 :li.:link reftype=hd res=5174 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Name:elink.
 :li.:link reftype=hd res=5175 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 PrimaryNumber:elink.
 :li.:link reftype=hd res=5176 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 SecondaryNumber:elink.
 :li.:link reftype=hd res=5177 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 BaudRate:elink.
 :li.:link reftype=hd res=5178 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 WordLength:elink.
 :li.:link reftype=hd res=5179 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Parity:elink.
 :li.:link reftype=hd res=5180 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 StopBits:elink.
 :li.:link reftype=hd res=5181 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 MaxMessages:elink.
 :li.:link reftype=hd res=5182 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 MaxBlockChars:elink.
 :esl.



 :p.
 :hp2.[Message]:ehp2.
 :sl compact.
 :li.:link reftype=hd res=5183 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Text:elink.
 :esl.


 :p.
 :hp2.[Subscribers]:ehp2.
 :sl compact.
 :li.:link reftype=hd res=5184 split group=11
           vpx=right vpy=top vpcx=75% vpcy=100%
           rules=border scroll=vertical.
 Pager1:elink.
 :esl.





:h2 res=5153 hide name=PANEL_KEYNAME_COMPORT.ComPort
:p.

This entry specifies the communications port you will be
using when sending an alphanumeric message.  The possible
range is 1 to 32.  The default is 1.


:h2 res=5154 hide name=PANEL_KEYNAME_SINGLEPAGE.SinglePage
:p.
This entry is set to :hp2.Y:ehp2. when you are sending a single page or
set to :hp2.N:ehp2. when multiple pages (Group Page) are being sent.  The
possible values are Y or N.  The default is Y.



:h2 res=5155 hide name=PANEL_KEYNAME_GROUPNAME.GroupName
:p.
This entry specifies the name of a group when you send a group message
and want this name to be printed at the end of the message.  The maximum
number of characters for a group name is :hp2.16:ehp2.  The name specified
in this entry will only be printed when the :hp2.StampGroup:ehp2.
entry on this section is set to :hp2.Y:ehp2.



:h2 res=5156 hide name=PANEL_KEYNAME_SENDERID.SenderID
:p.
This entry specifies the sender identification used when you send a message
and want this ID to be printed at the end of the message.  The maximun
number of characters for an ID is :hp2.8:ehp2.


:h2 res=5157 hide name=PANEL_KEYNAME_DIALPREFIX.DialPrefix
:p.
This entry specifies the prefix used when dialing a Paging Service phone
number.  The maximum number of characters is :hp2.5.:ehp2.  The default
value is :hp2.1.:ehp2.  This dial prefix is placed in front of the phone
number you select on the :hp2.PrimaryNumber:ehp2. or the
:hp2.SecondaryNumber:ehp2. entries on the :hp2.[Service]:ehp2. section
before a dial connection is made by QuickPage.


:h2 res=5158 hide name=PANEL_KEYNAME_STAMPID.StampID
:p.
This entry is set to :hp2.Y:ehp2. when you want the sender ID to be
stamped at the end of the page message.  This is ID is taken from the
:hp2.SenderID:ehp2. entry on this section.  The possible values are
Y or N.  The default is :hp2.Y.:ehp2.  This ID is presented within
:hp2.<>:ehp2.


:h2 res=5159 hide name=PANEL_KEYNAME_STAMPTIME.StampTime
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


:h2 res=5160 hide name=PANEL_KEYNAME_STAMPGROUP.StampGroup
:p.
This entry is set to :hp2.Y:ehp2. when you want a group name to be
displayed at the end of the page message.  The possible values are Y or N.
The default is :hp2.N.:ehp2.


:h2 res=5161 hide name=PANEL_KEYNAME_PAGERETRIES.PageRetries
:p.
This entry is used to specify the number of retries you want QuickPage to
make before it returs with an ending message.  The possible values are 3
to 99.


:h2 res=5162 hide name=PANEL_KEYNAME_LOGFILE.LogFile
:p.
This entry specifies the name of a file to be used by QuickPage to write
system information.  This name must be a valid OS/2 text file name.



:h2 res=5163 hide name=PANEL_KEYNAME_MODEMNAME.Name
:p.
This entry specifies the name of the modem configured.
The maximum size of this field is :hp2.50.:ehp2.


:h2 res=5164 hide name=PANEL_KEYNAME_MODEMSETUP.Setup
:p.
This entry specifies the setup command string used with the modem configured.
The maximum command string size is :hp2.40.:ehp2.

:h2 res=5165 hide name=PANEL_KEYNAME_MODEMRESET.Reset
:p.
This entry specifies the reset command string used with the modem configured.
The maximum command string size is :hp2.16.:ehp2.

:h2 res=5166 hide name=PANEL_KEYNAME_MODEMESCAPE.Escape
:p.
This entry specifies the escape command string used with the modem configured.
The maximum command string size is :hp2.16.:ehp2.

:h2 res=5167 hide name=PANEL_KEYNAME_MODEMDISCON.Disconnect
:p.
This entry specifies the disconnect command string used with the modem configured.
The maximum command string size is :hp2.16.:ehp2.

:h2 res=5168 hide name=PANEL_KEYNAME_MODEMBUSY.Busy
:p.
This entry specifies the busy command string used with the modem configured.
The maximum command string size is :hp2.16.:ehp2.

:h2 res=5169 hide name=PANEL_KEYNAME_MODEMDIAL.DialTone
:p.
This entry specifies the dial tone command string used with the modem configured.
The maximum command string size is :hp2.16.:ehp2.

:h2 res=5170 hide name=PANEL_KEYNAME_MODEMCARRIER.Carrier
:p.
This entry specifies the carrier command string used with the modem configured.
The maximum command string size is :hp2.16.:ehp2.


:h2 res=5171 hide name=PANEL_KEYNAME_MODEMANSWER.Answer
:p.
This entry specifies the answer command string used with the modem configured.
The maximum command string size is :hp2.16.:ehp2.


:h2 res=5172 hide name=PANEL_KEYNAME_MODEMSPEAKER.Speaker
:p.
This entry sets the modem speaker On or Off for the modem configured.
The possible values are :hp2.On:ehp2. or :hp2.Off.:ehp2.


:h2 res=5173 hide name=PANEL_KEYNAME_MODEMVOLUME.Volume
:p.
This entry sets the modem speaker volume to the modem configured.
The possible values are&colon.

:ul compact.
:li.(1) Low
:li.(2) Medium
:li.(3) High
:eul.



:h2 res=5174 hide name=PANEL_KEYNAME_SVCNAME.Name
:p.
This entry specifies the name of your paging service.
The maximum size of this field is :hp2.20.:ehp2.

:h2 res=5175 hide name=PANEL_KEYNAME_SVCPNUM.PrimaryNumber
:p.
This entry specifies your paging service primary number dial-up.
The maximum size of this field is :hp2.12.:ehp2.

:h2 res=5176 hide name=PANEL_KEYNAME_SVCSNUM.SecondaryNumber
:p.
This entry specifies your paging service secondary number dial-up.
The maximum size of this field is :hp2.12.:ehp2.

:h2 res=5177 hide name=PANEL_KEYNAME_SVCBAUDRATE.BaudRate
:p.
This entry specifies your paging service standard baud rate used
to communicate with their terminal.
The possible values are&colon.

:ul compact.
:li.:hp2.300:ehp2.
:li.:hp2.1200:ehp2.
:li.:hp2.2400:ehp2.
:li.:hp2.9600:ehp2.
:eul.

:h2 res=5178 hide name=PANEL_KEYNAME_SVCWLENGTH.WordLength
:p.
Use this field to select the number of bits that 
corresponds to the word length of the characters 
you send to your paging service.  The preselected
choice is :hp2.7:ehp2. bits.



:h2 res=5179 hide name=PANEL_KEYNAME_SVCPARITY.Parity
:p.
Use this field to select the type of parity checking 
that your paging service requires.  The
preselected choice is :hp2.Even.:ehp2.


:h2 res=5180 hide name=PANEL_KEYNAME_SVCSBITS.StopBits
:p.
Use this field to select the number that corresponds 
to the signal length that your paging service specifies
for stop bits.  The preselected choice is :hp2.1.:ehp2.


:h2 res=5181 hide name=PANEL_KEYNAME_SVCMAXMSGS.MaxMessages
:p.
Use this field to select the number of messages that
your paging service accepts in a single call.
The preselected choice is :hp2.10.:ehp2.

:h2 res=5182 hide name=PANEL_KEYNAME_SVCMAXBLOCKS.MaxBlockChars
:p.
Use this field to select the number of characters per block
your paging service accepts at one time.
The preselected choice is :hp2.80.:ehp2.



:h2 res=5183 hide name=PANEL_KEYNAME_MSGTEXT.Text
:p.
Use this field to pre-define an alphanumeric message.
There is no preselected text.



:h2 res=5184 hide name=PANEL_KEYNAME_SUBSCRPINNO.PIN Number (Pager/nnn)
:p.
Use this field to define a pager PIN number.
The maximum number of PINs sent in a single call is :hp2.128.:ehp2.



:h2 res=5300 hide name=PANEL_QUICKPAGE_INFO.Product Information
:p.
QuickPage and SafePage are registered trademarks of
OS/tools Incorporated.





:euserdoc.
