#interesting things I have noticed in PowerShell

#this clears errors and variables and resets error action
Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $error.Clear();