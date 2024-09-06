<#
.Synopsis
	update title and direct report and description
.Description
    Assumes AD module is installed otherwise it will try to get it
    Updates title and direct reports based on CSV
    Intended to be run in azure runbook
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string[]]$usrList = @("jjones@c3.com", "Jdonalds@c3.com", "abarker@c3.com"),

    [parameter(mandatory = $false)]
    [string[]]$titleArray = @("lead handler", "electrician", "officer"),

    [parameter(mandatory = $false)]
    [string]$titleColumn = "title",

    [parameter(mandatory = $false)]
    [string]$emailColumn = "email",

    [parameter(mandatory = $false)]
    [string]$directReportColumn = "directreport",

    [parameter(mandatory = $false)]
    [string]$descriptionColumn = "description",

    [parameter(mandatory = $false)]
    [string]$csvLocation = "$env:SystemDrive\Temp\usrList.csv", #checks if csv is created.

    [parameter(mandatory = $false)]
    [bool]$jobChgTitleComplete = $false, #checks if title change job was completed.

    [parameter(mandatory = $false)]
    [bool]$moduleChk = $false, #checks for AD module.

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




#import CSV and then update title and direct report.

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



#get the CSV and change the title and direct reports

$titleList = Import-Csv -Path $csvLocation -Delimiter ","


#write for each user

Try
{
    ForEach ($title in $titleList)
    {
        $email = $user.$emailColumn
        $title = $user.$titleColumn
        $directReport = $user.$directReportColumn
        $description = $user.$descriptionColumn


        Set-ADUser -Identity $email -Title $title -Description $description -DirectReports $directReport -Credential $Creds
        Write-Verbose "$(Get-Date -Format MM-dd-yyyy-hh-mm): Updated user $email"
    }

    #mark job complete
    $jobTitleChgComplete = $true
}
Catch
{
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to update title."
    $failTitle = $_
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) $failTitle
    Exit
}




#close out of job complete
if ($jobTitleChgComplete -eq $true) 
{
    Write-Verbose (Get-Date -Format MM-dd-yyyy-hh-mm) "Success, Server List Compliation Complete."
    Exit
}

