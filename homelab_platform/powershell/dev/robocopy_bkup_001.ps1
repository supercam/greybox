<#
.Synopsis
	Copy file to another location with robocopy
.Description
	Use robocopy to transfer files from src to dst
.Author
	James Lewis
#>


$ErrorActionPreference = 'stop'

#Options
$srcDir = "D:\bulkbackup"
$dstDir = "NasSvc\05_backups"
$dstHostname = "rdsnas-001"
$robocopyoptions = "/e /r:1 /w:0 /COPY:DAT /DCOPY:DAT /mt:10 /z" 
$LogPath = "C:\temp\robocopy_001.log"
$rootFolderName = $inRoot

#IPC connection
$IPCUser = $inUser
$IPCPwd = $inPWD

#Attempt to get username/auth
Try
{
	$inUser = Read-Host "Enter Name for account"
	$inPWD = Get-Content C:\temp\pwdtemp.txt
	NET USE \\$dstHostname\IPC$ /user:$IPCUser $IPCPwd
}
catch
{
	Write-Host "Failed to Auth.`n" -ForegroundColor Red 
    $failauth = $error[0]
    Write-Host $failauth -ForegroundColor Red
    NET USE IPC$ /D
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

Write-Host "Auth Successful" -ForegroundColor DarkGreen

#Attempt to make root folder
Try
{
	$inRoot = Read-Host "Enter Name for root folder"
	md \\$dstHostname\$dstDir\$rootFolderName
}
catch
{
	Write-Host "Failed to make root folder.`n" -ForegroundColor Red 
    $failrootfolder = $error[0]
    Write-Host $failrootfolder -ForegroundColor Red 
    NET USE \\$dstHostname\IPC$ /D
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

Write-Host "Successfully made root folder" -ForegroundColor DarkGreen

#Attempt to copy attribute to root folder
Try
{
	robocopy $srcDir\ \\$dstHostname\$dstDir\$rootFolderName /DCOPY:T /LOG+:$LogPath
}
catch
{
	Write-Host "Failed to copy attributes to root folder. `n" -ForegroundColor Red
    $failrootattribute = $error[0]
    Write-Host $failrootattribute -ForegroundColor Red 
    NET USE \\$dstHostname\IPC$ /D
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

Write-Host "Successfully copied root attribute" -ForegroundColor DarkGreen

#Attempt to copy folder contents to root folder
Try
{
	robocopy $srcDir\ \\$dstHostname\$dstDir\$rootFolderName /e /r:1 /w:0 /COPY:DAT /DCOPY:DAT /mt:10 /z /np /eta /LOG+:$LogPath
}
catch
{
    Write-Host "Failed to copy to files root folder. `n" -ForegroundColor Red 
    $failrobocopy = $error[0]
    Write-Host $failrobocopy -ForegroundColor Red 
    NET USE \\$dstHostname\IPC$ /D
    Read-Host -Prompt "Press Enter to Exit"
    Exit
}

Write-Host "Successfully copied files" -ForegroundColor DarkGreen
NET USE \\$dstHostname\IPC$ /D