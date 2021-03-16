#!/bin/bash

if [ -z "$1" ]; then softlayer_speedtest="fra02"; else softlayer_speedtest="$1"; fi

CSTATS=`curl -w '%{speed_download}\t%{time_namelookup}\t%{time_total}\n' --max-time 30 -o /dev/null http://speedtest.${softlayer_speedtest}.softlayer.com/downloads/test10.zip --interface vti0`

TOTALTIME=`echo $CSTATS | awk '{print $3}'`
DNSTIME=`echo $CSTATS | awk '{print $2}'`
SPEED=`echo $CSTATS | awk '{print $1}' | sed 's/\..*//'`

echo "Time: $TOTALTIME seconds."
echo "DNSlookup: $DNSTIME seconds."

let KBSPEED=$SPEED/1024*8
let MBSPEED=$SPEED/1024/1024*8
#echo "Download: $KBSPEED KBit/s"
#echo "Download: $MBSPEED MBit/s"

# If 'let' doesn't work, try expr:
#KBSPEED=`expr $SPEED / 1024`
#MBSPEED=`expr $SPEED / 1048576`
if [ $KBSPEED -gt 10000 ] ; then
    echo "Download: $MBSPEED MBit/s"
else
    echo "Download: $KBSPEED KBit/s"
fi

exit 0
