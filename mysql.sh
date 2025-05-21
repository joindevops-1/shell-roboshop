#!/bin/bash

source ./common.sh
app_name=mysql

check_root

dnf install mysql-server -y &>>$LOG_FILE
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld  

VALIDATE $? "Installed and Started MySQL"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "Root password setup"
print_time