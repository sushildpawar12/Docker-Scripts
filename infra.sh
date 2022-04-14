#/bin/bash

#Purpose: 
#   Startup of docker containers using shell script.
#   Verfification if the docker container is started.
#   Option to Mount and unmount the containers.
#Version:1.0
#Created Date: 14.04.2022
#Modified Date:
#Author: Sushil Pawar
#Execution:
#   sh infra.sh -mount / -unmount / -remount
#   Mount - to spin up the containers
#   Unmount - Shoutdown the containers
#   Remount - TODO


_sleeptimer=1

#Verify if the container is strted in a healthy Mode
function isContainerRunning() {
    if [[ "$(docker container inspect -f '{{.State.Health.Status}}' $1)" == "healthy" ]]; then
        return 0
    else
        return 1
    fi
    
}
#Show the WIP status.
function spin() {
    local -a marks=( '/' '-' '\' '|' );
    echo -ne "${marks[i++ % ${#marks[@]}]}";
    sleep $_sleeptimer;
    echo -ne "\b";  
}

#Mount the containers
function mountApps () {
    docker start soaosbdb
    docker start splunk
    while ! isContainerRunning soaosbdb
    do
        spin
    done
    
    if isContainerRunning soaosbdb ; then
        echo 'Container soaosbdb is up and running. Starting soaosbas ...'
        docker start soaosbas
        docker exec soaosbas /bin/sh -c "cd splunkforwarder/bin/;./splunk start;exit"
        docker exec -d soaosbas "/u01/oracle/user_projects/domains/soainfra/bin/startNodeManager.sh"
    fi
    
}

function unMountApps() {
    docker stop soaosbas
    docker stop soaosbdb
    docker stop splunk
    echo Container soaosbdb, soaosbdb, splunk stopping.
    while isContainerRunning soaosbas
    do
        #echo Waiting for Container soaosbas.
        spin
    done
    echo Container soaosbas stopped.
    while  isContainerRunning soaosbdb
    do
        #echo Waiting for Container soaosbdb.
        spin
    done
    echo Container soaosbdb stopped.
    while isContainerRunning splunk
    do
        #echo Waiting for Container Splunk.
        spin
    done
    echo Container splunk stopped.
}


case "$1" in
    "-mount")
        echo Initiating Mount of docker containers.
        echo ****************************************.
        mountApps
    ;;
    "-unmount")
        echo Initiating Unmount of docker containers.
        echo ****************************************.
        unMountApps
    ;;
    "-remount")
        echo you in remount
    ;;
    *)
        echo "You have failed to specify what to do correctly."
        exit 1
    ;;
esac


