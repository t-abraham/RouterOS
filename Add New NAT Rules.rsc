######################################################################
###Identity: Add New NAT Rules
###Author: Tahasanul Abraham
###Created: Oct 16 2016
###Last Edited: Jan 5 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

### Local variable initialization ### 

:local clientip "XXX:YYY:ZZZ:XYZ"
:local serverip "XXX:YYY:ZZZ:XYZ"
:local cnmt "Mikrotik_Server"

### Working Script ### 
/ip firewall nat
add action=dst-nat chain=dstnat comment=$cnmt dst-port=1200 protocol=tcp to-addresses=$clientip to-ports=8728
add action=dst-nat chain=dstnat dst-port=1201 protocol=tcp to-addresses=$clientip to-ports=8291
add action=dst-nat chain=dstnat dst-port=1202 protocol=tcp to-addresses=$clientip to-ports=80
add action=dst-nat chain=dstnat dst-port=1203 protocol=tcp to-addresses=$clientip to-ports=90
add action=src-nat chain=srcnat dst-address=$clientip to-addresses=$serverip