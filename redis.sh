#!/bin/bash

source ./common.sh
app_name=redis

check_root
dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disable default redis"
dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enable redis:7"
dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
VALIDATE $? "Allowing Redis to accept remote connections"

systemctl enable redis 
systemctl start redis 
VALIDATE $? "Enabled and Started Redis"

print_time