######################################################################
Identity: ExpressVPN Connect Sync
Author: Tahasanul Abraham
Creadted: Oct 16 2016
Last Edited: Jan 5 2018
Compatible Versions: ROS 6.x
Tested on: ROS 6.2 - 6.42
######################################################################

### Local variable initialization ### 
:local ExpressVPNServerDnsName "L2TP Server";
:local interface "L2TP-Interface";
:local schedulername "expressvpn_check";
:local glbvar "ExpressVPN";
:local a "connected";
:local b "disconnected";
:global evpnserverip;
:execute ":global $glbvar $b";

### Working Script ### 
:if ([ :typeof $evpnserverip ] = "nothing" ) do={
	:set evpnserverip [:resolve "$ExpressVPNServerDnsName"];}
	
:if ($evpnserverip != [/interface l2tp-client get $interface connect-to]) do={
	:log warning ("$interface server IP address change is necessary");
	:interface l2tp-client disable $interface;
	/interface l2tp-client set [/interface l2tp-client find name="$interface"] connect-to="$evpnserverip";
	:log warning ("$interface server IP address changed to $evpnserverip");
	:log warning "$interface turned OFF";
	:delay 30;
	:interface l2tp-client enable $interface;
	:log warning "$interface turned ON";
	:delay 30;} else={
	:log warning ("PPP $interface server IP address change is NOT necessary");}

:if ([/interface l2tp-client get $interface running]=true) do={
	:log warning "$interface is running perfectly";
	:execute ":set $glbvar $a";} else={
	:execute ":set $glbvar $b";
	:log warning "$interface is NOT running"; 
	:interface l2tp-client disable $interface;
	:log warning "$interface turned off for 5 minutes";
	:delay 300; 
	:interface l2tp-client enable $interface;
	:log warning "$interface turned ON";
	:delay 30;
	:if ([/interface l2tp-client get $interface running]=true) do={
	:log warning "$interface is running perfectly";
	:execute ":set $glbvar $a";} else={
	:execute ":set $glbvar $b";
	:system scheduler disable $schedulername;
	:while ([/interface l2tp-client get $interface running]!=true) do={
	:log warning "$interface is NOT running";
	:log warning ("PPP server IP address change necessary");
	:log warning "$interface turned OFF";
	:local current [:resolve "$ExpressVPNServerDnsName"];
	:interface l2tp-client disable $interface;
	/interface l2tp-client set [/interface l2tp-client find name="$interface"]   connect-to="$current";
	:log warning ("PPP server dynamic IP address changed to $current");
	:delay 30;
	:interface l2tp-client enable $interface;
	:log warning "$interface turned ON";
	:delay 30;}
	:system scheduler enable $schedulername;
	:if ([/interface l2tp-client get $interface running]=true) do={
	:log warning "$interface is running perfectly";
	:execute ":set $glbvar $a";
	:set evpnserverip [/interface l2tp-client get $interface connect-to];} else={
	:execute ":set $glbvar $b";
	:log warning "$interface is NOT running";
	:interface l2tp-client disable $interface;};};};