# Supercam Homelab

This project is meant to demonstrate the use of a Continuous Integration / Continuous Deployment pipeline. It is part of a homelab project

## Overview
Lab Status: **ALPHA**

The homelab is still in experimental stage but still acts a showcase of projects.  It also allows room to practice and learn different technologies that can be used in various orgs.


## [Portfolio](https://supercam.github.io/greybox/)


## Tech Stack

| Tech Stack | Description |
| --- | --- |
| Ansible / Puppet | Configuration Management |
| MS AD | Active Directory |
| ADFS | Identity |
| Cloudflare | Remote Access with SSL |
| Proxmox | Virtual Machines |
| TrueNAS | Storage |
| Asustor NAS | Storage |
| Sunshine / Moonlight | Remote GPU Display |
| Parsec | Remote GPU Display |
| Perforce | Version Control |
| Github | Version Control |
| Keepass / Bitwarden | Password Management |
| Fortinet Firewall | Network / Netsec |
| Jira | Project Management |
| Confluence | Documentation |
| Zabbix | Monitoring |
| Powershell | [Script Portfolio](https://github.com/supercam/greybox/tree/main/homelab_platform/powershell) |

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
