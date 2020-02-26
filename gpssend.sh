#!/bin/bash

function datasend {
    gpspipe -w | \
    while read gpsjson;
    do
        if [[ $gpsjson == *"mode\":3"* || $gpsjson == *"mode\":2"* ]]; then
            mosquitto_pub -h 13.59.237.93 -u evdatar -P evMosquito -t geolocation -m $gpsjson 2>/dev/null
        fi
    done
}

sleep 5
wifion=`ifconfig wlan0 | grep inet\ addr`
if [[ $wifion ]]; then
    echo "Usando Wifi"
datasend
else
    echo "Usando GSM"
(
   while : ; do
       wvdial
       sleep 10
   done
) &
datasend
fi
