#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

# check the user has root priveleges or not
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

dnf install maven -y

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

mkdir /app 

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
cd /app 
unzip /tmp/shipping.zip

mvn clean package 
mv target/shipping-1.0.jar shipping.jar 

systemctl daemon-reload
systemctl enable shipping 
systemctl start shipping


dnf install mysql -y 
mysql -h mysql.daws84s.site -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ]
    mysql -h mysql.daws84s.site -uroot -pRoboShop@1 < /app/db/schema.sql
    mysql -h mysql.daws84s.site -uroot -pRoboShop@1 < /app/db/app-user.sql
    mysql -h mysql.daws84s.site -uroot -pRoboShop@1 < /app/db/master-data.sql
else
    echo -e "Shipping data is already loaded... $Y SKIPPING $N"
fi
systemctl restart shipping


