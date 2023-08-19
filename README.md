# Supercam Homelab

This project is meant to demonstrate the use of a Continuous Integration / Continuous Deployment pipeline. It is part of a homelab project

## Overview
Lab Status: **ALPHA**

The homelab is still in experimental stage but still acts a showcase of projects.  It also allows room to practice and learn different technologies that can be used in various orgs.


| Tech Stack | Description |
| --- | --- |
| Ansible | Configuration Management |
| Cloudflare | Remote Access |
| Proxmox | Virtual Machines |
| TrueNAS | Storage |
| Sunshine / Moonlight | Remote Display |
| Perforce | Version Control |
| Keepass | Credentials |
| Powershell | Codebase |

## Roadmap

- **Virtualization**
- [x] Setup Proxmox
- [ ] Virtualize all services
- [ ] Right-size vm services

- **Storage**
- [x] Setup TrueNas
- [ ] Setup zfs pool Raid Mirror
- [ ] Setup Domain services
- [ ] Setup Alerting an storage service

- **Backup Disaster / Recovery**
- [ ] Setup TrueNas
- [ ] Setup NAS
- [ ] Write Script to copy data on scheduled basis
- [ ] backup VM configurations to NAS
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

- **Configuration Management**
- [ ] Setup Ansible
- [ ] Setup Powershell DSC
- [ ] Setup Chocalatey
- [ ] Setup playbooks for Windows VM creation and app deployment


## License
Copyright © 2023 - Supercam Labs
Distributed under MIT License.  See `license.md`
