#!/bin/bash 
killall -9 supervise 2>/dev/null # kill the deamon
BUS=$(lsusb | grep '04d8:003f' | awk '{print $2}') # get the bus number for power strip
DEVICE=$(lsusb | grep '04d8:003f' | awk '{print $4}' | sed 's/\([0-9]*\).*/\1/') # get the device number for power strip
EVENTNUM=$(ls -l /dev/input/by-id/ |  grep event | grep -v -i keyboard | awk '{print $11}' | cut -d"/" -f2) # get event number for scanner
if [ -n "${BUS}" ] && [ -n "${EVENTNUM}" ]
  then
    # reset the USB-controlled power strip first because it keeps bugging uughhh
    echo "Reseting PowerUSB with the following values"
    echo "Bus:" $BUS "    Device:" $DEVICE "    EventNum:" $EVENTNUM 
    echo xnqpla29 | sudo -S /home/blake/excursion/yassine/reset /dev/bus/usb/$BUS/$DEVICE  # reset USB-controlled power strip
    echo xnqpla29 | sudo -S chmod 666 /dev/input/$EVENTNUM  #get persmission to access scanner
    echo /dev/input/$EVENTNUM > /home/blake/excursion/yassine/deamon/scannereventfilename.txt # deamon/run will read this file for the filename
    nohup supervise /home/blake/excursion/yassine/deamon &>/dev/null & # this runs the code in deamon/run and keep it running
fi
if [ -z "${EVENTNUM}" ]
  then
    echo "Can't find gate scanner!! Gate scanner probably not plugged" 1>&2
    exit 1
fi

if [ -z "${BUS}" ]
  then
    echo "Can't find BUS number!! USB-controlled power strip probably not plugged" 1>&2
    exit 1
fi 
