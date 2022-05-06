#!/bin/bash

# Stops all the programs and clears everything.
clear_usage(){
    systemctl stop flaskapp
    systemctl stop expressapp
    systemctl stop aspnetapp
    pm2 delete all 
    pm2 stop all 
    rm /etc/nginx/sites-enabled/express.conf 
    rm /etc/nginx/sites-enabled/flask.conf 
    rm /etc/nginx/sites-enabled/aspnet.conf 
    systemctl restart nginx
}

# Fucntion that clears by passing "clear" as an argument
if [ $1 = "clear" ]; then
    clear_usage
    echo "Cleaned system."
    exit 1
fi

# Starts express via argument
if [ $1 = "express" ]; then
    clear_usage
    systemctl start expressapp &
    exit 1
fi

# Starts flask via argument
if [ $1 = "flask" ]; then
    clear_usage
    systemctl start flaskapp &
    exit 1
fi

# Starts aspnet via argument
if [ $1 = "aspnet" ]; then
    clear_usage
    systemctl start aspnetapp &
    exit 1
fi

# CLI Menu for manual use
RED='\033[0;31m'
echo  "\033[31m"
echo '################################'
echo '#                              #'
echo '# \033[0;32m ERMA testing tool \033[31m          #'
echo '#                              #'
echo '################################'
echo "\033[1;37m"
echo ''
echo 'What test would you like to do?'
echo ''
echo '\033[1;34m## Tests ##\033[1;37m'
echo '1. Express'
echo '2. ASP.NET'
echo '3. Flask'
echo ''
echo '\033[1;31m## Functions ##\033[1;37m'
echo '4. Kill all'
echo '5. Install dependencies'
echo '6. Setup konfigurations'
read option

if [ $option -eq 1 ]
then
    clear_usage
    systemctl start expressapp &
fi

if [ $option -eq 2 ]
then
    clear_usage
    systemctl start aspnetapp &
fi

if [ $option -eq 3 ]
then
    clear_usage
    systemctl start flaskapp &
fi

if [ $option -eq 4 ]
then
    systemctl stop expressapp
    systemctl stop aspnetapp
    systemctl stop flaskapp
    clear_usage
    systemctl restart nginx
fi

if [ $option -eq 5 ]
then
    apt update -y
    apt upgrade -y
    apt install npm -y
    apt install nodejs -y
    npm install pm2 -g
    wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb 
    dpkg -i packages-microsoft-prod.deb
    apt-get install apt-transport-https -y
    apt-get update -y
    apt install dotnet-sdk-5.0 -y
    apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools -y
    pip install Flask
fi

if [ $option -eq 6 ]
then
    echo "Setting up enviroment..."
    cp ./serverfiles/flaskapp.service /etc/systemd/system/flaskapp.service
    echo "\033[0;32mCopied flaskapp.service."
    cp ./serverfiles/sites-available/flask.conf /etc/nginx/sites-available/flask.conf
    cp ./serverfiles/sites-available/express.conf /etc/nginx/sites-available/express.conf
    cp ./serverfiles/sites-available/aspnet.conf /etc/nginx/sites-available/aspnet.conf
    cp ./serverfiles/*.service /etc/systemd/system/
    echo "\033[0;32mCopied nginx files."
    systemctl daemon-reload > /dev/null 2>&1
    systemctl restart nginx > /dev/null 2>&1
    echo "\033[0;32mReloaded systemctl & restarted nginx."
    echo "\033[0;32mDONE\033[1;37m"
fi


