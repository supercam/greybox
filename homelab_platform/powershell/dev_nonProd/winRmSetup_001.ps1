<#
.Synopsis
	Setup WinRM on host windows device
.Description
    Runs commands to automatically setup winRM on remote windows VM
    cmd line usage example: .\winRmSetup_001.ps1 -logging $true -trustHosts $true
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string[]]$vmList = @("172.16.0.12","172.16.0.13"),

    [parameter(mandatory = $false)]
    [bool]$setvmList = $false, #default value to not update Trust host.

    [parameter(mandatory = $false)]
    [bool]$jobWinRmSetupComplete = $false, #checks if job complete.

    [parameter(mandatory = $false)]
    [bool]$jobWinRmTrustHostComplete = $false, #checks if trusted host job complete.

    [parameter(mandatory = $false)]
    [bool]$trustHosts, #job for setting up trusted hosts on Control PC

    [parameter(mandatory = $false)]
    [bool]$winRmSetup, #job for setting up setting up winrm on remote VM

    [parameter(mandatory = $false)]
    [bool]$logging #sets up logging and checks for temp folder.
)

#set script to stop on error
$ErrorActionPreference = 'stop'

#variables
$winRmLog = "$env:SystemDrive\Temp\winRmLog.txt"

#convert array to string
$vmListStr = $vmList -join ","


#attempt to setup logging by checking for temp directory, if it doesn't exist it will create it.
if ($logging -eq $true)
{
    Try
    {
        if (test-path "$env:SystemDrive\temp") 
        {
             Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Path already exists." | Out-File -FilePath $winRmLog -Append
        } 
        else 
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Writing temp directory." | Out-File -FilePath $winRmLog -Append
            #New-Item -Path "$env:SystemDrive\Temp" -ItemType Directory | Out-Null
        }
    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to create path for logging." | Out-File -FilePath $winRmLog -Append
        $failDir = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failDir | Out-File -FilePath $winRmLog -Append
        Exit
    }
}



#setup WinRM
if ($winRmSetup -eq $true)
{
    Try
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Attempt to setup WinRm on main device." | Out-File -FilePath $winRmLog -Append
        winrm quickconfig
        Start-Service -Name WinRM
        Set-Service -Name WinRM -StartupType Automatic

        #validate service is running
        Try
        {
            $winRmSvc = Get-Service -Name WinRM
            if($winRmSvc.status -eq 'Running')
            {
                Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "WinRM Service is Running and Setup." | Out-File -FilePath $winRmLog -Append
                $jobWinRmSetupComplete -eq $True
            }
        }
        catch
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to setup WinRm Service." | Out-File -FilePath $winRmLog -Append
            $failWinRm = $_
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failWinRm | Out-File -FilePath $winRmLog -Append
            Exit
        }
    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to setup WinRM." | Out-File -FilePath $winRmLog -Append
        $failWinRm = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failWinRm | Out-File -FilePath $winRmLog -Append
        Exit
    }
}


#trusted hosts setup needs to be ran on main device
if ($trustHosts -eq $true)
{
    Try
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Attempt to add Trusted Hosts on main device." | Out-File -FilePath $winRmLog -Append
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value $vmListStr
        #validate that trusted hosts file was updated.
        Try
        {
            $hostVal = Get-Item WSMan:\localhost\Client\TrustedHosts
            if($hostVal.value -eq $vmListStr)
            {
                Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Trusted Hosts added to Control device." | Out-File -FilePath $winRmLog -Append
                $jobWinRmTrustHostComplete -eq $True
            }
        }
        catch
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to validate updating of Trusted hosts file." | Out-File -FilePath $winRmLog -Append
            $failWinRm = $_
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failWinRm | Out-File -FilePath $winRmLog -Append
            Exit
        }
    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to update trusted hosts file." | Out-File -FilePath $winRmLog -Append
        $failWinRm = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failWinRm | Out-File -FilePath $winRmLog -Append
        Exit
    }
}


#if jobs marked as complete mark in log
if ($jobWinRmSetupComplete -eq $True) 
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Success, WinRm setup is complete." | Out-File -FilePath $winRmLog -Append
    Exit
}

if ($jobWinRmTrustHostComplete -eq $True) 
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Success, WinRm Trusted Host update is complete." | Out-File -FilePath $winRmLog -Append
    Exit
}