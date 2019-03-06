#!/bin/bash
set -o errexit

ETH_MAC=$(cat /sys/class/net/eth0/address)
BT_STATION_MAC=$(bluetoothctl list | cut -d " " -f 2)

# Check if bluetooth is plugged in
[[ -z  "$BT_STATION_MAC" ]] && echo "MSG, no BT, MAC_ethernet=${ETH_MAC}" && sleep 1 && exit

coproc bluetoothctl
echo "Powering on bluetooth controller"
echo "power on" >&${COPROC[1]}
sleep 2
echo 'Start scanning'
echo "scan on" >&${COPROC[1]}

echo "INFO, station, MAC_bluetooth=${BT_STATION_MAC}, MAC_ethernet=${ETH_MAC}"
while read -u "${COPROC[0]}" DIRTY_LOGLINE
do
    if [[ "${DIRTY_LOGLINE}" =~ "RSSI" ]]; then
        # Remove color codes | remove newlines | remove whitespace at beginnning and end | squeeze spaces
        LOGLINE=$(echo "${DIRTY_LOGLINE}" | sed 's/\x1B\[[0-9;]*[JKmsu]//g; s/\r/\n/g' | tr -d '\n' | sed "s/^[ \t]*//" | tr -s ' ')
        BATON_MAC=$(echo "${LOGLINE}" | cut -d ' ' -f 4)
        RSSI=$(echo "${LOGLINE}" | cut -d ' ' -f 6)
        echo "${BT_STATION_MAC},IGNORE,${BATON_MAC},${RSSI}"
    fi
done
