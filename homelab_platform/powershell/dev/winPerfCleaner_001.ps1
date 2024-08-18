<#
.Synopsis
	Windows performance cleaner
.Description
    Uninstall apps via powershell
    disable search indexing
    disable auto starting programs
    remove temporary files
    disable background apps

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
    [switch]$credsChk #checks if creds need to be entered

)

#set script to stop on error
$ErrorActionPreference = 'stop'

#variables
$adObjLog = "$env:SystemDrive\Temp\devicePatch001.txt"

#attempt to get PSWindowsupdate Module
if ($moduleChk)
{
    Try
    {
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate))
        {
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


#Get all available updates if available
Try
{
    $updates = Get-WUlist -Name MicrosoftUpdate
    if ($updates)
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Updates are available." | Out-File -FilePath $adObjLog -Append
        $updates | ForEach-Object { Write-Output $._.Title | Out-File -FilePath $adObjLog -Append }

        #install updates
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

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
            $updateHistory | ForEach-Object { Write-Output $._.Title | Out-File -FilePath $adObjLog -Append }
        }
    }
    else 
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Unable to check update history." | Out-File -FilePath $adObjLog -Append    
    }

}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to update." | Out-File -FilePath $adObjLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $adObjLog -Append
    Exit
}



if ($jobGetListComplete -eq $true) 
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Device update job complete." | Out-File -FilePath $adObjLog -Append
    Exit
}

