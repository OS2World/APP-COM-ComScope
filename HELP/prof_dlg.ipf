:h1 nosearch hide res=40001 name=HLPP_PROFILE_DLG.Help for COMscope Profile Manage Dialog
:p.
Select a profile name to operate on from the :hp2.Available Configuration Sets:ehp2. list box.
:nt.The currently loaded profile will be automatically selected upon entry to this dialog box.
:ent.
:ul.
:li.Click on the :hp2.Automatically Save on Exit:ehp2. check box to toggle automatic saving of the currently
loaded profile upon exit from a COMscope session.
:lp.Unless you select :hp2.Automatically Save on Exit:ehp2. you will be asked if you want to save
the current configuration upon exit from this COMscope session.  You will only be asked if
some parameter stored in the profile has changed since the last save or since this COMscope session began.
:lp.If you are using the "shutdown server" feature of COMscope you will want to enable this option.  Otherwise
each COMscope session will prompt for save instructions when the "kill" command is sent to the server.
:li.Click on the :hp2.Load Monitor Configurtion:ehp2. check box to toggle loading, on startup, of the monitor configuration
in effect the when you exit this COMscope session.
:li.Click on the :hp2.Load Last Window Positions:ehp2. check box to toggle using the last display and status
window positions for the monitor configuration in effect when you exit this COMscope session.
:nt.The states of these three check boxes will be stored for any profile selected when the :hp2.Save:ehp2.
push button is selected.
:lp.Any changes to these check boxes will be applied to the currently loaded profile
only if you select the :hp2.Save:ehp2. push button while that profile is selected in the list box.
:ent.
:li.Select the :hp2.Save:ehp2. push button to save the currently selected profile.
:li.Select the :hp2.Load:ehp2. push Button to load the selected profile.
:li.Select the :hp2.Delete:ehp2. push Button to delete the selected profile.
:li.Select the :hp2.New:ehp2. push Button to add a new profile.
:lp.The new profile will duplicate the currently loaded profile and become the "currently loaded" profile
for this session of COMscope.
:li.Select the :hp2.Done:ehp2. push button to exit this dialog box.
:nt.Deleted profiles will will be marked as "deleted" in the list box.
:lp.If you select a "deleted" profile the :hp2.Delete:ehp2. push button will become an
:hp2.Undelete:ehp2. push button.  You will be able to restore any "deleted" profile by
selecting that profile and selecting the :hp2.Undelete:ehp2. push button.
:lp.All "deleted" profiles will be available for recovery until any currently active
COMscope session is exited.  At that time those profiles marked as "deleted" will be
removed from the COMscope.INI file, forever.
:ent.
:eul.
Related Information&colon.
:ul Compact.
:li.:link refid=HLPC_MULTI_SHUTDOWN reftype=hd.Multiple Session Shutdown Server:elink.
:eul.

