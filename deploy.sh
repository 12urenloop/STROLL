#!/bin/bash
systemctl stop systemd-networkd && systemctl disable systemd-networkd
apt-get update -yyq && apt-get upgrade -yyq
apt-get install -yyq git bluez netcat-traditional
git clone https://github.com/12urenloop/STROLL.git /root/STROLL
cp /root/STROLL/scanner.service /etc/systemd/system
cp /root/STROLL/networking /etc/network/interfaces
service networking stop
service networking start
systemctl daemon-reload
systemctl enable scanner && systemctl restart scanner
systemctl stop haveged
systemctl disable haveged getty@ttyS0
