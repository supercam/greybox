# Managed Identity in AzureAD:

This project is about managing identity in Azure of small organization that is Pure Cloud.

Use Case:
Pure Cloud Identity and Access Management was the default standard of organization.  This did however lead to many problems such as:

* No on-prem Active Directory
* No group policy
* Smaller database of attributes to work with
* There is no LDAP
* Flat directory sturcture no OU's or forests
* No Active Directory services such as LDFS / ADFS / DNS / DHCP / Hyper-V / IIS

In order to address concerns around the identity the following areas had to be addressed.

- [x] Single-Sign On
	* [x] XML authenication to apps that have Azure plugin or no plugin
- [x] Multi-Factor Authentication
	* [x] 2FA code prompt
    * [x] Conditional Access
    * [x] User Lifecycle involving SCIM/JIT
    * [x] Azure MFA with modern authentication
- [x] Attribute Based Access Control (ABAC)
	* [x] Dynamic Security groups based on attributes
- [x] Priviledged Identity management
	* [x] Just-In-Time access to administrative permissions


Lessons Learned:

* Azure AD can't really replace AD and needs additional tools to be functional 
* Smaller database of attributes means hitting limits on attributes used in security groups
