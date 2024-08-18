<#
.Synopsis
	Create Secure Credential
.Description
	Has option for xml or pscredential
.Author
	James Lewis
#>


[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string]$secCredPathXml = "$env:SystemDrive\Temp\secCred.xml", #path for xml

    [parameter(mandatory = $false)]
    [string]$logPath = "$env:SystemDrive\Temp\Log001.txt",

    [parameter(mandatory = $false)]
    [switch]$UseSecCredsXml, #use for XML

    [parameter(mandatory = $false)]
    [string]$secCredsXml, #use for XML

    [parameter(mandatory = $false)]
    [bool]$secCredsXmlJobComplete = $false #mark job complete

)

#Set Error Action Preference
$ErrorActionPreference = 'stop'


#attempt to get Credentials
Try
{
    if ($UseSecCredsXml)
    {

        #get Credential
        Write-Verbose "Please enter credential" -Verbose
        $secCredsXml = Get-Credential 

        #export Credential
        Write-Verbose "Exporting Credential" -Verbose
        $secCredsXml | Export-Clixml -Path $secCredPath

        $secCredXmlJobComplete = $True
    }
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to output XML." | Out-File -FilePath $Log001 -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $Log001 -Append
    Read-Host "Press any key to exit"
    Exit
}



if ($secCredsXmlJobComplete = $true)
{
    Write-Verbose "XML Credentials created and stored at $secCredPathXml" -Verbose
    Read-Host "Press any key to exit"
    Exit
}
