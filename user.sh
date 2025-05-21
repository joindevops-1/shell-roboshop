#!/bin/bash

START_TIME=$(date +%s)
source ./common.sh
app_name=user

check_root
setup_app
setup_nodejs
systemd_setup

