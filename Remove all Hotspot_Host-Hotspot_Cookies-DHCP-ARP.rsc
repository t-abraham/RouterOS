######################################################################
Identity: Remove all Hotspot_Host-Hotspot_Cookies-DHCP-ARP
Author: Tahasanul Abraham
Creadted: Oct 16 2016
Last Edited: Jan 5 2018
Compatible Versions: ROS 6.x
Tested on: ROS 6.2 - 6.42
######################################################################

### Working Script ### 
:log warning "Removing all Hotspot Cookies"
foreach i in=[/ip hotspot cookie find] do={/ip hotspot cookie remove $i}
:log warning "All Hotspot Cookies removed"

:log warning "Removing all Hotspot Hosts"
foreach i in=[/ip hotspot host find] do={/ip hotspot host remove $i}
:log warning "All Hotspot Hosts removed"

:log warning "Removing all Dynamic DHCP Leases"
/ip dhcp-server lease remove [find dynamic]
:log warning "All Dynamic DHCP Leases removed"

:log warning "Removing all IP ARP"
foreach i in=[/ip arp find] do={/ip arp remove $i}
:log warning "All IP ARP removed"