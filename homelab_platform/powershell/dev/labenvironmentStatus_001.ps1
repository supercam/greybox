<#

Environment checker
Baseline concept to check environment
script is mostly redundant due to new relic

Checks to see if computer/server/website is reachable by ping

#needs more polish but has basic framework to act as monitoring agent for devices in Homelab
#eventually want to run this as a scheduled task on a VM to monitor the lab environment

#>

$ErrorActionPreference = "SilentlyContinue"


#point to file containing servers
$serverListFilePath = "E:\projFolderCode\greybox\homelab_platform\powershell\envChecker.csv"

$ServerList = Import-Csv -Path $serverListFilePath -Delimiter ","

$Export=[System.Collections.ArrayList]@()
foreach($Server in $ServerList)
{
    $ServerName = $Server.ServerName
    $LastStatus = $Server.LastStatus
    $DownSince = $Server.DownSince
    $LastDownAlert = $Server.LastDownAlertTime
    
    $Connection = Test-Connection $Server.ServerName -Count 1
    $DateTime = Get-Date

    if($Connection.Buffersize -eq "32")
    {
        Write-Host "$ServerName is still online"
        if($LastStatus -ne "32")
        {
            $Server.DownSince = $null
            $Server.LastDownAlertTime = $null
            Write-Host "$ServerName is now online"
        }
    }
    else
    {
        if($LastStatus -eq "32")
        {
            Write-Host "$ServerName is now offline"
            $Server.DownSince = $DateTime
            $Server.LastDownAlertTime = $DateTime
        }
        else
        {
            $DownFor = $((Get-Date -Date $DateTime) - (Get-Date -Date $DownSince)).TotalDays
            $SinceLastDownAlert= $((Get-Date -Date $DateTime) - (Get-Date -Date $LastDownAlert)).TotalDays
            if(($DownFor -ge 1) -and ($SinceLastDownAlert -ge 1))
            {
                Write-Host "It has been $SinceLastDownAlert days since last alert"
                Write-Host "$ServerName is still offline for $DownFor days"
                $Server.LastDownAlertTime = $DateTime
            }
            
        }
    }

    $Server.LastStatus = $Connection.Buffersize
    $Server.LastCheckTime = $DateTime
    [void]$Export.Add($Server)
}

$Export | Export-CSV -Path $serverListFilePath -Delimiter "," -NoTypeInformation

