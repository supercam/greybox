<#
.Synopsis
	export list of groups with info such as name / group members / owner
.Description
    Assumes AD module is installed otherwise it will try to get it
    Exports CSV with list of all groups and the name / gruup members / owner / type of group
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string]$csvLocation = "$env:SystemDrive\Temp\grpList001-$(Get-Date -Format yyyy-MM-dd-hh-mm).csv", #destination where csv lands.

    [parameter(mandatory = $false)]
    [string]$smbShareLocation = "\\server\share\path\grpList001-$(Get-Date -Format yyyy-MM-dd-HH-mm).csv", # SMB share path

    [parameter(mandatory = $false)]
    [string[]]$grpProperties = @("DisplayName", "Description", "ManagedBy", "GroupCategory", "GroupScope"),

    [parameter(mandatory = $false)]
    [bool]$jobGrpExportComplete = $false, #checks if group export job was completed.

    [parameter(mandatory = $false)]
    [bool]$moduleChk = $false, #checks for AD module.

    [parameter(mandatory = $false)]
    [bool]$smbChk = $false, #checks to upload to smb Share

    [parameter(mandatory = $false)]
    [bool]$credsChk, #checks if creds need to be entered

    [parameter(mandatory = $false)]
    [bool]$secCredsChk, #checks for mapping to secured credentials

    [parameter(mandatory = $false)]
    [string]$secCredsPath = "$env:SystemDrive\Temp" #path to secured credentials

)

#set script to stop on error
$ErrorActionPreference = 'silentlyContinue'

#variables
$groups = @() #empty array for group info


#attempt to get ActiveDirectory Module
if ($moduleChk -eq $true)
{
    Try
    {
        if (Get-Module -ListAvailable -Name ActiveDirectory) 
        {
             Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "AD module already exists."
        } 
        else 
        {
            Import-Module ActiveDirectory
        }
    }
    catch
    {
        Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to get AD module."
        $failModule = $_
        Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) $failModule
        Exit
    }
}

#attempt to get Credentials
Try
{
    if ($credsChk -eq $true)
    {
        $Creds = Get-Credential
    }
    
}
catch
{
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to Auth module."
    $failAuth = $_
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth
    Exit
}


#attempt to get sec Credentials
Try
{
    if ($secCredsChk -eq $true)
    {
        $secCredsXml = Import-Clixml -Path $secCredsPath
        Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Found secured credentials path."
    }
    
}
catch
{
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to find secured credentials."
    $failAuth = $_
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth
    Exit
}

#get list of groups and export to CSV

Try
{
    $groups = Get-ADGroup -Filter * -Properties $grpProperties
    
    #output log to C:\temp
    $groups | Select-Object $grpProperties | Export-CSV -Path $csvLocation -NoTypeInformation -Append
 
    #mark job complete
    $jobGroupExportComplete = $true
}
Catch
{
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to export Groups."
    $failGroupExport = $_
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) $failGroupExport
    Exit
}


if ($smbChk -eq $true)
{
    Try
    {
        # Copy the CSV to the SMB share
        Copy-Item -Path $csvLocation -Destination $smbShareLocation -Force
    }
    Catch
    {
        Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to upload Groups."
        $failGroupExport = $_
        Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) $failGroupExport
        Exit  
    }
}



#close out of job complete
if ($jobGroupExportComplete -eq $true) 
{
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Success, Group Export Complete."
    Exit
}

