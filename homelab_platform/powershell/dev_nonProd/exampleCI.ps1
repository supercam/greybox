<#
.Synopsis
    example CI script with GitHub Actions
.Description
    example script used in CI GitHub Actions pipeline
.Author
    James Lewis
#>

param(
    [Switch]$Fail
)

if ($Fail) {
    throw "This script fails!"
}

$thanks = "Thank you for watching"

Write-Host "This script was called by GitHub Actions"

$thanks