#!/bin/bash
set -o errexit

BT_STATION_MAC=$(bluetoothctl list | cut -d " " -f 2)
while read -r line ; do
        if [ ! -z "$line" ]
        then
                echo "${BT_STATION_MAC},IGNORE,${line},0"
        fi

done < /dev/ttyACM0
