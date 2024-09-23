<#
.Synopsis
	Call Github Script Directly
.Description
    Call Github directly from Repo or use download + new object to store script in file.
.Author
	James Lewis
#>

#script to download scripts directly from github and run via a bypass.
$url = https://raw.githubusercontent.com/ansible/ansible-documentation/ae8772176a5c645655c91328e93196bcf741732d/examples/scripts/ConfigureRemotingForAnsible.ps1
$file = $env:temp\ConfigureRemotingForAnsible.ps1

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

powershell.exe -ExecutionPolicy ByPass -File $file


#pull app removal script
Invoke-WebRequest -Uri https://raw.githubusercontent.com/supercam/greybox/main/homelab_platform/powershell/dev_nonProd/appRemoval_001.ps1 -OutFile .\appRemoval_001.ps1; .\appRemoval_001.ps1