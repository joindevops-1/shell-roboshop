#!/bin/bash

source ./common.sh
app_name=shipping

check_root
setup_app
setup_maven
systemd_setup

dnf install mysql -y 
mysql -h mysql.daws84s.site -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE

if [ $? -ne 0 ]
then
    mysql -h mysql.daws84s.site -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.daws84s.site -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h mysql.daws84s.site -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is already loaded... $Y SKIPPING $N"
fi
systemctl restart shipping
print_time

