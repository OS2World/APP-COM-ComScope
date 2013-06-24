.*
.*******************************************************************************
.*  Profile Dialog help
.*******************************************************************************
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
.*
.*******************************************************************************
.*  Profile Delete Message Box help
.*******************************************************************************
:h1 nosearch hide res=40003 name=HLPP_MB_PROFILE_DEL.Help for Profile Delete
:p.
Profile management will not let you delete a profile that is in use by this, or any other COMscope
session.
:p.
If you want to delete the currently loaded profile for this COMscope session you must either load
a different existing profile or create a new profile first.
:p.
If you want to delete a profile that is being used another COMscope session you will either have to close
that COMscope session or cause that COMscope session to load a different profile.
:nt text='Caution:'.COMscope will allow you to load a profile that is being used by another COMscope session.  Deleteing
a profile that is being used by another COMscope session can have unpredictable results; not
catastrophic, just unpredictable.
.*
.*******************************************************************************
.*  Profile Name Message Box help
.*******************************************************************************
:h1 nosearch hide res=40004 name=HLPP_MB_PROFILE_NAME.Help for New Profile Name
:p.
Hey, we had to use some character to mark deleted profiles.  You can use the character,
just not for the first character.
.*
.*******************************************************************************
.*  Profile Save Message Box help
.*******************************************************************************
:h1 nosearch hide res=40002 name=HLPP_MB_PROFILE_SAVE.Help for Profile Save
:p.
You have selected a profile name to be saved a profile other than the profile currently loaded.
:p.
If you select :hp2.Yes:ehp2. you will cause the current configuration to overwrite
the selected profile.
:p.
If you select :hp2.No:ehp2. nothing will be saved or overwritten.
.*
.*******************************************************************************
.*  Profile help
.*******************************************************************************
:h1 res=40000 id=HLPC_PROFILE_MNG name=HLPP_PROFILE.COMscope Profiles
:i1.Profiles in COMscope
:p.
COMscope includes the ability to save not only your current COMscope session configuration (profile), but any number
of session profiles.
:p.
COMscope session profile access can be managed in three ways:
:ol.
:li.:hp5.By selection from the:ehp5. :hp7.Manage Profile...:ehp7. :hp5.menu item under the:ehp5. :hp7.Options:ehp7. :hp5.heading.
The:ehp5. :hp7.Manage Profile:ehp7. :hp5.dialog box will allow you to&colon.:ehp5.
:ol compact.
:li.Save the existing configuration.
:li.Create a new name for the existing configuration.
:li.Load an existing configuration.
:li.Delete a listed configuration.
:li.Turn automatic profile save on or off.
:li.Cause the loaded profile to start the process that was in effect the last time COMscope was exited.
:li.Cause the last window positions to be used for all COMscope status and display windows that were open
the last time COMscope was exited.
:eol.
:li.:hp5.By placing the name of a profile on the COMscope command line.:ehp5.
:sl.
:li.If you place :hp2./P"My COMscope Profile":ehp2. after COMscope, on the command line, or in the :hp2.Parameters:ehp2.
entry field in the settings notebook, the Profile :hp2.My COMscope Profile:ehp2. will be accessed by that session
of COMscope.  If a profile by that name does not exist it will be created, and all configuration information
for that session will be stored there.
:esl.
:li.:hp5.By placing the:ehp5. :hp7./S:ehp7. :hp5.switch on the COMscope command line.:ehp5.
:sl.
:li.If you place :hp2./S"Profile Name":ehp2. after COMscope, on the command line, or in the :hp2.Parameters:ehp2.
entry field in the settings notebook, each new COMscope session will load, or create, the next profile in the series
:hp2.Profile Name x:ehp2..  Where "x" is the number of the COMscope session started.
:lp.
The first COMscope loaded with the :hp2./S:ehp2. switch will have the profile name :hp2.Profile Name 1:ehp2..  The second will
have the name :hp2.Profile Name 2:ehp2., and so on.  If no "name" follows the :hp2./S:ehp2. switch, the default profile name,
:hp2.COMscope:ehp2., will be used.
:ol compact.
This feature will best be used by creating (modifying) a COMscope object with the following settings notebook entries:
:li.Place the :hp2./S:ehp2. in the Parameters entry field.
:li.Under the :hp2.Window:ehp2. tab in the :hp2.Oblect open behavior:ehp2. group select the :hp2.Create new window:ehp2.
radio button.
:eol.
:li.Each time you open a COMscope session from that object a different profile of the series will be loaded and acted upon.
:li.In this manner you may open multiple sessions, configure each session, and place each required COMscope status window.
:li.When you exit each COMscope session the configuration for that session will be saved.
:li.Open multiple sessions again and each session will be opened again just as it was when you exited.
:esl.
:eol.
:nt.If you place a ":hp2.-:ehp2." after the ":hp2.S:ehp2." (e.g., :hp2./S-:ehp2.) COMscope will not access any profile and all profile
management features will be disabled.
:ent.
:nt.Profile names supplied on the command line with the :hp2./P:ehp2. or :hp2./S:ehp2. switches are case sensitive and if there are
any spaces or tabs in the name it MUST be quoted (see example, above).  The last :hp2./P:ehp2. or :hp2./S:ehp2. switch found on the
command line will take precident.
:ent.
:nt text='FYI:'.COMscope accesses or creates an OS/2 Profile file named :hp2.COMscope.ini:ehp2. in the directory in which COMscope
is located.  Each COMscope profile name created becomes an entry in that file.  COMscope.ini is normally a "hidden" file since OS/2
Profiles are marked as hidden by the Profile API.
:ent.
