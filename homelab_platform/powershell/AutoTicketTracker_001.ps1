<#
.Synopsis
	Tracking Automation spreadsheet
.Description
	Spreadsheet to track automations, tracks tickets, timestamps, description
.Author
	James Lewis
#>

#capture input from user

$tktnum = Read-host -prompt "Please enter ticket number"
$tktdesc = Read-host -prompt "Please Enter Description"
$tkttime = Get-Date -format "hh:mm - tt"
$tktdate = Get-Date -format "dd-MM-yyyy"
$tktsaved = Read-host -prompt "Please Input time to complete task"


$autotkt =[pscustomobject]@{
	'Ticket Number' = $tktnum
	'Description' = $tktdesc
    'Date' = $tktdate
    'Time' = $tkttime
	'Time Saved' = $tktsaved
}


$autotkt | Export-CSV c:\temp\AutoTrackSheet_001.csv -Append -Force -NoTypeInformation