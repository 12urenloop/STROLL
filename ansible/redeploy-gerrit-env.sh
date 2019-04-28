#!/bin/sh
ansible-playbook -i ./gerrits.ini -u zeus -b -k  -K ./task-redeploy-env.yml
