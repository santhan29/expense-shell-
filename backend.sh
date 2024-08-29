#!/bin/bash 

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER 

userid=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $userid -ne 0 ]
    then 
        echo -e "$R please run script with root privileges $N" | tee -a $LOG_FILE
        exit 1
    fi 

}

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is $R failed $N" | tee -a $LOG_FILE
    else 
        echo -e "$2 is $G success $N" | tee -a $LOG_FILE
    fi 
}

echo "script started executing at $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf module disable nodejs -y
VALIDATE $? "disable default nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enable nodejs:20"

dnf install nodejs -y
VALIDATE $? "install nodejs"

useradd expense
VALIDATE $? "creating expense user"

