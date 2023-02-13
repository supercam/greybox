# Managed Identity in AzureAD:

This project is about managing identity in Azure of small organization that is Pure Cloud.

Use Case:
Pure Cloud Identity and Access Management was the default standard of organization.  This did however lead to many problems such as:

* No on-prem Active Directory
* No group policy
* Smaller database of attributes to work with
* There is no LDAP
* Flat directory sturcture no OU's or forests

In order to address concerns around the identity the following areas had to be addressed.

-Single-Sign On using SAML

-Multi-Factor Authentication

-Conditional Access
creating basic layers of security to secure the login session when logging into cloud application

-User Lifecycle
90% of the time SCIM was used as part of user lifecycle to get the user in and out of cloud application.

Lessons Learned:

* Azure AD can't really replace AD and needs additional tools to be functional 