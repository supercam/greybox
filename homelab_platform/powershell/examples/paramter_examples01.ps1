<#
#parameters examples this is simple allows you just to pass in an argument
#$param = $args[0]
#write-host $param


#example 2
$servername = $args[0]
$envname = $args[1]
write-host "If this script was gonna do it, it would $servername it with $envname"



#named parameters examples, these allow you to pass in an argument with the parameter assigned to it, you don't have to think about the order.
param ($servername, $envname)
write-host "If this script was gonna do it, it would $servername it with $envname"



Param(
    [switch]$Debug
)

try {
    if ($Debug)
    {
        $Creds = Get-Credential
    }
    else
    {
        Write-Host "auth failed"
    }
}
catch
{
    Write-Host "failed to identify server or creds"
    Exit
}
#>


#named parameters example can assign a default value to it, and this value can be overwritten when ran, it will prompt if you spec mandatory
param ($servername = "water", 
    [Parameter(Mandatory)]$envname
)
write-host "If this script was gonna do it, it would $servername it with $envname"
