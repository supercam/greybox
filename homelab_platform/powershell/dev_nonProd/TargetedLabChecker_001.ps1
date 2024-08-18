<#

Targeted device checker for homelab

Checks to see if computer/server/website is reachable by ping

#needs more polish but has basic framework to act as monitoring agent for devices in Homelab

#>

#Set Error action
$ErrorActionPreference = "SilentlyContinue"

#use readhost to obtain server list
$device = Read-Host "Provide name of device"

#getdate
$DateTime = Get-Date
$DownSince = ""


#attempt to ping device and provide status
Try
{
#test device connection
    #check for bytes at 32, if you recieve 32 packets, then that tells you machine has recieved ping.
    Write-Host "Testing Connection" -ForegroundColor Green
    $deviceConnection = Test-Connection $device -Count 1
    if($deviceConnection.BufferSize -eq "32")
    {
        Write-Host "$device is still online" -ForegroundColor Green
        if($deviceConnection.BufferSize -ne "32")
        {
            Write-Host "$device is now online" -ForegroundColor Green
        }
    }
    else
    {
        if($deviceConnection.BufferSize -eq "32")
        {
            Write-Host "$device is now offline" -ForegroundColor Red
            $Device.DownSince = $DateTime
        }
        else
        {
            Write-Host "$device is still offline" -ForegroundColor Red
        }
    }
}
catch
{
    Write-Host "Failed to ping device" -ForegroundColor Red
    Write-Host "$device is offline" -ForegroundColor Red
}

#write output to path
$path = "E:\projFolderCode\greybox\homelab_platform\powershell"
$logname = "devicestatus_001.txt"

Write-Host "writing log to path" -ForegroundColor Green
$deviceConnection | Out-File -FilePath "E:\projFolderCode\greybox\homelab_platform\powershell\devicestatus.txt" -Append

Write-Host "Writing log to path complete" -ForegroundColor Green