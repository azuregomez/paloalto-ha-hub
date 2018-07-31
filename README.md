This deployment features:

•	Palo Alto cluster with configurable node amount.  3 NICs each VM: trusted, untrusted and management.
•	Standard or Basic Load Balancer with a single frontend IP for the untrusted interfaces.
•	Standard or Basic Internal Load Balancer for the trusted interface. Backhaul could also go thru trusted.
•	Managed disks for the VMs

