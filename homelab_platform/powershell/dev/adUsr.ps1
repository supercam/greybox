#manage users with AD

#creates a user
New-ADUser -Name "peter jackson" -GivenName Peter -Surname Jackson -UserPrincipalname "peterD@contoso.com" -SamAccountName PeterD -Department "IT" -OtherAttributes @{"title"="director";"mail"="peterj@contoso.com"}
#creates a user
Remove-ADUser -Name "peter jackson" -identity "peterD@contoso.com"

#disable a user
Disable-ADAccount -Identity "peterD@contoso.com"

#enable a user
Enable-ADAccount -Identity "peterD@contoso.com"

#Move a user
Move-ADObject -Identity "peterD@contoso.com" -TargetPath "OU=corp","DC=Contoso","DC=com"

#search accounts and remove all disabled accounts
Search-ADAccount -AccountDisabled -searchbase "OU=corp","DC=Contoso","DC=com" | remove-aduser