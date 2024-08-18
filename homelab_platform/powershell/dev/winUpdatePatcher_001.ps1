<#
.Synopsis
	Update windows using PSupdate Windows module
.Description
    Assumes PSWinUpdate module is installed otherwise it will try to get it
    Checks for update history and logs it
    if updates exist it will install them
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(

    [parameter(mandatory = $false)]
    [bool]$moduleChk = $false, #checks for module.

    [parameter(mandatory = $false)]
    [bool]$winUpdateHistory = $false, #check Update history.

    [parameter(mandatory = $false)]
    [bool]$jobGetListComplete = $false, #checks if job is done.

    [parameter(mandatory = $false)]
    [bool]$jobGetUpdateHistoryComplete = $false, #checks if get update history job is done.

    [parameter(mandatory = $false)]
    [int]$days = "7",

    [parameter(mandatory = $false)]
    [switch]$credsChk, #checks if creds need to be entered

    [parameter(mandatory = $false)]
    [switch]$secCredsChk, #switch for secured credentials

    [parameter(mandatory = $false)]
    [string]$secCredsPath = "$env:SystemDrive\Temp\adServObjLog.txt" #path to secured credentials

)

#set script to stop on error
$ErrorActionPreference = 'stop'

#variables
$adObjLog = "$env:SystemDrive\Temp\devicePatch001.txt"
$date = Get-Date
$cutOffDate = $date.AddDays(-($days)).ToString() #reach out to certain amount of days specified

#attempt to get PSWindowsupdate Module
if ($moduleChk)
{
    Try
    {
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate))
        {
            Install-Module -Name PSWindowsUpdate
            Import-Module -Name PSWindowsUpdate
        }
        else
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Module PSWindows Update is already installed" | Out-File -FilePath $adObjLog -Append
        }

    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to get module." | Out-File -FilePath $adObjLog -Append
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
        Write-Host "Ignore Auth"    
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
    else 
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to find secured credentials." | Out-File -FilePath $adObjLog -Append
        Exit    
    }
    
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to find secured credentials." | Out-File -FilePath $adObjLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $adObjLog -Append
    Exit
}


#Get all available updates if available
Try
{
    $updates = Get-WUlist -Name MicrosoftUpdate
    if ($updates)
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Updates are available." | Out-File -FilePath $adObjLog -Append
        $updates | ForEach-Object { Write-Output $_.Title | Out-File -FilePath $adObjLog -Append }

        #install updates
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

        #run check again to check for installed updates
        $updatesNew = Get-WUHistory | Where-Object { $_.ResultCode -eq 2 -and $_.Date -gt $cutOffDate } #check if they are installed

        if ($updatesNew)
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "New Updates were installed." | Out-File -FilePath $adObjLog -Append
            $updatesNew | ForEach-Object { Write-Output $_.Title | Out-File -FilePath $adObjLog -Append }
        }

        $jobGetListComplete = $true
    }
    else
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "No Updates available." | Out-File -FilePath $adObjLog -Append
    }
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to update." | Out-File -FilePath $adObjLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $adObjLog -Append
    Exit
}



#Check update history
Try
{
    if ($winUpdateHistory)
    {
        #check actual win update history
        $updateHistory = Get-WUHistory
        if ($updateHistory)
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Updates history found." | Out-File -FilePath $adObjLog -Append
            $updateHistory | ForEach-Object { Write-Output $_.Title | Out-File -FilePath $adObjLog -Append }
            
            $jobGetUpdateHistoryComplete = $true
        }
        else
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "There are no updates available." | Out-File -FilePath $adObjLog -Append
            $jobGetUpdateHistoryComplete = $true   
        }
    }
    else 
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to check update history." | Out-File -FilePath $adObjLog -Append    
    }

}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to get update history." | Out-File -FilePath $adObjLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $adObjLog -Append
    Exit
}



if ($jobGetListComplete -eq $true) 
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Device update job complete." | Out-File -FilePath $adObjLog -Append
    Exit
}

