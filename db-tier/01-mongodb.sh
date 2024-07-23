#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G success $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

# Setup the MongoDB repo file
cp /home/ec2-user/roboshop-shell/db-tier/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "Setup mongoDB repo"

dnf install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Installing mongoDB org"

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enabling mongod"

systemctl start mongod &>>$LOGFILE
VALIDATE $? "Starting mongod"

cp /home/ec2-user/roboshop-shell/db-tier/mongod.conf /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "Update listen address"

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "Restarting mongod"
