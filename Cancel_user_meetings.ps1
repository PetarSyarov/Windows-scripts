# TO BE EXECUTED LINE BY LINE !!!

# Install Exhcange Online Module
Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force

# Connect Exachange Online
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -DisableWAM

# Verify mailbox
Get-Mailbox -Identity user.name@company.com

# Preview meetings
Remove-CalendarEvents -Identity user.name@delasport.com `
  -CancelOrganizedMeetings:$true `
  -QueryStartDate (Get-Date).AddDays(-300) `
  -QueryWindowInDays 1500 `
  -PreviewOnly

# Cancel meetings
Remove-CalendarEvents -Identity user.name@delasport.com `
  -CancelOrganizedMeetings:$true `
  -QueryStartDate (Get-Date).AddDays(-300) `
  -QueryWindowInDays 1500