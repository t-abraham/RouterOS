######################################################################
###Identity: WAN/Netflix Gateway Sync (NAT/Filter)
###Author: Tahasanul Abraham
###Created: Oct 16 2016
###Last Edited: Jan 5 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

### Working Script ### 
# correct firewall to access NATed router
:local wanip [/ip dhcp-client get [/ip dhcp-client find interface="WAN"] address];
:local wangateway [/ip dhcp-client get [/ip dhcp-client find interface="WAN"] gateway];
:local firewalladdress [/ip firewall nat get [/ip firewall nat find comment="NATed Router Remote"] to-addresses];
:local netflixaddress [/ip route get [/ip route find comment="Netflix"] gateway];
:local filteraddress [/ip route get [/ip route find comment="Filter"] gateway];

:log warning "WAN Gateway $wangateway vs $firewalladdress";
:if ($wangateway != $firewalladdress) do={
	:log warning "WAN Firewall NAT Gateway change detected";
	/ip firewall nat set [/ip firewall nat find comment="NATed Router Remote"] to-addresses=$wangateway;
	:log warning "WAN Gateway changed to $wangateway";} else={
	:log warning "No change detected in WAN Firewall NAT Gateway";}
:if ($wangateway != $netflixaddress) do={
	:log warning "WAN Netflix Route Gateway change detected";
	/ip route set [/ip route find comment="Netflix"] gateway=$wangateway;
	:log warning "Netflix Gateway changed to $wangateway";} else={
	:log warning "No change detected in WAN Netflix Route Gateway";}
:if ($wangateway != $filteraddress) do={
	:log warning "WAN Filter Route Gateway change detected";
	/ip route set [/ip route find comment="Filter"] gateway=$wangateway;
	:log warning "Filter Gateway changed to $wangateway";} else={
	:log warning "No change detected in WAN Filter Route Gateway";}
