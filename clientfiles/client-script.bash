#!/bin/bash

################################ Colors ###########################################
C_GREEN='\033[0;32m'
C_RED='\033[31m'
C_WB='\033[1;37m'

################################ Global Variables #################################

JMETER_PATH="./apache-jmeter-5.4.3/bin/jmeter"
DIR_DATE=$(date +"%Y-%m-%d-KL-%H-%M-%S-USERS-")
USERS="10"
MAX_USERS="100"
RAMPUP="1"
HOST="10.0.0.1"
PORT="80"
DURATION="10"
DELAY="5"
INC_USERS="10"
FRAMEWORK=""
SLEEP_FW="0"
INC_THROUGHPUT="0"
MIN_THROUGHPUT="0"
MAX_THROUGHPUT="0"


################### Installing needed programs and fetching from GIT ##########################

# Check if java is installed on the system
if ! [ -x "$(command -v java)" ]
then   
    echo "Java not installed."
    echo "Please follow the guide"
    echo "Installing..."
    echo "###########################################"
    sudo apt update
    sudo apt install default-jdk
    echo "###########################################"
    echo "Java installation complete"
    
else
    echo "Java installed"  
fi

#Check if Jmeter is in the current folder
if [ ! -d ./apache-jmeter-5.4.3/bin/ ]
then
    echo "Jmeter not installed"
    echo "Fetching Jmeter from web. Please wait"
    wget -q https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.4.3.zip
    echo "Unzipping Jmeter"
    unzip -qq apache-jmeter-5.4.3.zip
fi


############################## Internal Functions ##############################

createDir(){
    if [ ! -d ./$1/ ]
    then
        mkdir $1
    fi
}

runJmeter(){
    #$1 is the current users and $2 is the framework

    local _Users=-JUsers=${1}
    local _Rampup=-JRampUp=${RAMPUP}
    local _Host=-JHost=${HOST}
    local _Port=-JPort=${PORT}
    local _Duration=-JDuration=${DURATION}
    local _Delay=-JDelay=${DELAY}
    local _TP=-JThroughput${2}

    local _JMeter_Options="${_Users} ${_Rampup} ${_Host} ${_Port} ${_Duration} ${_Delay} ${_TP}"

    # #Create the directory for the framework, will only be done 1 time
    createDir $FRAMEWORK

    # #Concat number of req to date filename
    dirName="${DIR_DATE}-${1}"
    mkdir $FRAMEWORK/$dirName/
    mkdir $FRAMEWORK/$dirName/Result

    echo -e "Test started at: $(date +"%Y-%m-%d-%H:%M:%S")\nUsers: ${1}\nIncrement with: ${INC_USERS}\nMax Users: ${MAX_USERS}\nRampUp: ${RAMPUP}s\nHost: ${HOST}:${PORT}\nDuration: ${DURATION}s\nDelay: ${DELAY}s\nMIN_TP: ${MIN_THROUGHPUT}\nMAX_TP: ${MAX_THROUGHPUT}\nINC_TP: ${INC_THROUGHPUT}\nCurrent_TP: ${_TP}s" >> $FRAMEWORK/$dirName/currentSetup.txt
    $JMETER_PATH $_JMeter_Options -n -t ./examensarbete_jmeter/RouteTester.jmx -l $FRAMEWORK/$dirName/output.csv -e -o $FRAMEWORK/$dirName/Result 
    echo -e "Test ended at: $(date +"%Y-%m-%d-%H:%M:%S")\n" >> $FRAMEWORK/$dirName/currentSetup.txt
}

setJmeterOptions(){
    echo $1
    echo ""
    echo -e "${C_RED}#############################################"
    echo -e "#        ${C_GREEN} Current settings${C_RED}                  #"
    echo -e "      ${C_GREEN}HOST: ${C_WB}${HOST}"
    echo -e "      ${C_GREEN}PORT: ${C_WB}${PORT}"
    echo -e "      ${C_GREEN}FRAMEWORK: ${C_WB}${FRAMEWORK}${C_RED}"
    echo "#                                           #"
    echo -e "#############################################${C_GREEN}"
    
    if [ $1 -eq 666 ]
    then
        echo -e "${C_GREEN}Number of users:"
        read USERS

        echo -e "${C_GREEN}Set start throughput ${C_WB}"
        read MIN_THROUGHPUT

        echo -e "${C_GREEN}Set max throughput ${C_WB}"
        read MAX_THROUGHPUT

        echo -e "${C_GREEN}Set increment throughput ${C_WB}"
        read INC_THROUGHPUT
    else
        echo -e "${C_GREEN}Start number of users?${C_WB}"
        read USERS

        echo -e "${C_GREEN}Max users?${C_WB}"
        read MAX_USERS

        echo -e "${C_GREEN}Increment users with?${C_WB}"
        read INC_USERS
    fi

    echo -e "${C_GREEN}Rampup time in sec?${C_WB}"
    read RAMPUP

    echo -e "${C_GREEN}Duration in sec?${C_WB}"
    read DURATION

    echo -e "${C_GREEN}Delay in sec?${C_WB}"
    read DELAY

    echo -e "${C_GREEN}Sleep between framework switches in sec?${C_WB}"
    read SLEEP_FW
}

printCurrentSettings(){
    local _numIter
    local _numIterTP
    if [ $INC_USERS -eq 0 ]
    then
        ((_numIter = 1)) 
    else
        ((_numIter = (($MAX_USERS-$USERS)/$INC_USERS)+1))
    fi

    if [ $INC_THROUGHPUT -eq 0 ]
    then
        ((_numIterTP = 1)) 
    else
        ((_numIterTP = (($MAX_THROUGHPUT-$MIN_THROUGHPUT)/$INC_THROUGHPUT)+1))
    fi

    echo -e "${C_GREEN}Current setup: "
    echo -e "${C_GREEN}Framework:${C_WB} ${FRAMEWORK} "

    if [ $1 -eq 666 ]
    then
        echo -e "${C_GREEN}Start throughput ${C_WB} ${MIN_THROUGHPUT}"
        echo -e "${C_GREEN}Max throughput ${C_WB} ${MAX_THROUGHPUT}"
        echo -e "${C_GREEN}Increment throughput ${C_WB} ${INC_THROUGHPUT} (Will run for ${_numIterTP} itterations)"
        echo -e "${C_GREEN}Users:${C_WB} ${USERS}"
    else
        echo -e "${C_GREEN}Users:${C_WB} ${USERS}"
        echo -e "${C_GREEN}Max users:${C_WB} ${MAX_USERS}"
        echo -e "${C_GREEN}Increment users:${C_WB} ${INC_USERS} (Will run for ${_numIter} itterations)"
    fi

    echo -e "${C_GREEN}Rampup time:${C_WB} ${RAMPUP}s"
    echo -e "${C_GREEN}Duration:${C_WB} ${DURATION}s"
    echo -e "${C_GREEN}Delay:${C_WB} ${DELAY}s"
    echo -e "${C_GREEN}Sleep between frameworks:${C_WB} ${SLEEP_FW}s"
    echo -e ""
    echo -e "${C_GREEN}Host IP:${C_WB} ${HOST}"
    echo -e "${C_GREEN}Port:${C_WB} ${PORT}"

}

jmeterMenu(){
    clear
    
    FRAMEWORK=${1}

    setJmeterOptions

    echo ""

    clear

    printCurrentSettings

    echo -e ""
    echo -e "${C_GREEN}Continue with test? (Y/N)${C_WB}"
    local _Continue
    read _Continue

    if [[ "$_Continue" == "n" ]] || [[ "$_Continue" == "N" ]]
    then
        return
    fi

    local _itter=1
    local _numIter
    if [ $INC_USERS -eq 0 ]
    then
        ((_numIter = 1)) 
    else
        ((_numIter = (($MAX_USERS-$USERS)/$INC_USERS)+1))
    fi

    #If no increment run 1 instance of jmeter
    if [[ $USERS -eq $MAX_USERS ]]
    then
        runJmeter $USERS
    else
        #Loop through and increas the number of users
        local _CurrentUsers=$USERS

        while [ $_CurrentUsers -le $MAX_USERS ]
        do
            echo -e "${C_RED}Running framework ${FRAMEWORK}. Itteration ${_itter} of ${_numIter}${C_WB}" 
            runJmeter $_CurrentUsers
            ((_CurrentUsers=_CurrentUsers+INC_USERS))
            ((_itter=_itter+1))
        done
    fi

    _itter=1

    echo -e "${C_GREEN}Done with all tests. Press enter to continue...${C_WB}"
    read _temp

    clear
}

runAllFrameworks(){
    clear
    FRAMEWORK=Express

    echo -e "${C_RED}#############################################"
    echo "#                                           #"
    echo -e "#           ${C_GREEN}Automatic Testing       ${C_RED}        #"
    echo "#                                           #"
    echo -e "${C_GREEN}"
    echo -e "Please configure the test below:${C_WB} "

    setJmeterOptions
    clear
    printCurrentSettings
    echo -e "${C_GREEN}Continue with test? (Y/N)${C_WB}"
    local _Continue
    read _Continue

    if [[ "$_Continue" == "n" ]] || [[ "$_Continue" == "N" ]]
    then
        return
    fi

    local _itter=1
    local _numIter
    if [ $INC_USERS -eq 0 ]
    then
        ((_numIter = 1)) 
    else
        ((_numIter = (($MAX_USERS-$USERS)/$INC_USERS)+1))
    fi

    echo -e "${C_GREEN}Switching framework to: ${FRAMEWORK} ${C_WB}"

    timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh express'
    sleep $SLEEP_FW

    echo -e "${C_RED}Switched framework to: ${FRAMEWORK} ${C_WB}"
    #If no increment run 1 instance of jmeter
    if [[ $USERS -eq $MAX_USERS ]]
    then
        runJmeter $USERS
    else
        #Loop through and increas the number of users
        local _CurrentUsers=$USERS

        while [ $_CurrentUsers -le $MAX_USERS ]
        do
            echo -e "${C_RED}Running framework ${FRAMEWORK} (1/3). Itteration ${_itter} of ${_numIter}${C_WB}" 
            runJmeter $_CurrentUsers
            ((_CurrentUsers=_CurrentUsers+INC_USERS))
            ((_itter=_itter+1))
        done
    fi

    _itter=1

    echo -e "${C_GREEN}Switching framework to: ${FRAMEWORK} ${C_WB}"
    
    timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh aspnet'
    sleep $SLEEP_FW

    FRAMEWORK=ASP.NET
    echo -e "${C_RED}Switched framework to: ${FRAMEWORK} ${C_WB}"
    #If no increment run 1 instance of jmeter
    if [[ $USERS -eq $MAX_USERS ]]
    then
        runJmeter $USERS
    else
        #Loop through and increas the number of users
        local _CurrentUsers=$USERS

        while [ $_CurrentUsers -le $MAX_USERS ]
        do
            echo -e "${C_RED}Running framework ${FRAMEWORK} (2/3). Itteration ${_itter} of ${_numIter}${C_WB}" 
            runJmeter $_CurrentUsers
            ((_CurrentUsers=_CurrentUsers+INC_USERS))
            ((_itter=_itter+1))
        done
    fi

    _itter=1

    echo -e "${C_GREEN}Switching framework to: ${FRAMEWORK} ${C_WB}"
    
    timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh flask'
    sleep $SLEEP_FW

    FRAMEWORK=Flask
    echo -e "${C_RED}Switched framework to: ${FRAMEWORK} ${C_WB}"
    #If no increment run 1 instance of jmeter
    if [[ $USERS -eq $MAX_USERS ]]
    then
        runJmeter $USERS
    else
        #Loop through and increas the number of users
        local _CurrentUsers=$USERS

        while [ $_CurrentUsers -le $MAX_USERS ]
        do
            echo -e "${C_RED}Running framework ${FRAMEWORK} (3/3). Itteration ${_itter} of ${_numIter}${C_WB}" 
            runJmeter $_CurrentUsers
            ((_CurrentUsers=_CurrentUsers+INC_USERS))
            ((_itter=_itter+1))
        done
    fi

    _itter=1

    echo -e "${C_GREEN}Done with all tests. Press enter to continue...${C_WB}"
    read _temp
}

serverReset(){
    clear
    timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh clear'
    echo -e "${C_GREEN}Reset command sent to server. Start a framework?"
    echo "1. Express"
    echo "2. ASP.NET"
    echo "3. Flask"
    echo "4. Exit"

    echo -e "${C_WB}"
    local _option
    read _option

    if [ $_option -eq 1 ]
    then
        timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh express'
    fi

    if [ $_option -eq 2 ]
    then
        timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh aspnet'
    fi

    if [ $_option -eq 3 ]
    then
        timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh flask'
    fi

    if [ $_option -eq 4 ]
    then
        return
    fi
}


runAllFrameworksCPU(){
    clear
    FRAMEWORK=Express

    echo -e "${C_RED}#############################################"
    echo "#                                           #"
    echo -e "#           ${C_GREEN}Automatic CPU Testing       ${C_RED}        #"
    echo "#                                           #"
    echo -e "${C_GREEN}"
    echo -e "Please configure the test below:${C_WB} "

    setJmeterOptions 666
    clear
    printCurrentSettings 666
    echo -e "${C_GREEN}Continue with test? (Y/N)${C_WB}"
    local _Continue
    read _Continue

    if [[ "$_Continue" == "n" ]] || [[ "$_Continue" == "N" ]]
    then
        return
    fi

    local _itter=1
    local _numIter
    
    ((_numIter = (($MAX_THROUGHPUT-$MIN_THROUGHPUT)/$INC_THROUGHPUT)+1))

    echo -e "${C_GREEN}Switching framework to: ${FRAMEWORK} ${C_WB}"

    timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh express'
    sleep $SLEEP_FW

    echo -e "${C_RED}Switched framework to: ${FRAMEWORK} ${C_WB}"
    #Loop through and increas the number of users
    local _CurrentTP=$MIN_THROUGHPUT

    while [ $_CurrentTP -le $MAX_THROUGHPUT ]
    do
        echo -e "${C_RED}Running framework ${FRAMEWORK} (1/3). Itteration ${_itter} of ${_numIter}${C_WB}" 
        runJmeter $USERS $_CurrentTP
        cd ${FRAMEWORK}
        mkdir CPU
        cd ..
        mv performance.jtl ${FRAMEWORK}/CPU/CPU-TP${_CurrentTP}.jtl
        echo "INC_THROUGHPUT ${INC_THROUGHPUT}"
        echo "Current THROUGHPUT ${_currentTP}"
        ((_CurrentTP=_CurrentTP+INC_THROUGHPUT))
        ((_itter=_itter+1))
    done
    #Rester counter
    _itter=1

    FRAMEWORK=ASP.NET
    echo -e "${C_GREEN}Switching framework to: ${FRAMEWORK} ${C_WB}"
    
    timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh aspnet'
    sleep $SLEEP_FW
    
    echo -e "${C_RED}Switched framework to: ${FRAMEWORK} ${C_WB}"
    #Loop through and increas the number of users
    local _CurrentTP=$MIN_THROUGHPUT

    while [ $_CurrentTP -le $MAX_THROUGHPUT ]
    do
        echo -e "${C_RED}Running framework ${FRAMEWORK} (2/3). Itteration ${_itter} of ${_numIter}${C_WB}" 
        runJmeter $USERS $TP
        cd ${FRAMEWORK}
        mkdir CPU
        cd ..
        mv performance.jtl ${FRAMEWORK}/CPU/CPU-TP${_CurrentTP}.jtl
        ((_CurrentTP=_CurrentTP+INC_THROUGHPUT))
        ((_itter=_itter+1))
    done
    #Rester counter
    _itter=1

    FRAMEWORK=Flask
    echo -e "${C_GREEN}Switching framework to: ${FRAMEWORK} ${C_WB}"
    
    timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh flask'
    sleep $SLEEP_FW

    echo -e "${C_RED}Switched framework to: ${FRAMEWORK} ${C_WB}"
    #Loop through and increas the number of users

    local _CurrentTP=$MIN_THROUGHPUT

    while [ $_CurrentTP -le $MAX_THROUGHPUT ]
    do
        echo -e "${C_RED}Running framework ${FRAMEWORK} (3/3). Itteration ${_itter} of ${_numIter}${C_WB}" 
        runJmeter $USERS $TP
        cd ${FRAMEWORK}
        mkdir CPU
        cd ..
        mv performance.jtl ${FRAMEWORK}/CPU/CPU-TP${_CurrentTP}.jtl
        ((_CurrentTP=_CurrentTP+INC_THROUGHPUT))
        ((_itter=_itter+1))
    done
    #Rester counter
    _itter=1

    echo -e "${C_GREEN}Done with all tests. Press enter to continue...${C_WB}"
    read _temp
}


######################### Application start ################################


mainMenu(){

while [ 1 -eq 1 ]
do
    clear
    echo -e "${C_RED}#############################################"
    echo "#                                           #"
    echo -e "#      ${C_GREEN}Lokets Jmeter testing factory${C_RED}        #"
    echo -e "#    ${C_GREEN}Used for testing APIs with Jmeter${C_RED}      #"
    echo "#                                           #"
    echo -e "#############################################${C_GREEN}"

    echo -e "${C_GREEN}Current host: ${C_WB}${HOST}"
    echo -e "${C_GREEN}Current host: ${C_WB}${PORT}"
    echo ""

    echo -e "${C_GREEN}What application is running on the server?${C_WB}"
    echo "1. Express"
    echo "2. ASP.NET"
    echo "3. Flask"
    echo "4. Run all frameworks (automatic)"
    echo "5. Run all frameworks CPU test (automatic)"
    echo "6. Start Jmeter GUI"
    echo "7. Check connectivity to server"
    echo "8. Reset the server"
    echo "9. Exit"
    local _option
    read _option

    #Express
    if [ $_option -eq 1 ]
    then
        echo "Switching server framework to Express"
        timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh express'
        jmeterMenu Express
    fi

    #ASP.NET
    if [ $_option -eq 2 ]
    then
        echo "Switching server framework to ASP.NET"
        timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh aspnet'
        jmeterMenu ASP.NET
    fi

    #Flask
    if [ $_option -eq 3 ]
    then
        echo "Switching server framework to Flask"
        timeout 10 ssh root@$HOST 'sh /var/www/examensarb/zosh.sh flask'
        jmeterMenu Flask
    fi

    #Automatic test
    if [ $_option -eq 4 ]
    then
        runAllFrameworks
    fi

    #Automatic CPU test
    if [ $_option -eq 5 ]
    then
        runAllFrameworksCPU
    fi

    #Jmeter GUI
    if [ $_option -eq 6 ]
    then
        ./apache-jmeter-5.4.3/bin/jmeter
    fi

    #Check connection
    if [ $_option -eq 7 ]
    then
        ping -c 3 $HOST
        read _pingTemp
    fi

    if [ $_option -eq 8 ]
    then
        serverReset
    fi

    if [ $_option -eq 9 ]
    then
        exit
    fi

done
}

mainMenu

