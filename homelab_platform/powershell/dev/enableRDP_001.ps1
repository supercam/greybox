<#
.Synopsis
	Enable RDP on remote device.
.Description
	Enable RDP on single targeted device, assumes that rdp was previously enabled but needs to be re-enabled due to changes
.Author
	James Lewis
#>

#set script to stop on error
$ErrorActionPreference = 'stop'

#get creds and store in psObject
$credentials = Get-Credential
$username = $credentials.username
$creds = New-Object System.Management.Automation.PSCredential $username, $credentials.password

#prompt user for workstation ID
$WSID = Read-Host "Enter WorkstationID of destination machine"

#check if WSID is blank
if($WSID -eq "") {
    Write-Host "WorkstationID is blank" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

#check for workstation heartbeat / ping
try {
    Write-Host "Checking if $WSID is Active"
    $Connection = Test-Connection $WSID -Count 1
    if($Connection.Buffersize -eq "32") 
    {
        Write-Host "$WSID is Active"
    }
}
catch
{
    Write-Host "Failed to find Device `n" -ForegroundColor Red
    $failfinddevice = $_
    Write-Host $failfinddevice -ForegroundColor Red 
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}


#auth session
try {
    Write-Host "Please enter credentials for remote Session"
    $Session = New-PSSession -ComputerName $WSID -Credential "Domain\"
}
catch {
    Write-Host "Failed to Auth. `n" -ForegroundColor Red 
    $failauth = $_
    Write-Host $failauth -ForegroundColor Red 
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

#Check status of RDP on device
try {
    Write-Host "checking status of RDP on $WSID"
    $WSIDRDP = Invoke-Command -ScriptBlock {Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fdenyTSConnections"} -Credential $creds -ComputerName $WSID
    if ($WSIDRDP.value -eq "1") {
        #set rdp value to 0
        Write-Host "RDP is disabled." -ForegroundColor Red
        Write-Host "Attempt to set RDP value to 0"
        Invoke-Command -ScriptBlock {Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fdenyTSConnections" -value 0} -Credential $creds -ComputerName $WSID
        $WSIDRDPsetval = Invoke-Command -ScriptBlock {Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fdenyTSConnections"} -Credential $creds -ComputerName $WSID
        if (WSIDRDPsetval.fDenyTSConnections -eq "0") {
            Write-Host "RDP value is set correctly"
        }
    }
    else {
        Write-Host "RDP value is set correctly, no action to take."
    }

    $WSIDFWRule = Get-NetFirewallRule -DisplayGroup "Remote Desktop"
    if ($WSIDFWRule.Enabled -eq "False") {
        Write-Host "Firewall rule is not enabled.  Enabling firewall rule"
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        #validate firewall rule
        $WSIDRDPsetFWRule = Get-NetFirewallRule -DisplayGroup "Remote Desktop"
        If($WSIDRDPsetFWRule.Enabled -eq "True")
            Write-Host "Firewall rule has been set."
    }
    else {
        Write-Host "firewall rule is set correctly, no action to take."
    }   
}
catch {
    Write-Host "Failed to set RDP value or firewall rule. `n" -ForegroundColor Red
    $failrdpset = $_
    Write-Host $failrdpset -ForegroundColor Red 
    Exit-PSSession
}

Read-Host -Prompt "Press Enter to Exit"
Exit
