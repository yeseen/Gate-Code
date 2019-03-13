#!/bin/bash 
killall -9 supervise 2>/dev/null # kill the deamon

touch ~/gatelogs/gate.log #make sure gate log is there
gateIP=$(~/hs100/hs100.sh discover | awk 'NF{ print $NF }') # get smart plug ip

EVENTNUM=$(ls -l /dev/input/by-id/ |  grep event | grep -v -i keyboard | awk '{print $11}' | cut -d"/" -f2) # get event number for scanner
if [ -n "${gateIP}" ] && [ -n "${EVENTNUM}" ]
  then
    echo "Scanner found at EventNum:" $EVENTNUM 
    echo xnqpla29 | sudo -S chmod 666 /dev/input/$EVENTNUM  #get persmission to access scanner
    echo /dev/input/$EVENTNUM > ~/Gate-Code/deamon/scannereventfilename.txt # deamon/run will read this file for the filename

    echo "Smart plug found at IP " $gateIP
    echo xnqpla29 | sudo -S sed -i "\$ a $gateIP\ths100\n" /etc/hosts #add smart plug to known hosts

    nohup supervise ~/Gate-Code/deamon &>/dev/null & # this runs the code in deamon/run and keep it running
fi
if [ -z "${gateIP}" ]
  then
    echo "Can't find gate smart plug!! its probably not plugged" 1>&2
    exit 1
fi

if [ -z "${EVENTNUM}" ]
  then
    echo "Can't find gate scanner!! Gate scanner probably not plugged" 1>&2
    exit 1
fi

