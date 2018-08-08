This deployment features:

+ Palo Alto cluster with configurable node amount.  3 NICs each VM: trusted, untrusted and management.
+ Standard or Basic Load Balancer with a single frontend IP for the untrusted interfaces.
+ Standard or Basic Internal Load Balancer for the trusted interface. Backhaul could also go thru trusted.
+ Managed disks for the VMs

Zones not part of this template but can be added easily.
https://docs.microsoft.com/en-us/azure/availability-zones/az-overview
This template follows the Shared model explained in page 32 of the Palo Alto reference architecture:
https://www.paloaltonetworks.com/resources/whitepapers/intelligent-architectures-azure-reference-architecture
The only change is:
There is no eth3 interface in the PAN VMs. This is because Azure allows only 1 type of Load Balancer (Internal, External) on the same Availability Set.

