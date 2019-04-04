# STROLL: System Tracking Runners On Langdurige Loopwedstrijden

STROLL is a shell script that will be the replacement of the
[gyrid](https://github.com/12urenloop/gyrid) software that runs on the old gyrids.
It's meant to be run on the new Espressobin platform. The main function of STROLL is
to send data about nearby bluetooth devices (MAC address and RSSI) to
[count-von-count](https://github.com/12urenloop/cvc).


This repo will also contain information about how to setup the Espressobins.

Deploying to the Espressobins is easy-peasy just use `curl -sSL https://raw.githubusercontent.com/12urenloop/STROLL/master/deploy-arch.sh | bash` and set the `count-von-count` server ip in the environment file of the `STROLL` directory.

## Dependencies

* git
* bluez
* netcat-traditional

## Info about the data being send

The data for `count-von-count` raw protocol is formatted as follow.

```
STATION_MAC,IGNORE,BATTON_MAC,RSSI
```

STROLL uses `client.sh` and `scan.sh` to get the data from bluez.
It just parses the `INFO`/`DEBUG` messages that show up from `bluethootctl` when ran interactive.

## Testing CVC

`test-client.sh` can be executed to test out count-von-count. For example, calling `./test-client.sh`
start sending test messages to the cvc server. The test batton and station needs to be added to
count-von-count config script.
