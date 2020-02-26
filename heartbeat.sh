#!/bin/bash

function heartbeat {
    mosquitto_pub -h 13.59.237.93 -u evdatar -P evMosquito -t status -m $status 2>/dev/null
}

sleep 5
wifion=`ifconfig wlan0 | grep inet\ addr`
if [[ $wifion ]]; then
   echo "Usando Wifi"
(
   while true ; do
       status=”WIFI"
       heartbeat
       sleep 10
   done
) &
else
    echo "Usando GSM"
(
   while true ; do
       status="GSM"
       heartbeat
       sleep 10
   done
) &
fi
