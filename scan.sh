#!/bin/bash

OUR_MAC=$(hcitool dev | grep "hci0" | cut -f 3)
echo "INFO: station MAC: ${OUR_MAC}"
coproc bluetoothctl
echo 'scan on' >&${COPROC[1]}
while read -u ${COPROC[0]} LOGLINE
do
    if [[ $LOGLINE = *"RSSI"* ]]; then
        BATON_MAC=$(echo "$LOGLINE" | cut -d ' ' -f 4)
        RSSI=$(echo "$LOGLINE" | cut -d ' ' -f 6)
        echo "${OUR_MAC},IGNORE,${BATON_MAC},${RSSI}"
    fi
done
