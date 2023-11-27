# Perforce for Version Control:

This project is about setting up Perforce for independent development.

Use Case:
Perforce is good for Version control with binaries, it has to be self-hosted.  It can be hosted on-prem or in the cloud.  For this project it will be hosted on-prem with a VM.  Similar practice can be applied to the cloud.

Why not Github or Git + LFS:
I have tried these options and there are limiations such as:

* File size limits for binaries


In order to get this setup the following had to be setup:
- [x] Designate a VM as a server
- [x] Install Perforce on a server VM
	* [x] install client on test machine
    * [x] open up firewall rules to allow connections to perforce server
    * [x] setup example workspace
    * [x] setup example user to connect to perforce workspace
- [] Setup Game Engine
	* [] Integrate Game Engine with Perforce
- [] Setup CD software such as jenkins to create automatic builds of the game

Lessons Learned:

* Setting up firewall rules to control access to perforce is necessary 

References:
[Configure Helix for Game Engines](https://www.youtube.com/watch?v=Hvmvv2MG-UE "Perforce Reference 1")
[Setup Perforce with Unity 7 minutes](https://www.youtube.com/watch?v=dh6gTTC-GIs "Setup Perforce with Unity 7 minutes")
[Game Development Ops - Hosting your local Perforce Server](https://www.youtube.com/watch?v=5MUYEwhxP60 "Game Development Ops - Hosting your local Perforce Server")
[Getting Started with P4V](https://www.youtube.com/watch?v=Yvgxx2vwsRY&list=PLxdnSsBqCrrGq_8ecmdE7A6KnRfbhHE4Q "Getting Started with P4V")
[Perforce Helix Core Beginner's Guide](https://www.youtube.com/watch?v=jIQEjDiSe0g&list=PLH3pq2J85xsPYn71_yzzsZQKvalTW-duE "Perforce Helix Core Beginner's Guide")
[Perforce with Jenkins](https://www.youtube.com/watch?v=h6AInFCno8o&pp=ygUQcGVyZm9yY2UgamVua2lucw%3D%3D "Perforce with Jenkins")
[Perforce Streams](https://www.youtube.com/watch?v=qB6mpOy8ZUs "Perforce Streams")
[Source Control and Remote Team Collaboration](https://www.youtube.com/watch?v=YKMDdtX-8gM "Source Control and Remote Team Collaboration")
[Perforce Setup](https://www.youtube.com/watch?v=HOaDZEG49Z4&list=PL4Aiqqv5C1J6Bnm9Gsmex6of01ZKpQJsH&index=1 "Perforce Setup")

