<#
.Synopsis
	Remove Applications
.Description
    Removes MS apps
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(

    [parameter(mandatory = $false)]
    [string[]]$appList = @("microsoft.zune"
    "microsoft.bingweather"
    "microsoft.microsoftsolitairecollection"
    "microsoft.microsoft3dviewer"
    "microsoft.office.onenote"
    "microsoft.wallet"
    "microsoft.zunevideo"
    "microsoft.zunemusic"
    "microsoft.yourphone"
    "microsoft.people"), #list of apps to remove.

    [parameter(mandatory = $false)]
    [bool]$jobGetListComplete = $false, #checks if csv is created.

    [parameter(mandatory = $false)]
    [bool]$credsChk, #checks if creds need to be entered

    [parameter(mandatory = $false)]
    [bool]$secCredsChk, #checks for mapping to secured credentials

    [parameter(mandatory = $false)]
    [string]$secCredsPath = "$env:SystemDrive\Temp" #path to secured credentials

)


#set script to stop on error
$ErrorActionPreference = 'stop'

#variables
$rmAppLog = "$env:SystemDrive\Temp\rmAppLog.txt"

#attempt to get Credentials
Try
{
    if ($credsChk -eq $true)
    {
        $Creds = Get-Credential
    }
    else 
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Ignore Auth Check." | Out-File -FilePath $rmAppLog -Append  
    }
    
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to Auth module." | Out-File -FilePath $rmAppLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $rmAppLog -Append
    Exit
}


#attempt to get sec Credentials
Try
{
    if ($secCredsChk -eq $true)
    {
        $secCredsXml = Import-Clixml -Path $secCredsPath
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Found secured credentials path." | Out-File -FilePath $rmAppLog -Append
    }
    else 
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Ignore secCredsChk" | Out-File -FilePath $rmAppLog -Append   
    }
    
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to find secured credentials." | Out-File -FilePath $rmAppLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $rmAppLog -Append
}


#start removal of applications

Try
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Start App Removal Job." | Out-File -FilePath $rmAppLog -Append
    $rmAppCmd = Get-AppXPackage | where-object {$_.name -in $appList }
    foreach ($app in $rmAppCmd)
    {
        $app | Remove-AppxPackage
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "removed $app.name" | Out-File -FilePath $rmAppLog -Append
    }

    #if job successfull mark complete
    $jobGetListComplete = $True
}
catch
{
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to remove application " | Out-File -FilePath $rmAppLog -Append
        $failModule = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failModule | Out-File -FilePath $rmAppLog -Append
        Exit
}

if ($jobGetListComplete -eq $True) 
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Success, Removed Apps. Exiting" | Out-File -FilePath $rmAppLog -Append
    Exit
}

