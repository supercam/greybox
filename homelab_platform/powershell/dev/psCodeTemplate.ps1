<#
.Synopsis
	Template for scripts
.Description
	Template to write scripts and speed up workflow
.Author
	James Lewis
#>


[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string[]]$ouList = @("OU=General,OU=Servers=OU,DC=Barrington,DC=net", "OU=Test,OU=Servers,DC=Barrington,DC=net"),

    [parameter(mandatory = $false)]
    [bool]$jobGetListComplete = $false, #checks if csv is created.

    [parameter(mandatory = $false)]
    [string]$logPath = "$env:SystemDrive\Temp\Log001.txt",

    [parameter(mandatory = $false)]
    [string]$secCredPath = "$env:SystemDrive\Temp\secCred.xml",

    [parameter(mandatory = $false)]
    [bool]$credsChk = $false #checks if creds need to be entered

)


#Set Error Action Preference
$ErrorActionPreference = 'stop'

#Variables Placeholder
$testVar = "fear"

#attempt to get Modules this is placeholder for any module that you want to add.
if ((Get-Module).Name -notContains "ActiveDirectory")
{
    Try
    {
        Write-Verbose "Attempting to get AD module" -Verbose
        Import-Module -name ActiveDirectory
    }
    catch
    {
        Write-Verbose "Failed get Module" -Verbose
        $fail = $_
        Write-Error $fail -Verbose
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $fail | Out-File -FilePath $logPath -Append
        throw $fail
    }
}
else
{
    Write-Verbose "Active Directory module already added" -Verbose
}


#attempt to get Credentials placeholder, assumes xml is used
Try
{
    if ($credsChk = $true)
    {
        $secCreds = Import-Clixml -Path $secCredPath
    }
    if ($credsChk = $false) 
    {
        $secCreds = Get-Credential   
    }
    
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to Auth." | Out-File -FilePath $Log001 -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $Log001 -Append
    Exit
}

#Actual Code block
Try
{
    #do Something    
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to do something." | Out-File -FilePath $Log001 -Append
    $failJob = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failJob | Out-File -FilePath $Log001 -Append
    Exit
}