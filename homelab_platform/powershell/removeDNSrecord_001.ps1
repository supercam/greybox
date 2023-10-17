<#
.Synopsis
	remove DNS record
.Description
	use this to remove dns records on a workstation device.  Assumes AD module is installed.
.Author
	James Lewis
#>

#set script to stop on error
$ErrorActionPreference = 'stop'

#variables
$zonename = "dnszonename"
$compName = "dnscomputername"

#prompt user for workstation ID
$WSID = Read-Host "Enter WorkstationID of destination machine"

#check if WSID is blank
if($WSID -eq "") 
{
    Write-Host "WorkstationID is blank"
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

#check if PC exists in AD and is enabled.
try 
{
    $device = Get-ADComputer -Filter "Enabled -eq 'True'" $WSID
    Write-Host "Checking if device exists"
    if ($device.enabled eq "True") 
    {
        Write-Host "found $device"    
    }
}
catch
{
    Write-Host "Failed to find device" -ForegroundColor Red
    $failfinddevice = $_
    Write-Host $failfinddevice
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}


#find DNS record and remove from target machine
try 
{
    $srcRec = Get-dnsserverresourcerecord -zonename $zonename -computername $compName -name $WSID
    Write-Host "Checking for Dns record" -ForegroundColor DarkGreen
    
    #if dns record found ask to remove
    if($srcRec.record -eq "")
    {
        Write-Host "found record"
        $input = Read-Host "Do you want to remove record? type 'y or n'"
        if ($input -eq "y") 
        {
            #attempt to remove record
            Remove-DnsServerResourceRecord -Zonename $zonename -computername $compName -RRType A -name $WSID
            Write-Host "attempting to remove record"
            ipconfig /registerdns
        }
        else 
        {
            Write-Host "aborting operation"
            Read-Host -Prompt "Press enter to exit"
            Exit
        }
    }

}
catch 
{
    Write-Host "Failed to find Dns Record `n" -ForegroundColor Red
    $failfindrecord = $_
    Write-Host $failfindrecord -ForegroundColor Red
    Read-Host -Prompt "Press Enter to Exit" 
    Exit
}

Read-Host -Prompt "Press Enter to Exit"
Exit
