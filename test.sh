#!/bin/bash
DELAY=5
RSSI=1

STATION_ARRAY=("00:01:95:0B:AD:8E" "00:01:95:0D:CF:E1" "00:01:95:0D:D1:F0" "00:01:95:0D:CF:E4")
BATTON="20:13:01:30:03:69"

while true;
do
  for STAT in ${STATION_ARRAY[@]};
  do
    echo "$STAT,IGNORE,$BATTON,$RSSI"
    sleep $DELAY
  done
done
