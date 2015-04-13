.*
.**************************************************
.* Sealevel support (3)
.**************************************************
:h3 id=SUPPORT_SEA.Sealevel Systems Incorporated
:i2 refid=SUPPORT.Sealevel Systems Incorporated
:p.
Sealevel Systems supplies several high quality adapters that support shared
interrupts on :link refid=ISA reftype=fn.ISA:elink. machines.  The two adapters
Sealevel sells directly are the :hp2.TURBO COMM+4:ehp2. and the :hp2.COMM+8:ehp2.
asynchronous serial adapters.  Sealevel also supplies equivalent adapters to other
suppliers that are sold under other names.
:p.
Sealevel adapters that have shared interrupt capabilities can be configured
to enable the interrupt status register at either the base I/O address plus seven or
at some address defined in an on-board PAL.
:p.
When configuring COMi for a Sealevel adapter with shared interrupts you will
need to supply the address of the interrupt status register, the hardware interrupt
level, and I/O addresses for each device for which you have configured the
adapter.  All devices on a single adapter must be configured for the same interrupt
level.
:p.
More than one Sealevel adapter can be connected to a single hardware
interrupt.
.*
.**************************************************
.* DigiBoard support (3)
.**************************************************
:h3 id=SUPPORT_DIGI.DigiBoard
:i2 refid=SUPPORT.DigiBoard
:p.
RS-232, RS-422, and RS-485 adapters are available from DigiBoard that support shared
interrupts on :link refid=ISA reftype=fn.ISA:elink. machines.  DigiBoard adapters
that support shared interrupts have a DIP switch on the adapter to select the
interrupt status register address and to enable interrupt sharing.
:p.
DigiBoard adapters can also be configured to allow devices on a board to use two
different hardware interrupt levels (except the PC/16).  More than one DigiBoard
adapter can be connected to a single hardware interrupt.
:p.
To configure COMi to share interrupts on DigiBoard serial adapters you will need to
know the I/O base address selected for each device on the adapter, the interrupt
level for each device, and the address of the interrupt status register.  If your are
going to use two different hardware interrupt levels on a single adapter you will
need to define two loads of the COMi device driver, one for each hardware interrupt
level.
:p.
If you are using the DigiBoard PC/16 you will need to know the address ranges the
adapter is assinged by being aware of the on-board PAL that defines the I/O base
addresses to your adapter.  The PC/16 supports only one interrupt level per adapter.
:p.
.*
.**************************************************
.* Comtrol Corporation Hostess (3)
.**************************************************
:h3 id=SUPPORT_COMTROL.Comtrol Corporation Hostess
:i2 refid=SUPPORT.Comtrol Corporation Hostess
:p.
Comtrol Corporation has two serial adapters that support shared interrupts on :link
refid=ISA reftype=fn.ISA:elink. machines.  These are the Hostess 550 RJ11 (four
ports) and the Hostess 550 RJ45 (eight ports).
:p.
To configure a Hostess adapter to work with COMi you must enable interrupt sharing
and disable the interrupt mask mode on the adapter.  The Comtrol Hostess adapters
also support hardware interrupt sharing across adapters.
:p.
To configure COMi to work with a Hostess adapter you will need to know the hardware
interrupt level and the base I/O address.  The interrupt status register address is
located at the base I/O address plus seven.  Each device takes eight consecutive I/O
addresses.  If the base I/O address is set to 500h the first device's address block
will be begin at 500h, the second devices address block will begin at 508h, and so
on.
.*
.**************************************************
.* Quatech support (3)
.**************************************************
:h3 id=SUPPORT_QUA.Quatech Incorporated
:i2 refid=SUPPORT.Quatech Incorporated
:p.
Quatech manufactures numerous serial adapters that support shared interrupts on an
:link refid=ISA reftype=fn.ISA:elink. machine.  They have adapters that support
RS-232, RS-422,
and RS-485. Quatech also has adapters that use either RJ11/RJ45 or DB25 connectors.
:p.
Quatech adapters that have shared interrupt capabilities can be configured to enable
the interrupt status register at any device's base I/O address plus seven.
:p.
When configuring COMi for a Quatech adapter for shared interrupts you will need to
supply the address of an interrupt status register.  Additionally, you will need to
supply the hardware interrupt level and base I/O addresses for each device for which
you have configured the adapter.  All devices on a single adapter must be configured
for the same interrupt level.
:p.
Only one Quatech serial adapter can be connected to a single hardware interrupt
level.
:nt.Some Quatech adapters that were manufactured before 1992 will require that you
disable modem interrupts for those devices.  See the :link refid=EXTENSIONS
reftype=hd.Extensions:elink. sections for information on disabling modem interrupts.
:ent.
