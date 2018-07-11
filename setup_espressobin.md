# Espressobin setup

1. Download the [Armbian stretch](https://www.armbian.com/espressobin/)
ISO for the Espressobin and follow the instructions to install and setup u-boot.

2. Flash the ISO to the SD-card. Mount the SD-card and add an extra line in
`/boot/armbianEnv.txt`: `ethaddr=f0:ad:4e:03:86:9a`, where the MAC address is the
one printed on the sticker on the ethernet ports. This prevents all board from
having the same MAC address.

3. Boot the Espressobin, change the root password and don't add a regular user.

4. Update apt: `apt-get update && apt-get upgrade`

5. Install requirements `apt-get install bluez git netcat-traditional`

6. Clone this repo with git.

7. Setup systemd to start the scanner service at boot: `cp STROLL/scanner.service /etc/systemd/system`
 and enable it: `systemctl enable scanner`.

 8. Configure the IP address and port of CVC in `client.sh`

 9. TODO: bridge setup
