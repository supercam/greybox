<#
.Synopsis
	Create Secure Credential
.Description
	Has option for xml or pscredential

    Additional notes to use secured credentials for a remote device with XML.
    $credential = Import-Clixml -Path "$env:SystemDrive\temp\credential.xml"
    $session = New-PSSession -ComputerName "IP" -Credential $credent
    Enter-pssession -Session $session

    Method to do this with secure-string
    $usrName = "randomuser"
    $remotePassword = "RandomPassword"
    $securePassword = ConvertTo-SecureString -String $remotePassword -AsPlainText -Force
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $usrName, $securePassword
    $session = New-PSSession -ComputerName DestinationIP -Credential $credential
    Enter-PSSession -Session $session 

    if unable to bypass via a session / set remote VM or device execution policy to remotesigned using set-executionpolicy
    remotesigned allows scripts to run locally but still requires external script validation

.Author
	James Lewis
#>


[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string]$secCredPathXml = "$env:SystemDrive\Temp\secCred.xml", #path for xml

    [parameter(mandatory = $false)]
    [bool]$logging, #for logging

    [parameter(mandatory = $false)]
    [bool]$useSecCredsXml, #use for XML

    [parameter(mandatory = $false)]
    [string]$secCredsXml, #use for XML pwd

    [parameter(mandatory = $false)]
    [bool]$secCredsXmlJobComplete = $false #mark job complete

)

#Set Error Action Preference
$ErrorActionPreference = 'stop'

#variables
$secXmlGenLog = "$env:SystemDrive\Temp\secXmlGenLog.txt"

#attempt to setup logging by checking for temp directory, if it doesn't exist it will create it.
if ($logging -eq $true)
{
    Try
    {
        if (test-path "$env:SystemDrive\temp") 
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Path already exists." | Out-File -FilePath $secXmlGenLog -Append
        } 
        else 
        {
            New-Item -Path "$env:SystemDrive\Temp" -ItemType Directory | Out-Null
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Writing temp directory." | Out-File -FilePath $secXmlGenLog -Append
        }
    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to create path for logging." | Out-File -FilePath $secXmlGenLog -Append
        $failDir = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failDir
        Exit
    }
}


#attempt to make path for credentials
if ($useSecCredsXml -eq $True)
{
    Try
    {
        if (test-path "$env:SystemDrive\temp")
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Path already exists." | Out-File -FilePath $secXmlGenLog -Append
        } 
        else
        {
            New-Item -Path "$env:SystemDrive\Temp" -ItemType Directory | Out-Null
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Writing temp directory." | Out-File -FilePath $secXmlGenLog -Append
        }
    }
    catch
    {
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to create path for logging." | Out-File -FilePath $secXmlGenLog -Append
        $failDir = $_
        Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failDir
        Exit
    }
}


#attempt to get Credentials
Try
{
    if ($useSecCredsXml -eq $True)
    {

        #get Credential
        Write-Verbose "Please enter credential" -Verbose
        $secCredsXml = Get-Credential 

        #export Credential
        Write-Verbose "Exporting Credential" -Verbose
        $secCredsXml | Export-Clixml -Path $secCredPathXml

        if (test-path $secCredPathXml)
        {
            Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Validated XML file exists" | Out-File -FilePath $secXmlGenLog -Append
            $secCredXmlJobComplete = $True
        }
    }
}
catch
{
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to output XML." | Out-File -FilePath $secXmlGenLog -Append
    $failAuth = $_
    Write-Output (Get-Date -Format MM-dd-yyyy-hh-mm) $failAuth | Out-File -FilePath $secXmlGenLog -Append
    Read-Host "Press any key to exit"
    Exit
}



if ($secCredsXmlJobComplete = $true)
{
    Write-Verbose "XML Credentials created and stored at $secCredPathXml" -Verbose
    Read-Host "Press any key to exit"
    Exit
}
