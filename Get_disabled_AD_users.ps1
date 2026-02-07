$Users = Get-ADUser -Filter {Enabled -eq $false} -Properties badPasswordTime, CanonicalName, EmailAddress, lastLogon, mail, mailNickname, Name, DisplayName, SamAccountName, pwdLastSet, Title, Description, UserPrincipalName

$Users | select SamAccountName, UserPrincipalName, Name, DisplayName, Description, Title, EmailAddress, mail, mailNickname, CanonicalName,
    @{Label="lastLogon"; Expression = {[datetime]::FromFileTime($_.lastLogon).ToString("yyyy-MM-dd HH:mm:ss")}},
    @{Label="pwdLastSet"; Expression = {[datetime]::FromFileTime($_.pwdLastSet).ToString("yyyy-MM-dd HH:mm:ss")}},
    @{Label="badPasswordTime"; Expression = {[datetime]::FromFileTime($_.badPasswordTime).ToString("yyyy-MM-dd HH:mm:ss")}} | Export-Csv "$env:USERPROFILE\Desktop\disabled_users.csv" -NoTypeInformation
