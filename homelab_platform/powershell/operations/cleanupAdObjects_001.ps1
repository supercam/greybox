<#
.Synopsis
	Get List of stale objects
.Description
    Assumes AD module is installed.
    Gets list of Ad objects that are stale past a certain date
    exports to a .csv
    re-uses .csv to move objects into archive OU
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string[]]$ouList = @("OU=General,OU=Servers=OU,DC=Barrington,DC=net", "OU=Test,OU=Servers,DC=Barrington,DC=net"),

    [parameter(mandatory = $false)]
    [string]$archiveOU = "DC=Barrington,DC=net",

    [parameter(mandatory = $false)]
    [string]$adProperties = @("Name", "Enabled", "OperatingSystem"),

    [parameter(mandatory = $false)]
    [bool]$moveArchiveOU = $false, #default value do not move OU

    [parameter(mandatory = $false)]
    [int]$daysInactive = "365"

)

#set script to stop on error
$ErrorActionPreference = 'stop'

#attempt to get ActiveDirectory Module
Try
{
    Import-Module -Name ActiveDirectory
}
catch
{
    Write-Host "Failed to import module n" -ForegroundColor Red
    $failModule = $_
    Write-Host $failModule
    Read-Host "Press Enter to Exit"
    Exit
}

#variables
$SearchBase = "OU=Servers,DC=Barrington,DC=net"
$date = Get-Date
$time = $date.AddDays(-($daysInactive)).ToString() #reach out to certain amount of days specified
$sortedDevices = @() #1st pass sorted device array to be used outside of loop
#device list CSV's
$devicesCSV = "$env:SystemDrive\Temp\servers001-$(Get-Date -Format yyyy-MM-dd-hh-mm).csv"
$adObjLog = "$env:SystemDrive\Temp\adServObjLog-$(Get-Date -Format yyyy-MM-dd-hh-mm).txt"

#attempt to get list of devices
Try
{
    Write-Host "Attempting to get devices and totals. n" -ForegroundColor Green
    Foreach($ou in $ouList)
    {
        $devices = Get-ADComputer -Filter { OperatingSystem -like "*Windows Server*"
        -and Name -notlike "*DC01*"

        } -SearchBase $ou -Properties $adProperties

        #sort servers based on date
        $sortedServers += $devices | Where-Object {$_.LastLogonDate -lt $time}

        #output log to C:\temp
        $sortedDevicesAlt | Select-Object $adProperties | Export-CSV -Path $devicesCSV -NoTypeInformation -Append
    }
    Write-Host "List finished and saved to $devicesCSV n"
}
catch
{
    Write-Host "Failed to get list of servers n" -ForegroundColor Red
    $failDeviceList = $_
    Write-Host $failDeviceList
    Read-Host "Press Enter to Exit"
    Exit
}

#Move AD objects to archiveOU if called from parameter

if ($archiveOU)
{
    Try
    {
        $serverList = Import-CSV -Path $devicesCSV
        foreach($servers in $serverList)
        {
            Get-AdComputer $servers.Name | Move-AdObject -TargetPath $archiveOU
            Write-Host "Moving "$($servers.Name)" to $archiveOU" -ForegroundColor Green | Out-File -FilePath $adObjLog -Append
        }
    }
    catch
    {
        Write-Host "Failed to move AD object n" -ForegroundColor Red
        $failmoveAdObject | Out-File -FilePath $adObjLog -Append
        Read-Host "Press Enter to Exit"
        Exit
    }
}
Read-Host -Prompt "Press Enter to Exit"
Exit
