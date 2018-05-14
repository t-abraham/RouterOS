######################################################################
Identity: RADIUS (Usermanager) Expired User Cleaner
Author: Tahasanul Abraham
Created: Oct 16 2016
Last Edited: Jan 5 2018
Compatible Versions: ROS 6.x
Tested on: ROS 6.2 - 6.42
######################################################################

### Working Script ### 
if ([/system ntp client get enable]=yes) do={
   :global iterator 0
   :global deleted 0
   :global skipped 0
   :global kept 0
   /tool user-manager user print brief  without-paging
   :global counter [/tool user-manager user print count-only]
   :do {
      :local thisDate
      :local thisYear
      :local thisDay
      :local thisMonth
      :local thisSeen
      :local thisProfile
      :local thisOwner
      :local thisCredit
      :local creditYear
      :local creditDay
      :local creditMonth
      :local expireMonth
      :local creditName
      :set thisDate [/system clock get date]
      :set thisYear [:pick $thisDate 7 11]
      :set thisDay [:pick $thisDate 4 6]
      :set thisMonth [:pick $thisDate 0 3]
      :if ($thisMonth="jan") do { :set thisMonth "01"}
      :if ($thisMonth="feb") do { :set thisMonth "02"}
      :if ($thisMonth="mar") do { :set thisMonth "03"}
      :if ($thisMonth="apr") do { :set thisMonth "04"}
      :if ($thisMonth="may") do { :set thisMonth "05"}
      :if ($thisMonth="jun") do { :set thisMonth "06"}
      :if ($thisMonth="jul") do { :set thisMonth "07"}
      :if ($thisMonth="aug") do { :set thisMonth "08"}
      :if ($thisMonth="sep") do { :set thisMonth "09"}
      :if ($thisMonth="oct") do { :set thisMonth "10"}
      :if ($thisMonth="nov") do { :set thisMonth "11"}
      :if ($thisMonth="dec") do { :set thisMonth "12"}
      :local thisSeen [/tool user-manager user get $iterator last-seen]
      :local thisProfile [/tool user-manager user get $iterator actual-profile]
      :local thisOwner [/tool user-manager user get $iterator customer]
      :set creditName [/tool user-manager user get $iterator username]
      :if ([:len $thisProfile]!=0) do {
      :put {"Username ". $creditName . " Have valid profile:". $thisProfile . " Skipping ..."};
      :set skipped ($skipped+1) } else {
      :if ([$thisSeen]!= "never") do {
      :set creditYear [:pick $thisSeen 7 11]
      :set creditDay [:pick $thisSeen 4 6]
      :set creditMonth [:pick $thisSeen 0 3]
      :if ($creditMonth="jan") do { :set creditMonth "02";:set expireMonth "feb"}
      :if ($creditMonth="feb") do { :set creditMonth "03";:set expireMonth "mar"}
      :if ($creditMonth="mar") do { :set creditMonth "04";:set expireMonth "apr"}
      :if ($creditMonth="apr") do { :set creditMonth "05";:set expireMonth "may"}
      :if ($creditMonth="may") do { :set creditMonth "06";:set expireMonth "jun"}
      :if ($creditMonth="jun") do { :set creditMonth "07";:set expireMonth "jul"}
      :if ($creditMonth="jul") do { :set creditMonth "08";:set expireMonth "aug"}
      :if ($creditMonth="aug") do { :set creditMonth "09";:set expireMonth "sep"}
      :if ($creditMonth="sep") do { :set creditMonth "10";:set expireMonth "oct"}
      :if ($creditMonth="oct") do { :set creditMonth "11";:set expireMonth "nov"}
      :if ($creditMonth="nov") do { :set creditMonth "12";:set expireMonth "dec"}
      :if ($creditMonth="dec") do { :set creditMonth "01";:set expireMonth "jan";:set creditYear ($creditYear+1)}
     :set thisCredit ($expireMonth ."/". $creditDay . "/". $creditYear)
      :if ($creditYear>$thisYear) do {
      :put {"Kept username ".$creditName." which expires on ".$thisCredit };
      :set kept ($kept+1) } else {
      :if ($creditYear<$thisYear) do {
      /tool user-manager user remove $creditName;
      :put {"Deleted username ". $creditName . " which expired on " . $thisCredit};
      :set deleted ($deleted+1) } else {
      :if ($creditMonth>$thisMonth) do {
      :put {"Kept username " . $creditName . " which expires on " . $thisCredit};
      :set kept ($kept+1) }  else {
      :if ($creditMonth<($thisMonth)) do {
      /tool user-manager user remove $creditName;
      :put {"Deleted username ". $creditName . " which expired on " . $thisCredit};
      :set deleted ($deleted+1) } else {
       :if ($creditDay>=$thisDay) do {
       :put {"Kept username " . $creditName . " which expires on " . $thisCredit};
       :set kept ($kept +1) }  else {
        /tool user-manager user remove $creditName;
       :put {"Deleted username ". $creditName . " which expired on " . $thisCredit};
       :set deleted ($deleted+1) }
       }
       }
       }
       }
       }  else {
       :put {"Username ". $creditName . " is not yet activated. Skipping ..."};
       :set skipped ($skipped+1)}
       }
       :set iterator ($iterator+1)
       } while=($iterator!=$counter)
   :put {"\n\n\r________________________________\n\n\rCleaning ready!\n\n\rPerformed these operations:\n\r\t"}
   :put {"Records processed: \t" . $counter}
   :put {"\n\rDeleted usernames: \t" . $deleted}
   :put {"Skipped usernames: \t" . $skipped}
   :put {"Kept usernames:\t\t" . $kept}
   :put {"\n\r__________________________________\n\r"}

   :log info ("\n\r_________________________________\n\n\rCleaning ready!\n\n\rPerformed these operations:\n\r\t")
   :log info ("Records processed: \t" . $counter)
   :log info ("\n\rDeleted usernames: \t" . $deleted)
   :log info ("Skipped usernames: \t" . $skipped)
   :log info ("Kept usernames: \t\t" . $kept)
   :log info ("\n\r_________________________________\n\r")

}

#END OF FILE