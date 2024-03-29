# Supercam Homelab

This is documentation for Homelab:
The documentation is formally placed on supercam.github.io/greybox which demonstrates the use of a Continuous Integration / Continuous Deployment pipeline. 

## Overview
Lab Status: **ALPHA**

The homelab is still in experimental stage but still acts a showcase of projects.  It also allows room to practice and learn different technologies that can be used in various orgs.


## [Portfolio](https://supercam.github.io/greybox/)


## Tech Stack

| Tech Stack | Description |
| --- | --- |
| Ansible / Chef | Configuration Management |
| Terraform | Infrastrucure as Code |
| MS AD | Active Directory |
| ADFS | Identity and Access Management |
| Cloudflare | Remote Access with SSL |
| RustDesk / Remmina | RDP |
| Proxmox | Virtualization |
| TrueNAS | Storage |
| Asustor NAS | Storage |
| Sunshine / Moonlight | Remote Streaming |
| Parsec | Remote GPU Display |
| Perforce / Github | Version Control |
| Keepass / Bitwarden | Password Management |
| Fortinet Firewall | Network / Netsec |
| Jira | Project Management |
| Confluence | Documentation |
| Zabbix | Monitoring |
| Powershell | [Script Portfolio](https://github.com/supercam/greybox/tree/main/homelab_platform/powershell/operations) |

## Roadmap

- **Virtualization**
- [x] Setup Proxmox
- [ ] Right-size vm services
- [ ] Virtualize all services

- **Storage**
- [x] Setup TrueNas
- [x] Setup zfs pool Raid Mirror
- [ ] Setup Domain services
- [x] Setup Alerting an storage service
- [ ] Research DFS namespaces

- **Backup Disaster / Recovery**
- [x] Setup TrueNas
- [x] Setup External NAS
- [ ] Write Script to copy data on scheduled basis
- [x] backup VM configurations to NAS
- [x] Test reloading VM configurations in proxmox

- **Networking**
- [ ] Setup VLANS
- [ ] Setup VPN
- [ ] Setup DHCP
- [ ] Setup DNS

- **Game Development**
- [x] Setup Perforce
- [ ] Setup Hansoft
- [ ] Setup Game Engine
- [ ] Setup Remote Services
- [ ] Explore frontend and kiosk mode for locked down VM

- **Configuration Management**
- [ ] Setup Ansible
- [ ] Setup Powershell DSC
- [ ] Setup Chocalatey
- [ ] Setup playbooks for Windows VM creation and app deployment

- **Identity**
- Active Directory
- [ ] Setup Active Directory with Domain Controller
- [ ] Setup Group Policy
- [ ] Setup Replication on MSAD Domain Controller
- [ ] Setup Failover cluster with 2 nodes
- [ ] Research troubleshooting tools for domain controllers
- Samba 4
- [ ] Setup Samba4 on Debian server
- [ ] Setup LAMP server
- Credential Management
- [ ] Setup ADFS / Authentik
- [ ] Setup Password management via Keepass / Bitwarden
- [ ] Setup 2FA via 2FAS / Aegis

- **Monitoring**
- [ ] Setup Zabbix to handle monitoring of services
- [ ] Setup logging


## License
Copyright © 2023 - Supercam Labs
Distributed under MIT License.  See `license.md`
