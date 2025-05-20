#!/bin/bash

START_TIME=$(date +%s)
source ./common.sh
app_name=user

check_root
setup_app
setup_nodejs
systemd_setup

END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo -e "Script Exectution $G SUCCESS $N, Time taken: $G $ELAPSED_TIME seconds $N"
