######################################################################
###Identity: Subscription Expiry Check
###Author: Tahasanul Abraham
###Created: Oct 16 2018
###Last Edited: Oct 16 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

### Local variable initialization ### 

:global issueDate;
:global validityDays;
:global vpninterfaces;
:global crtlVPN "yes";
:global crtlHotspot "no";
:global crtlRadius "yes";

:local shiftDate [:parse [/system script get func_shiftDate source]]

# the date to compare
:local date1 [$shiftDate date=$issueDate days=$validityDays];
:global expiryDate [$shiftDate date=$issueDate days=$validityDays];

# get current date
:local date2 [ /system clock get date ];


# months array
:local months ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");

# extract month from date1
:local date1month [ :pick $date1 0 3 ];
# extract day
:local date1day [ :pick $date1 4 6 ];
# extract year
:local date1year [ :pick $date1 7 11 ];
# get position of our month in the array = month number
:local mm ([ :find $months $date1month -1 ] + 1);
# if month number is less than 10 (a single digit), then add a leading 0
:if ($mm < 10) do={
	:set date1month ("0" . $mm);
# otherwise, just set it as the number
} else={
	:set date1month $mm;
}
# combine year, month, and day to create a "number", ie: 20120413
:local date1value ($date1year . $date1month . $date1day);


# extract month from date2
:local date2month [ :pick $date2 0 3 ];
# extract day
:local date2day [ :pick $date2 4 6 ];
# extract year
:local date2year [ :pick $date2 7 11 ];
# get position of our month in the array = month number
:local mm ([ :find $months $date2month -1 ] + 1);
# if month number is less than 10 (a single digit), then add a leading 0
:if ($mm < 10) do={
    :set date2month ("0" . $mm);
# otherwise, just set date2month as the number
} else={
    :set date2month $mm;
}
# combine year, month, and day to create a "number", ie: 20120413
:local date2value ($date2year . $date2month . $date2day);

# if date1 value is greater than date2, enable the firewall rule
if ($date1value >= $date2value) do={
	:log warning "Subscription is NOT expired";
	
# otherwise, disable the firewall rule
} else={
	:log warning "Subscription is expired";
	:if ($crtlVPN = "yes") do={
		:log warning "Running VPN Control";
		:system scheduler disable VPN_Sync;
		:foreach vpn in=$vpninterfaces do={
			:interface l2tp-client disable $vpn;
			/interface l2tp-client set [/interface l2tp-client find name="$vpn"] user="expired";
			/interface l2tp-client set [/interface l2tp-client find name="$vpn"] password="expired";
			:log warning "$vpn credentials has been reseted";
		}
	}
	:if ($crtlHotspot = "yes") do={
		:log warning "Running Hotspot Control";
		:system scheduler disable Disable_hotspot;
		:ip hotspot disable "Hotspot";
		:log warning "Hotspot Service Disabled";
	}
	:if ($crtlRadius = "yes") do={
		:log warning "Running RADIUS Control";
		:radius disable [/radius find service=hotspot]
		:log warning "RADIUS Service Disabled";
	}
}