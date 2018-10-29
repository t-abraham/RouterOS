######################################################################
###Identity: System Time Sync
###Author: Tahasanul Abraham
###Created: Oct 16 2018
###Last Edited: Oct 16 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################


if ([ping 8.8.8.8 count=5] > 4) do={
	/system ntp client set enabled=no primary-ntp=216.239.35.8 secondary-ntp=216.239.35.0 server-dns-names="time.google.com,time1.google.com,time2.google.com,time3.google.com,time4.google.com";
	:delay 15s;
	/system ntp client set enabled=yes primary-ntp=216.239.35.8 secondary-ntp=216.239.35.0 server-dns-names="time.google.com,time1.google.com,time2.google.com,time3.google.com,time4.google.com";
	/system scheduler set sync_time interval=00:00:00;
	:log warning "SNTP Client Synchronized Current TIme";} else={/system scheduler set sync_time interval=00:01:00;
	:log warning "SNTP Client FAILED To Synchronize Current TIme";}