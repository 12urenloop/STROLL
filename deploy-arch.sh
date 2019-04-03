#!/bin/bash
echo "Clearing the old directory ..."
rm -rf /root/STROLL
#echo "Disabling systemd networkd ..."
#systemctl stop systemd-networkd && systemctl disable systemd-networkd
pacman -S --noconfirm openbsd-netcat bluez bluez-utils git
echo "Install STROLL ..."
git clone https://github.com/12urenloop/STROLL.git /root/STROLL
cp /root/STROLL/scanner.service /etc/systemd/system
cp /root/STROLL/networkd/* /etc/systemd/network/
echo "Restarting network ..."
systemctl restart systemd-networkd
systemctl daemon-reload
systemctl enable scanner && systemctl restart scanner
systemctl stop haveged
systemctl disable haveged getty@ttyS0
