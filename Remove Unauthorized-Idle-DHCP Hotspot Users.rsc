######################################################################
Identity: Remove Unauthorized-Idle-DHCP Hotspot Users
Author: Tahasanul Abraham
Created: Oct 16 2016
Last Edited: Jan 5 2018
Compatible Versions: ROS 6.x
Tested on: ROS 6.2 - 6.42
######################################################################

### Working Script ### 
/ip hotspot host remove [find authorized=no dynamic=yes]
/ip hotspot host remove [find authorized=no DHCP=yes]
/ip hotspot host remove [find idle-time>1d]