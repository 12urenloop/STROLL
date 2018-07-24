#!/bin/bash
cp /root/STROLL/scanner.service /etc/systemd/system
systemctl daemon-reload
systemctl enable scanner
systemctl restart scanner
