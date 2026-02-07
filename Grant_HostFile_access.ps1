Enter-PSSession Computer_Name

$FilePath = "C:\Windows\System32\drivers\etc\hosts"
$User = "company\user"
$acl = Get-Acl $FilePath
$permission = New-Object System.Security.AccessControl.FileSystemAccessRule($User,"Modify","Allow")
$acl.AddAccessRule($permission)
Set-Acl -Path $FilePath -AclObject $acl