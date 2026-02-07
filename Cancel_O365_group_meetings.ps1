# TO BE EXECUTED LINE BY LINE !!!

# Make sure Graph is installed
Install-Module Microsoft.Graph -Scope CurrentUser -Repository PSGallery -Force

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Find the group ID
$group = Get-MgGroup -Filter "M365_SHARED_MAILBOX_NAME'"

# List events from the group calendar
$events = Get-MgGroupEvent -GroupId $group.Id -All | Where-Object { $_.Subject -eq "NAME_OF_MEETING_YOU_WANT_TO_CANCEL" }

# Preview
$events | Select-Object Id, Subject, @{Name='Start';Expression={$_.Start.DateTime}}

# Cancel them (sends cancellation email to members)
foreach ($e in $events) {
    Stop-MgGroupEvent -GroupId $group.Id -EventId $e.Id -Comment "Canceled by admin" -Confirm:$false
}
