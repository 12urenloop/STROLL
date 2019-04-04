#!/bin/bash
echo "Clearing the old directory ..."
rm -rf /home/stroll/STROLL
#echo "Disabling systemd networkd ..."
#systemctl stop systemd-networkd && systemctl disable systemd-networkd
echo "Installing packages ..."
pacman -S --noconfirm openbsd-netcat bluez bluez-utils git sudo vim
echo "Creating stroll user ..."
useradd -m -G wheel stroll
echo "Install STROLL ..."
git clone https://github.com/12urenloop/STROLL.git /home/stroll/STROLL
chown -R stroll:stroll /home/stroll/STROLL
cp /home/stroll/STROLL/scanner.service /etc/systemd/system
rm -rf /etc/systemd/network/*
cp /home/stroll/STROLL/networkd/* /etc/systemd/network/
echo 'Reload systemd ...'
systemctl daemon-reload
echo "Restarting network ..."
systemctl restart systemd-networkd
echo "Enabling and starting scanner ..."
systemctl enable scanner && systemctl restart scanner
