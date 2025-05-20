#!/bin/bash

START_TIME=$(date +%s)
source ./common.sh
app_name=catalogue
# check the user has root priveleges or not
check_root

# validate functions takes input as exit status, what command they tried to install

setup_app

setup_nodejs

systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo 
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB Client"

STATUS=$(mongosh --host mongodb.daws84s.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.daws84s.site </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi

END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo -e "Script Exectution $G SUCCESS $N, Time taken: $G $ELAPSED_TIME seconds $N"


