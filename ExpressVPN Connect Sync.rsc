######################################################################
###Identity: ExpressVPN Connect Sync
###Author: Tahasanul Abraham
###Created: Oct 16 2016
###Last Edited: Nov 05 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

###NEEDS TO BE USED AS A SCHEDULAR TO WORK PROPERLY###
###ATTACHED SCHEDULAR IS IN THE FILE NAMED "ExpressVPN Connect Sync Schedular"###

### Local variable initialization ### 

:global ExpressVPNServerDnsName;
:global vpninterfaces;
:global schedulername;
:local a "connected";
:local b "disconnected";
:global evpnserverip;
:local adminmail1 "RECEIVER EMAIL ADDRESS"
:local sub1 ([/system identity get name])
:local sub2 ([/system clock get time])
:local sub3 ([/system clock get date])

# MAIL SMTP DYNAMIC Config Section, Make sure to change these values to match your's / Jz
:local webmailid "SENDER EMAIL ADDRESS"
:local webmailuser "SENDER EMAIL ADDRESS"
:local fromuser "SENDER EMAIL ADDRESS"
:local webmailpwd "SENDER EMAIL PASSWORD"
:local webmailport "465"
:local webmailsmtp
:set webmailsmtp [:resolve "SENDER EMAIL SMTP URL/IP"];

# Setting gmail options in tool email as well, useful when u dont have configured toosl email option
/tool e-mail set address=$webmailsmtp port=$webmailport start-tls=tls-only from=$webmailid user=$webmailuser password=$webmailpwd

### Working Script ### 

:if ([ :len $ExpressVPNServerDnsName ] = 0 )  do={
	:system script environment remove [/system script environment find name="ExpressVPNServerDnsName"];
	:system script environment remove [/system script environment find name="evpnserverip"];} else={
		:if ([ :len $evpnserverip ] = 0 ) do={
			:set evpnserverip [:resolve "$ExpressVPNServerDnsName"];};}
			
		:foreach vpn in=$vpninterfaces do={
			:execute ":global $vpn $b";
			### Sync VPN Server IP ###
			:if ($evpnserverip != [/interface l2tp-client get $vpn connect-to]) do={
				:log warning ("$vpn server IP address change is necessary");
				:interface l2tp-client disable $vpn;
				/interface l2tp-client set [/interface l2tp-client find name="$vpn"] connect-to="$evpnserverip";
				:log warning ("$vpn server IP address changed to $evpnserverip");
				:log warning "$vpn turned OFF";
				:delay 30;
				:interface l2tp-client enable $vpn;
				:log warning "$vpn turned ON";
				:delay 30;} else={
					:log warning ("PPP $vpn server IP address change is NOT necessary");}
			### VPN Connectivity Check ###
			:if ([/interface l2tp-client get $vpn running]=true) do={
				:log warning "$vpn is running perfectly";
				:execute ":set $vpn $a";} else={
					:execute ":set $vpn $b";
					:log warning "$vpn is NOT running"; 
					:interface l2tp-client disable $vpn;
					:log warning "$vpn turned off for 2 minutes 30 seconds";
					:delay 150; 
					:interface l2tp-client enable $vpn;
					:log warning "$vpn turned ON";
					:delay 30;
					:if ([/interface l2tp-client get $vpn running]=true) do={
						:log warning "$vpn is running perfectly";
						:execute ":set $vpn $a";} else={
							:execute ":set $vpn $b";
							:system scheduler disable $schedulername;
							/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail1 subject="$vpn on $sub1 is DISCONNECTED" body="$vpn on $sub1 is DISCONNECTED on $sub3 at $sub2";
							:while ([/interface l2tp-client get $vpn running]!=true) do={
								:log warning "$vpn is NOT running";
								:log warning ("PPP server IP address change necessary");
								:log warning "$vpn turned OFF";
								:local current [:resolve "$ExpressVPNServerDnsName"];
								:interface l2tp-client disable $vpn;
								/interface l2tp-client set [/interface l2tp-client find name="$vpn"]   connect-to="$current";
								:log warning ("PPP server dynamic IP address changed to $current");
								:delay 30;
								:interface l2tp-client enable $vpn;
								:log warning "$vpn turned ON";
								:delay 30;}
							:system scheduler enable $schedulername;
							/tool e-mail send server=$webmailsmtp port=$webmailport start-tls=tls-only user=$webmailuser password=$webmailpwd from=$fromuser to=$adminmail1 subject="$vpn on $sub1 is CONNECTED" body="$vpn on $sub1 is CONNECTED on $sub3 at $sub2";
							:if ([/interface l2tp-client get $vpn running]=true) do={
								:log warning "$vpn is running perfectly";
								:execute ":set $vpn $a";
								:set evpnserverip [/interface l2tp-client get $vpn connect-to];} else={
									:execute ":set $vpn $b";
									:log warning "$vpn is NOT running";
									:interface l2tp-client disable $vpn;};};};};}