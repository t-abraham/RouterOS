######################################################################
###Identity: Bind multiple MAC addresses to Hotspot Users
###Author: Tahasanul Abraham
###Created: Nov 09 2018
###Last Edited: Nov 09 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

### Description ###
### make .txt files with the file names as the user name for the MAC to bind ###
### save the MAC addreses inside the txt file ###
### upload the text file in the mikrotik files section under a folder named "users" ##
### copy and paste the working script in the user profile for which the mac binded users will be using ###
### the script should be pasted in the hotspot profile under the option scripts -> on login ###

### Working Script ### 

:delay 1
:local m $"mac-address"
:log warning "$m $username"
:local f [/file get value-name=contents [find name="users/$username.txt"]]
:if ($f!="") do={
	:log warning "MAC bind file for user $username found"
	:if ([:len [find $f $m]]=0) do={
		:log warning "User MAC for $username NOT found"
		/ip hotspot active remove [find mac-address=$m]
	}
}