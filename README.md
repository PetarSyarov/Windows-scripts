 # --------------------------------------------
 # Explanation for each script in this repo
 # --------------------------------------------

 # Cancel_O365_group_meetings
Used to cancel meetings that were setup via an O365 group. Does not work if a mailbox is targeted. Upon cancelation sends an email to all atendees.

 # Cancel_user_meetings
Used to cancel meetings thaat were scheduled by a user that has left the company. Can be used to target User or Shared Mailboxes. Works even if the user account is disabled, as long as the mailbox still exists. Attendees receive cancellation notices for all future occurrences

 # Grant_HostFile_access
Grants specified user access to modify their computer host file.

 # Get_disabled_AD_users
Straightforward script that generates a csv with a list of all disabled users in Active Directory

 # Grant_local_admin
Add user to the local Administrator group granting them admin access to their machine. Must reboot before changes can take effect.

 # Process_mmonitor
PowerShell equivelant of the " top " command in Linux shell.