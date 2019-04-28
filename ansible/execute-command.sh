#!/bin/sh
ansible all -i ./gerrits.ini -u zeus -b -m raw -a 'echo "Hello on \$(hostname) as \$(whoami)"' -k  -K
