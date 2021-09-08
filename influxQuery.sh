#!/bin/bash

# $crontab -e
# Script is run every day at 23:59
# 59 23 * * * /home/pi/DigitalEnergy/influxQuery.sh
#

logger -s  "Influx export started"
fileName=$(date +"/home/pi/influxExport/%Y%m%d_%a.csv") #construct filename e.g. 20210823_mon.csv

dayEpoch=86400000000000 #number of ns in a day
now=$(date +%s%N) #current EPOCH (ns)
tdiff=$((now - dayEpoch)) #time diff in EPOCH ns 

#build query
query="SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$now""

#query
logger -s  "launching query"
influx -database 'digitalEnergy' -execute "$query" -format csv > "$fileName"

#backup to google drive
logger -s  "Uploading to google drive"
rclone copy "$fileName" pxl:PXL/DigitalEnergyData


