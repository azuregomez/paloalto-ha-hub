[![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://azuredeploy.net/)

This deployment features:

<ul>
<li>Palo Alto cluster with configurable node amount.  4 NICs each VM: trusted, untrusted, backhaul and management.
<li>Standard or Basic Load Balancer with a single frontend IP for the untrusted interfaces.
<li>Standard or Basic Internal Load Balancer for the trusted interface. Additional backend pool for the Backhaul interface.
<li>Managed disks for the VMs
</ul>

This template follows the Shared Model.  The deployment guide published by Palo Alto is also included. 

<img src="https://storagegomez.blob.core.windows.net/public/images/pan-shared.jpg"/>

<b>Inbound Traffic</b>
For inbound traffic, a public load-balancer distributes traffic to the firewalls. To simplify firewall configuration, the frontend public IP address is associated with a DNS name and floating IP is enabled on the load-balancer rules. The public load-balancer’s health probes monitor firewall availability through the HTTPS service activated in the interface management profile. Connectivity to the HTTPS service is limited to traffic sourced from the health probe IP address.

<b>Outbound Traffic</b>
For outbound traffic, an internal load-balancer distributes traffic to the firewalls. User-defined routes on the private subnets direct traffic to the load-balancer’s frontend IP address, which shares a subnet with the firewall private interfaces. Load-balancer rules forward all TCP and UDP ports to the firewalls. Common ports required for outbound traffic include UDP/123 (NTP), TCP/80 (HTTP), and TCP/443 (HTTPS). DNS is not needed, because virtual machines communicate to Azure name services directly through the Azure network fabric. The internal load-balancer’s health probes monitor firewall availability through the HTTPS service enabled in the interface management profile. Connectivity to the HTTPS service is limited to traffic sourced from the health probe IP address. 

<b>East-West Traffic</b>
East-west traffic, or traffic between private subnets, uses the same internal load-balancer to distribute traffic to the firewalls as the outbound traffic. User-defined routes to the private network subnets are applied to the private subnets and direct traffic to the load-balancer’s frontend IP address. The existing load-balancer rules for outbound traffic apply to east-west traffic as well, and apply to all TCP and UDP ports.

<b>Backhaul Traffic</b>
User-defined routes applied to the gateway subnet direct traffic that has a destination in the private network range to the internal load-balancer with an additional frontend IP dedicated to incoming traffic from the backhaul connection. The load-balancer then distributes traffic to a new backend pool with dedicated interfaces on the firewalls. Dedicated firewall interfaces are used for the backhaul traffic because they allow for enhanced security policies that can take zone into account. 

<b>Management</b>
Traffic from the on-site networks communicates to the management subnet directly. This allows on-site administrators to manage the firewalls even when a misconfiguration occurs in user-defined routing or load-balancers.<br/>
<i>For the purpose of making it easier for this template to be tested, the management interfaces have a public IP so they are accessible to the internet by adding an NSG to the management subnet that allow traffic.  However, if management should come only from within the network, the parameter validManagementSourceIPRange allows for a valid range. The public IP can also be removed. Panorama is out of the scope of this template.</i>

<hr/>

<b>Notes</b>
<ul>
<li> On section 8.5 of the deployment guide, it reads: <i>...  Because the firewall’s public interface is a member of the Azure public load-balancer backend pool, Azure networking (Azure Load Balancer) performs translation (SNAT) for only TCP/UDP ports referenced in the active load balancing rules. To support a broad range of services, create a new public IP address for the public interface of each firewall used for outbound access. This method supports all TCP/UDP ports.
</i><br/>However, ALB Standard has Outbound rules: https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-rules-overview
<li>Before creating the first Palo Alto firewall in an Azure Subscription, the Palo Alto terms for the Azure Marketplace have to be accepted. This can be accomplished by running acceptterms.ps1
</ul>

