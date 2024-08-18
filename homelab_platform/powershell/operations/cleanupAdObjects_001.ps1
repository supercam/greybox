<#
.Synopsis
	Get List of stale objects
.Description
    Assumes AD module is installed otherwise it will try
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
    [string[]]$adProperties = @("Name", "Enabled", "OperatingSystem"),

    [parameter(mandatory = $false)]
    [bool]$moveArchiveOU = $false, #default value do not move OU.

    [parameter(mandatory = $false)]
    [int]$daysInactive = "365",

    [parameter(mandatory = $false)]
    [bool]$jobGetListComplete = $false, #checks if csv is created.

    [parameter(mandatory = $false)]
    [bool]$jobMoveOuComplete = $false, #checks if move OU job was completed.

    [parameter(mandatory = $false)]
    [bool]$moduleChk = $false, #checks for AD module.

    [parameter(mandatory = $false)]
    [switch]$credsChk, #checks if creds need to be entered

    [parameter(mandatory = $false)]
    [switch]$secCredsChk, #checks for mapping to secured credentials

    [parameter(mandatory = $false)]
    [string]$secCredsPath = "$env:SystemDrive\Temp" #path to secured credentials

)

#set script to stop on error
$ErrorActionPreference = 'stop'

#variables
$date = Get-Date
$time = $date.AddDays(-($daysInactive)).ToString() #reach out to certain amount of days specified
$sortedDevices = @() #1st pass sorted device array to be used outside of loop
#device list CSV's
$devicesCSV = "$env:SystemDrive\Temp\servers001-$(Get-Date -Format yyyy-MM-dd-hh-mm).csv"
$adObjLog = "$env:SystemDrive\Temp\adServObjLog.txt"

#attempt to get ActiveDirectory Module
if ($moduleChk)
{
    Try
    {
        if (Get-Module -ListAvailable -Name ActiveDirectory) 
        {
             Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "AD module already exists." | Out-File -FilePath $adObjLog -Append
        } 
        else 
        {
            Import-Module ActiveDirectory
        }
    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to get AD module." | Out-File -FilePath $adObjLog -Append
        $failModule = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failModule | Out-File -FilePath $adObjLog -Append
        Exit
    }
}

#attempt to get Credentials
Try
{
    if ($credsChk)
    {
        $Creds = Get-Credential
    }
    else 
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Credentials entered incorrectly." | Out-File -FilePath $adObjLog -Append
    }
    
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to Auth module." | Out-File -FilePath $adObjLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $adObjLog -Append
    Exit
}


#attempt to get sec Credentials
Try
{
    if ($secCredsChk)
    {
        $secCredsXml = Import-Clixml -Path $secCredsPath
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Found secured credentials path." | Out-File -FilePath $adObjLog -Append
    }
    
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to find secured credentials." | Out-File -FilePath $adObjLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $adObjLog -Append
    Exit
}


#attempt to get list of devices
Try
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Attempting to get devices and totals." | Out-File -FilePath $adObjLog -Append
    Foreach($ou in $ouList)
    {
        $devices = Get-ADComputer -Filter { OperatingSystem -like "*Windows Server*"
        -and Name -notlike "*DC01*"

        } -SearchBase $ou -Properties $adProperties

        #sort servers based on date
        $sortedServers += $devices | Where-Object {$_.LastLogonDate -lt $time}

        #output log to C:\temp
        $sortedDevices | Select-Object $adProperties | Export-CSV -Path $devicesCSV -NoTypeInformation -Append
    }
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "List finished and saved to $devicesCSV" | Out-File -FilePath $adObjLog -Append
    $jobGetListComplete = $true
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to get list of servers n" | Out-File -FilePath $adObjLog -Append
    $failDeviceList = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failDeviceList | Out-File -FilePath $adObjLog -Append
    Exit
}

#Move AD objects to archiveOU if called from parameter
if ($moveArchiveOU)
{
    Try
    {
        #import list that was generated previously
        $serverList = Import-CSV -Path $devicesCSV
        foreach($servers in $serverList)
        {
            #get the servers and move them into a new OU that has been specified
            Get-AdComputer $servers.Name | Move-AdObject -TargetPath $archiveOU
            #Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Moving "$($servers.Name)" to $archiveOU." | Out-File -FilePath $adObjLog -Append
        }

        #mark OU job move as complete
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Finished moving AD objects to Archive OU" | Out-File -FilePath $adObjLog -Append
        $jobMoveOuComplete = $True

    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to move AD object" | Out-File -FilePath $adObjLog -Append
        $failmoveAdObject = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failmoveAdObject | Out-File -FilePath $adObjLog -Append
        Exit
    }
}


if ($jobGetListComplete -eq $True) 
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Success, Server List Compliation Complete." | Out-File -FilePath $adObjLog -Append
    Exit
}

if ($jobMoveOuComplete -eq $True) 
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Success, Stale Server AD Objects Complete." | Out-File -FilePath $adObjLog -Append
    Exit
}

