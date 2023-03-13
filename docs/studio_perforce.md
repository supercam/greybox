# Homelab Server with Perforce:

Use Case:
To create a file server for learning / homelab to do achieve the following:

* Have more storage rather than what is available on laptop
* To better understand how to use virtualization
* To better understand how to use servers
* To setup a space for indie game development
* To implement a plan for backup and disaster recovery
* To not give up so much control to 3rd party services
* Have more control over my own data

These are the tasks that need to be solved:

Initial layout

1. ISP
	1. Setup ISP
		1. ISP is 400mb
		2. can upgrade to 800mb for $10
		3. have to check if router has wifi, if not purchase WAP
	2. Redundancy / Resiliancy
		1. ISP - none, requires 2nd internet connection
		2. Use internet from phone if ISP fails
2. Wan Level
	1. Firewall, No
	2. Get a managed switch
	3. Layer 2 or Layer 3
		1. Layer 2 preferred
	4. Vendor
		1. Cisco
		2. HP aruba
		3. No ubiquiti
	5. Redundancy / Resiliancy 
		1. resiliancy if cost effective and makes sense otherwise none.
	6. WAP
		1. Only if router does not have wifi built-in
		2. maybe necessary evil if wired networking fails.
		3. Redundancy / Resiliancy - none, only purchasing 1 WAP
	7. File Server / Hardware
		1. Will purchase hardware and build own
		2. Storage
			1. SSD
				1. WD SN750 1 TB - boot drive
			2. HDD
				1. WD NAS 4TB 5400 RPM CMR
				2. Seagate Ironwolf 4TB 5400 RPM CMR
			3. HDD/SSD usage
				1. 1 - Boot Drive / SSD (Nothing is going to live here)
				2. 2 - Raid 1 - prod
				3. 3 - Raid 1 backup
				4. 4 - Data
				5. 5 - Test environment
			4. RAM
				1. start 32GB and upgrade to 64GB
				2. or start 64GB and upgrade to 128gb
			5. OS
				1. Layer 1
					1. Proxmox
					2. Windows Server 2022
				2. Layer 2
					1. VMware VM workstation player
					2. Hyper-V
					3. Oracle VM VirtualBox 
				3. How many VM’s
					1. 5 VM’s
						1. 1 - Windows VM to hold perforce
						2. 2 - Windows Test VM
						3. hold configurations
						4. Windows configuration and VM backups not sure how I would implement these.
						5. 3 - DHCP server
						6. 4 - unknown
						7. 5 - unknown
			6. Backup / Disaster recover
				1. What is good backup software?
				2. What are good 2 bay enclosures?
				3. What cloud areas I can use
					1. Google Drive
					2. Onedrive
						1. important docs can go there.
					3. Power backup
						1. might get rackmount UPS or basic cheap UPS
						2. need to check to make sure powerstrips are good
			7. Network security
				1. Create a VPN?
				2. Create a proxy?
				3. I’m not sure what basic network security I can have in place.
			8. Network configuration
				1. start with the private IP range
					1. 10.0.0.0 (preferred)
					2. 172.169.0.0
					3. 192.168
				2. Vlan’s
					1. 1 - prod
					2. 2 - test
					3. 3 - wifi
					4. Does it make sense to have multiple Vlan’s here?