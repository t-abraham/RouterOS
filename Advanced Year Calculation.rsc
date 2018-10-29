######################################################################
###Identity: Advanced Year Calculation
###Author: Tahasanul Abraham
###Created: Oct 16 2018
###Last Edited: Oct 16 2018
###Compatible Versions: ROS 6.x
###Tested on: ROS 6.2 - 6.42
######################################################################

################################################################### func_shiftDate - add days to date
#  Input: date, days
#    date - "jan/1/2017"
#    days - number
# correct only for years >1918
################################################################### uncomment for testing
#:local date "jan/01/2100"
#:local days 2560
########################################
#:put "$date + $days"
:local mdays  {31;28;31;30;31;30;31;31;30;31;30;31}
:local months {"jan"=1;"feb"=2;"mar"=3;"apr"=4;"may"=5;"jun"=6;"jul"=7;"aug"=8;"sep"=9;"oct"=10;"nov"=11;"dec"=12}
:local monthr  {"jan";"feb";"mar";"apr";"may";"jun";"jul";"aug";"sep";"oct";"nov";"dec"}

:local dd  [:tonum [:pick $date 4 6]]
:local yy [:tonum [:pick $date 7 11]]
:local month [:pick $date 0 3]

:local mm (:$months->$month)
:set dd ($dd+$days)

:local dm [:pick $mdays ($mm-1)]
:if ($mm=2 && (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }

:while ($dd>$dm) do={
  :set dd ($dd-$dm)
  :set mm ($mm+1)
  :if ($mm>12) do={
    :set mm 1
    :set yy ($yy+1)
  }
 :set dm [:pick $mdays ($mm-1)]
 :if ($mm=2 &&  (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }
};
:local res "$[:pick $monthr ($mm-1)]/"
:if ($dd<10) do={ :set res ($res."0") }
:set $res "$res$dd/$yy"
:return $res


:local shiftDate [:parse [/system script get func_shiftDate source]]
:put [$shiftDate date="jan/01/2017" days=256]