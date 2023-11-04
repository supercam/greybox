# Supercam Homelab

This project is meant to demonstrate the use of a Continuous Integration / Continuous Deployment pipeline. It is part of a homelab project

## Overview
Lab Status: **ALPHA**

The homelab is still in experimental stage but still acts a showcase of projects.  It also allows room to practice and learn different technologies that can be used in various orgs.


## [Portfolio](https://supercam.github.io/greybox/)


## Tech Stack

| Tech Stack | Description |
| --- | --- |
| Ansible | Configuration Management |
| Cloudflare | Remote Access |
| Proxmox | Virtual Machines |
| TrueNAS | Storage |
| Asustor NAS | Storage |
| Sunshine / Moonlight | Remote GPU Display |
| Perforce | Version Control |
| Keepass / Bitwarden | Credentials |
| Fortinet Firewall | Network / Netsec |
| Jira | Project Management |
| Confluence | Documentation |
| Powershell | [Script Portfolio](https://github.com/supercam/greybox/tree/main/homelab_platform/powershell) |

## Roadmap

- **Virtualization**
- [x] Setup Proxmox
- [ ] Virtualize all services
- [ ] Right-size vm services

- **Storage**
- [x] Setup TrueNas
- [x] Setup zfs pool Raid Mirror
- [ ] Setup Domain services
- [x] Setup Alerting an storage service

- **Backup Disaster / Recovery**
- [x] Setup TrueNas
- [x] Setup External NAS
- [ ] Write Script to copy data on scheduled basis
- [x] backup VM configurations to NAS
- [ ] Test reloading VM configurations in proxmox

- **Networking**
- [ ] Setup VPN
- [ ] Setup DHCP
- [ ] Setup DNS
- [ ] Setup VLANS

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
- [ ] Move Credentials to Keepass
- [ ] Move 2FA to Bitwarden / Aegis
- [ ] Research Microsoft AD vs OpenLDAP vs SAMBA


## License
Copyright © 2023 - Supercam Labs
Distributed under MIT License.  See `license.md`
