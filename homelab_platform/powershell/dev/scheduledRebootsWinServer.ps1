<#
.Synopsis
	Notes for scheduled task
.Description
	Notes on scheduled tasks for windows server
.Author
	James Lewis
#>

<#
#scheduled task settings to be used for servers
1. Set the name
2. Set the description, format date / task
3. Set user to SYSTEM, run with highest privileges, configure for current version of windows server
Triggers:
1. set the frequency
2. Stop the task if more than 2 hours
3. set to enabled
Actions:
1. Start a program
2. Program Script: C:\Windows\System32\Shutdown.exe -args /r /f /t 900 /c "Please save your work"
Settings:
1. mark - Allow to be run on demand
2. mark - Stop task if runs longer than 2 hours
3. mark - If running task does not end when required force it to stop
4. If task is already running, check stop the existing instance

#>