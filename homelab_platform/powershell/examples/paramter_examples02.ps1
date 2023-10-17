#this is an example of boolean parameter, this is because you want to spec as an argument either $true,$false,1,0
<#
param( [boolean] $help )

if ($help -eq $true)
{
    Write-host "This is a help program."
}
else
{
    Write-host "what do you want a cookie?"
}
#>

#this is an example of a switch parameter, you cannot assign a value to a switch data type, to make this argument work must pass in argument like this -help
param( [switch] $help )

if ($help)
{
    Write-host "This is a help program."
}
else
{
    Write-host "what do you want a cookie?"
}

