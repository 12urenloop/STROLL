#!/bin/bash
set -o errexit

ETH_MAC=$(cat /sys/class/net/wlp58s0/address)
BT_STATION_MAC=$(bluetoothctl list | cut -d " " -f 2)

controller_count=$(echo "$BT_STATION_MAC"  | wc -l)
if [[ $controller_count -gt 1 ]]; then
  echo "Multiple bluetooth controllers detected" >&2
  echo "Select your preferred one to scan on" >&2
  echo >&2
  i=1
  for controller in $BT_STATION_MAC; do
    echo "[$i] $controller" >&2
    (( i+=1 ))
  done

  read -p '> ' choice >&2
  if ! [[ $choice =~ ^[0-9]+$ ]]; then
    echo "[Error] Please provide a number" >&2
    exit 1
  fi

  if [[ $choice -lt 1 || $choice -gt $controller_count ]]; then
    echo "There is no controller with that number, sorry :/" >&2
    exit 2
  fi

  echo "$BT_STATION_MAC" >&2
  bluetooth_controller=$(echo "$BT_STATION_MAC" | sed -n "${choice}p" )

  BT_STATION_MAC="$bluetooth_controller"
fi

echo "Using bluetooth controller with mac: [$BT_STATION_MAC]" >&2

# Check if bluetooth is plugged in
[[ -z  "$BT_STATION_MAC" ]] && echo "MSG, no BT, MAC_ethernet=${ETH_MAC}" && sleep 1 && exit

coproc bluetoothctl
#echo "Powering on bluetooth controller"
echo "power on" >&${COPROC[1]}
sleep 2
#echo 'Start scanning'
echo "scan on" >&${COPROC[1]}
sleep 2
echo "menu scan" >&${COPROC[1]}
sleep 2
echo "transport le" >&${COPROC[1]}
sleep 2

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
