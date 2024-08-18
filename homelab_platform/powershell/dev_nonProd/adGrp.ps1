#manage groups with AD

#creates a group
New-ADGroup -Name "Reasearch admins" -SAMAccountName ResearchAdmins -GroupCategory Security -GroupScope Global -DisplayName "Research Admins" -Path "OU=Groups,OU=Corp.DC=Contoso,DC=COM" -Description "members of this are network admins"

#adds user to group
Add-ADGroupMember -Identity "CN=Research admins, OU=Groups" -Members "KarenB"

#get user group
Get-ADGroupMember -Identity "CN=Research admins, OU=Groups" -Members "KarenB"



