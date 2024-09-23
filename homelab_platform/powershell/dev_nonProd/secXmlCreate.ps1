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
        Write-Error (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to create path for logging." | Out-File -FilePath $secXmlGenLog -Append
        $failDir = $_
        Write-Error (Get-Date -Format MM-dd-yyyy-hh-mm) $failDir
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
        Write-Error (Get-Date -Format MM-dd-yyyy-hh-mm) "Failed to create path for logging." | Out-File -FilePath $secXmlGenLog -Append
        $failDir = $_
        Write-Error (Get-Date -Format MM-dd-yyyy-hh-mm) $failDir
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
        $secCredsXml | Export-Clixml -Path $secCredPath

        $secCredXmlJobComplete = $True
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
