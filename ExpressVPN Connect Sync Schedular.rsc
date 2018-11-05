######################################################################
###Identity: ExpressVPN Connect Sync Schedular
###Author: Tahasanul Abraham
###Created: Nov 05 2018
###Last Edited: Nov 05 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

###NEDS TO BE USED AS A SCHEDULAR TO WORK PROPERLY###
###ATTACHED SCHEDULAR IS IN THE FILE NAMED "ExpressVPN Connect Sync Schedular"###
###SAVE THIS SCHEDULAR SCRIPT WITH THE NAME "VPN_Sync"###


:global ExpressVPNServerDnsName;
:if ([ :len $ExpressVPNServerDnsName ] = 0 )  do={:global ExpressVPNServerDnsName "L2TP VPN SERVER IP7URL";}
:global schedulername "VPN_Sync";
:global vpninterfaces {"L2TP VPN INTERFACE NAME 1";"L2TP VPN INTERFACE NAME 1"};
/system script run VPN_Sync;