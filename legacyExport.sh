#!/bin/bash

echo "$1"

#date --date='@2147483647'
time=$(( $1 / 1000000000))
echo "$time"
currentData=`date -d@"$time"`
echo "$currentData"

#fileName=$(date +"/home/pi/influxExport/%Y%m%d_%a.csv") #construct filename e.g. 20210823_mon.csv

#dayEpoch=86400000000000 #number of ns in a day
#now="$1" #current EPOCH (ns)
#tdiff=$((now - dayEpoch)) #time diff in EPOCH ns 

#build query
#query="SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$now""

#query
#influx -database 'digitalEnergy' -execute "$query" -format csv > test.csv

#backup to google drive
#rclone copy "$fileName" googleDrive:DigitalEnergyData


