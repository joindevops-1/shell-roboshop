#!/bin/bash

source ./common.sh
app_name=mysql

check_root

dnf install mysql-server -y
systemctl enable mysqld
systemctl start mysqld  

VALIDATE $? "Installed and Started MySQL"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Root password setup"
print_time