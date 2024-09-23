<#
.Synopsis
	Copy file to remote device.
.Description
	uses copy-item to copy file to users machine when using windows
	run locally on server or PS-Session to a server to copy files to remote machine
.Author
	James Lewis
#>

[CmdletBinding()]
Param(
    [parameter(mandatory = $true)]
    [string]$WSID = "",

    [parameter(mandatory = $true)]
    [string]$Source = "",

    [parameter(mandatory = $true)]
    [string]$Destination = "$env:SystemDrive\Temp"

)

#set script to stop on error
$ErrorActionPreference = 'stop'

#check if WSID is blank
if($WSID -eq "") {
    Write-Host "WorkstationID is blank"
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

#auth session
try {
    $Session = New-PSSession -ComputerName $WSID -Credential "Domain\"
}
catch {
    Write-Host "Failed to Auth. `n" -ForegroundColor Red 
    $failauth = $_
    Write-Host $failauth -ForegroundColor Red 
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

#copy from source machine to destination machine
#Source is the directory on the local machine
#Destination is the remote machine and is assumed to be C:\Temp
#using verbose to write to console, there are other methods to do this but want to see directly in console

try {
    Copy-Item $Source -Destination $Destination -ToSession $Session -Recurse -PassThru -Verbose
}
catch {
    Write-Host "Failed to initiate copy `n" -ForegroundColor Red
    $failcopy = $_
    Write-Host $failcopy -ForegroundColor Red 
    Exit-PSSession
}
Read-Host -Prompt "Press Enter to Exit"
Exit
