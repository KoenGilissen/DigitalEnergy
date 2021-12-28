#!/bin/bash

#$crontab -e
# Script is run every day at 23:59
# 59 23 * * * /home/.../xxx.sh
#

logger -s  "Influx export started"
fileName=$(date +"/home/wizard/digitalEnergy/%Y%m%d_%a.csv") #construct filename e.g. 20210823_mon.csv

dayEpoch=86400000000000 #number of ns in a day
now=$(date +%s%N) #current EPOCH (ns)
tdiff=$((now - dayEpoch)) #time diff in EPOCH ns

#build query
query="SELECT * FROM datapoint WHERE time >= "$tdiff" AND time <= "$now""

#query
logger -s  "launching query"
influx -database 'digitalEnergy' -execute "$query" -format csv > "$fileName"

#backup to onedrive PXL
logger -s  "Uploading to ONE drive"
rclone copy "$fileName" pxl:PXL/DigitalEnergyData

