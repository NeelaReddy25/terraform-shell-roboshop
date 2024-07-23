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

dnf install redis -y &>>$LOGFILE
VALIDATE $? "Installing redis"

systemctl enable redis &>>$LOGFILE
VALIDATE $? "Enabling redis"

systemctl start redis &>>$LOGFILE
VALIDATE $? "Starting redis"

cp /home/ec2-user/roboshop-shell/db-tier/redis.conf /etc/redis/redis.conf &>>$LOGFILE
VALIDATE $? "Update listen address"

systemctl restart redis &>>$LOGFILE
VALIDATE $? "Restarting redis"