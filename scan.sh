#!/bin/bash
set -o errexit

ETH_MAC=$(cat /sys/class/net/eth0/address)
BT_STATION_MAC=$(hcitool dev | grep "hci0" | cut -f 3)

# Check if bluetooth is plugged in
[[ -z  "$BT_STATION_MAC" ]] && echo "MSG, no BT, MAC_ethernet=${ETH_MAC}" && sleep 1 && exit

echo "INFO, station, MAC_bluetooth=${BT_STATION_MAC}, MAC_ethernet=${ETH_MAC}"
coproc bluetoothctl
echo 'scan on' >&"${COPROC[1]}"
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
