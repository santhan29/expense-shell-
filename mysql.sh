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

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing mysql server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "enabled mysql server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "started mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
VALIDATE $? "settingup root password"

# mysql -h mysql.aws81s.store -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
# if [ $? ne 0 ]
# then 
#     echo "mysql root password is not setup setup now" &>>$LOG_FILE
#     mysql_secure_installation --set-root-pass ExpenseApp@1
#     VALIDATE $? "setting up root password"
# else 
#     echo -e "mysql root password is already setup $Y skipping $N" | tee -a $LOG_FILE
# fi 
