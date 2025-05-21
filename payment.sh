#!/bin/bash

source ./common.sh
app_name=payment

check_root
setup_app
setup_python
systemd_setup
print_time