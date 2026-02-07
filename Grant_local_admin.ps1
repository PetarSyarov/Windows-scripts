# TO BE EXECUTED LINE BY LINE !!!

# Start PSsession to domain computer
Enter-PSSession Computer_Name

# Get logged on user info
quser

# Add user to local admin group
Add-LocalGroupMember -Group Administrators -Member username