######################################################################
###Identity: Cloud VPN Linkup
###Author: Tahasanul Abraham
###Created: Oct 16 2016
###Last Edited: Jan 5 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

### Local variable initialization ### 
:local myvar1 "PPTPCLOUD";
:local myvar2 "L2TPCLOUD";
:local myvar3 "OVPNCLOUD";
:local id "PPP Username";
:local pass "PPP Password";
:local pppServerDnsName "Server Address";
:local l2tpinterface "l2tp-cloud.de";
:local pptpinterface "pptp-cloud.de";
:local ovpninterface "ovpn-cloud.de";
:local l2tpdeconn "disconnected";
:local pptpdeconn "disconnected";
:local ovpndeconn "disconnected";
:global pppserverip;
:execute ":global $myvar1 $l2tpdeconn";
:execute ":global $myvar2 $pptpdeconn";
:execute ":global $myvar3 $ovpndeconn";
:log warning ("Start check for PPP connectivity");


### Working Script ###
:if ([ :typeof $pppserverip ] = "nothing" ) do={ :global pppserverip [:resolve "$pppServerDnsName"] }
:local current [:resolve "$pppServerDnsName"];
:log warning ("$pppserverip" . " vs " . "$current");



#connectivity check
:if ([/interface pptp-client get $pptpinterface running]=true) do={
	:log warning "$pptpinterface is running perfectly";
	:set pptpdeconn "connected";
	:execute ":set $myvar1 $pptpdeconn";} else={
	:set pptpdeconn "disconnected";
	:execute ":set $myvar1 $pptpdeconn";
	:if ([/interface l2tp-client get $l2tpinterface running]=true) do={
	:log warning "$l2tpinterface is running perfectly";
	:set l2tpdeconn "connected";
	:execute ":set $myvar2 $l2tpdeconn";} else={
	:set l2tpdeconn "disconnected";
	:execute ":set $myvar2 $l2tpdeconn";
	:if ([/interface ovpn-client get $ovpninterface running]=true) do={
	:log warning "$ovpninterface is running perfectly";
	:set ovpndeconn "connected";
	:execute ":set $myvar3 $ovpndeconn";} else={
	:set ovpndeconn "disconnected";
	:execute ":set $myvar3 $ovpndeconn";};};}
	
#PPTP linkup	
:if (($pptpdeconn = "connected") || ($l2tpdeconn = "connected") || ($ovpndeconn = "connected")) do={
	:log warning "Linkup with Mikrotik Cloud Host Router is working";} else={
	:log warning "Linkup with Mikrotik Cloud Host Router is NOT working";
	:log warning "Starting to debug";
	:if (($pptpdeconn != "connected") && ($l2tpdeconn != "connected") && ($ovpndeconn != "connected")) do={
		:log warning "$pptpinterface turned off for 30 seconds";
		:log warning "$l2tpinterface turned off for 30 seconds";
		:log warning "$ovpninterface turned off for 30 seconds";
		:interface pptp-client disable $pptpinterface;
		:interface l2tp-client disable $l2tpinterface;
		:interface ovpn-client disable $ovpninterface;
		:local setip [/interface pptp-client get [/interface pptp-client find name="$pptpinterface"]   connect-to];
		:if ($pppServerDnsName = $setip) do={
		  :log warning ("No PPP server IP address change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   connect-to="$pppServerDnsName";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   connect-to="$pppServerDnsName";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   connect-to="$pppServerDnsName";
		  :log warning ("PPP server dynamic IP address changed from " . "$setip" . " to " . "$pppServerDnsName" );
		  :global pppserverip $current;}
		:local setid [/interface pptp-client get [/interface pptp-client find name="$pptpinterface"]   user];
		:if ($id = $setid) do={
		  :log warning ("No PPP server username change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   user="$id";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   user="$id";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   user="$id";
		  :log warning ("PPP server username changed from " . "$setid" . " to " . "$id" );}
		:local setpass [/interface pptp-client get [/interface pptp-client find name="$pptpinterface"]   password];
		:if ($pass = $setpass) do={
		  :log warning ("No PPP server password change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   password="$pass";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   password="$pass";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   password="$pass";
		  :log warning ("PPP server password changed from " . "$setpass" . " to " . "$pass" );}
		:delay 10;
		:interface pptp-client enable $pptpinterface;
		:log warning "$pptpinterface turned on and checking for connectivity";
		:delay 10;
		:if ([/interface pptp-client get $pptpinterface running]=true) do={
		:log warning "$pptpinterface is running perfectly";
		:set pptpdeconn "connected";
		:execute ":set $myvar1 $pptpdeconn";} else={
		:log warning "$pptpinterface is NOT running";
		:log warning "$pptpinterface is turned OFF";
		:set pptpdeconn "disconnected";
		:execute ":set $myvar1 $pptpdeconn";
		:interface pptp-client disable $pptpinterface;};}
# L2TP linkup
	:if (($pptpdeconn != "connected") && ($l2tpdeconn != "connected") && ($ovpndeconn != "connected")) do={
		:local setip [/interface l2tp-client get [/interface l2tp-client find name="$l2tpinterface"]   connect-to];
		:if ($pppServerDnsName = $setip) do={
		  :log warning ("No PPP server IP address change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   connect-to="$pppServerDnsName";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   connect-to="$pppServerDnsName";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   connect-to="$pppServerDnsName";
		  :log warning ("PPP server dynamic IP address changed from " . "$setip" . " to " . "$pppServerDnsName" );
		  :global pppserverip $current;}
		:local setid [/interface pptp-client get [/interface pptp-client find name="$pptpinterface"]   user];
		:if ($id = $setid) do={
		  :log warning ("No PPP server username change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   user="$id";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   user="$id";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   user="$id";
		  :log warning ("PPP server username changed from " . "$setid" . " to " . "$id" );}
		:local setpass [/interface pptp-client get [/interface pptp-client find name="$pptpinterface"]   password];
		:if ($pass = $setpass) do={
		  :log warning ("No PPP server password change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   password="$pass";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   password="$pass";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   password="$pass";
		  :log warning ("PPP server password changed from " . "$setpass" . " to " . "$pass" );}
		:interface l2tp-client enable $l2tpinterface;
		:log warning "$l2tpinterface turned on and checking for connectivity";
		:delay 10;
		:if ([/interface l2tp-client get $l2tpinterface running]=true) do={
		:log warning "$l2tpinterface is running perfectly";
		:set l2tpdeconn "connected";
		:execute ":set $myvar2 $l2tpdeconn";} else={
		:log warning "$l2tpinterface is NOT running";
		:log warning "$l2tpinterface is turned OFF";
		:set l2tpdeconn "disconnected";
		:execute ":set $myvar2 $l2tpdeconn";
		:interface l2tp-client disable $l2tpinterface;};};
# OVPN linkup
	:if (($pptpdeconn != "connected") && ($l2tpdeconn != "connected") && ($ovpndeconn != "connected")) do={
		:local setip [/interface ovpn-client get [/interface ovpn-client find name="$ovpninterface"]   connect-to];
		:if ($pppServerDnsName = $setip) do={
		  :log warning ("No PPP server IP address change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   connect-to="$pppServerDnsName";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   connect-to="$pppServerDnsName";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   connect-to="$pppServerDnsName";
		  :log warning ("PPP server dynamic IP address changed from " . "$setip" . " to " . "$pppServerDnsName" );
		  :global pppserverip $current;}
		:local setid [/interface pptp-client get [/interface pptp-client find name="$pptpinterface"]   user];
		:if ($id = $setid) do={
		  :log warning ("No PPP server username change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   user="$id";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   user="$id";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   user="$id";
		  :log warning ("PPP server username changed from " . "$setid" . " to " . "$id" );}
		:local setpass [/interface pptp-client get [/interface pptp-client find name="$pptpinterface"]   password];
		:if ($pass = $setpass) do={
		  :log warning ("No PPP server password change necessary");} else={
		  /interface pptp-client set [/interface pptp-client find name="$pptpinterface"]   password="$pass";
		  /interface l2tp-client set [/interface l2tp-client find name="$l2tpinterface"]   password="$pass";
		  /interface ovpn-client set [/interface ovpn-client find name="$ovpninterface"]   password="$pass";
		  :log warning ("PPP server password changed from " . "$setpass" . " to " . "$pass" );}
		:interface ovpn-client enable $ovpninterface;
		:log warning "$ovpninterface turned on and checking for connectivity";
		:delay 10;
		:if ([/interface ovpn-client get $ovpninterface running]=true) do={
		:log warning "$ovpninterface is running perfectly";
		:set ovpndeconn "connected";
		:execute ":set $myvar3 $ovpndeconn";} else={
		:log warning "$ovpninterface is NOT running";
		:log warning "$ovpninterface is turned OFF";
		:set ovpndeconn "disconnected";
		:execute ":set $myvar3 $ovpndeconn";
		:interface ovpn-client disable $ovpninterface;};};	
	:if (($l2tpdeconn = "connected") || ($pptpdeconn = "connected") || ($ovpndeconn = "connected")) do={
	:log warning "Linkup with Mikrotik Cloud Host Router is up";};};
