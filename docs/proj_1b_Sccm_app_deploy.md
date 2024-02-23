# System Center Configuration Manager Application Deployments:

This project is about System Center Configuration Manager(SCCM) Application Deployments:

Use Case:

Ongoing work organization had to deploy software packages into organization.
This largely speaks from the perspective of Corporate Workstation deployments and not servers.  Info about servers will be mentioned in "Servers"


Application Deployment Summary:

* Create an application
	* Application should have an MSI from vendor.
	* Install / uninstall batch script.
	* Batch script should contain a line that outputs a log file if applicable.
	* Icon.
* Settings to fill out
	* Description / Product / Name.
	* Deployment Type.
	* Specify that a script is loaded that contains information from create an application step.
	* Set Detection Method.  This would be using .msi product code or file version.
	* Specify content location.
* Create Test Collection (list of devices)
	* Create rules based on limiting collection and membership to add devices.
	* Deploy to test collection.
	* Validate program installs.
	* Validate device is in collection.
	* Check in software center that application shows up on device.
	* Check installation log / Appenforce.log to see if application was detected / installed.
* Change Management 
	* File a change request for deployment.
	* Describe what is being changed.
	* Add what has been tested to test plan.
	* Set a deployment window (if deployment does not go well roll back based on backout plan).
	* Add a backout plan if things do not go well.
	* If deployment does not go well outside of deployment window file a new change to roll back previous change.
* Deployment to production
	* Deploy the application within the window from Change Request.


Operating System(OS) Patching:
Typically for an organization two updates would be needed for corporate workstations.
Microsoft releases updates on "Patch Tuesday" 2nd Tuesday of each month.

* Cumulative Update
* Malicious Software tool

(Servers)
For servers these might be broken up into patch groups to patch them at different times.  This is delegated to the server owner to allow them to manage the server as needed.  Additional patching may be needed depending on whether the server owner received a report from InfoSec or Vulnerability Team.  These typically come in the form of qualys reports.

Logs to be aware of for Applications:

* Appenforce.log
* AppDiscovery.log
* Policy.log
* Log from Software installation, this would come from the batch scripts to call the .msi

Logs to be aware of for Software Updates:

* Windows-update.log (get from using get-windowsupdate)
* WuaHandler.log
* UpdatesDeployment.log
* UpdatesHandler.log

Cycles:

Cycles can be ran to help flush the sensors that the SCCM client uses to communicate with the SCCM server.

Commonly used cycles:

* Software Inventory Cycle
* Application Deployment Evaluation Cycle
* Discovery Data Collection Cycle
* Machine Policy Retrieval Cycle & Evaluation Cycle
* User Policy Retrieval Cycle
* Hardware Inventory Cycle
* Software Updates Deployment Evaluation Cycle
* Software Updates Scan Cycle


Lessons Learned:

* Deployments should be tested thoroughly for success, SCCM is very slow so changes will take time to propagate.
* Be aware of using cycles to help flush the filters so Software Center can check for new applications.
* Check logs for error codes and status updates.