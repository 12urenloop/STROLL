# Espressobin setup

1. Download the latest [uboot](https://dl.armbian.com/espressobin/u-boot/). 
The correct binary match the RAM mem size, the amount of RAM chips onboard, the CPU and DDR speed.
The RAM mem size, CPU and DDR speed can be seen in the splash screen on boot.
For the # of RAM chips, look at the front and back of the Espressobin for a rectangular chip on the exact same location.
If only on 1 side, there's only 1 chip. Otherwise there are 2.
Copy the matching bin over to a USB port and plug it into the UB3.0 port. Boot into the uboot and run `bubt flash-image-MEM-RAM_CHIPS-CPU_DDR_boot_sd_and_usb.bin spi usb`

2. Download the [Armbian stretch](https://www.armbian.com/espressobin/)
ISO for the Espressobin and follow the instructions to install and setup u-boot.

3. Flash the ISO to the SD-card. Mount the SD-card and add an extra line in
`/boot/armbianEnv.txt`: `ethaddr=f0:ad:4e:03:86:9a`, where the MAC address is the
one printed on the sticker on the ethernet ports. This prevents all board from
having the same MAC address.

4. Boot into uboot and use the following commands.
```
setenv initrd_addr 0x1100000
setenv image_name boot/Image
setenv load_script 'if test -e mmc 0:1 boot/boot.scr; then echo \"... booting from SD\";setenv boot_interface mmc;else echo \"... booting from USB/SATA\";usb start;setenv boot_interface usb;fi;if test -e \$boot_interface 0:1 boot/boot.scr;then ext4load \$boot_interface 0:1 0x00800000 boot/boot.scr; source; fi'
setenv bootcmd 'run get_images; run set_bootargs; run load_script;booti \$kernel_addr \$ramfs_addr \$fdt_addr'
saveenv
```
Boot the Espressobin, change the root password and don't add a regular user.

5. Run `curl -sSL https://raw.githubusercontent.com/12urenloop/STROLL/master/deploy.sh | bash` or continue manually; Update apt: `apt-get update && apt-get upgrade`

6. Install requirements `apt-get install bluez git netcat-traditional`

7. Clone this repo with git.

8. Setup systemd to start the scanner service at boot: `cp STROLL/scanner.service /etc/systemd/system`
 and enable it: `systemctl enable scanner`.

9. Configure the IP address and port of CVC in `environment`

10. TODO: bridge setup
