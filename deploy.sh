#!/bin/bash
rm -rf /root/STROLL
echo "Disabling systemd networkd ..."
systemctl stop systemd-networkd && systemctl disable systemd-networkd
echo "\n Updating system ..."
apt-get update -yyq && apt-get upgrade -yyq
apt-get install -yyq git bluez netcat-traditional
echo "\n Install STROLL ..."
git clone https://github.com/12urenloop/STROLL.git /root/STROLL
cp /root/STROLL/scanner.service /etc/systemd/system
cp /root/STROLL/networking /etc/network/interfaces
echo "\n Restarting network ..."
service networking stop
service networking start
systemctl daemon-reload
systemctl enable scanner && systemctl restart scanner
systemctl stop haveged
systemctl disable haveged getty@ttyS0
