<#
.Synopsis
	Call Github Script Directly
.Description
    Call Github directly from Repo
.Author
	James Lewis
#>


#pull app removal script
Invoke-WebRequest -Uri https://raw.githubusercontent.com/supercam/greybox/main/homelab_platform/powershell/dev_nonProd/appRemoval_001.ps1 -OutFile .\appRemoval_001.ps1; .\appRemoval_001.ps1